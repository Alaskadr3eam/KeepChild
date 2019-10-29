//
//  UIImage+Extension.swift
//  KeepChild
//
//  Created by Clément Martin on 10/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit

extension UIImage {

    enum Quality: CGFloat {
        case lowestHard  = 0
        case lowest = 0.01
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func jpeg(_ jpegQuality: Quality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
  
}
