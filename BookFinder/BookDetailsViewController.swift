//
//  BookDetailsViewController.swift
//  BookFinder
//
//  Created by Atikur Rahman on 6/19/16.
//  Copyright © 2016 Atikur Rahman. All rights reserved.
//

import UIKit

class BookDetailsViewController: UIViewController {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var book: Book!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = book.name
        self.authorLabel.text = "Author: \(book.artist)"
        self.genreLabel.text = "Genre: \(book.genres)"
        self.priceLabel.text = "Price: \(book.price) \(book.currency)"
        
        downloadBookCoverImage()
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
