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
    
    private let _model: Library
    var delegate: LibraryTableViewControllerDelegate?
    
    
    
    // MARK: - Computed Properties
    
    var defaultBookCoverData: Data {
        get{
            let defaultCoverUrl = Bundle.main.url(forResource: "Books_Icon", withExtension: "png")
            return try! Data(contentsOf: defaultCoverUrl!)
            
        }
        
    }
    
    // MARK: - Init
    
    init(model: Library, style: UITableViewStyle = .plain){
        _model = model
        super.init(nibName: nil, bundle: nil)
        title = "HackerBooks"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerNib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNotifications()
    }
    
    deinit {
        tearDownNotifications()
    }
    
    // MARK: - Cell Registration
    private func registerNib(){
        let nib = UINib(nibName: "BookTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: BookViewCell.cellId)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return _model.tags.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return _model.tags[section]._name
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tagName = _model.tags[section]._name
        
        guard let books = _model.books(forTagName: tagName) else {
            fatalError("No books for tag: \(tagName)")
        }
        
        return books.count
    }
    
    // MARK: - Cell Configuration
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Encuentro el libro
        let tag = _model.tags[indexPath.section]
        let book = _model.book(forTagName: tag._name, at: indexPath.row)
        
        // Creo la celda
        let cell = tableView.dequeueReusableCell(withIdentifier: BookViewCell.cellId, for: indexPath) as! BookViewCell
        
        // Sincronizo modelo con la vista
        cell.startObserving(book: book)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BookViewCell.cellHeight
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Recojo el libro
        let tag = _model.tags[indexPath.section]
        let book = _model.book(forTagName: tag._name, at: indexPath.row)
        
        // Creo el ViewController
        let bookVC = BookViewController(model: book)
        
        // Lo cargo
        navigationController?.pushViewController(bookVC, animated: true)
    }

    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! BookViewCell
        cell.stopObserving()
    }

    

    // MARK: - Notifications
    var bookObserver: NSObjectProtocol?
    
    func setupNotification() {
        let nCenter = NotificationCenter.default
        bookObserver = nCenter.addObserver(forName: BookDidChange, object: nil, queue: nil, using: { (n: Notification) in
            self.tableView.reloadData()
        })
    }
    
    
    func tearDownNotifications(){
        guard let observer = bookObserver else {
            return
        }
        let nCenter = NotificationCenter.default
        nCenter.removeObserver(observer)
    }
}

// MARK: - Delegate Protocol
protocol LibraryTableViewControllerDelegate {
    func libraryTableViewController(_sender: LibraryTableViewController, didSelect selectedBook: Book)
}
    






















