//
//  RecentlyViewedBooksViewedController.swift
//  BookFinder
//
//  Created by Atikur Rahman on 6/19/16.
//  Copyright © 2016 Atikur Rahman. All rights reserved.
//

import UIKit
import CoreData

class RecentlyViewedBooksViewController: UITableViewController {
    
    let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
    
    var fetchedResultsController: NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRecentlyViewedBooks()
    }
    
    func fetchRecentlyViewedBooks() {
        let fetchRequest = NSFetchRequest(entityName: "RecentlyViewedBook")
        fetchRequest.sortDescriptors = []
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
            fetchedResultsController.delegate = self
        } catch {
            print("Erro while trying to perform a search.")
        }
    }
}

extension RecentlyViewedBooksViewController: NSFetchedResultsControllerDelegate {
    
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

extension RecentlyViewedBooksViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecentlyViewedBookCell", forIndexPath: indexPath)
        
        let recentlyViewedBook = fetchedResultsController.objectAtIndexPath(indexPath) as! RecentlyViewedBook
        cell.textLabel?.text = recentlyViewedBook.title
        cell.detailTextLabel?.text = recentlyViewedBook.author
        
        return cell
    }
}