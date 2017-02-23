//
//  PDFViewController.swift
//  HackerBooks
//
//  Created by Fran Lucena on 7/2/17.
//  Copyright © 2017 Fran Lucena. All rights reserved.
//

import UIKit

class PDFViewController: UIViewController {
    
    var _model: Book?
    var _bookObserver: NSObjectProtocol?
    
    @IBOutlet weak var browser: UIWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    
    // MARK: - Init
    
    init(model: Book) {
        _model = model
        super.init(nibName: nil, bundle: nil)
        title = _model?.title
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotifications()
        browser.load((_model?._pdf.data)!, mimeType: "application/pdf", textEncodingName: "utf8", baseURL: URL(string: "http://www.google.com"))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tearDownNotifications()
    }
}


// MARK: - Notifications
extension PDFViewController{
    func setupNotifications(){
        let nCenter = NotificationCenter.default
        _bookObserver = nCenter.addObserver(forName: BookPDFDidDownload, object: _model, queue: nil) { (n: Notification) in
            self.browser.load((self._model?._pdf.data)!, mimeType: "application/pdf", textEncodingName: "utf8", baseURL: URL(string: "http://www.google.com")!)
        }
    }
    
    func tearDownNotifications(){
        guard let observer = _bookObserver else {
            return
        }
        
        let nCenter = NotificationCenter.default
        nCenter.removeObserver(observer)
        _bookObserver = nil
        
    }
}



































