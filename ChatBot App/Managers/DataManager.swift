//
//  AppDelegate.swift
//  ChatBot App
//
//  Created by RajeshKumar on 28/02/21.
//

import Foundation
import MessageKit

class DataManager {
    let coreDataClient = CoreDataClient()
    
    
    func getChatHistory(userName:Sender,otherUserName:Sender) -> [Message]{
        var messages = [Message]()
        let history : [SavedChats] = coreDataClient.getAllChats(entityName: "ChatData")
        for d in history{
            var sender = userName
            guard let text = d.message else {return []}
            guard let msgId = d.messageId else {return []}
            guard let senderName = d.sender else {return []}
            guard let sentDate = d.sentDate else {return []}
            guard let message = d.message else {return []}
            if senderName == "chatBot"{
                sender = userName
            }else{
                sender = otherUserName
            }
            let messageData = Message(text: text, sender: sender,
                                          messageId: String(msgId),
                                          sentDate: sentDate,
                                          kind: .text(message))
            messages.append(messageData)
            
        }
        return messages
        
    }
    
    
    func getBackUpData(userName:Sender,otherUserName:Sender) -> [Message]{
        var messages = [Message]()
        let history : [SavedChats] = coreDataClient.getAllChats(entityName: "BackUpData")
        if history.count == 0{
            return messages
        }else{
            for d in history{
                var sender = userName
                guard let text = d.message else {return []}
                guard let msgId = d.messageId else {return []}
                guard let senderName = d.sender else {return []}
                guard let sentDate = d.sentDate else {return []}
                guard let message = d.message else {return []}
                if senderName == "chatBot"{
                    sender = userName
                }else{
                    sender = otherUserName
                }
                let messageData = Message(text: text, sender: sender,
                                              messageId: String(msgId),
                                              sentDate: sentDate,
                                              kind: .text(message))
                
                messages.append(messageData)
                
            }
            return messages
        }
    }
}
