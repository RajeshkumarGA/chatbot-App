//
//  ChatViewController.swift
//  ChatBot App
//
//  Created by RajeshKumar on 28/02/21.
//

import Foundation
import UIKit
import MessageKit
import InputBarAccessoryView
import CoreData



class ChatViewController: MessagesViewController,MessagesDataSource,MessagesLayoutDelegate,MessagesDisplayDelegate,UITextFieldDelegate {
    
    let reachability = try! Reachability()
    
    let user = Sender(senderId: "self", displayName: "chatBot")
    let otherUser = Sender(senderId: "other", displayName: "MediBuddy")
    var messageId : Int = 1
    var messages = [MessageType]()
    let apiCallmanager = ApiCallsManager()
    let coreDataClient = CoreDataClient()
    let dataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        self.setUpDelegates()
        self.getChatHistory()
        
        
        reachability.whenReachable = { _ in
            DispatchQueue.main.async {
                self.view.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                self.getBackUpData()
            }
        }
        
        reachability.whenUnreachable = { _ in
            DispatchQueue.main.async {
                self.view.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            }
        }
        
        do{
            try reachability.startNotifier()
        }catch{
            print("reachability Notifier not started")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.becomeFirstResponder()
        self.setUpMessageInputBar()
    }
    
    
    func setUpDelegates(){
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    func setUpMessageInputBar(){
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.tintColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        messageInputBar.sendButton.setTitleColor(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), for: .normal)
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 10, animated: true)
        messageInputBar.backgroundView.backgroundColor = #colorLiteral(red: 0.8896886706, green: 0.9060741663, blue: 0.9018747211, alpha: 1)
        messageInputBar.inputTextView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        messageInputBar.inputTextView.layer.cornerRadius = 10
    }
    
    func currentSender() -> SenderType {
        return user
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func getChatHistory() {
        let messages = dataManager.getChatHistory(userName: self.user, otherUserName: self.otherUser)
        for i in 0..<messages.count {
            self.insertNewMessage(messages[i])
        }
    }
    
    func getBackUpData() {
        let messages = dataManager.getBackUpData(userName: self.user, otherUserName: self.otherUser)
        for i in 0..<messages.count {
            self.insertNewMessage(messages[i])
            getChatResponseFromServer(chat: messages[i].text)
        }
        coreDataClient.deleteAllDataFromCoreData()
    }
    
    
    
    
    
    func insertNewMessage(_ message: Message) {
        messages.append(message)
        DispatchQueue.main.async {
            self.messagesCollectionView.reloadData()
        }
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToBottom(animated: true)
        }
    }
    
    func getChatResponseFromServer(chat: String) {
        self.messageId += 1
        DispatchQueue.main.async{
            self.apiCallmanager.getChatMessageFromBotServer(chatMessage: chat,completionHandler: { response, error in
                if let errorMessage = error {
                    self.showErrorAlert(title:"OOPS",message:errorMessage)
                }
                if let _ = response,let message = response?.message?.message {
                    self.insertNewMessage(Message(text: chat, sender: self.otherUser,
                                                  messageId: String(self.messageId),
                                                  sentDate: Date(),
                                                  kind: .text(message)))
                    self.coreDataClient.saveChatToCoreData(sender: self.otherUser.displayName, messageId: self.messageId, sentDate: Date(), message: message, entityName: "ChatData")
                }
                
                
            })}
    }
    
    
    
    private func showErrorAlert(title:String,message:String) {
        let alertVc:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        alertVc.addAction(alertAction)
        DispatchQueue.main.async {
            self.navigationController?.present(alertVc, animated: true)
        }
        
    }
}


extension ChatViewController {
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1): #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if message.sender.senderId == user.senderId {
            avatarView.image = #imageLiteral(resourceName: "IMG_0204")
        } else {
            avatarView.image = #imageLiteral(resourceName: "medibuddyWithName")
            
        }
    }
    
    internal func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight: .bottomLeft
        return .bubbleTail(corner, .curved)
    }
}


extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        self.messageId+=1
        self.insertNewMessage(Message(text: text, sender: user,
                                messageId: String(messageId),
                                sentDate: Date(),
                                kind: .text(text)))
        
        print(reachability.connection.description)
//        WiFi,Cellular
        if reachability.connection.description == "WiFi" || reachability.connection.description == "Cellular"{
            DispatchQueue.main.async {
                self.getChatResponseFromServer(chat: text)
                self.coreDataClient.saveChatToCoreData(sender: self.user.displayName, messageId: self.messageId, sentDate: Date(), message: text, entityName: "ChatData")
            }
        }else{
            DispatchQueue.main.async {
                self.coreDataClient.saveChatToCoreData(sender: self.user.displayName, messageId: self.messageId, sentDate: Date(), message: text, entityName: "BackUpData")
            }
        }
      
    inputBar.inputTextView.text = ""
    messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: false)
  }
}


