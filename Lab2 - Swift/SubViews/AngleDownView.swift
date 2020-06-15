//
//  AngleDownView.swift
//  Lab2 - Swift
//
//  Created by Jimmie Määttä on 2019-04-22.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit

class AngleDownView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.clear
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.beginPath()
        
        context.move(to: CGPoint(x: 0.0, y: 0.0))
        
        context.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height))
        
        context.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height/2))
        
        context.addLine(to: CGPoint(x: self.frame.size.width, y: 0.0))
        
        context.closePath()
        
        context.setFillColor(UIColor(named: "NotQuiteWhite")!.cgColor)
        context.fillPath()
    }
}
