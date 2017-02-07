//
//  BookViewCell.swift
//  HackerBooks
//
//  Created by Fran Lucena on 5/2/17.
//  Copyright © 2017 Fran Lucena. All rights reserved.
//

import UIKit

class BookViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookTags: UILabel!
    @IBOutlet weak var bookAuthors: UILabel!
    
     var coverData: AsyncData? = nil
    
    // MARK: - Cell Properties
    
    static var cellId: String{
        get{
            return "BookCellView"
        }
    }
    
    static var cellHeight: CGFloat {
        
        get{
            return 95.0;
        }
        
    }
}


extension BookViewCell: AsyncDataDelegate {
    
    func asyncData(_ sender: AsyncData, didEndLoadingFrom url: URL) {
        UIView.transition(with: coverImage, duration: 0.3, options: [.transitionCurlDown], animations: { 
            self.coverImage.image = UIImage(data: sender.data)
        }, completion: nil)
    }
    
    // MARK: - Utils
    
    func setCoverData(data: AsyncData) {
        coverData = data
        coverData!.delegate = self
        coverImage.image = UIImage(data: coverData!.data)
    }
    
}
