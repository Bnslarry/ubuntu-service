//
//  SubmitProduct.swift
//  Hello
//
//  Created by Lambert Bns on 2018/3/23.
//

import Foundation
import Vapor

extension Droplet {
    func SubmitProduct() throws {
        
        post("submit") {
            req in
            var json = JSON()
            guard
                let product_name = req.data["product_name"]?.string,
                let product_type = req.data["product_type"]?.string,
                let sole_price = req.data["sole_price"]?.string,
                let inventory = req.data["inventory"]?.string,
                let product_introduction = req.data["product_introduction"]?.string,
                let phone_number = req.data["phone_number"]?.string
                else {
                    try json.set("status", 101)
                    return json
                    throw Abort.badRequest
            }
            
            let number = Int(inventory)!
            let mysqlDriver = try self.mysql()
            
            try mysqlDriver.raw("insert into product(product_name, product_type, sole_price, inventory, product_introduction, phone_number, product_image) value ('\(product_name)','\(product_type)','\(sole_price)','\(number)', '\(product_introduction)', '\(phone_number)', '')")
            try json.set("status", 100)
            
            let db = try self.mysql()
            let res = try db.raw("select max(product_id) from product")
            let id = res.wrapped["max(product_id)"]!
            try json.set("product_id", id.array![0].string!)
            let num = id.array![0].int!
            
            try db.raw("update product set product_image = '\(id.array![0])' where product_id = \(num)")
            
            print(json)
            return json
        }
        
        try resource("pst", PostController.self)
    }
}
