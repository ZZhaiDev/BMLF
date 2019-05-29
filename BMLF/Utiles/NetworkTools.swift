//
//  NetworkTools.swift
//  Carloudy-Weather
//
//  Created by Zijia Zhai on 12/13/18.
//  Copyright © 2018 cognitiveAI. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {
    case get
    case post
}

class NetworkTools {
    class func requestData(_ type : MethodType, URLString : String, parameters : [String : Any]? = nil, finishedCallback :  @escaping (_ result : Any) -> ()) {
        
        // 1.获取类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        // 2.发送网络请求
//        ZJPrint(URLString)
        AF.request(URLString, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            // 3.获取结果
            guard let result = response.result.value else {
                print(response.result.value ?? "")
                return
            }

            // 4.将结果回调出去
            finishedCallback(result)
        }
//        AF.request(URLString, method: .post, parameters: parameters, encoder: JSONEncoding.default, headers: nil).responseJSON { (response) in
//            // 3.获取结果
//            guard let result = response.result.value else {
//                print(response.result.value ?? "")
//                return
//            }
//
//            // 4.将结果回调出去
//            finishedCallback(result)
//        }

    }
}


class ApiService{
    static func getPostString(params:[String:Any]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    
    static func callPost(url:URL, params:[String:Any], finish: @escaping ((message:String, data:Data?)) -> Void){
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let postString = self.getPostString(params: params)
        request.httpBody = postString.data(using: .utf8)
        
        var result:(message:String, data:Data?) = (message: "Fail", data: nil)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if(error != nil)
            {
                result.message = "Fail Error not null : \(error.debugDescription)"
            }
            else
            {
                ZJPrint(response)
                ZJPrint(response?.description)
                ZJPrint(data)
                ZJPrint(data?.description)
                result.message = "Success"
                result.data = data
            }
            
            finish(result)
        }
        task.resume()
    }
    
    
    static func uploadToS3(image: UIImage, urlString: String, completion: @escaping (Data?, Error?) -> Void) {
        let imageData = image.jpegData(compressionQuality: 0.9)
        let decodedURLString = urlString.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "\n", with: "").removingPercentEncoding!
        ZJPrint(decodedURLString)
        guard let encoded = decodedURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let myURL = URL(string: encoded) else{
            return
        }
        ZJPrint(myURL)
        var request = URLRequest(url: myURL)
        request.httpMethod = "PUT"
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.setValue("base64", forHTTPHeaderField: "Content-Encoding")
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        request.httpBody = imageData
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, responce, error) in
            let result = String(decoding: data!, as: UTF8.self)
//            let dict = convertToDictionary(text: result)
            ZJPrint(result)
//            ZJPrint(dict)
            ZJPrint(error)
            completion(data, error)
        }
        task.resume()
    }
    
//   static func convertToDictionary(text: String) -> [String: Any]? {
//        if let data = text.data(using: .utf8) {
//            do {
//                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//        return nil
//    }
    
    
   
}
