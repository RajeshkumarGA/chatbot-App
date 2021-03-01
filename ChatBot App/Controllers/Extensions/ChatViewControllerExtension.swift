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
        self.getChatResponseFromServer(chat: text)
        
        LocalHistoryManager.shared.saveChatToCoreData(sender: user.displayName, messageId: messageId, sentDate: Date(), message: text)

    inputBar.inputTextView.text = ""
    messagesCollectionView.reloadData()
    messagesCollectionView.scrollToBottom(animated: true)
  }
}
