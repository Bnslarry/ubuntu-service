//
//  AddToCart.swift
//  Hello
//
//  Created by Lambert Bns on 2018/3/25.
//

import Foundation
import Vapor

extension Droplet {
    func AddToCart() throws {
        post("addToCart") { req in
            var json = JSON()
            guard
            let phone_number = req.data["phone_number"]?.string,
            let product_id = req.data["product_id"]?.string,
            let product_name = req.data["product_name"]?.string,
            let sole_price = req.data["sole_price"]?.string,
            let number = req.data["number"]?.string,
            let image = req.data["image"]?.string
            else
            {
                try json.set("status", 101)
                return json
                throw Abort.badRequest
            }
            let id = Int(product_id)!
            let num = Int(number)!
            let db = try self.mysql()
            try db.raw("insert into cart value('\(phone_number)',\(id),'\(product_name)','\(sole_price)',\(num),'\(image)')")
            
            try json.set("status", 100)
            return json
            
        }
        
        post("uploadCart") { req in
            var json = JSON()
            guard
                let phone_number = req.data["phone_number"]?.string
                else
            {
                try json.set("status", 101)
                return json
                throw Abort.badRequest
            }
            
            let db = try self.mysql()
            let res = try db.raw("select * from cart where phone_number = '\(phone_number)'")
            
            let id = res.wrapped
            json = JSON(node: id)
            
            return json
            
        }
        
        post("cancelBuy") { req in
            var json = JSON()
            guard
                let product_id = req.data["product_id"]?.string
                else
            {
                try json.set("status", 101)
                return json
                throw Abort.badRequest
            }
            
            let db = try self.mysql()
            try db.raw("delete from cart where product_id = '\(product_id)'")
            
            try json.set("status", 100)
            return json
        }
        
        post("updateCart") { req in
            guard
                let product_id = req.data["product_id"]?.string,
                let number = req.data["number"]?.string
                else
            {
                throw Abort.badRequest
            }
            let num = Int(number)!
            let db = try self.mysql()
            try db.raw("update cart set number = \(num) where product_id = '\(product_id)'")
            return JSON()
        }
        
        try resource("post", PostController.self)
    }
}
