//
//  ManageProduct.swift
//  Hello
//
//  Created by Lambert Bns on 2018/3/25.
//

import Foundation
import Vapor

extension Droplet {
    func ManageProduct() throws {
     
        post("updateProduct") {
            req in
            var json = JSON()
            guard
                let product_id = req.data["product_id"]?.string,
                let product_name = req.data["product_name"]?.string,
                let product_type = req.data["product_type"]?.string,
                let sole_price = req.data["sole_price"]?.string,
                let inventory = req.data["inventory"]?.string,
                let product_introduction = req.data["product_introduction"]?.string
                else {
                    try json.set("status", 101)
                    return json
                    throw Abort.badRequest
            }
            
            let number = Int(inventory)!
            let mysqlDriver = try self.mysql()
            
            try mysqlDriver.raw("update product set product_name = '\(product_name)', product_type = '\(product_type)', sole_price = '\(sole_price)', inventory = '\(number)', product_introduction = '\(product_introduction)' where product_id = '\(product_id)'")
            try json.set("status", 100)
            
            return json
        }
        
        post("deleteProduct") {
            req in
            var json = JSON()
            guard
            let product_id = req.data["product_id"]?.string
                else {
                    try json.set("status", 101)
                    return json
                    throw Abort.badRequest
            }
            let mysqlDriver = try self.mysql()
            
            try mysqlDriver.raw("delete from product where product_id = '\(product_id)'")
            try json.set("status", 100)
            
            return json
        }
        
        try resource("post", PostController.self)
    }
}
