//
//  DashboardView.swift
//  KeepChild
//
//  Created by Clément Martin on 18/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit

class DashboardView: UIView {
    //MARK: - Outlet
    @IBOutlet weak var imageAnnounce: UIImageView!
    @IBOutlet weak var labelCountAnnounce: UILabel!
    @IBOutlet weak var imageMessage: UIImageView!
    @IBOutlet weak var labelCountConversation: UILabel!
    @IBOutlet weak var lastConnexionlabel: UILabel!
    
    func setUpView() {
        imageAnnounce.image = Constants.Image.announce
        imageMessage.image = Constants.Image.envelope
        imageMessage.tintColor = .black
        lastConnexionlabel.text = "Dernière connexion: "
    }

}
