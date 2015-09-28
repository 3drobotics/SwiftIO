//
//  AddressTests.swift
//  SwiftIO
//
//  Created by Jonathan Wight on 8/8/15.
//
//  Copyright (c) 2014, Jonathan Wight
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright notice, this
//    list of conditions and the following disclaimer.
//
//  * Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


import XCTest

import SwiftIO

class AddressTests: XCTestCase {

    func testLocahost() {
        let address = try! Address(address: "127.0.0.1")
        XCTAssertEqual(address.address, "127.0.0.1")
    }

    func testLocahostIPV4() {
        let address = try! Address(address: "localhost", family: .INET)
        XCTAssertEqual(address.address, "127.0.0.1")
    }

//    func testLocahostIPV6() {
//        let address = try! Address(address: "localhost", family: .INET6)
//        XCTAssertEqual(address.address, "::")
//    }

    func testLocahost3() {
        let addresses: [(Address,InetProtocol,ProtocolFamily,String?)] = try! Address.addresses("apple.com")
        addresses.forEach() { print($0) }
    }

    func testInterfaces() {
        let addresses = try! Address.addressesForInterfaces()
        XCTAssertEqual(addresses["lo0"]!.address, "127.0.0.1")
    }
}
