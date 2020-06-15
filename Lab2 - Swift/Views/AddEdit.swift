//
//  AddEditReceipt.swift
//  Lab2 - Swift
//
//  Created by Jimmie Määttä on 2019-04-30.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit

class AddEdit: UIView, UITextFieldDelegate {
    
    
    // MARK: --- PROPERTIES
    
    var statusState: Bool!
    
    var receipt: Receipt? {
        didSet {
            let currencyFormatter = NumberFormatter()
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.numberStyle = .currency
            currencyFormatter.locale = Locale(identifier: "sv_SE")
            
            var sum:String = ""
            if receipt!.sum < 0 {
                sum = String(receipt!.sum * -1)
                sumSegmentedControl.selectedSegmentIndex = 0
            } else if receipt!.sum == 0 {
                sumSegmentedControl.selectedSegmentIndex = 0
            } else {
                sum = String(receipt!.sum)
                sumSegmentedControl.selectedSegmentIndex = 1
            }
            
            switch sumSegmentedControl.selectedSegmentIndex {
            case 0:
                self.activateStatus()
            case 1:
                self.inactivateStatus()
            default:
                break
            }
            
            if let status = receipt?.status {
                switch status {
                case "Paid":
                    statusSegmentedControl.selectedSegmentIndex = 0
                case "Unpaid":
                    statusSegmentedControl.selectedSegmentIndex = 1
                default:
                    break
                }
            }
            
            titleTextField.text = receipt!.title
            sumTextField.text = String(sum)
            datePicker.date = receipt!.due
            categoryTextField.text = receipt!.category
            receiverTextField.text = receipt!.receiver
            receiptId = receipt!.receiptId
        }
    }
    
    let angleUpView = AngleUpView()
    let angleDownView = AngleDownView()
    
    var receiptId: String?
    
    let titleLabel: UILabel = {
        let label = AvenirMedium()
        label.font = label.font
        label.text = "Title: ".uppercased()
        return label
    }()
    
    let receiverLabel: UILabel = {
        let label = AvenirMedium()
        label.text = "Receiver: ".uppercased()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = AvenirMedium()
        label.text = "Category: ".uppercased()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sumLabel: UILabel = {
        let label = AvenirMedium()
        label.text = "Sum: ".uppercased()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = AvenirMedium()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.clearButtonMode = .always
        textField.placeholder = "Title"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let receiverTextField: UITextField = {
        let textField = UITextField()
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.clearButtonMode = .always
        textField.placeholder = "Receiver"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let categoryTextField: UITextField = {
        let textField = UITextField()
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.clearButtonMode = .always
        textField.placeholder = "Category"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let sumTextField: UITextField = {
        let textField = UITextField()
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.clearButtonMode = .always
        textField.placeholder = "0"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.locale = Locale.init(identifier: "en_EN")
        picker.backgroundColor = UIColor(named: "NotQuiteWhite")
        picker.datePickerMode = UIDatePicker.Mode.date
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let sumSegmentedControl: UISegmentedControl = {
        let options = ["Expense", "Income"]
        let segmentedControl = UISegmentedControl(items: options)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.layer.cornerRadius = 8.0
        segmentedControl.backgroundColor = UIColor(named: "NotQuiteWhite")
        segmentedControl.tintColor = UIColor(named: "BondingBlue")
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    let statusSegmentedControl: UISegmentedControl = {
        let options = ["Paid", "Unpaid"]
        let segmentedControl = UISegmentedControl(items: options)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.layer.cornerRadius = 8.0
        segmentedControl.backgroundColor = UIColor(named: "NotQuiteWhite")
        segmentedControl.tintColor = UIColor(named: "BondingBlue")
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    let saveLabel: UILabel = {
        let label = AvenirMedium()
        label.textAlignment = .center
        label.textColor = UIColor(named: "BondingBlue")
        label.font = label.font.bold
        label.isUserInteractionEnabled = true
        label.text = "Save".uppercased()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cancelLabel: UILabel = {
        let label = AvenirMedium()
        label.textAlignment = .center
        label.textColor = UIColor(named: "RegretRed")
        label.font = label.font.bold
        label.isUserInteractionEnabled = true
        label.text = "Cancel".uppercased()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: --- INIT
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "NotQuiteWhite")
        translatesAutoresizingMaskIntoConstraints = false
        
        titleTextField.delegate = self
        sumTextField.delegate = self
        categoryTextField.delegate = self
        receiverTextField.delegate = self
        
        addSubview(angleUpView)
        addSubview(angleDownView)
        
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
        
        let stackTitle = UIStackView(arrangedSubviews: [titleLabel, titleTextField])
        let stackReceiver = UIStackView(arrangedSubviews: [receiverLabel, receiverTextField])
        let stackCategory = UIStackView(arrangedSubviews: [categoryLabel, categoryTextField])
        let stackSum = UIStackView(arrangedSubviews: [sumLabel, sumTextField])
        let stackOptions = UIStackView(arrangedSubviews: [saveLabel, cancelLabel])
        let stackArray:[UIStackView] = [stackTitle, stackSum, stackCategory, stackReceiver, stackOptions]
        for stackView in stackArray {
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.spacing = 8
            stackView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addSubview(sumSegmentedControl)
        addSubview(statusSegmentedControl)
        addSubview(dateLabel)
        
        let dateView:UIView = {
            let view = UIView()
            view.backgroundColor = .clear
            view.layer.masksToBounds = true
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        dateView.addSubview(datePicker)
        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: dateView.centerXAnchor, constant: 0),
            datePicker.centerYAnchor.constraint(equalTo: dateView.centerYAnchor, constant: 0)
            ])
        
        addSubview(stackTitle)
        addSubview(stackReceiver)
        addSubview(stackCategory)
        addSubview(stackSum)
        addSubview(dateView)
        addSubview(stackOptions)
        
        NSLayoutConstraint.activate([
            stackTitle.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            stackTitle.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            stackTitle.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9)
            ])
        
        NSLayoutConstraint.activate([
            stackReceiver.topAnchor.constraint(equalTo: stackTitle.bottomAnchor, constant: 8),
            stackReceiver.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            stackReceiver.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9)
            ])
        
        NSLayoutConstraint.activate([
            stackCategory.topAnchor.constraint(equalTo: stackReceiver.bottomAnchor, constant: 8),
            stackCategory.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            stackCategory.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9)
            ])
        
        NSLayoutConstraint.activate([
            stackSum.topAnchor.constraint(equalTo: stackCategory.bottomAnchor, constant: 8),
            stackSum.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            stackSum.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9)
            ])
        
        NSLayoutConstraint.activate([
            sumSegmentedControl.topAnchor.constraint(equalTo: stackSum.bottomAnchor, constant: 8),
            sumSegmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            sumSegmentedControl.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9)
            ])
        
        NSLayoutConstraint.activate([
            statusSegmentedControl.topAnchor.constraint(equalTo: sumSegmentedControl.bottomAnchor, constant: 8),
            statusSegmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            statusSegmentedControl.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9)
            ])
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: statusSegmentedControl.bottomAnchor, constant: 8),
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            dateLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9)
            ])
        
        NSLayoutConstraint.activate([
            dateView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            dateView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            dateView.heightAnchor.constraint(equalToConstant: 64),
            dateView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9)
            ])
        
        NSLayoutConstraint.activate([
            stackOptions.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: 8),
            stackOptions.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            stackOptions.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            stackOptions.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: --- HANDLERS
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    func inactivateStatus() {
        statusState = false
        
        statusSegmentedControl.alpha = 0.5
        statusSegmentedControl.tintColor = UIColor(named: "GoneGray")
        statusSegmentedControl.isUserInteractionEnabled = false
        
        dateLabel.text = "Received: ".uppercased()
    }
    
    func activateStatus() {
        statusState = true
        
        statusSegmentedControl.alpha = 1
        statusSegmentedControl.tintColor = UIColor(named: "BondingBlue")
        statusSegmentedControl.isUserInteractionEnabled = true
        
        dateLabel.text = "Due Date: ".uppercased()
    }
}
