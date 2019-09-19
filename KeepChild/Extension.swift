//
//  Extension.swift
//  KeepChild
//
//  Created by Clément Martin on 14/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation
import FirebaseAuth
import UIKit
import FirebaseStorage

extension UITableView {
    //func to create a view waiting for the request on the tableview
    func setLoadingScreen(loadingView: UIView,spinner:UIActivityIndicatorView, loadingLabel: UILabel ) {
        
        let width: CGFloat = self.bounds.width
        let height: CGFloat = self.bounds.height
        let x: CGFloat = 0
        let y: CGFloat = 0
        
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        // Sets loading text
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        //loadingLabel.center = loadingView.center
        loadingLabel.frame = CGRect(x: 0, y: 0, width: loadingView.bounds.width, height: loadingView.bounds.height - 200)
        
        // Sets spinner
        spinner.style = .gray
        spinner.frame = CGRect(x: -100, y: 0, width: loadingView.bounds.width, height: loadingView.bounds.height - 200)
        spinner.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)
        
        //self.addSubview(loadingView)
        self.addSubview(loadingView)
        //self.backgroundView = loadingView
    }
    
    func removeLoadingScreen(loadingView: UIView,spinner:UIActivityIndicatorView, loadingLabel: UILabel) {
        //we stop everything and we hide it
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
        //we remove the view
        loadingView.removeFromSuperview()
    }
    
    func setEmptyMessage(_ message: String) {
        //create label for message
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.backgroundColor = UIColor(named: "Fond")
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 18)
        messageLabel.sizeToFit()
        //add label in backgroundView
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func restore() {
        //remove the backgroundView from the tableView
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

extension UIViewController {
    func verifyIdUser() -> String? {
        var idUserTransfer = String()
    Auth.auth().addStateDidChangeListener() { auth, user in
    if user != nil {
    guard let idUser = user?.uid else { return }
    idUserTransfer = idUser
    }
    }
        return idUserTransfer
    }
}
extension UIImage {
    enum Quality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func jpeg(_ jpegQuality: Quality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
/*extension UIImage {
    func uploadProfileImage(imageData: Data)
    {
        /*let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
         activityIndicator.startAnimating()
         activityIndicator.center = self.view.center
         self.view.addSubview(activityIndicator)*/
        
        
        let storageReference = Storage.storage().reference()
        let currentUser = Auth.auth().currentUser
        let profileImageRef = storageReference.child("users").child(currentUser!.uid).child("\(currentUser!.uid)-profileImage.jpg")
        
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        profileImageRef.putData(imageData, metadata: uploadMetaData) { (uploadedImageMeta, error) in
            
            // activityIndicator.stopAnimating()
            // activityIndicator.removeFromSuperview()
            
            if error != nil
            {
                print("Error took place \(String(describing: error?.localizedDescription))")
                return
            } else {
                
                selfz = UIImage(data: imageData)
                
                print("Meta data of uploaded image \(String(describing: uploadedImageMeta))")
            }
        }
    }
}*/
