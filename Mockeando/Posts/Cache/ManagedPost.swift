//
//  ManagedPost.swift
//  Mockeando
//
//  Created by Franklin Samboni on 17/12/22.
//
//

import Foundation
import CoreData

@objc(ManagedPost)
class ManagedPost: NSManagedObject {
    @NSManaged public var userId: Int64
    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var isFavorite: Bool
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<ManagedPost> {
        return NSFetchRequest<ManagedPost>(entityName: "ManagedPost")
    }
}
