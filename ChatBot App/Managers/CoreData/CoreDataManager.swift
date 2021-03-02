//
//  AppDelegate.swift
//  ChatBot App
//
//  Created by RajeshKumar on 28/02/21.
//

import Foundation
import CoreData


class CoreDataManager {
    static let sharedInstance:CoreDataManager = CoreDataManager()
    
    private init() {
        
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ChatBot_App")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    func getCoreDataContext() ->  NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    
}
