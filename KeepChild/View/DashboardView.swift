//
//  DashboardView.swift
//  KeepChild
//
//  Created by Clément Martin on 18/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit

class DashboardView: UIView {
    
    @IBOutlet weak var imageAnnounce: UIImageView!
    @IBOutlet weak var labelCountAnnounce: UILabel!
    @IBOutlet weak var imageMessage: UIImageView!
    @IBOutlet weak var labelCountConversation: UILabel!
    @IBOutlet weak var lastConnexionlabel: UILabel!
    
    func setUpView() {
        imageAnnounce.image = Constants.Image.announce
        imageAnnounce.tintColor = UIColor.black
        imageMessage.image = Constants.Image.envelope
        imageMessage.tintColor = UIColor.black
        lastConnexionlabel.text = "Derniere connexion: "
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
