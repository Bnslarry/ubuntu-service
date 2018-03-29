//
//  OrderManage.swift
//  Hello
//
//  Created by Lambert Bns on 2018/3/25.
//

import Foundation
import Vapor

extension Droplet {
    func OrderManage() throws {
        post("orderList") { req in
            var json = JSON()
            guard
            let user_phone = req.data["user_phone"]?.string,
            let product_id = req.data["product_id"]?.string,
            let number = req.data["number"]?.string,
            let time = req.data["time"]?.string,
            let address = req.data["address"]?.string
                else {
                    try json.set("status", 101)
                    return json
                    throw Abort.badRequest
            }
            
            let id = Int(product_id)!
            let num = Int(number)!
            let db = try self.mysql()
            var res = try db.raw("select inventory from product where product_id = \(id)")
            let inventory = res.wrapped["inventory"]!.array![0].int!
            if num > inventory
            {
                try json.set("status", 102)
                return json
            }
            
            res = try db.raw("select phone_number from product where product_id = \(id)")
            let phone = res.wrapped["phone_number"]!
            let seller_phone = phone.array![0].string!
            
            try db.raw("insert into order_list value('\(user_phone)','\(seller_phone)','\(id)','\(num)','\(time)','\(address)', 0)")
            try json.set("status", 100)
            return json
        }

    try resource("post", PostController.self)
}
}
