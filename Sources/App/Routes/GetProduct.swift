//
//  GetProduct.swift
//  Hello
//
//  Created by Lambert Bns on 2018/3/24.
//

import Foundation
import Vapor

extension Droplet {
    func GetProduct() throws {
        post("getProducts") { req in
            var json = JSON()
            guard let phone_number = req.data["phone_number"]?.string
            else
            {
                try json.set("status", 102)
                return json
                throw Abort.badRequest
            }
            let db = try self.mysql()
            let res = try db.raw("select * from product where phone_number = '\(phone_number)'")

            let id = res.wrapped
            json = JSON(node: id)

            return json
        }
        
        
        try resource("post", PostController.self)
    }
}
