//
//  SellerUpdate.swift
//  HelloPackageDescription
//
//  Created by Lambert Bns on 2018/3/22.
//

import Foundation
import Vapor

extension Droplet {
    func SellerUpdate() throws {
        post("updateForSeller") { request in
            var json = JSON()
            guard let phone_number = request.data["phone_number"]?.string,
             let seller_name = request.data["seller_name"]?.string,
             let address = request.data["address"]?.string,
             let image = request.data["image"]?.string,
             let store_name = request.data["store_name"]?.string,
             let store_introduction = request.data["store_introduction"]?.string
            else
            {
                try json.set("status", 101)
                return json
                throw Abort.badRequest
            }
            let mysqlDriver = try self.mysql()
            try mysqlDriver.raw("update seller set seller_name = '\(seller_name)', address = '\(address)', image = '\(image)', store_name = '\(store_name)', store_introduction = '\(store_introduction)' where phone_number = '\(phone_number)'")
            
            try json.set("status",100)
            return json
        }
        
        post("changePassword") { req in
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
            try mysqlDriver.raw("update seller set password = '\(new_password)' where phone_number = '\(phone_number)'")
            try json.set("status",100)
            return json
            
        }
        
        try resource("psot", PostController.self)
    }
}
