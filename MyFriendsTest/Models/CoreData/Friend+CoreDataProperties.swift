//
//  Friend+CoreDataProperties.swift
//  
//
//  Created by Anna on 12/27/19.
//
//

import Foundation
import CoreData


extension Friend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Friend> {
        return NSFetchRequest<Friend>(entityName: "Friend")
    }

    @NSManaged public var email: String?
    @NSManaged public var name: String?
    @NSManaged public var isFriend: Bool
    @NSManaged public var phone: String?
    @NSManaged public var largePicture: String?
    @NSManaged public var thumbnail: String?
    @NSManaged public var id: String?

}
