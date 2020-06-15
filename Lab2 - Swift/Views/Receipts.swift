//
//  Receipts.swift
//  Lab2 - Swift
//
//  Created by Jimmie Määttä on 2019-04-29.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit

class Receipts: UIView, UITextFieldDelegate {
    
    
    // MARK: --- PROPERTIES
    
    let angleUpView = AngleUpView()
    let angleDownView = AngleDownView()
    
    let receiptsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(named: "NotQuiteWhite")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.clearButtonMode = .always
        textField.placeholder = "Title, Receiver, Category"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let searchLabel: UILabel = {
        let label = AvenirMedium()
        label.textColor = UIColor(named: "GoneGray")
        label.font = label.font.bold
        label.text = "Search:".uppercased()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let filterSumSegmentedControl: UISegmentedControl = {
        let options = ["All", "Expense", "Income"]
        let segmentedControl = UISegmentedControl(items: options)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.layer.cornerRadius = 8.0
        segmentedControl.backgroundColor = UIColor(named: "NotQuiteWhite")
        segmentedControl.tintColor = UIColor(named: "BondingBlue")
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    let filterStatusSegmentedControl: UISegmentedControl = {
        let options = ["All", "Paid", "Unpaid"]
        let segmentedControl = UISegmentedControl(items: options)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.layer.cornerRadius = 8.0
        segmentedControl.backgroundColor = UIColor(named: "NotQuiteWhite")
        segmentedControl.tintColor = UIColor(named: "BondingBlue")
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    let sortDateSegmentedControl: UISegmentedControl = {
        let options = ["Due", "Added"]
        let segmentedControl = UISegmentedControl(items: options)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.layer.cornerRadius = 8.0
        segmentedControl.backgroundColor = UIColor(named: "NotQuiteWhite")
        segmentedControl.tintColor = UIColor(named: "BondingBlue")
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    
    // MARK: --- INIT
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "NotQuiteWhite")
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(angleUpView)
        addSubview(angleDownView)
        addSubview(filterSumSegmentedControl)
        addSubview(receiptsTableView)
        
        let searchStackView = UIStackView(arrangedSubviews: [searchLabel, searchTextField])
        searchStackView.axis = .horizontal
        searchStackView.distribution = .fillProportionally
        searchStackView.spacing = 0
        searchStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(searchStackView)
        
        let optionsStackView = UIStackView(arrangedSubviews: [filterStatusSegmentedControl, sortDateSegmentedControl])
        optionsStackView.axis = .horizontal
        optionsStackView.distribution = .fill
        optionsStackView.spacing = 8
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(optionsStackView)
        
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
            searchStackView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            searchStackView.heightAnchor.constraint(equalToConstant: 32),
            searchStackView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            searchStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9)
            ])
        
        NSLayoutConstraint.activate([
            filterSumSegmentedControl.topAnchor.constraint(equalTo: searchStackView.bottomAnchor, constant: 8),
            filterSumSegmentedControl.heightAnchor.constraint(equalToConstant: 32),
            filterSumSegmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            filterSumSegmentedControl.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9)
            ])
        
        NSLayoutConstraint.activate([
            optionsStackView.topAnchor.constraint(equalTo: filterSumSegmentedControl.bottomAnchor, constant: 8),
            optionsStackView.heightAnchor.constraint(equalToConstant: 32),
            optionsStackView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            optionsStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9)
            ])
        
        NSLayoutConstraint.activate([
            receiptsTableView.topAnchor.constraint(equalTo: optionsStackView.bottomAnchor, constant: 8),
            receiptsTableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            receiptsTableView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            receiptsTableView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: HANDLERS
    
    func statusInactive() {
        filterStatusSegmentedControl.alpha = 0.5
        filterStatusSegmentedControl.tintColor = UIColor(named: "GoneGray")
        filterStatusSegmentedControl.isUserInteractionEnabled = false
    }
    
    func statusActive() {
        filterStatusSegmentedControl.alpha = 1
        filterStatusSegmentedControl.tintColor = UIColor(named: "BondingBlue")
        filterStatusSegmentedControl.isUserInteractionEnabled = true
    }
}
