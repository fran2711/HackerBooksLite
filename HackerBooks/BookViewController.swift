//
//  BookViewController.swift
//  HackerBooks
//
//  Created by Fran Lucena on 5/2/17.
//  Copyright © 2017 Fran Lucena. All rights reserved.
//

/*// MARK: - Static Properties
 
 private static let defaultCover = Bundle.main.url(forResource: "Books_Icon", withExtension: "png")!
*/

import UIKit

class BookViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var makeBookFavorite: UIBarButtonItem!
    @IBOutlet weak var coverView: UIImageView!
    
    var _model: Book
    
    // MARK: - Init
    
    init(model: Book){
        self._model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @IBAction func readBook(_ sender: UIBarButtonItem) {
        
        let pdfVC = PDFViewController(model: _model)
        navigationController?.pushViewController(pdfVC, animated: true)
    }

    
    @IBAction func bookMadeFavorite(_ sender: UIBarButtonItem) {
       _model.isFavorite = !_model.isFavorite
    }

    
    // MARK: - View Sync
    
    func syncViewWithModel(book: Book) {
        coverView.image = UIImage(data: _model._cover.data)
        title = _model.title
        if _model.isFavorite {
            makeBookFavorite.title = "★"
        }else{
            makeBookFavorite.title = "☆"
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        startObserving(book: _model)
        syncViewWithModel(book: _model)
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopObserving(book: _model)
    }
    
    // MARK: - Notifications
    let _nCenter = NotificationCenter.default
    var bookObserver: NSObjectProtocol?
    
    func startObserving(book: Book) {
        bookObserver = _nCenter.addObserver(forName: BookDidChange, object: book, queue: nil, using: { (n: Notification) in
            self.syncViewWithModel(book: book)
        })
    }
    
    func stopObserving(book: Book) {
        guard let observer = bookObserver else {
            return
        }
        _nCenter.removeObserver(observer)
    }
}

extension BookViewController: LibraryTableViewControllerDelegate{
    func libraryTableViewController(_ sender: LibraryTableViewController, didSelectBook book: Book) {
        stopObserving(book: _model)
        _model = book
        startObserving(book: book)
    }
}











