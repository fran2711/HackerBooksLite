//
//  BookErrors.swift
//  HackerBooks
//
//  Created by Fran Lucena on 2/2/17.
//  Copyright © 2017 Fran Lucena. All rights reserved.
//

import Foundation

enum BookErrors : Error {
    case nilJSONObject
    case wrongURLFormatForJSONResource
    case resourcePointedByURLNotReachable
    case jsonParsingError
}
