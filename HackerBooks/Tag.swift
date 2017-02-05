//
//  Tag.swift
//  HackerBooks
//
//  Created by Fran Lucena on 4/2/17.
//  Copyright © 2017 Fran Lucena. All rights reserved.
//

import Foundation

struct Tag {
    
    private static var favoriteRawValue: String {
        get{
            return "Favorites"
        }
    }
    
    private static var favoriteTagInstance: Tag?
    
    static var favorites: Tag {
        get{
            if (favoriteTagInstance == nil) {
                favoriteTagInstance = Tag(rawValue: favoriteRawValue)
            }
            return favoriteTagInstance ?? Tag(rawValue: favoriteRawValue)
        }
    }
    
    
    var rawValue: String
    var isFavoriteTag: Bool{
        get{
            return rawValue == Tag.favoriteRawValue
        }
    }
    
    init(rawValue: String) {
        self.rawValue = rawValue
    }
    
}


//MARK: - Protocolos

extension Tag: CustomStringConvertible{
    var description: String {
        get{
            return rawValue
        }
    }
    
}

extension Tag : Equatable{
    
    public static func ==(lhs: Tag, rhs: Tag) -> Bool{
        
        return lhs.rawValue == rhs.rawValue
        
    }
}


extension Tag : Comparable{
    
    public static func <(lhs: Tag, rhs: Tag) -> Bool{
        
        if (lhs.rawValue == "Favorite"){
            return true
        }else if (rhs.rawValue == "Favorite"){
            return false
        }else{
            return (lhs.rawValue < rhs.rawValue)
        }
        
    }
    
}

// Implemento Hashable para el Multidiccionario
extension Tag : Hashable{
    
    public var hashValue: Int {
        get{
            return rawValue.hashValue
        }
    }
    
}

