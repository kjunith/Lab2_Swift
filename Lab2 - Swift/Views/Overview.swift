//
//  TotalSums.swift
//  Lab2 - Swift
//
//  Created by Jimmie Määttä on 2019-04-26.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit
import EFCountingLabel

class Overview: UIView {
    
    
    // MARK: --- PROPERTIES
    
    let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    var collView: UICollectionView!
    
    var cellId = "BarCell"
    
    let numberFormatter = NumberFormatter()
    let locale = Locale(identifier: "sv_SE")
    
    let date = Date()
    
    let angleUpView = AngleUpView()
    let angleDownView = AngleDownView()
    
    let dateLabel: UILabel = {
        let label = AvenirBig()
        var date = Date()
        label.textAlignment = .center
        label.font = label.font.bold
        return label
    }()
    
    let nextLabel: UILabel = {
        let label = AvenirMedium()
        label.textAlignment = .left
        label.textColor = UIColor(named: "BondingBlue")
        label.font = label.font.bold
        label.isUserInteractionEnabled = true
        label.text = "Next".uppercased()
        return label
    }()
    
    let prevLabel: UILabel = {
        let label = AvenirMedium()
        label.textAlignment = .right
        label.textColor = UIColor(named: "BondingBlue")
        label.font = label.font.bold
        label.isUserInteractionEnabled = true
        label.text = "Prev".uppercased()
        return label
    }()
    
    let incomesLabel: UILabel = {
        let label = AvenirMedium()
        label.text = "Incomes: ".uppercased()
        return label
    }()
    
    let expensesLabel: UILabel = {
        let label = AvenirMedium()
        label.text = "Expenses: ".uppercased()
        return label
    }()
    
    let totalLabel: UILabel = {
        let label = AvenirMedium()
        label.text = "Total: ".uppercased()
        return label
    }()
    
    let incomesSumLabel: EFCountingLabel = {
        let label = EFCountingLabel()
        label.textColor = UIColor(named: "GoodGreen")
        label.font = label.font.bold
        label.textAlignment = .right
        return label
    }()
    
    let expensesSumLabel: EFCountingLabel = {
        let label = EFCountingLabel()
        label.textColor = UIColor(named: "RegretRed")
        label.font = label.font.bold
        label.textAlignment = .right
        return label
    }()
    
    let totalSumLabel: EFCountingLabel = {
        let label = EFCountingLabel()
        label.textColor = UIColor(named: "BondingBlue")
        label.font = label.font.bold
        label.textAlignment = .right
        return label
    }()
    
    var totalSumsStackView = UIStackView()
    
    
    // MARK: --- INIT
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "NotQuiteWhite")
        translatesAutoresizingMaskIntoConstraints = false
        
        updateLabels(date: date)
        setupTotalSumsStackView()
        setupCollectionView()
        
        addSubview(angleUpView)
        addSubview(angleDownView)
        addSubview(totalSumsStackView)
        addSubview(collView)
        
        let stackView = UIStackView(arrangedSubviews: [prevLabel, dateLabel, nextLabel])
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
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
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
            ])
        
        NSLayoutConstraint.activate([
            collView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
            collView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            collView.heightAnchor.constraint(equalToConstant: 128),
            collView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9)
            ])
        
        NSLayoutConstraint.activate([
            totalSumsStackView.topAnchor.constraint(equalTo: collView.bottomAnchor, constant: 8),
            totalSumsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            totalSumsStackView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            totalSumsStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: --- HANDLERS
    
    func setupDateLabel(date:Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MMM yyyy"
        dateLabel.text = dateFormatter.string(from: date).uppercased()
    }
    
    func setupTotalSumsStackView() {
        let incomesStackView: UIStackView = {
            let views:[UIView] = [incomesLabel, incomesSumLabel]
            let stackView = UIStackView(arrangedSubviews: views)
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.spacing = 8
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        
        let expensesStackView: UIStackView = {
            let views:[UIView] = [expensesLabel, expensesSumLabel]
            let stackView = UIStackView(arrangedSubviews: views)
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.spacing = 8
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        
        let totalStackView: UIStackView = {
            let views:[UIView] = [totalLabel, totalSumLabel]
            let stackView = UIStackView(arrangedSubviews: views)
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.spacing = 8
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        
        totalSumsStackView = UIStackView(arrangedSubviews: [incomesStackView, expensesStackView, totalStackView])
        totalSumsStackView.axis = .vertical
        totalSumsStackView.distribution = .fillEqually
        totalSumsStackView.spacing = 8
        totalSumsStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func updateLabels(date:Date) {
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = locale
        
        let labelArray: [EFCountingLabel] = [incomesSumLabel , expensesSumLabel, totalSumLabel]
        for label in labelArray {
            label.formatBlock = {
                (value) in
                return (self.numberFormatter.string(from: NSNumber(value: Double(value))) ?? "")
            }
            label.method = EFLabelCountingMethod.easeIn
            label.animationDuration = 0.66
        }
        
        incomesSumLabel.countFromZeroTo(CGFloat(ReceiptsData.handler.incomesSum))
        expensesSumLabel.countFromZeroTo(CGFloat(ReceiptsData.handler.expensesSum))
        totalSumLabel.countFromZeroTo(CGFloat(ReceiptsData.handler.totalSum))
        
        setupDateLabel(date: date)
    }
    
    func setupCollectionView() {
        collView = UICollectionView(frame: CGRect(x: 0, y: 0, width: frame.width * 0.9, height: 128), collectionViewLayout: layout)
        collView.register(BarCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collView.isScrollEnabled = false
        collView.translatesAutoresizingMaskIntoConstraints = false
        collView.backgroundColor = .clear
    }
}
