//
//  Book.swift
//  BookFinder
//
//  Created by Atikur Rahman on 6/17/16.
//  Copyright © 2016 Atikur Rahman. All rights reserved.
//

import Foundation

struct Book {
    let title: String
    let author: String
    let imageUrl: NSURL
    let storeUrl: NSURL
    let currency: String
    let price: Double
    let genres: String
    
    init(recentlyViewedBook: RecentlyViewedBook) {
        self.title = recentlyViewedBook.title!
        self.author = recentlyViewedBook.author!
        self.imageUrl = NSURL(string: recentlyViewedBook.imageUrl!)!
        self.storeUrl = NSURL(string: recentlyViewedBook.storeUrl!)!
        self.currency = recentlyViewedBook.currency!
        self.price = recentlyViewedBook.price! as Double
        self.genres = recentlyViewedBook.genre!
    }
    
    init(wishlistBook: WishlistBook) {
        self.title = wishlistBook.title!
        self.author = wishlistBook.author!
        self.imageUrl = NSURL(string: wishlistBook.imageUrl!)!
        self.storeUrl = NSURL(string: wishlistBook.storeUrl!)!
        self.currency = wishlistBook.currency!
        self.price = wishlistBook.price! as Double
        self.genres = wishlistBook.genre!
    }
    
    init?(dictionary: [String: AnyObject]) {
        guard let title = dictionary[ITCClient.ResponseKeys.TrackName] as? String,
            imageUrlStr = dictionary[ITCClient.ResponseKeys.ArtworkUrl] as? String,
            imageUrl = NSURL(string: imageUrlStr),
            storeUrlStr = dictionary[ITCClient.ResponseKeys.TrackViewUrl] as? String,
            storeUrl = NSURL(string: storeUrlStr),
            currency = dictionary[ITCClient.ResponseKeys.Currency] as? String,
            price = dictionary[ITCClient.ResponseKeys.Price] as? Double,
            genresArr = dictionary[ITCClient.ResponseKeys.Genres] as? [String],
            author = dictionary[ITCClient.ResponseKeys.ArtistName] as? String else {
            return nil
        }
        
        self.title = title
        self.author = author
        self.imageUrl = imageUrl
        self.storeUrl = storeUrl
        self.currency = currency
        self.price = price
        self.genres = genresArr.joinWithSeparator(",")
    }
    
    static func booksListFromResults(results: [[String: AnyObject]]) -> [Book] {
        var booksList = [Book]()
        
        for result in results {
            if let book = Book(dictionary: result) {
                booksList.append(book)
            }
        }
        
        return booksList
    }
}