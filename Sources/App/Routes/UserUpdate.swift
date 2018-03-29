//
//  SellerUpdate.swift
//  HelloPackageDescription
//
//  Created by Lambert Bns on 2018/3/22.
//

import Foundation
import Vapor

extension Droplet {
    func UserUpdate() throws {
        post("updateForUser") { request in
            var json = JSON()
            guard let phone_number = request.data["phone_number"]?.string,
                let user_name = request.data["user_name"]?.string,
                let address = request.data["address"]?.string,
                let image = request.data["image"]?.string
                else
            {
                try json.set("status", 101)
                return json
                throw Abort.badRequest
            }
            let mysqlDriver = try self.mysql()
            try mysqlDriver.raw("update user set user_name = '\(user_name)', address = '\(address)', image = '\(image)' where phone_number = '\(phone_number)'")
            
            try json.set("status",100)
            return json
        }
        
        post("userChangePassword") { req in
            var json = JSON()
            guard let phone_number = req.data["phone_number"]?.string,
                let new_password = req.data["new_password"]?.string
                else
            {
                try json.set("status", 101)
                return json
                throw Abort.badRequest
            }
            print(phone_number)
            print(new_password)
            let mysqlDriver = try self.mysql()
            try mysqlDriver.raw("update user set password = '\(new_password)' where phone_number = '\(phone_number)'")
            try json.set("status",100)
            return json
            
        }
        
        try resource("psot", PostController.self)
    }
}

