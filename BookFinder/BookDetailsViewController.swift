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
    
    // MARK: - Properties
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var wishlistSwitch: UISwitch!
    
    let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
    var book: Book!
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = book.title
        self.authorLabel.text = "Author: \(book.author)"
        self.genreLabel.text = "Genre: \(book.genres)"
        self.priceLabel.text = "Price: \(book.price) \(book.currency)"
        
        wishlistSwitch.on = isBookInWishlist()
        
        downloadBookCoverImage()
        saveBookInCoreData(book)
    }
    
    // MARK: - Actions
    
    @IBAction func buyButtonTapped(sender: UIButton) {
        UIApplication.sharedApplication().openURL(book.storeUrl)
    }
    
    @IBAction func wishlistSwitchChanged(sender: UISwitch) {
        toggleWishlistStatus()
        wishlistSwitch.on = sender.on
    }
    
    // MARK: -
    
    // save book in CoreData if it doesn't already exist
    func saveBookInCoreData(book: Book) {
        let fetchRequest = NSFetchRequest(entityName: "RecentlyViewedBook")
        
        // predicate
        let predicate = NSPredicate(format: "storeUrl=%@", book.storeUrl.absoluteString)
        fetchRequest.predicate = predicate
        
        do {
            let results = try coreDataStack.context.executeFetchRequest(fetchRequest)
            // insert new record
            if results.isEmpty {
                _ = RecentlyViewedBook(book: book, context: coreDataStack.context)
                coreDataStack.save()
            }
        } catch {
            print("Error while trying to fetch recently viewed books.")
        }
    }
    
    func isBookInWishlist() -> Bool {
        var inWishlist = false
        let fetchRequest = NSFetchRequest(entityName: "WishlistBook")
        
        // predicate
        let predicate = NSPredicate(format: "storeUrl=%@", book.storeUrl.absoluteString)
        fetchRequest.predicate = predicate
        
        do {
            let results = try coreDataStack.context.executeFetchRequest(fetchRequest)
            if !results.isEmpty {
                inWishlist = true
            }
        } catch {
            print("Error while trying to fetch recently viewed books.")
        }
        return inWishlist
    }
    
    func toggleWishlistStatus() {
        let fetchRequest = NSFetchRequest(entityName: "WishlistBook")
        
        // predicate
        let predicate = NSPredicate(format: "storeUrl=%@", book.storeUrl.absoluteString)
        fetchRequest.predicate = predicate
        
        do {
            let results = try coreDataStack.context.executeFetchRequest(fetchRequest)
            if results.isEmpty {
                _ = WishlistBook(book: book, context: coreDataStack.context)
                coreDataStack.save()
            } else {
                coreDataStack.context.deleteObject(results[0] as! WishlistBook)
                coreDataStack.save()
            }
        } catch {
            print("Error while trying to fetch wishlist books.")
        }
    }
    
    func downloadBookCoverImage() {
        ITCClient.sharedInstance.taskForImageWithUrl(book.imageUrl) {
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
