//
//  Book.swift
//  BookFinder
//
//  Created by Atikur Rahman on 6/17/16.
//  Copyright © 2016 Atikur Rahman. All rights reserved.
//

import Foundation

struct Book {
    let name: String
    let artist: String
    let imageUrl60: NSURL
    let imageUrl100: NSURL
    let storeUrl: NSURL
    let currency: String
    let price: Double
    let genres: String
    
    init?(dictionary: [String: AnyObject]) {
        guard let name = dictionary[ITCClient.ResponseKeys.TrackName] as? String,
            imageUrl60Str = dictionary[ITCClient.ResponseKeys.ArtworkUrl60] as? String,
            imageUrl60 = NSURL(string: imageUrl60Str),
            imageUrl100Str = dictionary[ITCClient.ResponseKeys.ArtworkUrl100] as? String,
            imageUrl100 = NSURL(string: imageUrl100Str),
            storeUrlStr = dictionary[ITCClient.ResponseKeys.TrackViewUrl] as? String,
            storeUrl = NSURL(string: storeUrlStr),
            currency = dictionary[ITCClient.ResponseKeys.Currency] as? String,
            price = dictionary[ITCClient.ResponseKeys.Price] as? Double,
            genresArr = dictionary[ITCClient.ResponseKeys.Genres] as? [String],
            artist = dictionary[ITCClient.ResponseKeys.ArtistName] as? String else {
            return nil
        }
        
        self.name = name
        self.artist = artist
        self.imageUrl60 = imageUrl60
        self.imageUrl100 = imageUrl100
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