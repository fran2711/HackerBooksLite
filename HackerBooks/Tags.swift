//
//  Tag.swift
//  HackerBooks
//
//  Created by Fran Lucena on 4/2/17.
//  Copyright © 2017 Fran Lucena. All rights reserved.
//

import Foundation

typealias Tags = Set<Tag>
typealias TagName = String

struct TagConstants {
    static let favoriteTag = "Favorite"
}

struct Tag {
    
    let _name: TagName
    
    init(name: TagName) {
        _name = name.capitalized
    }
    
    static func favoriteTag() -> Tag {
        return self.init(name: TagConstants.favoriteTag)
    }
    
    func isFavorite() -> Bool {
        return _name == TagConstants.favoriteTag
    }
}

// MARK: - Hashable

extension Tag: Hashable {
    public var hashValue: Int {
        return _name.hashValue
    }
}

// MARK: - Equatable

extension Tag: Equatable {
    static func == (lhs: Tag, rhs: Tag) -> Bool{
        return (lhs._name == rhs._name)
    }
}


// MARK: - Comparable

extension Tag: Comparable {
    static func <(lhs: Tag, rhs: Tag) -> Bool{
        if lhs.isFavorite() {
            return true
        } else if rhs.isFavorite() {
            return false
        } else {
            return lhs._name < rhs._name
        }
        
    }
}





















