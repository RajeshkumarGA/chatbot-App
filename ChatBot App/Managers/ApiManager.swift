//
//  ApiManager.swift
//  ChatBot App
//
//  Created by RajeshKumar on 28/02/21.
//

import Foundation
class getChatData{
    static let shared = getChatData()
    private init(){}
    func getChatMessageFromBotServer(chatMessage: String, userCompletionHandler: @escaping (String, Error?) -> Void) {
      var name = "RajeshKumar"
      let jsonUrl = "https://www.personalityforge.com/api/chat/?apiKey=6nt5d1nJHkqbkphe&message=\(chatMessage.replacingOccurrences(of: " ", with: "%20"))&chatBotID=63906&externalID=\(name)"
      guard let url = URL(string: jsonUrl) else {return}
      let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in

        guard let data = data else { return }
        do {
            let course = try JSONDecoder().decode(ChatResponce.self, from : data)
            print(course.message?.message)
            if let chatMessage = course.message?.message{
                userCompletionHandler(chatMessage, nil)
            }
        } catch let parseErr {
          print("JSON Parsing Error", parseErr)
            userCompletionHandler("", parseErr)
        }
      })
      task.resume()
    }
}

