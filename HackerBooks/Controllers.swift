//
//  Controllers.swift
//  HackerBooksLite
//
//  Created by Fran Lucena on 19/2/17.
//  Copyright © 2017 Fran Lucena. All rights reserved.
//


import UIKit

extension UIViewController{
    
    func wrappedInNavigationController()->UINavigationController{
        return UINavigationController(rootViewController: self)
    }
}
