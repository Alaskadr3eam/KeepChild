//
//  UIImageView+Extension.swift
//  KeepChild
//
//  Created by Clément Martin on 10/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit
import Firebase

extension UIImageView {
    
    func download(idUserImage: String, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        contentMode = mode
        
        
        let storageReference = Storage.storage().reference()
        let reference = storageReference.child("usersProfil")
        let photoUser = reference.child("\(idUserImage).jpg")
        photoUser.getData(maxSize: 1*1024*1024) { (data, error) in
            guard error == nil else { print("error download:\(error?.localizedDescription)") ; return }
            guard let dataSecure = data else { return }
            let image = UIImage(data: dataSecure)
            self.image = image
        }
    }
}

extension CustomImageView {
    
    func setLoadingScreen() {
        
        let width: CGFloat = self.bounds.width
        let height: CGFloat = self.bounds.height
        let x: CGFloat = 0
        let y: CGFloat = 0
        
        //self.loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        self.loadingView.center = self.center
        self.loadingView.backgroundColor = UIColor.white
        // Sets spinner
        self.spinner.center = self.center
        self.spinner.style = .gray
        
        self.spinner.frame = CGRect(x: 0, y: 0, width: loadingView.bounds.width, height: loadingView.bounds.height)
        self.spinner.startAnimating()
        // Add spinner to the view
        self.loadingView.addSubview(spinner)
        //self.addSubview(loadingView)
        self.addSubview(loadingView)
        //self.backgroundView = loadingView
    }
    
    func removeLoadingScreen() {
        //we stop everything and we hide it
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
        //we remove the view
        self.loadingView.removeFromSuperview()
    }
    
    func downloadCustom(idUserImage: String, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        contentMode = mode
        
        self.setLoadingScreen()
        let storageReference = Storage.storage().reference()
        let reference = storageReference.child("usersProfil")
        let photoUser = reference.child("\(idUserImage).jpg")
        photoUser.getData(maxSize: 1*1024*1024) { (data, error) in
            guard error == nil else { print("error download:\(error?.localizedDescription)") ; return }
            guard let dataSecure = data else {
                self.image = UIImage(named: "default")
                print("no image")
                return }
            let image = UIImage(data: dataSecure)
            self.image = image
            self.removeLoadingScreen()
        }
    }
}