//
//  LibraryTableViewController.swift
//  HackerBooks
//
//  Created by Fran Lucena on 5/2/17.
//  Copyright © 2017 Fran Lucena. All rights reserved.
//

import UIKit

class LibraryTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var model: Library
    var delegate: LibraryTableViewControllerDelegate? = nil
    
    // MARK: - Computed Properties
    
    var defaultBookCoverData: Data {
        get{
            let defaultCoverUrl = Bundle.main.url(forResource: "Books_Icon", withExtension: "png")
            return try! Data(contentsOf: defaultCoverUrl!)
            
        }
        
    }
    
    // MARK: - Init
    
    init(model: Library){
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Hacker Books"
        let bookCell = UINib(nibName: "BookViewCeel", bundle: nil)
        tableView.register(bookCell, forCellReuseIdentifier: BookViewCell.cellId)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return model.tagCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.bookCount(forTag: tag(inSection: section))
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let tagContent = tag(inSection: section).description
        return tagContent.capitalized
    }
    
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let book = model.book(forTag: tag(inSection: indexPath.section), at: indexPath.row)
        let cell: BookViewCell = tableView.dequeueReusableCell(withIdentifier: BookViewCell.cellId) as? BookViewCell ?? BookViewCell()
        
        cell.setCoverData(data: AsyncData(url: (book?.bookCover)!, defaultData: defaultBookCoverData))
        cell.bookTitle?.text = book?.title
        cell.bookAuthors?.text = book?.authorsNames
        cell.bookTags?.text = book?.tagsName
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedBook = model.book(forTag: tag(inSection: indexPath.section), at: indexPath.row) else {
            return
        }
        
        delegate?.libraryTableViewController(self, didSelectBook: selectedBook)
        
    }


    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BookViewCell.cellHeight
    }

    
    
    //MARK: - Utils
    
    func tag(inSection section: Int) -> Tag {
        return model.tags[section]
    }

}


// MARK: - Protocols

protocol LibraryTableViewControllerDelegate: class {
    func libraryTableViewController(_ sender: LibraryTableViewController, didSelectBook book: Book)
}


// // MARK: - LibraryTableViewControllerDelegate

extension LibraryTableViewController: LibraryTableViewControllerDelegate {
    func libraryTableViewController(_ sender: LibraryTableViewController, didSelectBook book: Book) {
        let  bookController = BookViewController(model: book)
        bookController.delegate = self
        navigationController?.pushViewController(bookController, animated: true)
        
    }
}

// MARK: - BookViewControllerDelegate

extension LibraryTableViewController: BookViewControllerDelegate {
    func bookChangedFavoriteState(book: Book, isFavorite: Bool){
        if (isFavorite) {
            model.addBookToFavorites(book)
        } else {
            model.removeBookFromFavorites(book)
        }
        
        self.tableView.reloadData()
        
    }
}


//MARK: - Notifications

extension LibraryTableViewController {
    
    static let NotificationName = Notification.Name(rawValue: "LibraryTableViewControllerBookDidChange")
    static let BookKey = "LibraryTableViewControllerBookKey"
    
    func notify(bookDidChange book: Book) {
        let notificationCenter = NotificationCenter.default
        let notification = Notification(name: LibraryTableViewController.NotificationName, object: self, userInfo: [LibraryTableViewController.BookKey : book])
        
        notificationCenter.post(notification)
    }
}

















