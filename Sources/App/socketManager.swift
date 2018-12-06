//
//  socketManager.swift
//  App
//
//  Created by Jerome Reid on 06/12/2018.
//

import Foundation
import SwiftSocket


class SocketManager {
    
    let socket : TCPClient
    
    class var sharedInstance: SocketManager {
        struct Singleton {
            static let instance = SocketManager()
        }
        return Singleton.instance
    }
    
    init() {
        // Create the socket
        
        self.socket = TCPClient(address: "192.168.1.22", port: 4201)
        // Connect the socket
        let result : Result
        result = self.socket.connect(timeout: 1)

        print("\(result.error) : \(result.isSuccess)")
        
    }
    
    internal func sendMessage(data: String){
        
        DispatchQueue.global(qos: .background).async {
            let request = self.sendRequest(data: data, client: self.socket)
            print("received message: \(request)")
            DispatchQueue.main.async{ () -> Void in
                print("This is run on the main queue, after the previous code in outer block")
            }
            
        }
    }
    
    private func sendRequest(data: String, client: TCPClient?) -> (String?) {
        // It use ufter connection
        if client != nil {
            // Send data  (WE MUST ADD SENDING MESSAGE '\n' )
            //let (isSuccess, errorMessage) = client!.send(string: "\(data)\n")
            let result: Result
            
            result = client!.send(string: "\(data)\n")
            
            if result.isSuccess {
                // Read response data
                let data = client!.read(1024*10)
                if let d = data {
                    // Create String from response data
                    if let str = NSString(bytes: d, length: d.count, encoding: String.Encoding.utf8.rawValue) as String?? {
                        return (data: str) as? String
                    } else {
                        return (nil)
                    }
                } else {
                    return (nil)
                }
            } else {
                print("\(result.error)")
                return (nil)
            }
        } else {
            return (nil)
        }
    }
}
