//
//  AvenirSize20.swift
//  Lab2 - Swift
//
//  Created by Jimmie Määttä on 2019-04-27.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit

class AvenirBig: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.font = UIFont(name: "Avenir", size: 20)
        self.textColor = UIColor(named: "GoneGray")
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
