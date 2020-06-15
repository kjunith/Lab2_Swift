//
//  ReceiptsTableViewCell.swift
//  Lab2 - Swift
//
//  Created by Jimmie Määttä on 2019-04-25.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit

class ReceiptsTableViewCell: UITableViewCell {
    
    
    // MARK: --- PROPERTIES
    
    let dateFormatter = DateFormatter()
    let numberFormatter = NumberFormatter()
    let dateLocale = Locale(identifier: "en_EN")
    let numberLocale = Locale(identifier: "sv_SE")
    
    var receipt: Receipt? {
        didSet {
            dateFormatter.dateFormat = "d MMM yyyy"
            dateFormatter.locale = dateLocale
            
            numberFormatter.locale = numberLocale
            numberFormatter.numberStyle = .currency
            numberFormatter.usesGroupingSeparator = true
            
            if receipt!.title != "" {
                titleLabel.text = receipt!.title.uppercased()
            } else {
                titleLabel.text = "N/A".uppercased()
            }
            
            if receipt!.receiver != "" {
                receiverLabel.text = "Rec.: \(receipt!.receiver)".uppercased()
            } else {
                receiverLabel.text = "Rec.: N/A".uppercased()
            }
            
            if receipt!.category != "" {
                categoryLabel.text = "Cat.: \(receipt!.category)".uppercased()
            } else {
                categoryLabel.text = "Cat.: N/A".uppercased()
            }
            
            if receipt!.sum != 0.0 {
                if receipt!.sum > 0.0 {
                    sumLabel.textColor = UIColor(named: "GoodGreen")
                } else if receipt!.sum < 0.0 {
                    sumLabel.textColor = UIColor(named: "RegretRed")
                }
                sumLabel.text = numberFormatter.string(from: receipt!.sum as NSNumber)?.uppercased()
            } else {
                sumLabel.text = numberFormatter.string(from: 0.0 as NSNumber)?.uppercased()
            }
            
            switch receipt!.status {
            case "None":
                let due = dateFormatter.string(from: receipt!.due)
                dueLabel.textColor = UIColor(named: "BondingBlue")
                dueLabel.text = "Received: \(due)".uppercased()
            case "Paid":
                let due = dateFormatter.string(from: receipt!.due)
                dueLabel.textColor = UIColor(named: "GrownGreen")
                dueLabel.text = "Paid on: \(due)".uppercased()
            case "Unpaid":
                let due = dateFormatter.string(from: receipt!.due)
                dueLabel.textColor = UIColor(named: "RuinedRed")
                dueLabel.text = "Due date: \(due)".uppercased()
            default:
                break
            }
            
            let added = dateFormatter.string(from: receipt!.added)
            addedLabel.text = "Added: \(added)".uppercased()
        }
    }
    
    let titleLabel: UILabel = {
        let label = AvenirMedium()
        label.textColor = UIColor(named: "BondingBlue")
        label.font = label.font.bold
        return label
    }()
    
    var sumLabel: UILabel = {
        let label = AvenirMedium()
        label.font = label.font.italic
        label.textAlignment = .right
        return label
    }()
    
    var receiverLabel: UILabel = {
        let label = AvenirSmall()
        label.font = label.font.bold
        return label
    }()
    
    var dueLabel: UILabel = {
        let label = AvenirSmall()
        label.font = label.font.boldItalic
        label.textAlignment = .right
        return label
    }()
    
    var categoryLabel: UILabel = {
        let label = AvenirSmall()
        return label
    }()
    
    var addedLabel: UILabel = {
        let label = AvenirSmall()
        label.font = label.font.italic
        label.textAlignment = .right
        return label
    }()
    
    
    // MARK: --- INIT
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(named: "NotQuiteWhite")
        
        let layoutView = UIView()
        layoutView.backgroundColor = .clear
        layoutView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(layoutView)
        NSLayoutConstraint.activate([
            layoutView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            layoutView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            layoutView.heightAnchor.constraint(equalToConstant: 64),
            layoutView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            layoutView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
            ])
        
        let topStackView = UIStackView(arrangedSubviews: [titleLabel, sumLabel])
        let midStackView = UIStackView(arrangedSubviews: [receiverLabel, dueLabel])
        let botStackView = UIStackView(arrangedSubviews: [categoryLabel, addedLabel])
        let stackArray:[UIStackView] = [topStackView, midStackView, botStackView]
        for stackView in stackArray {
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.spacing = 0
            stackView.alignment = .bottom
            stackView.translatesAutoresizingMaskIntoConstraints = false
        }
        layoutView.addSubview(topStackView)
        layoutView.addSubview(midStackView)
        layoutView.addSubview(botStackView)
        
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: layoutView.topAnchor, constant: 0),
            topStackView.leadingAnchor.constraint(equalTo: layoutView.leadingAnchor, constant: 0),
            topStackView.trailingAnchor.constraint(equalTo: layoutView.trailingAnchor, constant: 0)
            ])
        
        NSLayoutConstraint.activate([
            midStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 0),
            midStackView.leadingAnchor.constraint(equalTo: layoutView.leadingAnchor, constant: 0),
            midStackView.trailingAnchor.constraint(equalTo: layoutView.trailingAnchor, constant: 0),
            midStackView.heightAnchor.constraint(equalToConstant: 16)
            ])
        
        NSLayoutConstraint.activate([
            botStackView.topAnchor.constraint(equalTo: midStackView.bottomAnchor, constant: 0),
            botStackView.leadingAnchor.constraint(equalTo: layoutView.leadingAnchor, constant: 0),
            botStackView.trailingAnchor.constraint(equalTo: layoutView.trailingAnchor, constant: 0),
            botStackView.heightAnchor.constraint(equalToConstant: 16)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
