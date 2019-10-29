//
//  UIImageView+Extension.swift
//  KeepChild
//
//  Created by Clément Martin on 10/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit
import Firebase

extension CustomImageView {
    func downloadCustom(idUserImage: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        
        self.setLoadingScreen()
        let storageReference = Storage.storage().reference()
        let reference = storageReference.child("usersProfil")
        let photoUser = reference.child("\(idUserImage).jpg")
        photoUser.getData(maxSize: 1*1024*1024) { (data, error) in
            guard error == nil else {
                self.image = UIImage(named: "default")
                self.removeLoadingScreen()
                return }
            guard let dataSecure = data else {
                self.image = UIImage(named: "default")
                self.removeLoadingScreen()
                return }
            let image = UIImage(data: dataSecure)
            self.image = image
            self.removeLoadingScreen()
        }
    }
}
