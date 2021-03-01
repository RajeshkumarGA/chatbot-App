//
//  BackUpData+CoreDataProperties.swift
//  
//
//  Created by RajeshKumar on 01/03/21.
//
//

import Foundation
import CoreData


extension BackUpData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BackUpData> {
        return NSFetchRequest<BackUpData>(entityName: "BackUpData")
    }

    @NSManaged public var sender: String?
    @NSManaged public var sentDate: Date?
    @NSManaged public var message: String?
    @NSManaged public var messageId: Int64

}
