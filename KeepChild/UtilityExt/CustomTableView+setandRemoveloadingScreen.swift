//
//  CustomTableView+setandRestoreBackgroundViewMessage.swift
//  KeepChild
//
//  Created by Clément Martin on 29/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit
extension CustomTableView {
    func setLoadingScreen() {
        
        let width: CGFloat = self.bounds.width
        let height: CGFloat = self.bounds.height
        let x: CGFloat = 0
        let y: CGFloat = 0
        
        self.loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        self.loadingView.backgroundColor = UIColor.white
        
        // Sets loading text
        self.label.textColor = .gray
        self.label.textAlignment = .center
        self.label.text = "Loading..."
        //loadingLabel.center = loadingView.center
        self.label.frame = CGRect(x: 0, y: 0, width: loadingView.bounds.width, height: loadingView.bounds.height - 200)
        
        // Sets spinner
        self.spinner.style = .gray
        self.spinner.frame = CGRect(x: -50, y: 0, width: loadingView.bounds.width, height: loadingView.bounds.height - 200)
        self.spinner.startAnimating()
        
        // Adds text and spinner to the view
        self.loadingView.addSubview(self.spinner)
        self.loadingView.addSubview(self.label)
        
        //self.addSubview(loadingView)
        self.addSubview(self.loadingView)
        //self.backgroundView = loadingView
        
    }
    
    func removeLoadingScreen() {
        //we stop everything and we hide it
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
        self.label.isHidden = true
        //we remove the view
        self.loadingView.removeFromSuperview()
    }
}
