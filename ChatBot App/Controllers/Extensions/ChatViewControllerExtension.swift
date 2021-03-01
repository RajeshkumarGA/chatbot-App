//
//  ChatViewControllerExtension.swift
//  ChatBot App
//
//  Created by RajeshKumar on 28/02/21.
//

import Foundation
import InputBarAccessoryView

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        self.messageId+=1
        self.insertNewMessage(Message(sender: user,
                                messageId: String(messageId),
                                sentDate: Date(),
                                kind: .text(text)))
        
        print(reachability.connection.description)
//        WiFi,Cellular
        if reachability.connection.description == "WiFi" || reachability.connection.description == "Cellular"{
            DispatchQueue.main.async {
                self.getChatResponseFromServer(chat: text)
                LocalHistoryManager.shared.saveChatToCoreData(sender: self.user.displayName, messageId: self.messageId, sentDate: Date(), message: text, entityName: "ChatData")
            }
        }else{
            DispatchQueue.main.async {
                LocalHistoryManager.shared.saveChatToCoreData(sender: self.user.displayName, messageId: self.messageId, sentDate: Date(), message: text, entityName: "BackUpData")
            }
        }
      
    inputBar.inputTextView.text = ""
    messagesCollectionView.reloadData()
    messagesCollectionView.scrollToBottom(animated: true)
  }
}
