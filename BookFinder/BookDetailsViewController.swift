//
//  BookDetailsViewController.swift
//  BookFinder
//
//  Created by Atikur Rahman on 6/19/16.
//  Copyright © 2016 Atikur Rahman. All rights reserved.
//

import UIKit
import CoreData

class BookDetailsViewController: UIViewController {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
    var book: Book!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = book.name
        self.authorLabel.text = "Author: \(book.artist)"
        self.genreLabel.text = "Genre: \(book.genres)"
        self.priceLabel.text = "Price: \(book.price) \(book.currency)"
        
        downloadBookCoverImage()
        saveBookInCoreData(book)
    }
    
    func saveBookInCoreData(book: Book) {
        let fetchRequest = NSFetchRequest(entityName: "RecentlyViewedBook")
        
        let predicate = NSPredicate(format: "storeUrl=%@", book.storeUrl.absoluteString)
        fetchRequest.predicate = predicate
        
        do {
            let results = try coreDataStack.context.executeFetchRequest(fetchRequest)
            // insert if book isn't already added
            if results.isEmpty {
                print("results empty")
                _ = RecentlyViewedBook(book: book, context: coreDataStack.context)
                coreDataStack.save()
            } else {
                print(results.count)
            }
        } catch {
            print("Error while trying to fetch recently viewed books.")
        }
    }
    
    func downloadBookCoverImage() {
        ITCClient.sharedInstance.taskForImageWithUrl(book.imageUrl100) {
            data, error in
            
            guard let data = data,
                downloadedImage = UIImage(data: data) else {
                    return
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.bookImageView.image = downloadedImage
            }
        }
    }
}
