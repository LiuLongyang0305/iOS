//
//  UploadJsonObjectToServer.swift
//  NetworkDemo
//
//  Created by liulongyang on 2019/3/31.
//  Copyright © 2019 liulongyang. All rights reserved.
//

import Foundation

struct Order : Encodable {
    let customerId : String
    let items : [String]
}

extension ViewController {
    func prepareUploadData()  -> Data? {
        let order = Order(customerId: "lly19900305", items: ["Chinese pizza","Diet soda"])
        guard let uploadData = try? JSONEncoder().encode(order) else {
            return nil
        }
        return uploadData
    }
    
    func testUploadDataToServer()  {
        let url = URL(string: "https://example.com/post")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: prepareUploadData()) { (data, response, error) in
            if let err = error {
                print("Error : \(err.localizedDescription)")
                return 
            }
            guard let res = response as? HTTPURLResponse,(200...299).contains(res.statusCode ) else {
                print("Server Error")
                return
            }
            if let mineType = res.mimeType, mineType == "application/json", let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Got data : \(dataString)")
            }
        }
        task.resume()
    }
}
