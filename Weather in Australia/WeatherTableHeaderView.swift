//
//  WeatherTableHeaderView.swift
//  Weather in Australia
//
//  Created by David Ye on 10/2/17.
//  Copyright © 2017 Bestau Pty Ltd. All rights reserved.
//

import UIKit

class WeatherTableHeaderView: UIView {
    
    @IBOutlet var segment : UISegmentedControl?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        segment = UISegmentedControl(frame: CGRect(x: 0, y: 0, width: frame.size.width * 0.5, height: 30))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
