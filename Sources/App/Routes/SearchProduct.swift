//
//  SearchProduct.swift
//  Hello
//
//  Created by Lambert Bns on 2018/3/25.
//

import Foundation
import Vapor

extension Droplet {
    func SearchProduct() throws {
        
        post("searchProduct") {
            req in
            var json = JSON()
            guard
                let keyword = req.data["keyword"]?.string
                else {
                    try json.set("status", 101)
                    return json
                    throw Abort.badRequest
            }
            
            let db = try self.mysql()
            let res = try db.raw("select * from product natural join seller where product_name like '%\(keyword)%' or product_introduction like '%\(keyword)%' or product_type like '%\(keyword)%'")
            
            let id = res.wrapped
            json = JSON(node: id)
            
            return json

        }
        
        
        try resource("post", PostController.self)
    }
}
