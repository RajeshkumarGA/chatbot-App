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


struct Sender: SenderType{
    var senderId: String
    var displayName: String
}

struct Message : MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

class ChatViewController: MessagesViewController,MessagesDataSource,MessagesLayoutDelegate,MessagesDisplayDelegate,UITextFieldDelegate {
    
    let reachability = try! Reachability()
    
    let user = Sender(senderId: "self", displayName: "chatBot")
    let otherUser = Sender(senderId: "other", displayName: "MediBuddy")
    var messageId : Int = 1
    var messages = [MessageType]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpDelegates()
        self.getHistory()
        
        reachability.whenReachable = { _ in
            DispatchQueue.main.async {
                self.view.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
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
        messageInputBar.inputTextView.tintColor = .blue
        messageInputBar.sendButton.setTitleColor(.purple, for: .normal)
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
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
    
    func getHistory(){
        var history : [SavedChats] = LocalHistoryManager.shared.getAllChats()
        for d in history{
            var sender = self.user
            guard let msgId = d.messageId else {return}
            guard let senderName = d.sender else {return}
            guard let sentDate = d.sentDate else {return}
            guard let message = d.message else {return}
            if senderName == "chatBot"{
                sender = self.user
            }else{
                sender = self.otherUser
            }
            self.insertNewMessage(Message(sender: sender,
                                          messageId: String(msgId),
                                   sentDate: sentDate,
                                   kind: .text(message)))
            
        }
        
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
        var replayMessage : String = ""
        self.messageId += 1
        DispatchQueue.main.async{
            getChatData.shared.getChatMessageFromBotServer(chatMessage: chat, userCompletionHandler: { message, error in
             replayMessage =  message
             self.insertNewMessage(Message(sender: self.otherUser,
                                           messageId: String(self.messageId),
                                    sentDate: Date(),
                                    kind: .text(replayMessage)))
                LocalHistoryManager.shared.saveChatToCoreData(sender: self.otherUser.displayName, messageId: self.messageId, sentDate: Date(), message: replayMessage)
        })}
    }
}

