//
//  AppDelegate.swift
//  ChatBot App
//
//  Created by RajeshKumar on 28/02/21.
//

import Foundation
import CoreData

class CoreDataClient {
    private let coreDataQueryManager:CoreDataQueryManager
    
    
    init() {
        coreDataQueryManager = CoreDataQueryManager()
    }
    
    
    public func getAllChats(entityName:String) -> [SavedChats] {
        return coreDataQueryManager.getAllChats(entityName:entityName)
    }
    
    public func saveChatToCoreData(sender : String,messageId: Int,sentDate: Date,message: String,entityName: String) {
    coreDataQueryManager.saveChatToCoreData(sender : sender,
                                                       messageId: messageId,
                                                       sentDate: sentDate,
                                                       message: message,
                                                       entityName:entityName)
    }
    
    public func deleteAllDataFromCoreData(){
        coreDataQueryManager.deleteAllDataFromCoreData()
    }
}
