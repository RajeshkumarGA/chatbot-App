//
//  AppDelegate.swift
//  ChatBot App
//
//  Created by RajeshKumar on 28/02/21.
//

import Foundation

class ApiCallsManager {
    
    func getChatMessageFromBotServer(name:String = "RajeshKumar",
                                     chatMessage: String,
                                     completionHandler:@escaping (_ response:ChatResponce?,_ error:String?) -> Void) {
        
        let message = getDecodedMessage(chatMessage:chatMessage)
        let params:[String:Any] = ["message":message,"externalID":name]
        NetworkManager.sharedInstance.callApi(endPoint: .getChat,
                                              method: .get,
                                              params: params) { (data, error) in
            
        completionHandler(data,error)
        }
                                            
                                              
    }
    
    
    private func getDecodedMessage(chatMessage:String) -> String {
        return chatMessage.replacingOccurrences(of: " ", with: "%20")
    }
}





