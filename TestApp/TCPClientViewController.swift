//
//  TCPClientViewController.swift
//  SwiftIO
//
//  Created by Jonathan Wight on 1/25/16.
//  Copyright © 2016 schwa.io. All rights reserved.
//

import Cocoa

import SwiftIO
import SwiftUtilities

class TCPClientViewController: NSViewController {

    let port = UInt16(5507)
    var clientChannel: TCPChannel!
    var count: Int = 0

    dynamic var reconnect: Bool = false
    dynamic var state: String? = nil
    dynamic var connected: Bool = false

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        do {
            try createClient()
        }
        catch let error {
            fatalError("Error: \(error)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func createClient() throws {
        clientChannel = try TCPChannel(hostname: "10.1.1.10", port: port)
        clientChannel.stateChanged = {
            (old, new) in

            log?.debug("State changed: \(old) -> \(new)")

            Async.main() {
                self.state = String(new)
            }


            switch (old, new) {
                case (_, .Unconnected):
                    dispatch_async(dispatch_get_main_queue()) {
                        self.connected = false
                    }
                case (_, .Connected):
                    dispatch_async(dispatch_get_main_queue()) {
                        self.connected = true

                        try! self.clientChannel.socket.setNoDelay(true)
                    }
                default:
                    break
            }
        }

        clientChannel.readCallback = {
            (result) in
            if let error = result.error {
                log?.debug("Client read callback: \(error)")
                return
            }
        }

        clientChannel.reconnectionDelay = 1 / 8
        clientChannel.shouldReconnect = {
            return self.reconnect
        }
    }

    @IBAction func connect(sender: AnyObject?) {

        clientChannel.connect(retryDelay: 1 / 8) {
            (result) in

            if let error = result.error {
                assert(self.clientChannel.state.value == .Unconnected)
                SwiftIO.log?.debug("Client connect callback: \(error)")
                return
            }
        }
    }

    @IBAction func disconnect(sender: AnyObject?) {
        clientChannel.disconnect() {
            (result) in
            SwiftIO.log?.debug("Client disconnect callback: \(result)")
        }
    }

}
