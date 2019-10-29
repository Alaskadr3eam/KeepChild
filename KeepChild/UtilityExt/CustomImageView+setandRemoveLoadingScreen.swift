//
//  CustomImageView+setandRemoveLoadingScreen.swift
//  KeepChild
//
//  Created by Clément Martin on 29/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit

extension CustomImageView {
    func setLoadingScreen() {
        
        self.loadingView.center = self.center
        self.loadingView.backgroundColor = UIColor.white
        // Sets spinner
        self.spinner.center = self.center
        self.spinner.style = .gray
        self.spinner.frame = CGRect(x: 0, y: 0, width: self.loadingView.bounds.width, height: self.loadingView.bounds.height)
        self.spinner.startAnimating()
        // Add spinner to the view
        self.loadingView.addSubview(spinner)
        self.addSubview(loadingView)
        
    }
    
    func removeLoadingScreen() {
        //we stop everything and we hide it
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
        //we remove the view
        self.loadingView.removeFromSuperview()
    }
}
