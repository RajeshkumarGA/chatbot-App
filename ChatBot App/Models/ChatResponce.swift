//
//  ChatResponce.swift
//  ChatBot App
//
//  Created by RajeshKumar on 28/02/21.
//

import Foundation
struct ChatResponce : Decodable{
    let success : Int?
    let errorMessage : String?
    let message : MessageResponce?
    let data : [String]?
}
