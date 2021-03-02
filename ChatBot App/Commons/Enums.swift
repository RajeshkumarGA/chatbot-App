//
//  AppDelegate.swift
//  ChatBot App
//
//  Created by RajeshKumar on 28/02/21.
//

import Foundation

enum ServerType {
    case production
    case staging
    case develop
    
    func getString() -> String {
        switch self {
            case .production:
                return ""
            case .staging:
                return ""
            case .develop:
                return "https://www.personalityforge.com"
        }
    }
}

enum Endpoints {
    case getChat
    
    func getString() -> String {
        switch self {
            case .getChat:
                return "/api/chat/?apiKey=6nt5d1nJHkqbkphe&chatBotID=63906"
        }
    }
}



enum HttpMethod {
    case post
    case get
    case put
    
    func getString() -> String {
        switch self {
        case .post:
            return "POST"
        case .get:
            return "GET"
        case .put:
            return "PUT"
        }
    }
}
