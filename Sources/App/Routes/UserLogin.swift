//
//  sellerLogin.swift
//  HelloPackageDescription
//
//  Created by Lambert Bns on 2018/3/21.
//

import Foundation
import Vapor

extension Droplet {
    func UserLogin() throws {
        post("userLogin") { req in
            var json = JSON()
            guard
                let phoneNumber = req.data["phoneNumber"]?.string,
                let password = req.data["password"]?.string
                else {
                    try json.set("status", 102)
                    return json
                    throw Abort.badRequest
            }
            
            let mysqlDriver = try self.mysql()
            let result = try mysqlDriver.raw("select * from user where phone_number = '\(phoneNumber)' and password = '\(password)'")
            var arr = result.wrapped.pathIndexableArray
            
            if(arr?.count == 0) //账号不存在或密码错误
            {
                try json.set("status", 101)
            }
            else  //密码正确
            {
                json = JSON(node: result)
                try json.set("status", 100)
                
            }
            return json
        }
        
        try resource("psot", PostController.self)
    }
}

