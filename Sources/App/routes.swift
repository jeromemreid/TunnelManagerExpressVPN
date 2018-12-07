import Vapor
import Leaf
import SwiftSocket

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    // Basic "It works" example
    router.get { req in
        return "It works!"
     
    }
    
    router.get("connections") { req -> Future<View> in
        return Connection.query(on: req).all().flatMap { connections in
            let data = ["connectionlist": connections]
            return try req.view().render("connectionsview", data)
        }
    }
    
    router.post("connections") { req -> Future<Response> in
        return try req.content.decode(Connection.self).flatMap { connection in
            return connection.save(on: req).map { _ in
                return req.redirect(to: "connections")
            }
        }
    }
    
    //  "Hello, Leaf!" example
    router.get("hello") { req -> Future<View> in
        return try req.view().render("hello", ["name": "Leaf"])
    }
    
    //Testing connection to server port
    router.get("setupvpn") { req -> String in
        
        var pageMessage : String?
        
        let client = TCPClient(address: "192.168.1.222", port: 4201)
        switch client.connect(timeout: 1) {
        case .success:
            switch client.send(string: "expressvpn list\n" ) {
            case .success:
                sleep(2)
                guard let data = client.read(1024*10) else { client.close(); return "No data received from server" }
                
                if let response = String(bytes: data, encoding: .utf8) {
                    print(response)
                    pageMessage = response
                }
            case .failure(let error):
                print(error)
            }
            client.close()
        case .failure(let error):
            print(error)
        }

        return (pageMessage ?? "No Response")
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}
