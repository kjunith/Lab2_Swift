//
//  Menu.swift
//  Lab2 - Swift
//
//  Created by Jimmie Määttä on 2019-04-25.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit

enum MenuState {
    case active
    case inactive
}

class Menu: UIView {
    
    
    // MARK: --- PROPERTIES
    
    var state:MenuState?
    
    var angleUpView = UIView()
    
    let startpageLabel: UILabel = {
        let label = AvenirBig()
        label.textAlignment = .center
        label.textColor = UIColor(named: "BondingBlue")
        label.font = label.font.bold
        label.text = "Startpage".uppercased()
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let overviewLabel: UILabel = {
        let label = AvenirBig()
        label.textAlignment = .center
        label.textColor = UIColor(named: "BondingBlue")
        label.font = label.font.bold
        label.text = "Overview".uppercased()
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let receiptsLabel: UILabel = {
        let label = AvenirBig()
        label.textAlignment = .center
        label.textColor = UIColor(named: "BondingBlue")
        label.font = label.font.bold
        label.text = "Receipts".uppercased()
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "NotQuiteWhite")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let handleView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        view.backgroundColor = UIColor(named: "NotQuiteWhite")
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let menuIcon = MenuIcon(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
    
    var menuStackView = UIStackView()
    
    
    // MARK: --- INIT
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        state = .inactive
        
        angleUpView = AngleUpView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 64))
        addSubview(angleUpView)
        addSubview(handleView)
        handleView.addSubview(menuIcon)
        addSubview(containerView)
        
        NSLayoutConstraint.activate([
            angleUpView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            angleUpView.widthAnchor.constraint(equalTo: widthAnchor, constant: 0),
            angleUpView.heightAnchor.constraint(equalToConstant: 64)
            ])

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: angleUpView.bottomAnchor, constant: 0),
            containerView.heightAnchor.constraint(equalTo: heightAnchor, constant: -angleUpView.frame.height),
            containerView.widthAnchor.constraint(equalTo: widthAnchor, constant: 0)
            ])
        
        NSLayoutConstraint.activate([
            handleView.bottomAnchor.constraint(equalTo: angleUpView.bottomAnchor, constant: -16),
            handleView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            handleView.widthAnchor.constraint(equalToConstant: 64),
            handleView.heightAnchor.constraint(equalToConstant: 64)
            ])
        
        NSLayoutConstraint.activate([
            menuIcon.centerXAnchor.constraint(equalTo: handleView.centerXAnchor, constant: 0),
            menuIcon.centerYAnchor.constraint(equalTo: handleView.centerYAnchor, constant: 0)
            ])
        
        setupMenuStackView()
        containerView.addSubview(menuStackView)
        
        NSLayoutConstraint.activate([
            menuStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            menuStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            menuStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: --- HANDLERS
    
    func setupMenuStackView() {
        menuStackView = UIStackView(arrangedSubviews: [startpageLabel, overviewLabel, receiptsLabel])
        menuStackView.axis = .vertical
        menuStackView.distribution = .fillEqually
        menuStackView.spacing = 8
        menuStackView.translatesAutoresizingMaskIntoConstraints = false
    }
}
