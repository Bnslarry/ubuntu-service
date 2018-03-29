//
//  UserRegister.swift
//  HelloPackageDescription
//
//  Created by Lambert Bns on 2018/3/21.
//

import Foundation
import Vapor

extension Droplet {
func UserRegister() throws {
    
    post("userRegister") { req in
        var json = JSON()
        guard
            let phoneNumber = req.data["phoneNumber"]?.string,
            let password = req.data["password"]?.string,
            let userName = req.data["userName"]?.string,
            let address = req.data["address"]?.string
            else {
                try json.set("status", 102)
                return json
                throw Abort.badRequest
        }
        
        let mysqlDriver = try self.mysql()
        let result = try mysqlDriver.raw("select * from user where phone_number = '\(phoneNumber)'")
        var arr = result.wrapped.pathIndexableArray
        
        if(arr?.count == 0) //用户未被注册
        {
            let res = try mysqlDriver.raw("select * from seller where phone_number = '\(phoneNumber)'")
            var arr1 = res.wrapped.pathIndexableArray
            
            if(arr1?.count == 0)
            {
            try mysqlDriver.raw("insert into user value ('\(phoneNumber)','\(password)','\(userName)','\(address)', '')")
            try json.set("status", 100)
            }
            else
            {
                try json.set("status", 101)
            }
        }
        else
        {
            try json.set("status", 101)
        }
        return json
    }
    
    
    try resource("posts", PostController.self)
}
}
