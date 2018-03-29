import Vapor
import Foundation


extension Droplet {
    func sellerRegister() throws {
        
        post("sellerRegister") { req in
            var json = JSON()
            guard
            let phoneNumber = req.data["phoneNumber"]?.string,
            let password = req.data["password"]?.string,
            let sellerName = req.data["sellerName"]?.string,
            let storeName = req.data["storeName"]?.string,
            let storeIntroduction = req.data["storeIntroduction"]?.string,
            let address = req.data["address"]?.string
                else {
                try json.set("status", 102)
                return json
                throw Abort.badRequest
            }
            
            let mysqlDriver = try self.mysql()
            let result = try mysqlDriver.raw("select * from seller where phone_number = '\(phoneNumber)'")
            var arr = result.wrapped.pathIndexableArray
            
            if(arr?.count == 0) //用户未被注册
            {
                let res = try mysqlDriver.raw("select * from user where phone_number = '\(phoneNumber)'")
                var arr1 = res.wrapped.pathIndexableArray
                
                if(arr1?.count == 0)
                {
                    try mysqlDriver.raw("insert into seller value ('\(phoneNumber)','\(password)','\(sellerName)','\(storeName)','\(storeIntroduction)','\(address)', '')")
                    try json.set("status", 100)
                }
                else
                {
                    try json.set("status", 101)
                }
            }
            else
            {
                try json.set("status", 101)
            }
            return json
        }
        
        
        try resource("posts", PostController.self)
    }
}



