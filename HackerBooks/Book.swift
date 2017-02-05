//
//  Book.swift
//  HackerBooks
//
//  Created by Fran Lucena on 1/2/17.
//  Copyright © 2017 Fran Lucena. All rights reserved.
//

import Foundation
import UIKit

typealias Title = String
typealias Author = String

class Book {
    
    let title : Title
    let authors : [Author]
    let tags : [Tag]
    let bookCover : URL
    let bookURL : URL
    var isFavorite : Bool = false
    
    // MARK: - Computed Properties
    
    var authorsNames: String {
        get{
            return authors.sorted().map({$0 as String}).joined(separator: ", ")
        }
    }
    
    var tagsName: String {
    
        get{
            return tags.sorted().map({$0.description}).joined(separator: ", ")
        }
    }
    
    var favorite: Bool {
        get{
            return isFavorite
        }
    }
    
    

    // MARK: - Init
    
    init(title: Title, authors: [Author], tags: [Tag], bookCover: URL, bookURL: URL, isFavorite: Bool) {
        
        self.title = title
        self.authors = authors
        self.tags = tags
        self.bookCover = bookCover
        self.bookURL = bookURL
        self.isFavorite = isFavorite
    }
    
    // MARK: - Utils
    
    func favoriteState() {
        isFavorite = !isFavorite
    }
    
    
    // MARK: - Proxies
    
    func proxyForEquality() -> String {
        return "\(title)\(authors)\(tags)\(bookCover)\(bookURL)"
    }
    
    func proxyForComparision() -> String {
        return proxyForEquality()
    }

}

// MARK: - Protocols

extension Book: Equatable{
    public static func == (lhs: Book, rhs: Book) -> Bool{
        return (lhs.proxyForEquality() == rhs.proxyForEquality())
    }
}

extension Book: Comparable{
    public static func <(lhs: Book, rhs: Book) -> Bool{
        return lhs.proxyForComparision() < rhs.proxyForComparision()
    }
    
    
}

extension Book: CustomStringConvertible {
    public var description: String {
        get {
            return "<Book title:\(title) authors:\(authors) tags:\(tags) bookCover:\(bookCover.hashValue) bookURL:\(bookURL.hashValue)>"
        }
    }
}

extension Book: Hashable{
    public var hashValue: Int {
        get{
            return proxyForEquality().hashValue
        }
    }
}











