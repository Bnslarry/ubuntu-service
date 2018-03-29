//
//  ManageRequestList.swift
//  Hello
//
//  Created by Lambert Bns on 2018/3/26.
//

import Foundation
import Vapor

extension Droplet {
    func ManageRequestList() throws{
        
        post("uploadRequest") { req in
            var json = JSON()
            guard let seller_phone = req.data["seller_phone"]?.string
                else {
                    try json.set("status", 102)
                    return json
                    throw Abort.badRequest
            }
            let db = try self.mysql()
            let res = try db.raw("select * from product natural join order_list where seller_phone = '\(seller_phone)' and states = 0")
            
            let id = res.wrapped
            json = JSON(node: id)
            
            return json
        }
        
        post("acceptRequest") { req in
            var json = JSON()
            guard
            let seller_phone = req.data["seller_phone"]?.string,
            let product_id = req.data["product_id"]?.string,
            let number = req.data["number"]?.string,
            let time = req.data["time"]?.string
            else
            {
                try json.set("status", 102)
                return json
                throw Abort.badRequest
            }
            let db = try self.mysql()
            try db.raw("update order_list set time = '\(time)', states = 1 where seller_phone = '\(seller_phone)'")
            
            let num = Int(number)!
            let id = Int(product_id)!
            
            try db.raw("update product set inventory = inventory - \(num) where product_id = \(id)")
            
            try json.set("status", 100)
            return json
        }
        
        post("uploadSold") { req in
            var json = JSON()
            guard let seller_phone = req.data["seller_phone"]?.string
                else {
                    try json.set("status", 102)
                    return json
                    throw Abort.badRequest
            }
            let db = try self.mysql()
            let res = try db.raw("select * from product natural join order_list where seller_phone = '\(seller_phone)' and states = 1")
            
            let id = res.wrapped
            json = JSON(node: id)
            
            return json
        }
        
        try resource("post", PostController.self)
    }
}
