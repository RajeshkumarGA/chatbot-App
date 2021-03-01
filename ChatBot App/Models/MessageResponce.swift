//
//  MessageResponce.swift
//  ChatBot App
//
//  Created by RajeshKumar on 28/02/21.
//

import Foundation
struct MessageResponce: Decodable {
    let chatBotID : Int?
    let chatBotName : String?
    let message : String?
    let emotion : String?
}
