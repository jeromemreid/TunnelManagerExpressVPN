//
//  VPNClient.swift
//  App
//
//  Created by Jerome Reid on 11/12/2018.
//

import Foundation
import SwiftSocket


struct VPNClient {
    
    var client: TCPClient
    var serverAddress: String
    var serverPort: Int32
    
    enum VPNClientError : Error{
        case NoData
        
    }
    
   
    
    init (connectedTo address: String, atPort port: Int32){
        
        serverAddress = address
        serverPort = port
        client = TCPClient(address: serverAddress, port: serverPort)
        
        openConnection()
        
    }
    
    func openConnection() -> Result {
        
        
        return client.connect(timeout: 1)
    
    }
    
    func closeConnection() {
        client.close()
    }
    
    
    func  Send(message msg: String, receiveResponse response: inout String, waitfor wait: UInt32 = 2) throws -> Result{
        
        let result:Result = client.send(string: msg)
        switch  result {
        case .success:
            sleep(wait)
            guard let data = client.read(1024*10) else { throw  VPNClientError.NoData}
            
            if let answer = String(bytes: data, encoding: .utf8) {
                print(answer)
                response = answer
                return .success
                }
                
            
        case .failure(let error):
            print(error)
            return result
            
        }
        return result
    }
    
    
}
