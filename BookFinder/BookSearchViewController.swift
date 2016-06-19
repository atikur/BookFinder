//
//  BookSearchViewController.swift
//  BookFinder
//
//  Created by Atikur Rahman on 6/17/16.
//  Copyright © 2016 Atikur Rahman. All rights reserved.
//

import UIKit

class BookSearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var dataTask: NSURLSessionDataTask?
    
    var books: [Book]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        books = []
    }
    
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
            // TODO: display error to user
            print(message)
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
    
    // MARK: - Helper
    
    func configureCell(cell: BookTableViewCell, forIndexPath indexPath: NSIndexPath, withBook book: Book) {
        cell.titleLabel.text = book.name
        cell.authorLabel.text = book.artist
        cell.bookImageView.image = nil
        
        let task = ITCClient.sharedInstance.taskForImageWithUrl(book.imageUrl60) {
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
