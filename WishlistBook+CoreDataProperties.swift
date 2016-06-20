//
//  WishlistBook+CoreDataProperties.swift
//  BookFinder
//
//  Created by Atikur Rahman on 6/20/16.
//  Copyright © 2016 Atikur Rahman. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension WishlistBook {

    @NSManaged var author: String?
    @NSManaged var currency: String?
    @NSManaged var genre: String?
    @NSManaged var imageUrl: String?
    @NSManaged var price: NSNumber?
    @NSManaged var storeUrl: String?
    @NSManaged var title: String?

}
