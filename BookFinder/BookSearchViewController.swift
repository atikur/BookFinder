//
//  BookSearchViewController.swift
//  BookFinder
//
//  Created by Atikur Rahman on 6/17/16.
//  Copyright © 2016 Atikur Rahman. All rights reserved.
//

import UIKit

class BookSearchViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var dataTask: NSURLSessionDataTask?
    var books = [Book]()
    
    // MARK: - Search Books
    
    func getBooksForSearchTerm(term: String) {
        dataTask = ITCClient.sharedInstance.getBooksForSearchTerm(term) {
            booksList, errorString in
            
            guard let booksList = booksList else {
                self.displayError("Error", message: errorString)
                return
            }
            
            self.books = booksList
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    func displayError(title: String, message: String?) {
        if let message = message {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            let okayAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
            alertController.addAction(okayAction)
            
            dispatch_async(dispatch_get_main_queue()) {
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Prepare For Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowBookDetails" {
            let destinationVC = segue.destinationViewController as! BookDetailsViewController
            destinationVC.book = books[(sender as! NSIndexPath).row]
        }
    }
}

extension BookSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BookCell") as! BookTableViewCell
        let book = books[indexPath.row]
        
        configureCell(cell, forIndexPath: indexPath, withBook: book)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowBookDetails", sender: indexPath)
    }
    
    // MARK: - Helpers
    
    func configureCell(cell: BookTableViewCell, forIndexPath indexPath: NSIndexPath, withBook book: Book) {
        cell.titleLabel.text = book.title
        cell.authorLabel.text = book.author
        cell.bookImageView.image = nil
        
        let task = ITCClient.sharedInstance.taskForImageWithUrl(book.imageUrl) {
            data, error in
            
            guard let data = data,
                downloadedImage = UIImage(data: data) else {
                    return
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                if let updateCell = self.tableView.cellForRowAtIndexPath(indexPath) as? BookTableViewCell {
                    updateCell.bookImageView.image = downloadedImage
                }
            }
        }
        
        cell.taskToCancelIfCellIsReused = task
    }
}

extension BookSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else {
            return
        }
        
        searchBar.resignFirstResponder()
        dataTask?.cancel()
        
        getBooksForSearchTerm(searchTerm)
    }    
}
