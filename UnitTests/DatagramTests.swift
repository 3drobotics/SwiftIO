//
//  DatagramTests.swift
//  SwiftIO
//
//  Created by Jonathan Wight on 8/10/15.
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
import SwiftUtilities

class DatagramTests: XCTestCase {

    func testExample() {
        let address = try! Address(address: "localhost")

        let port:UInt16 = 12345
        let buffer = DispatchData <Void> (buffer:"Hello world".dataUsingEncoding(NSUTF8StringEncoding)!.toUnsafeBufferPointer())
        let datagram = Datagram(from: (address, port), data: buffer)
        let encodedData = try! NSData(streamable: datagram)
        encodedData.buffer
        let stream = MemoryStream(buffer: encodedData.toUnsafeBufferPointer())
        let decodedDatagram = try! Datagram.readFrom(stream)

        XCTAssertEqual(datagram, decodedDatagram)
    }

}

extension NSData {
    convenience init(streamable:BinaryOutputStreamable) throws {
        let stream = MemoryStream()
        try streamable.writeTo(stream)
        self.init(data:stream.data)
    }
}

//extension Datagram {
//
//    public static func readFrom <Stream:BinaryInputStream> (stream:Stream) throws -> Datagram {
//    }
//
