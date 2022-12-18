//
//  UserCache+CoreDataClass.swift
//  Mockeando
//
//  Created by Franklin Samboni on 17/12/22.
//
//

import Foundation
import CoreData

@objc(ManagedUser)
class ManagedUser: NSManagedObject {
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var username: String?
    @NSManaged public var email: String?
    @NSManaged public var city: String?
    @NSManaged public var website: String?
    @NSManaged public var company: String?

    @nonobjc class func fetchRequest() -> NSFetchRequest<ManagedUser> {
        return NSFetchRequest<ManagedUser>(entityName: "ManagedUser")
    }
}
