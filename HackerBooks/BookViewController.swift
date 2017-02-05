//
//  BookViewController.swift
//  HackerBooks
//
//  Created by Fran Lucena on 5/2/17.
//  Copyright © 2017 Fran Lucena. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var makeBookFavorite: UIBarButtonItem!
    @IBOutlet weak var coverView: UIImageView!
    
    var model: Book
    fileprivate var coverData: AsyncData
    
    // MARK: - Model
    
    init(model: Book){
        self.model = model
        coverData = AsyncData(url: model.bookCover, defaultData: try? Data(contentsOf: BookViewController.DefaultCover))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        syncViewWithModel()
    }
    
    // MARK: - View Sync
    
    func syncViewWithModel() {
        title = model.title
        syncCoverData()
        syncFavorites()
    }
    
    func syncFavorites() {
        makeBookFavorite.image = model.isFavorite ? UIImage(named: "") : UIImage(named: "")
    }

    
    @IBAction func readBook(_ sender: UIBarButtonItem) {
    }

    
    
}
