//
//  File.swift
//  
//
//  Created by Mohamed Aglan on 7/9/24.
//

import UIKit

class CustomButtonBorder: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8
    }
}
