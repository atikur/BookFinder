//
//  BookSearchViewController.swift
//  BookFinder
//
//  Created by Atikur Rahman on 6/17/16.
//  Copyright © 2016 Atikur Rahman. All rights reserved.
//

import UIKit

class BookSearchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       getBooksForSearchTerm("Harry Potter")
    }
    
    func getBooksForSearchTerm(term: String) {
        ITCClient.sharedInstance.getBooksForSearchTerm(term) {
            booksList, errorString in
            
            guard let booksList = booksList else {
                self.displayError("Error", message: errorString)
                return
            }
            
            print(booksList)
        }
    }
    
    func displayError(title: String, message: String?) {
        if let message = message {
            // TODO: display error to user
            print(message)
        }
    }
}
