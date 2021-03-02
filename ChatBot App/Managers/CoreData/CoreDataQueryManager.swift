//
//  localHistoryManager.swift
//  ChatBot App
//
//  Created by RajeshKumar on 01/03/21.
//

import Foundation
import CoreData

class CoreDataQueryManager {
    let context:NSManagedObjectContext!
    
    init(moc:NSManagedObjectContext = CoreDataManager.sharedInstance.getCoreDataContext()) {
        context = moc
    }
    
    
    func getAllChats(entityName: String) -> [SavedChats]{
        var allSavedChats = [SavedChats]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let records = try context.fetch(fetchRequest)
            
            for chat in records as! [NSManagedObject]{
                let savedChat = SavedChats(messageId: chat.value(forKey: "messageId") as! Int,
                                           sender: chat.value(forKey: "sender") as! String,
                                           sentDate: chat.value(forKey: "sentDate") as! Date,
                                           message: chat.value(forKey: "message") as! String)
                allSavedChats.append(savedChat)

            }
        } catch {
            print("Fetching Failed")
        }
        return allSavedChats
    }
    
    func saveChatToCoreData(sender : String,messageId: Int,sentDate: Date,message: String,entityName: String){
        
        if let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) {
            let newUser = NSManagedObject(entity: entity, insertInto: context)
            newUser.setValue(messageId, forKey: "messageId")
            newUser.setValue(sender, forKey: "sender")
            newUser.setValue(sentDate, forKey: "sentDate")
            newUser.setValue(message, forKey: "message")
            saveContext()
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
            saveContext()
        }
        catch {
                
        }
    }
    
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                debugPrint("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    

    
}
