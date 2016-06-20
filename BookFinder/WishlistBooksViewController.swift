//
//  WishlistBooksViewController.swift
//  BookFinder
//
//  Created by Atikur Rahman on 6/20/16.
//  Copyright © 2016 Atikur Rahman. All rights reserved.
//

import UIKit
import CoreData

class WishlistBooksViewController: UITableViewController {
    
    // MARK: - Properties
    
    let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
    var fetchedResultsController: NSFetchedResultsController!
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchWishlistBooks()
    }
    
    func fetchWishlistBooks() {
        let fetchRequest = NSFetchRequest(entityName: "WishlistBook")
        fetchRequest.sortDescriptors = []
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
            fetchedResultsController.delegate = self
        } catch {
            print("Error while trying to perform a search.")
        }
    }
    
    // MARK: -
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowWishlistBookDetails" {
            let destinationVC = segue.destinationViewController as! BookDetailsViewController
            let wishlistBook = fetchedResultsController.objectAtIndexPath(sender as! NSIndexPath) as! WishlistBook
            let book = Book(wishlistBook: wishlistBook)
            destinationVC.book = book
        }
    }
}

extension WishlistBooksViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            
        case .Update:
            tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
}

extension WishlistBooksViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WishlistBookCell", forIndexPath: indexPath)
        
        let wishlistBook = fetchedResultsController.objectAtIndexPath(indexPath) as! WishlistBook
        cell.textLabel?.text = wishlistBook.title
        cell.detailTextLabel?.text = wishlistBook.author
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowWishlistBookDetails", sender: indexPath)
    }
}
