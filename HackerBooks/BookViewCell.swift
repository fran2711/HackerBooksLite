//
//  BookViewCell.swift
//  HackerBooks
//
//  Created by Fran Lucena on 5/2/17.
//  Copyright © 2017 Fran Lucena. All rights reserved.
//

import UIKit

class BookViewCell: UITableViewCell {
    
    // MARK: - Cell Properties
    
    static let cellId = "BookCellViewId"
    static let cellHeight: CGFloat = 95.0
    
    // MARK: - Outlets
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookTags: UILabel!
    @IBOutlet weak var bookAuthors: UILabel!
    
    private var _book: Book?
    
    private let _nc = NotificationCenter.default
    private var _bookObserver: NSObjectProtcol?
    
    func startObserving(book: Book) {
        _book = book
        _nc.addObserver(forName: BookCoverImageDidDownload, object: _book, queue: nil) { (n: Notification) in
            self.syncWithBook()
        }
        syncWithBook()
    }
    
    
    func stopObserving(){
        if let observer = _bookObserver {
            _nc.removeObserver(observer)
            _bookObserver = nil
            _book = nil
        }
    }
    
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        stopObserving()
        syncWithBook()
    }
    
    
    deinit {
        stopObserving()
    }
    
    private func syncWithBook(){
        UIView.transition(with: self.coverImage, duration: 0.7, options: [.transitionCrossDissolve], animations: { 
            self.coverImage.image = UIImage(data: (self._book?._cover.data)!)
        }, completion: nil)
        
        bookTitle.text = _book?.title
        bookAuthors.text = _book?.formattedListOfAuthors()
        bookTags.text = _book?.formattedListOfTags()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}

