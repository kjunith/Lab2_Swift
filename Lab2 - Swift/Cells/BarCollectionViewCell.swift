//
//  BarCollectionViewCell.swift
//  Lab2 - Swift
//
//  Created by Jimmie Määttä on 2019-05-09.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit

class BarCollectionViewCell: UICollectionViewCell {
    
    
    var incomeHeight: NSLayoutConstraint?
    let incomeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "GooGreen")
        view.alpha = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let incomePointer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "GrownGreen")
        view.alpha = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var expenseHeight: NSLayoutConstraint?
    let expenseView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "RareRed")
        view.alpha = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let expensePointer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "RuinedRed")
        view.alpha = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let dayLabel: UILabel = {
        let label = AvenirSmall()
        label.font = UIFont(name: "Avenir", size: 8)
        label.textAlignment = .center
        label.backgroundColor = UIColor(named: "NotQuiteWhite")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let barView = UIView()
        barView.translatesAutoresizingMaskIntoConstraints = false
        barView.addSubview(incomeView)
        barView.addSubview(incomePointer)
        barView.addSubview(expenseView)
        barView.addSubview(expensePointer)
        addSubview(barView)
        addSubview(dayLabel)
        
        incomeHeight = incomeView.heightAnchor.constraint(equalToConstant: 0)
        incomeHeight?.isActive = true
        
        expenseHeight = expenseView.heightAnchor.constraint(equalToConstant: 0)
        expenseHeight?.isActive = true
        
        NSLayoutConstraint.activate([
            barView.bottomAnchor.constraint(equalTo: bottomAnchor),
            barView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            barView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0)
            ])
        
        NSLayoutConstraint.activate([
            dayLabel.bottomAnchor.constraint(equalTo: barView.bottomAnchor),
            dayLabel.heightAnchor.constraint(equalToConstant: 16),
            dayLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            dayLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 0)
            ])
        
        NSLayoutConstraint.activate([
            incomeView.bottomAnchor.constraint(equalTo: dayLabel.topAnchor),
            incomeView.widthAnchor.constraint(equalTo: barView.widthAnchor, multiplier: 0.5),
            incomeView.leftAnchor.constraint(equalTo: barView.leftAnchor)
            ])
        
        NSLayoutConstraint.activate([
            incomePointer.topAnchor.constraint(equalTo: incomeView.topAnchor),
            incomePointer.heightAnchor.constraint(equalToConstant: 2),
            incomePointer.widthAnchor.constraint(equalTo: barView.widthAnchor, multiplier: 0.5),
            incomePointer.leftAnchor.constraint(equalTo: barView.leftAnchor)
            ])
        
        NSLayoutConstraint.activate([
            expenseView.bottomAnchor.constraint(equalTo: dayLabel.topAnchor),
            expenseView.widthAnchor.constraint(equalTo: barView.widthAnchor, multiplier: 0.5),
            expenseView.rightAnchor.constraint(equalTo: barView.rightAnchor)
            ])
        
        NSLayoutConstraint.activate([
            expensePointer.topAnchor.constraint(equalTo: expenseView.topAnchor),
            expensePointer.heightAnchor.constraint(equalToConstant: 2),
            expensePointer.widthAnchor.constraint(equalTo: barView.widthAnchor, multiplier: 0.5),
            expensePointer.rightAnchor.constraint(equalTo: barView.rightAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
