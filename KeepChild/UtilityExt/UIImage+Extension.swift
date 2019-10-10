//
//  UIImage+Extension.swift
//  KeepChild
//
//  Created by Clément Martin on 10/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit

extension UIImage {
  
  var scaledToSafeUploadSize: UIImage? {
    let maxImageSideLength: CGFloat = 480
    
    let largerSide: CGFloat = max(size.width, size.height)
    let ratioScale: CGFloat = largerSide > maxImageSideLength ? largerSide / maxImageSideLength : 1
    let newImageSize = CGSize(width: size.width / ratioScale, height: size.height / ratioScale)
    
    return image(scaledTo: newImageSize)
  }
  
  func image(scaledTo size: CGSize) -> UIImage? {
    defer {
      UIGraphicsEndImageContext()
    }
    
    UIGraphicsBeginImageContextWithOptions(size, true, 0)
    draw(in: CGRect(origin: .zero, size: size))

    return UIGraphicsGetImageFromCurrentImageContext()
  }

    enum Quality: CGFloat {
        case lowestHard  = 0
        case lowest = 0.1
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func jpeg(_ jpegQuality: Quality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
  
}
