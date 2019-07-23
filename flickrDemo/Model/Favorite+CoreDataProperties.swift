//
//  Favorite+CoreDataProperties.swift
//  flickrDemo
//
//  Created by aaron on 2019/7/23.
//  Copyright © 2019 aaron. All rights reserved.
//
//

import Foundation
import CoreData


extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "MyFavorite")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var image: NSData?

}
