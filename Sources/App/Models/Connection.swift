//
//  Connection.swift
//  App
//
//  Created by Jerome Reid on 07/12/2018.
//


import FluentSQLite
import Vapor

/// Specify TCP connection to the Tunnel GW.
final class Connection: SQLiteModel {
    /// The unique identifier for this `Connection`.
    var id: Int?
    
    /// A title describing for this `Connection`.
    var title: String
    
    //Connection details
    var address: String
    var port: Int
    var isActive : Bool
    
    /// Creates a new `Connection`.
    init(id: Int? = nil, title: String = "openVpnGW", address: String = "192.168.1.222", port: Int = 4201, isActive: Bool = false) {
        self.id = id
        self.title = title
        self.address = address
        self.port = port
        self.isActive = isActive
    }
}

/// Allows `Connection` to be used as a dynamic migration.
extension Connection: Migration { }

/// Allows `Connection` to be encoded to and decoded from HTTP messages.
extension Connection: Content { }

/// Allows `Conection` to be used as a dynamic parameter in route definitions.
extension Connection: Parameter { }

