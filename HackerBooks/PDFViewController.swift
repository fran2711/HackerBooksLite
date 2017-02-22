//
//  PDFViewController.swift
//  HackerBooks
//
//  Created by Fran Lucena on 7/2/17.
//  Copyright © 2017 Fran Lucena. All rights reserved.
//

import UIKit

class PDFViewController: UIViewController {
    
    //MARK: - Class Properties
    
    static let PdfMimetype: String = "application/pdf"
    static let DefaultPdfUrl: URL = Bundle.main.url(forResource: "default_pdf", withExtension: "pdf")!
    
    
    //MARK: - Properties
    
    var pdfData: AsyncData
    
    @IBOutlet weak var browser: UIWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    // MARK: - Init
    
    init(pdfURL: URL) {
        pdfData = AsyncData(url: pdfURL, defaultData: try! Data(contentsOf: PDFViewController.DefaultPdfUrl))
        super.init(nibName: nil, bundle: nil)
        
        pdfData.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    // MARK: - Request Handling
    
    func requestPDF() {
        browser.load(pdfData.data, mimeType: PDFViewController.PdfMimetype, textEncodingName: "", baseURL: Bundle.main.bundleURL)
    }
    
    // // MARK: - Spinner
    
    func startSpinner() {
        spinner.isHidden = false
        spinner.startAnimating()
    }
    
    func stopSpinner() {
        spinner.isHidden = true
        spinner.stopAnimating()
    }
    
    
    // MARK: - AsyncData
    
    func syncPDFData(pdfURL: URL)  {
        pdfData = AsyncData(url: pdfURL, defaultData: try! Data(contentsOf: PDFViewController.DefaultPdfUrl))
        pdfData.delegate = self
        requestPDF()
    }
}

// MARK: - AsyncData Delegate

extension PDFViewController: AsyncDataDelegate {
    func asyncData(_ sender: AsyncData, didEndLoadingFrom url: URL) {
        requestPDF()
        stopSpinner()
    }
}

// MARK: - Notifications

extension PDFViewController {
    func subscribe() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: LibraryTableViewController.NotificationName, object: nil, queue: OperationQueue.main, using: {self.bookDidChange( $0 )})
    }
    
    func unsubscribe() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    func bookDidChange(_ notification: Notification) {
        let newBook = notification.userInfo?[LibraryTableViewController.BookKey] as! Book
        syncPDFData(pdfURL: newBook.pdfUrl)
        
    }
}
















