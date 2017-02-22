//
//  Library.swift
//  HackerBooks
//
//  Created by Fran Lucena on 4/2/17.
//  Copyright © 2017 Fran Lucena. All rights reserved.
//

import Foundation

typealias Books = MultiDictionary<Tag, Book>

class Library {
    
    //MARK: - Properties

    var _books : Books
    var _bookObserver : NSObjectProtocol?
    
    
    //MARK: - Initialization
    
    init(books: [Book]) {
    
        _books = Books()
        
        loadBooks(bookList: books)
        setupNotifications()
        
    }
    
    deinit {
        tearDownNotifications()
    }
    
    private func loadBooks(bookList: [Book]){
        
        for book in bookList{
            for tag in book.tags {
                _books.insert(value: book, forKey: tag)
            }
        }
    }
    
    // MARK: - Accessors
    
    var bookCount: Int {
        get{
            return _books.countUnique
        }
    }
    
    //MARK: - Data Retrieval
    
    func bookCount(forTagName name: TagName) -> Int {
        let tag = Tag(name: name)
        
        if let bucket = _books[tag] {
            return bucket.count
        }else{
            return 0
        }
    }
    
    
    func books(forTagName name: TagName) -> [Book]? {
        guard let books = _books[Tag(name:name)]else {
            return nil
        }
        
        if books.count == 0 {
            return nil
        }else{
            return books.sorted()
        }
    }
    
    
    
    func book(forTagName name: TagName, at: Int) -> Book? {
        guard let books = _books[Tag(name: name)] else {
            return nil
        }
        
        guard !(books.count > 0 && at > books.count) else {
            return nil
        }
        
        return books.sorted()[at]
    }
    

    var tags: [Tag]{
        get{
            return _books.keys.sorted()
        }
    }

}
    
// MARK: - Notifications

extension Library{
    
    
    func setupNotifications() {
        let notificationCenter = NotificationCenter.default
        
        _bookObserver = notificationCenter.addObserver(forName: BookDidChange, object: nil, queue: nil){

            (n: Notification) in
            
            let book = n.userInfo![BookKey] as! Book
            let fav = Tag.favoriteTag()
            
            if book.isFavorite{
                self._books.insert(value: book, forKey: fav)
            }else{
                self._books.remove(value: book, fromKey: fav)
            }
            
        }
    }
    
    func tearDownNotifications() {
        guard let observer = _bookObserver else{
            return
        }
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(observer)
        
    }
    
}



























