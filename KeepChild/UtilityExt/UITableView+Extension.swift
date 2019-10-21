//
//  UITableView+Extension.swift
//  KeepChild
//
//  Created by Clément Martin on 10/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit

extension UITableView {
    //func to create a view waiting for the request on the tableview
    func setEmptyMessage(_ messageStart: String, messageEnd: String, imageName: String) {
        //create label + image
        let fullString = NSMutableAttributedString(string: messageStart)
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: imageName)
        let image1String = NSAttributedString(attachment: image1Attachment)
        fullString.append(image1String)
        fullString.append(NSAttributedString(string: messageEnd))
        //create view
        //view.addSubview(messageLabel)
        //create label for message
        let messageLabel = UILabel(frame: CGRect(x: 0, y: self.bounds.size.height/2, width: self.bounds.size.width, height: self.bounds.size.height/2))
        messageLabel.backgroundColor = Constants.Color.bleu//Constants.Color.bleu
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = Constants.FontText.title
        messageLabel.sizeToFit()
        messageLabel.attributedText = fullString
        
        self.backgroundView = messageLabel
        
        self.separatorStyle = .none
    }
    
    func restore() {
        //remove the backgroundView from the tableView
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
    
    func setBackgroundView() {
        var gradientLayer: CAGradientLayer!
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.bounds
        guard let bleu = Constants.Color.bleu else { return }
        gradientLayer.colors = [bleu.cgColor, UIColor.white.cgColor, bleu.cgColor]
        self.tableFooterView?.layer.addSublayer(gradientLayer)
 
        //self.view.layer.addSublayer(gradientLayer)
    }
}

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
