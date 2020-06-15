//
//  MainViewController.swift
//  Lab2 - Swift
//
//  Created by Jimmie Määttä on 2019-04-04.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    
    // MARK: --- PROPERTIES
    
    var hideMenuCosntraint = NSLayoutConstraint()
    var showMenuConstraint = NSLayoutConstraint()
    
    let receiptsData = ReceiptsData.handler
    
    var startpageViewController: StartpageViewController?
    var receiptsViewController: ReceiptsViewController?
    var overviewViewController: OverviewViewController?
    var addEditViewController: AddEditViewController?
    
    var prevViewController: UIViewController?
    
    var bgImage: BgImage!
    var header: Header!
    var menuIcon: MenuIcon!
    var shadow: Shadow!
    var menu: Menu!
    
    var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // MARK: --- INIT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "NotQuiteWhite")
        
        startpageViewController = StartpageViewController()
        overviewViewController = OverviewViewController()
        receiptsViewController = ReceiptsViewController()
        addEditViewController = AddEditViewController()
        
        addEditViewController?.delegate = self
        startpageViewController?.delegate = self
        receiptsViewController?.delegate = self
        
        receiptsData.loadReceipts()
        receiptsData.calculateSums()
        
        setupViews()
        setupGestureRecignizers()
        addSubView(subViewController: startpageViewController!, parentView: containerView)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
    // MARK: --- HANDLERS
    
    func setupViews() {
        bgImage = BgImage(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(bgImage)
        NSLayoutConstraint.activate([
            bgImage.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0),
            bgImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            bgImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bgImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
            ])
        
        header = Header(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 64))
        view.addSubview(header)
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0),
            header.heightAnchor.constraint(equalToConstant: 64),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
            ])
        
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
            ])
        
        shadow = Shadow(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(shadow)
        NSLayoutConstraint.activate([
            shadow.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            shadow.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            shadow.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            shadow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
            ])
        
        menu = Menu(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 512))
        view.addSubview(menu)
        NSLayoutConstraint.activate([
            menu.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            menu.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            menu.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
            ])
        
        hideMenuCosntraint = menu.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -menu.angleUpView.frame.height)
        showMenuConstraint = menu.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -menu.frame.height / 2)
        
        switch menu.state! {
        case .active:
            NSLayoutConstraint.deactivate([hideMenuCosntraint])
            NSLayoutConstraint.activate([showMenuConstraint])
        case .inactive:
            NSLayoutConstraint.deactivate([showMenuConstraint])
            NSLayoutConstraint.activate([hideMenuCosntraint])
        }
    }
    
    func setupGestureRecignizers() {
        let tapIconGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        menu.menuIcon.addGestureRecognizer(tapIconGesture)
        
        let tapShadowGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        shadow.addGestureRecognizer(tapShadowGesture)
        
        let showStartpage = UITapGestureRecognizer(target: self, action: #selector(handleStartpage))
        let showOverview = UITapGestureRecognizer(target: self, action: #selector(handleOverview))
        let showReceipts = UITapGestureRecognizer(target: self, action: #selector(handleReceipts))
        
        for labels in menu.menuStackView.arrangedSubviews {
            if let label = labels as? UILabel {
                switch label.text {
                case "Startpage".uppercased():
                    label.addGestureRecognizer(showStartpage)
                case "Overview".uppercased():
                    label.addGestureRecognizer(showOverview)
                case "Receipts".uppercased():
                    label.addGestureRecognizer(showReceipts)
                default:
                    break
                }
            }
        }
    }
}
