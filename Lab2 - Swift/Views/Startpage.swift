//
//  Startpage.swift
//  Lab2 - Swift
//
//  Created by Jimmie Määttä on 2019-04-29.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit

class Startpage: UIView {
    
    
    // MARK: --- PROPERTIES
    
    let angleUpView = AngleUpView()
    let angleDownView = AngleDownView()
    
    let addNewLabel: UILabel = {
        let label = AvenirBig()
        label.font = label.font.bold
        label.text = "Add New Receipt".uppercased()
        return label
    }()
    
    let manuallyIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ic_textrows"))
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let scannerIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ic_barcode"))
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let manuallyLabel: UILabel = {
        let label = AvenirMedium()
        label.textColor = UIColor(named: "BondingBlue")
        label.font = label.font.bold
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.text = "Manually".uppercased()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let scannerLabel: UILabel = {
        let label = AvenirMedium()
        label.textColor = UIColor(named: "BondingBlue")
        label.font = label.font.bold
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.text = "Scanner".uppercased()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var stackManuall: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    var stackScanner: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    
    // MARK: --- INIT
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "NotQuiteWhite")
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(angleUpView)
        addSubview(angleDownView)
        addSubview(addNewLabel)
        
        stackManuall = UIStackView(arrangedSubviews: [manuallyIcon, manuallyLabel])
        stackManuall.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        stackManuall.axis = .vertical
        stackManuall.distribution = .fillProportionally
        stackManuall.spacing = 8
        stackManuall.isUserInteractionEnabled = true
        stackManuall.translatesAutoresizingMaskIntoConstraints = false
        
        stackScanner = UIStackView(arrangedSubviews: [scannerIcon, scannerLabel])
        stackScanner.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        stackScanner.axis = .vertical
        stackScanner.distribution = .fillProportionally
        stackScanner.spacing = 8
        stackScanner.isUserInteractionEnabled = true
        stackScanner.translatesAutoresizingMaskIntoConstraints = false
        
        let stackOptions = UIStackView(arrangedSubviews: [stackManuall, stackScanner])
        stackOptions.axis = .horizontal
        stackOptions.distribution = .fillEqually
        stackOptions.spacing = 8
        stackOptions.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackOptions)
        
        NSLayoutConstraint.activate([
            angleUpView.bottomAnchor.constraint(equalTo: topAnchor, constant: 0),
            angleUpView.heightAnchor.constraint(equalToConstant: 64),
            angleUpView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            angleUpView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
            ])
        
        NSLayoutConstraint.activate([
            angleDownView.topAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            angleDownView.heightAnchor.constraint(equalToConstant: 64),
            angleDownView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            angleDownView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
            ])
        
        NSLayoutConstraint.activate([
            addNewLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            addNewLabel.heightAnchor.constraint(equalToConstant: 64),
            addNewLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
            ])
        
        NSLayoutConstraint.activate([
            stackOptions.topAnchor.constraint(equalTo: addNewLabel.bottomAnchor, constant: 8),
            stackOptions.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            stackOptions.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            stackOptions.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
