//
//  JSONProcessing.swift
//  HackerBooks
//
//  Created by Fran Lucena on 2/2/17.
//  Copyright © 2017 Fran Lucena. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Aliases

typealias JSONObject = AnyObject
typealias JSONDictionary = [String: JSONObject]
typealias JSONArray = [JSONDictionary]

// MARK: - Decodification

func decode(book json: JSONDictionary) throws -> Book{
    
    // Valido el diccionario
    guard let authorsString = json["authors"] as? String else {
        throw BookErrors.nilJSONObject
    }
    
    guard let bookCover = json["image_url"] as? String, let coverURL = URL(string: bookCover) else {
            throw BookErrors.resourcePointedByURLNotReachable
    }
    
    guard let pdfURL = json["pdf_url"] as? String, let urlPDF = URL(string: pdfURL) else {
        throw BookErrors.resourcePointedByURLNotReachable
    }
    
    guard let tagsString = json["tags"] as? String else {
        throw BookErrors.nilJSONObject
    }
    
    
    let authors = authorsString.components(separatedBy: ", ")
    let tags = tagsString.components(separatedBy: ", ")
    
    let  mainBundle = Bundle.main
    
    let defaultImage = mainBundle.url(forResource: "emptyImage", withExtension: "png")!
    let defaultPdf = mainBundle.url(forResource: "emptyPDF", withExtension: "pdf")!
    
    let cover = AsyncData(url: coverURL, defaultData: try! Data(contentsOf: defaultImage))
    let pdf = AsyncData(url: urlPDF, defaultData: try! Data(contentsOf: defaultPdf))
    
    if let title = json["title"] as? String {
        return Book(title: title, authors: authors, tags: tags, bookCover: cover, bookURL: pdf)
    } else {
        throw BookErrors.nilJSONObject
    }
    
}

// MARK: - Optional Decodification

func decode(book json: JSONDictionary?) throws -> Book {
    guard let json = json else {
        throw BookErrors.nilJSONObject
    }
    return try decode(book: json)
}

// MARK: - Load

func loadFromRemoteURL(urlName url : String) throws -> JSONArray {
    
    if let url = URL(string: url),
        let jsonData = try? Data(contentsOf: url as URL),
        let maybeArray = try? JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? JSONArray,
        let library = maybeArray {
        for book in library {
            if let title = book["title"] as? String, let authors = book["authors"] as? String, let tags = book["tags"] as? String, let pdfURL = book["pdf_url"] as? String, let coverURL = book["image_url"] as? String {
                print((title, authors, tags, pdfURL, coverURL))
            }
        }
        return library
    } else {
        throw BookErrors.jsonParsingError
    }
    
}



















