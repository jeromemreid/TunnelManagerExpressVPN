import Vapor
import SwiftSocket

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req -> String in
        
//        let sm : SocketManager = SocketManager()
//        sm.sendMessage(data: "expressvpn status")
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
