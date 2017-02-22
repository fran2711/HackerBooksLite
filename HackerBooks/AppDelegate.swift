//
//  AppDelegate.swift
//  HackerBooks
//
//  Created by Fran Lucena on 31/1/17.
//  Copyright © 2017 Fran Lucena. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        let library = Library(books: downloadBookCollection())
        let libraryVC = LibraryTableViewController(model: library)
        let libraryNC = UINavigationController(rootViewController: libraryVC)
        
        let firstBook = fetchInitialBook(library: library)
        let bookVC = BookViewController(model: firstBook)
        let bookNC = UINavigationController(rootViewController: bookVC)
        
        let splitVC = UISplitViewController(nibName: nil, bundle: nil)
        splitVC.viewControllers = [libraryNC, bookNC]
        
        
        self.window?.rootViewController = splitVC
        self.window?.makeKeyAndVisible()
    
        return true
    }

   
    func fetchInitialBook(library: Library) -> Book {
        return library.book(forTag: library.tags.first!, at: 0)!
    }
    
    func downloadBookCollection() -> [Book] {
        
        let JSONData = fetchBookData()
        
        guard let JSONObject = try? JSONSerialization.jsonObject(with: JSONData, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [[String: String]], let bookCollection = JSONObject else {
            fatalError("Error while downloading book collection")
        }
        
        return bookCollection.flatMap({(dict: [String: String]) -> Book? in
            guard let title: String = dict["title"], let authors: String = dict["authors"], let tags: String = dict["tags"], let bookCover: String = dict["image_url"], let bookPDF: String = dict["pdf_url"] else {
                return nil
            }
            
            let book = Book(title: title, authors: authors, tags: tags, coverStringUrl: bookCover, pdfStringUrl: bookPDF)
            
            let userDefaults = UserDefaults.standard
            
            let isBookFavorite = userDefaults.bool(forKey: String(book.hashValue))
            
            if isBookFavorite{
                book.toggleFavoriteState()
            }
            
            return book
            
        })
    }
    
    func fetchBookData() -> Data {
        let bookDataKey = "BookDataKey"
        let userDefaults = UserDefaults.standard
        
        guard let bookData: Data = userDefaults.data(forKey: bookDataKey) else {
            
            guard let jsonUrl = URL(string:"https://t.co/K9ziV0z3SJ") else {
                fatalError("Error in book collection URL")
            }
            
            guard let jsonData = try? Data(contentsOf: jsonUrl) else {
                fatalError("Error in book collection endpoint")
            }
            
            userDefaults.set(jsonData, forKey: bookDataKey)
            
            return jsonData
        }
        return bookData
    }
}

