//
//  UIView+Extension.swift
//  KeepChild
//
//  Created by Clément Martin on 10/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit

extension UIView {
  
  func smoothRoundCorners(to radius: CGFloat) {
    let maskLayer = CAShapeLayer()
    maskLayer.path = UIBezierPath(
      roundedRect: bounds,
      cornerRadius: radius
    ).cgPath
    
    layer.mask = maskLayer
  }
  
    func setGradientLayer() {
        var gradientLayer: CAGradientLayer!
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        guard let bleu = Constants.Color.bleu else { return }
        gradientLayer.colors = [bleu.cgColor, UIColor.white.cgColor, bleu.cgColor]
        self.layer.addSublayer(gradientLayer)
        //self.layer.addSublayer(gradientLayer)
    }
}
