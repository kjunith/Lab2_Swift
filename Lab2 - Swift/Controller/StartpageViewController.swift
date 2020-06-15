//
//  StartpageViewController.swift
//  Lab2 - Swift
//
//  Created by Jimmie Määttä on 2019-04-26.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit
import YCBarcodeReader

protocol StartpageDelegate {
    func manuallyTapped()
    func scannerTapped(xmlItem:XMLItem)
}

class StartpageViewController: UIViewController {

    
    // MARK: --- PROPERTIES
    
    var delegate: StartpageDelegate?
    
    private let apiKey: String = "/XML?apikey=8ac8c4f6-174a-4de4-aaa4-c9f3be26dc73"
    private let apiUrl: String = "http://api.dabas.com/DABASService/V2/article/gtin/"
    
    var scanner = Scanner()
    var searchable: XMLItem?
    
    let receiptsData = ReceiptsData.handler
    let startpage = Startpage()
    
    
    // MARK: --- INIT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        scanner.scannerView.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            view.addSubview(scanner)
            scanner.alpha = 0
            NSLayoutConstraint.activate([
                scanner.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
                scanner.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
                scanner.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                scanner.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
                ])
        } else {
            showErrorDialog(title: "Device Error", message: "Failed to detect any camera on this device.")
        }
        
        view.addSubview(startpage)
        NSLayoutConstraint.activate([
            startpage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            startpage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            startpage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
            ])
        
        setupGestureRecgonizers()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        scanner.setNeedsDisplay()
        scanner.layoutIfNeeded()
    }
    
    
    // MARK: --- HANDLERS
    
    func setupGestureRecgonizers() {
        let tapManually = UITapGestureRecognizer(target: self, action: #selector(handleManually))
        startpage.stackManuall.addGestureRecognizer(tapManually)
        
        let tapScanner = UITapGestureRecognizer(target: self, action: #selector(handleScanner))
        startpage.stackScanner.addGestureRecognizer(tapScanner)
        
        let tapCancel = UITapGestureRecognizer(target: self, action: #selector(handleCancel))
        scanner.cancelLabel.addGestureRecognizer(tapCancel)
    }
    
    @objc func handleManually() {
        self.delegate?.manuallyTapped()
    }
    
    @objc func handleScanner() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.scanner.alpha = 1
                self.startpage.alpha = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            showErrorDialog(title: "Device Error", message: "Failed to detect any camera on this device.")
        }
    }
    
    @objc func handleCancel() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.scanner.alpha = 0
            self.startpage.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func fetchXMLData(with code: String) {
        let itemUrl = apiUrl + "0\(code)" + apiKey
        let itemParser = ItemParser()
        
        itemParser.parseItem(url: itemUrl) { (xmlItem) in
            self.searchable = xmlItem
            DispatchQueue.main.async {
                self.delegate?.scannerTapped(xmlItem: self.searchable!)
                if self.searchable?.title == "" {
                    self.showDataNotFoundDialog()
                }
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                    self.scanner.alpha = 0
                    self.startpage.alpha = 1
                    self.view.layoutIfNeeded()
                }, completion: nil)
                
                self.scanner.scannerView.reset()
            }
        }
    }
    
    func showErrorDialog(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showDataNotFoundDialog() {
        let alert = UIAlertController(title: title, message: "Data Not Found", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .destructive,
                                      handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}


// MARK: --- SCANNER EXTENSION

extension StartpageViewController: YCBarcodeReaderDelegate {
    func reader(didReadCode code: String, type: String) {
        fetchXMLData(with: code)
    }
    
    func reader(didReceiveError error: Error) {
        print("\(error)")
    }
}
