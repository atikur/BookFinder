//
//  RecentlyViewedBook.swift
//  BookFinder
//
//  Created by Atikur Rahman on 6/19/16.
//  Copyright © 2016 Atikur Rahman. All rights reserved.
//

import Foundation
import CoreData


class RecentlyViewedBook: NSManagedObject {

    convenience init(book: Book, context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entityForName("RecentlyViewedBook", inManagedObjectContext: context) {
            self.init(entity: entity, insertIntoManagedObjectContext: context)
            self.title = book.title
            self.author = book.author
            self.price = book.price
            self.currency = book.currency
            self.storeUrl = book.storeUrl.absoluteString
            self.imageUrl = book.imageUrl.absoluteString
            self.genre = book.genres
        } else {
            fatalError("Unable to find Entitiy 'RecentlyViewedBook'.")
        }
    }

}
