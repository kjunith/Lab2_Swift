//
//  Header.swift
//  Lab2 - Swift
//
//  Created by Jimmie Määttä on 2019-04-23.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit

class Header: UIView {
    
    
    // MARK: --- PROPERTIES
    
    
    let angleDownView = AngleDownView()
    
    let dateLabel: UILabel = {
        let label = AvenirMedium()
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_EN")
        dateFormatter.dateFormat = "dd MMM"
        label.textColor = UIColor(named: "NotQuiteWhite")
        label.font = label.font.bold
        label.text = dateFormatter.string(from: date).uppercased()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: --- INIT
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        addSubview(angleDownView)
        angleDownView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            angleDownView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            angleDownView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            angleDownView.heightAnchor.constraint(equalToConstant: 64),
            angleDownView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            angleDownView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
            ])
        
        NSLayoutConstraint.activate([
            dateLabel.bottomAnchor.constraint(equalTo: angleDownView.bottomAnchor, constant: 0),
            dateLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -16)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
