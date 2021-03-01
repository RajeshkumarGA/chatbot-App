//
//  localHistoryManager.swift
//  ChatBot App
//
//  Created by RajeshKumar on 01/03/21.
//

import Foundation
import CoreData
import UIKit

class LocalHistoryManager{
    static let shared = LocalHistoryManager()
    private init(){}
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getAllChats(entityName: String) -> [SavedChats]{
        var allSavedChats = [SavedChats]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let records = try context.fetch(fetchRequest)
            
            for chat in records as! [NSManagedObject]{
                allSavedChats.append(SavedChats(messageId: chat.value(forKey: "messageId") as! Int, sender: chat.value(forKey: "sender") as! String, sentDate: chat.value(forKey: "sentDate") as! Date, message: chat.value(forKey: "message") as! String))
//                print(chat.value(forKey: "messageId"))
//                print(chat.value(forKey: "sender"))
//                print(chat.value(forKey: "sentDate"))
//                print(chat.value(forKey: "message"))
            }
        } catch {
            print("Fetching Failed")
        }
        return allSavedChats
    }
    
    func saveChatToCoreData(sender : String,messageId: Int,sentDate: Date,message: String,entityName: String){
        
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(messageId, forKey: "messageId")
        newUser.setValue(sender, forKey: "sender")
        newUser.setValue(sentDate, forKey: "sentDate")
        newUser.setValue(message, forKey: "message")
        do{
            try context.save()
        }catch{
            print("core data save failed")
        }
        
    }
    
    func deleteAllDataFromCoreData(){
        var allSavedChats = [SavedChats]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BackUpData")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let records = try context.fetch(fetchRequest)
            
            for chat in records{
                context.delete(chat as! NSManagedObject)
            }
            try context.save()
            } catch {
                print("delete Failed")
            }
    }
    
    

    
}
