//
//  AppDelegate.swift
//  ChatBot App
//
//  Created by RajeshKumar on 28/02/21.
//

import Foundation

class NetworkManager {
    static let sharedInstance:NetworkManager = NetworkManager()
    private let session = URLSession.shared
    private let serverType:ServerType = .develop
    
    
    private init() {
    }
    
    
    func callApi(endPoint: Endpoints,
                 method:HttpMethod,
                 params: [String: Any],
                 completionHandler:@escaping (_ data: ChatResponce?, _ error:String?) -> Void) {
        
        var urlString:String = serverType.getString() + endPoint.getString()
        if method == .get {
            for (key, value) in params {
                urlString = urlString + "&\(key)=\(value)"
            }
        }
        print(urlString)
        var request = URLRequest(url: URL(string: urlString)!)
        
        
        do {
            let data = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
            request.httpBody = method == .post ? data : nil
        }catch _ {
           print("data JSONSerialization error params to data")
        }
        
        
        
        let task = session.dataTask(with: request) { (data, urlResponse, apiError) in
            guard apiError == nil else {
                completionHandler(nil, "\(apiError.debugDescription)")
                return
            }
            
            guard data != nil else {
                completionHandler(nil, "\(apiError.debugDescription)")
                return
            }
            
            do {
                let chatData = try JSONDecoder().decode(ChatResponce.self, from: data!)
                completionHandler(chatData, nil)
            } catch let err as NSError {
                completionHandler(nil, "\(err.debugDescription)")
            }
        }
        
        task.resume()
    }
}
