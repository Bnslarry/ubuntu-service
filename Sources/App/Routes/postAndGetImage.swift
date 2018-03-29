//
//  GetImage.swift
//  Hello
//
//  Created by Lambert Bns on 2018/3/22.
//

import Foundation
import Vapor

extension Droplet {
    func postAndGetImage() throws {  //根据用户的手机号或商品的id获取头像
        
        post("uploadImage") { req in
            let fileName = req.formData!["fileName"]?.string!
            let fileData = req.formData!["file"]?.part.body
            let workPath = "/home/ubuntu/vapor/sab-service/Public"
            let name = fileName! + ".png"
            print(name)
            let saveURL = URL(fileURLWithPath: workPath, isDirectory: true).appendingPathComponent(name, isDirectory: false)
            do {
                let data = Data(bytes: fileData!)
                try data.write(to: saveURL)
            } catch( _) {
                //print(error)
                throw Abort.badRequest
            }
            return ""
        }
        
        post("getImage") { request in
            guard var image = request.data["fileName"]?.string
                else { return "error" }
            let path = "/home/ubuntu/vapor/sab-service/Public"
            image += ".png"
            let saveURL = URL(fileURLWithPath: path, isDirectory: true).appendingPathComponent(image, isDirectory: false)
            let imageData = try Data(contentsOf: saveURL)
            return Response(status: .ok, body: imageData.makeBytes())
        }
        
        try resource("post", PostController.self)
    }
}
