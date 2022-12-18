//
//  ManagedPostComment.swift
//  Mockeando
//
//  Created by Franklin Samboni on 17/12/22.
//
//

import Foundation
import CoreData

@objc(ManagedPostComment)
class ManagedPostComment: NSManagedObject {
    @NSManaged public var id: Int64
    @NSManaged public var postId: Int64
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var body: String?

    @nonobjc class func fetchRequest() -> NSFetchRequest<ManagedPostComment> {
        return NSFetchRequest<ManagedPostComment>(entityName: "ManagedPostComment")
    }
}
