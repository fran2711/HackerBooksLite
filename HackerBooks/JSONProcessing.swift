//
//  JSONProcessing.swift
//  HackerBooks
//
//  Created by Fran Lucena on 22/2/17.
//  Copyright © 2017 Fran Lucena. All rights reserved.
//

import Foundation
import UIKit

enum JSONErrors : Error{
    case missingField(name:String)
    case incorrectValue(name: String, value: String)
    case emptyJSONObject
    case emptyJSONArray
}


//MARK: - Aliases
typealias JSONObject    = String    // We'll only receive strings
typealias JSONDictionary = [String : JSONObject]
typealias JSONArray = [JSONDictionary]

//MARK: - Decodification
func decode(book dict: JSONDictionary) throws -> Book{
    
    // validate first
    try validate(dictionary: dict)
    
    // extract from dict
    func extract(key: String) -> String{
        return dict[key]!   // we know it can't be missing because we validated first!
    }
    
    // parsing
    let authors = parseCommaSeparated(string: extract(key: "authors"))
    let imgURL = URL(string: extract(key: "image_url"))!
    let pdfURL = URL(string: extract(key: "pdf_url"))!
    let tags = Tags(parseCommaSeparated(string: extract(key: "tags")).map{Tag(name: $0)})
    let title = extract(key: "title").capitalized
    
    let mainBundle = Bundle.main
    
    let defaultImage = mainBundle.url(forResource: "emptyBookCover", withExtension: "png")!
    let defaultPdf = mainBundle.url(forResource: "emptyPdf", withExtension: "pdf")!
    
    // AsyncData
    let image = AsyncData(url: imgURL, defaultData: try! Data(contentsOf: defaultImage))
    let pdf = AsyncData(url: pdfURL, defaultData: try! Data(contentsOf: defaultPdf))
    
    
    return Book(title: title, authors: authors, tags: tags, pdf: pdf, cover: image)
    
}

func decode(book dict: JSONDictionary?) throws -> Book{
    
    guard let d = dict else {
        throw JSONErrors.emptyJSONObject
    }
    return try decode(book:d)
}

func decode(books dicts: JSONArray) throws -> [Book]{
    
    return try dicts.flatMap{
        try decode(book:$0)
    }
}

func decode(books dicts: JSONArray?) throws -> [Book]{
    guard let ds = dicts else {
        throw JSONErrors.emptyJSONArray
    }
    return try decode(books: ds)
}



//MARK: - Validation
private func validate(dictionary dict: JSONDictionary) throws{
    
    func isMissing() throws{
        for key in dict.keys{
            guard let value = dict[key] else{
                throw JSONErrors.missingField(name: key)
            }
            guard value.characters.count > 0  else {
                throw JSONErrors.incorrectValue(name: key, value: value)
            }
        }
        
    }
    
    try isMissing()
    
}


//MARK: - Parsing
func parseCommaSeparated(string s: String)->[String]{
    
    return s.components(separatedBy: ",").map({ $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }).filter({ $0.characters.count > 0})
}


