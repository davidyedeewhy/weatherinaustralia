//
//  WeatherDetailUIView.swift
//  Weather in Australia
//
//  Created by David Ye on 23/1/17.
//  Copyright © 2017 Bestau Pty Ltd. All rights reserved.
//

import UIKit

class WeatherDetailUIView: UIView {

    private var coder: NSCoder?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.coder = aDecoder
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        var y : CGFloat = 0.0
        let width = UIScreen.main.bounds.size.width
        
        if coder != nil{
            if let main = coder!.decodeObject(forKey: "main") as? Weather{
                
                NSString.init(string: "humidity").draw(in: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20) ,
                                                                withAttributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17)])
                
                NSString.init(string: "\(main.humidity)").draw(in: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20) ,
                                                    withAttributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17)])
                
                y = y + 20
            }
            
        }
    }

}
