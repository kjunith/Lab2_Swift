//
//  AvenirSmall.swift
//  Lab2 - Swift
//
//  Created by Jimmie Määttä on 2019-04-29.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit

class AvenirSmall: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.font = UIFont(name: "Avenir", size: 12)
        self.textColor = UIColor(named: "GoneGray")
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
