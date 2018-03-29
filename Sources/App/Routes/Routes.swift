import Vapor
import Foundation


extension Droplet {
    func setupRoutes() throws {
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }
        
//        get("hello") { request in
//            return Response(
//                status: .ok,
//                headers: ["Content-Type": "text/plain"],
//                body: "Hello, World!"
//            )
//        }

        get("plaintext") { req in
            return "Hello, world!"
        }

        // response to requests to /info domain
        // with a description of the request
        get("info") { req in
            return req.description
        }

        get("description") { req in return req.description }
        
        post("post") { req in
            guard let content = req.data["content"]?.string else {
                throw Abort.badRequest
            }
            var str = "test"
            let post = Post(content: content)
            //try post.save()
            let mysqlDriver = try self.mysql()
            try mysqlDriver.raw("insert into posts(content) value ('\(str)')")
            return post
            
        }
        
        post("registerSeller") { req in
            guard
            let name = req.data["name"]?.string,
            let phoneNumber = req.data["phoneNumber"]?.string
                else {
                    throw Abort.badRequest
            }
            let mysqlDriver = try self.mysql()
            
            let result = try mysqlDriver.raw("select * from seller where phoneNumber = '\(phoneNumber)'")
            print(result)
            
            var arr = result.wrapped.pathIndexableArray
            
            if(arr?.count == 0)
            {
                try mysqlDriver.raw("insert into seller(name, phoneNumber) value ('\(name)','\(phoneNumber)')")
                return Response(
                    status: .ok,
                    headers: ["Content-Type": "text/plain"],
                    body: "ok"
                )
            }
            else{
//            return Response(
//                status: .ok,
//                headers: ["Content-Type": "text/plain"],
//                body: "the seller has register"
//            ).description
                var json = JSON()
//                var status = Status(status: 200, description: "interesting")
                
                try json.set("status", 200)
                try json.set("succeed", true)
                return json
//                return JSON()
            }
        }
        
        get("version") { request in
            let db = try self.mysql()
            let version = try db.raw("select * from product where phone_number = '123'")
            return JSON(node: version)
        }
        
        post("update") { request in
            guard let name = request.data["name"]?.string, let id = request.data["id"]?.string else { return "error" }
            let db = try self.mysql()
            
            let version = try db.raw("update posts set content = '\(name)' where id = '\(id)'")
            return JSON(node: version)
        }
        
        post("test") { req in
            let db = try self.mysql()
            let res = try db.raw("select * from product where phone_number = '123'")
            //let phone1 = try version.get("phone_number")
            let id = res.wrapped
            //取出的phone是一个数组
            print("count: \(id.array!.count)")
            //取数组的第一个元素
            //var num = id.array![0].int!
           // print(num)
            print("\(id.array![0])")
            var json = JSON(node: id)
            print(json.wrapped.array![2])
            
            return json
        }
        
        
        post("image") {
            request in
            //
            print(request)
            //print(request.formData!)
            guard var image = request.data["name"]?.string
                else { return "error" }
            let fileData = request.formData!["file"]?.part.body
            //print(fileData)
            let workPath = "/Users/lambert/Desktop/Vapor/Hello/Public"
            //let name = UUID().uuidString + ".png"
            let name = image + ".png"
            
            let saveURL = URL(fileURLWithPath: workPath, isDirectory: true).appendingPathComponent(name, isDirectory: false)
            do {
                let data = Data(bytes: fileData!)
                try data.write(to: saveURL)
            } catch(let errorr) {
                print(errorr)
                throw Abort.badRequest
            }
            //let saveURL = URL(fileURLWithPath: workPath).appendingPathComponent(imageFolder, isDirectory: true).appendingPathComponent(name, isDirectory: false)
            return ""
            //    do {
            //        let data = Data(bytes: fileData)
            //        try data.write(to: saveURL)
            //    } catch {
            //        throw Abort.custom(status: .internalServerError, message: "Unable to write multipart form data to file. Underlying error \(error)")
            //    }
            
        }
        
        get("getImage") { request in
            guard var image = request.data["name"]?.string
                else { return "error" }
            let path = "/Users/lambert/Desktop/Vapor/Hello/Public"
            image += ".png"
            let saveURL = URL(fileURLWithPath: path, isDirectory: true).appendingPathComponent(image, isDirectory: false)
            let imageData = try Data(contentsOf: saveURL)
            return Response(status: .ok, body: imageData.makeBytes())
        }
        
        try resource("posts", PostController.self)
    }
}



