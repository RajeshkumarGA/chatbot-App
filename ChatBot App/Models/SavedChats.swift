//
//  SavedChats.swift
//  ChatBot App
//
//  Created by RajeshKumar on 01/03/21.
//

import Foundation

struct SavedChats : Decodable{
    let messageId : Int?
    let sender : String?
    let sentDate : Date?
    let message : String?
}

