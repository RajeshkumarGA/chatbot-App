//
//  ChatData+CoreDataProperties.swift
//  
//
//  Created by RajeshKumar on 02/03/21.
//
//

import Foundation
import CoreData


extension ChatData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatData> {
        return NSFetchRequest<ChatData>(entityName: "ChatData")
    }

    @NSManaged public var message: String?
    @NSManaged public var messageId: Int64
    @NSManaged public var sender: String?
    @NSManaged public var sentDate: Date?

}
