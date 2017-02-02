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
typealias Authors = String
typealias Tags = String

class Book {
    
    let title : Title
    let authors : [Authors]
    let tags : [Tags]
    let bookCover : AsyncData
    let bookURL : AsyncData
    var isFavorite : Bool

    
    
    init(title: Title, authors: [Authors], tags: [Tags], bookCover: AsyncData, bookURL: AsyncData) {
        
        self.title = title
        self.authors = authors
        self.tags = tags
        self.bookCover = bookCover
        self.bookURL = bookURL
        self.isFavorite = false
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

// Compruebo si hay 2 libros igual
extension Book: Equatable{
    public static func == (lhs: Book, rhs: Book) -> Bool{
        return (lhs.proxyForEquality() == rhs.proxyForEquality())
    }
}

// Comparo los libros
extension Book: Comparable{
    public static func <(lhs: Book, rhs: Book) -> Bool{
        return lhs.proxyForComparision() < rhs.proxyForComparision()
    }
    
    
}

extension Book: CustomStringConvertible{
    public var description: String{
        get{
            return "<\(type(of:self)): \(title) -- \(authors)>"
        }
    }
    
}











