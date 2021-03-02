//
//  SavedChats.swift
//  ChatBot App
//
//  Created by RajeshKumar on 01/03/21.
//

import Foundation
import MessageKit

struct SavedChats : Decodable{
    let messageId : Int?
    let sender : String?
    let sentDate : Date?
    let message : String?
}


struct Sender: SenderType{
    var senderId: String
    var displayName: String
}

struct Message : MessageType {
    var text:String
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

