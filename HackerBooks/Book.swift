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
typealias Authors = [Author]
typealias PDF = AsyncData
typealias Cover = AsyncData

class Book {
    
    //MARK: - Attributes
    
    let _authors: Authors
    let _title: Title
    var _tags: Tags
    let _pdf: PDF
    let _cover: Cover
    
    weak var delegate: BookDelegate?
    
    var tags: Tags{
        return _tags
    }
    
    var title: Title {
        return _title
    }
    
    init(title: Title, authors: Authors, tags: Tags, pdf: PDF, cover: Cover) {
        
        (_title, _authors, _tags, _pdf, _cover) = (title, authors, tags, pdf, cover)
    
        // Set Delegate
        _cover.delegate = self
        _pdf.delegate = self
    }
    
    func formattedListOfAuthors() -> String {
        return _authors.sorted().joined(separator: ", ").capitalized
    }
    
    func formattedListOfTags() -> String {
        return _tags.sorted().map{$._name}.joined(separator: ", ").capitalized
    }
    
}


// MARK: - Favorites

extension Book{
    
    private func hasFavoriteTag()-> Bool {
        return _tags.contains(Tag.favoriteTag())
    }
    
    private func addFavoriteTag(){
        _tags.insert(Tag.favoriteTag())
    }
    
    private func removeFavoriteTag() {
        _tags.remove(Tag.favoriteTag())
    }
    
    var isFavorite: Bool {
        get{
            return hasFavoriteTag()
        }
        set {
            if newValue == true {
                addFavoriteTag()
                sendNotification(name: BookDidChange)
            }else{
                removeFavoriteTag()
                sendNotification(name: BookDidChange)
            }
        }
    }
}



// MARK: - Protocols
extension Book: Hashable {
    var proxyForHasing: String {
        return "\(_title)\(_authors)"
    }
    
    var hashValue: Int {
        return proxyForHasing.hashValue
    }
}



extension Book: Equatable {
    var proxyForComparision: String {
        
        return "\(isFavorite ? "A" : "Z")\(_title)\(formattedListOfAuthors())"
    }
    
    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.proxyForComparision == rhs.proxyForComparision
    }
    
}

extension Book: Comparable {
    static func < (lhs: Book, rhs: Book) -> Bool {
        return lhs.proxyForComparision < rhs.proxyForComparision
    }
}

// MARK: - Comunication - Delegate
protocol BookDelegate: class {
    func bookDidChange(sender: Book)
    func bookCoverImageDidDownload(sender: Book)
    func bookPDFDidDownload(sender: Book)
}

extension BookDelegate{
    func bookDidChange(sender: Book){}
    func bookCoverImageDidDownload(sender: Book){}
    func bookPDFDidDownload(sender: Book){}
}

let BookDidChange = Notification.Name(rawValue: "com.franlucenadejuan.BookDidChange")
let BookKey = "com.franlucenadejuan.BookKey"

let BookCoverImageDidDownload = Notification.Name(rawValue: "com.franlucenadejuan.BookCoverImageDidDownload")
let BookPDFDidDownload = Notification.Name(rawValue: "com.franlucenadejuan.BookPDFDidDownload")

extension Book {
    
    func sendNotification(name: Notification.Name) {
        let notification = Notification(name: name, object: self, userInfo: [BookKey: self])
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(notification)
    }
}


// MARK: - AsyncDataDelegate

extension Book: AsyncDataDelegate {
    func asyncData(_ sender: AsyncData, didEndLoadingFrom url: URL) {

        let notificationName: Notification.Name
        
        switch sender {
        case _cover:
            notificationName = BookCoverImageDidDownload
            delegate?.bookCoverImageDidDownload(sender: self)
            
        case _pdf:
            notificationName = BookPDFDidDownload
            delegate?.bookPDFDidDownload(sender: self)
            
        default:
            fatalError("Fatal Error")
        }
        
        sendNotification(name: notificationName)
    }
    
    func asyncData(_ sender: AsyncData, shouldStartLoadingFrom url: URL) -> Bool {
        return true
    }
    
    func asyncData(_ sender: AsyncData, willStartLoadingFrom url: URL) {
        print("Loading from \(url)")
    }
    
    func asyncData(_ sender: AsyncData, didFailLoadingFrom url: URL, error: NSError) {
        print("Error loading from \(url)")
    }
    
}






























