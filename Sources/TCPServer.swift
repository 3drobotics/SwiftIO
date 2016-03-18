//
//  Server.swift
//  SwiftIO
//
//  Created by Jonathan Wight on 12/9/15.
//  Copyright © 2015 schwa.io. All rights reserved.
//

import SwiftUtilities

public class TCPServer {

    public let addresses: [Address]

    public var clientShouldConnect: (Address -> Bool)?
    public var clientWillConnect: (TCPChannel -> Void)?
    public var clientDidConnect: (TCPChannel -> Void)?
    public var clientDidDisconnect: (TCPChannel -> Void)?

    public var errorDidOccur: (ErrorType -> Void)? = {
        (error) in
        log?.debug("Server got: \(error)")
    }

    private var listenersByAddress: [Address: TCPListener] = [:]
    private let queue = dispatch_queue_create("io.schwa.TCPServer", DISPATCH_QUEUE_SERIAL)
    private var connections = Atomic(Set <TCPChannel> ())

    public init(address: Address) throws {
        self.addresses = [address]
    }

    public func startListening() throws {
        for address in addresses {
            print("startListening on \(address)")
            try startListening(address)
        }
    }


    private func startListening(address: Address) throws {

        let listener = try TCPListener(address: address, queue: queue)

        listener.clientShouldConnect = clientShouldConnect
        listener.clientWillConnect = {
            [weak self] channel in

            guard let strong_self = self else {
                return
            }

            channel.state.addObserver(strong_self, queue: dispatch_get_main_queue()) {
                (old, new) in

                guard let strong_self = self else {
                    return
                }
                if new == .Unconnected {
                    strong_self.connections.value.remove(channel)
                    strong_self.clientDidDisconnect?(channel)
                }
            }
            strong_self.clientWillConnect?(channel)
        }
        listener.clientDidConnect = {
            [weak self] channel in

            guard let strong_self = self else {
                return
            }

            strong_self.connections.value.insert(channel)
            strong_self.clientDidConnect?(channel)
        }
        listener.errorDidOccur = errorDidOccur

        try listener.startListening()

        listenersByAddress[address] = listener
    }

    public func stopListening() throws {

        for (address, listener) in listenersByAddress {
            try listener.stopListening()
            listenersByAddress[address] = nil
        }

    }

    public func disconnectAllClients() throws {
        for connection in connections.value {
            connection.disconnect() {
                (result) in
                log?.debug("Server disconnect all: \(result)")
            }
        }
    }
}
