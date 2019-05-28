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
        
        AF.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            
            // 3.获取结果
            guard let result = response.result.value else {
                print(response.result.value ?? "")
                return
            }
            
            // 4.将结果回调出去
            finishedCallback(result)
        }
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
//        let imageData
        let data = imageData?.base64EncodedData()
//        let urlString = "https://blissmotors-web-upload.s3.amazonaws.com/test.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAX7JZ5S7OYYBHPMNO%2F20190528%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20190528T221253Z&X-Amz-Expires=600&X-Amz-SignedHeaders=content-encoding%3Bcontent-type%3Bhost&X-Amz-Signature=92e9008840daefed38eec24267d817c7b4d4f35db2c2f6483fd9b608bade7b58"
        let urlString = "https://blissmotors-web-upload.s3.amazonaws.com/test.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAX7JZ5S7OYYBHPMNO/20190528/us-east-1/s3/aws4_request&X-Amz-Date=20190528T222315Z&X-Amz-Expires=600&X-Amz-SignedHeaders=content-encoding;content-type;host&X-Amz-Signature=acdd037e21d844fc2ee4df48da96dcaae3feba39396758cc815e6706d35b20d7"
//        urlString = String(utf8String: urlString.cString(using: String.Encoding.utf8)!)!.replacingOccurrences(of: "\"", with: "")
        ZJPrint("123123")
        ZJPrint(urlString)
//        var requestURL = URL(string: urlString!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        guard let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            let myURL = URL(string: encoded) else{
            return
        }
        let requestURL = myURL
//        let requestURL = URL(urlString)
//        let requestURL = URL(string: urlString!)!
        ZJPrint(requestURL)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.setValue("base64", forHTTPHeaderField: "Content-Encoding")
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        
//        request.setValue("public-read", forHTTPHeaderField: "x-amz-acl")
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) { (data, responce, error) in
            ZJPrint(data)
            let result = String(decoding: data!, as: UTF8.self)
            
            let dict = convertToDictionary(text: result)
            ZJPrint(result)
            ZJPrint(dict)
            ZJPrint(error)
            completion(data, error)
        }
        task.resume()
        

    }
    
   static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
   
}
