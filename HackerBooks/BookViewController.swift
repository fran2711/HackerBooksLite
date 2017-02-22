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
    weak var delegate: BookViewControllerDelegate? = nil

    
    // MARK: - Static Properties
    
    private static let defaultCover = Bundle.main.url(forResource: "Books_Icon", withExtension: "png")!
    
   
    
    // MARK: - Model
    
    init(model: Book){
        self.model = model
        coverData = AsyncData(url: model.coverImageUrl, defaultData: try! Data(contentsOf: BookViewController.defaultCover))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        syncViewWithModel()
    }
    
       // MARK: - Actions
    
    @IBAction func readBook(_ sender: UIBarButtonItem) {
        
        let pdfVC = PDFViewController(pdfURL: model.pdfUrl)
        navigationController?.pushViewController(pdfVC, animated: true)
        
        
    }
    
    
    
    @IBAction func bookMadeFavorite(_ sender: UIBarButtonItem) {
        model.toggleFavoriteState()
        syncFavorites()
        delegate?.bookChangedFavoriteState(book: model, isFavorite: model.isFavorite)
        persistFavoritesState()
        
    }
    
    // MARK: - View Sync
    
    func syncViewWithModel() {
        title = model.title
        syncBookCover()
        syncFavorites()
    }
    
    func syncFavorites() {
        makeBookFavorite.image = model.isFavorite ? UIImage(named: "ic_star.png") : UIImage(named: "ic_star_border.png")
    }
    
    // MARK: - Favorites
    
    func persistFavoritesState() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(model.isFavorite, forKey: String(model.hashValue))
    }
    
    // MARK: - AsyncData
    func syncBookCover() {
        coverData = AsyncData(url: model.coverImageUrl, defaultData: try! Data(contentsOf: BookViewController.defaultCover))
        coverData.delegate = self
        coverView.image = UIImage(data: coverData.data)
    }
    
}

// MARK: - Protocols

protocol BookViewControllerDelegate: class {
    func bookChangedFavoriteState(book: Book, isFavorite: Bool)
}


// MARK: - AsyncData Delegate

extension BookViewController: AsyncDataDelegate {
    func asyncData(_ sender: AsyncData, didEndLoadingFrom url: URL) {
        UIView.transition(with: coverView,
                          duration: 0.3,
                          options: [.transitionCurlDown],
                          animations: {
                            self.coverView.image = UIImage(data: sender.data)},
                          completion: nil)
    }
}












