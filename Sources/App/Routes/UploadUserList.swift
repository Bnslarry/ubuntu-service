//
//  UploadUserList.swift
//  Hello
//
//  Created by Lambert Bns on 2018/3/25.
//

import Foundation
import Vapor

extension Droplet {
    func UploadUserList() throws {
        post("uploadUserList") { req in
            var json = JSON()
            guard
                let user_phone = req.data["phone_number"]?.string
                else {
                    try json.set("status", 101)
                    return json
                    throw Abort.badRequest
            }
            
            let db = try self.mysql()
            var res = try db.raw("select * from order_list natural join product where user_phone = '\(user_phone)'")
            
            let id = res.wrapped
            json = JSON(node: id)
            return json
        }
        
        try resource("post", PostController.self)
    }
}
