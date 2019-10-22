//
//  Constant.swift
//  KeepChild
//
//  Created by Clément Martin on 17/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit

class Constants {
    
    struct Image {
        static let envelope = UIImage(named:"Image-Envelope")
        static let location = UIImage(named:"Image-Location")
        static let lock = UIImage(named:"Image-Lock")
        static let starsFond = UIImage(named: "starsFond")
        static let announce = UIImage(named:"announce")
        static let smileyContent = UIImage(named: "smileyContent")
        static let addUser = UIImage(named: "addUser")
    }
    
    struct Color {
        static let lightGray = UIColor(named: "lightGray")
        static let button = UIColor(named: "Color-Button")
        static let bleu = UIColor(named: "bleu")
        static let titleNavBar = UIColor.white
        static let placeHolder = UIColor(named: "GrayPlaceHolder")
    }
    
    struct FontText {
        static let title = UIFont(name: "Noteworthy-Bold", size: 25)
        static let editText = UIFont(name: "Noteworthy-Light", size: 20)
        
    }
    
    struct Segue {
        static let segueSearch = "Search"
        static let segueFiltered = "filtered"
        static let segueProfil = "Dashboard"
        static let segueEditProfil = "EditProfil"
        static let segueDetailAnnounce = "DetailAnnounce"
        static let segueMapKit = "mapKitView"
        static let segueSendMessage = "SendMessage"
        static let segueLoginToList = "LoginToList"
    }
    
    struct VCIdentifier {
        static let firstViewController = "firstViewController"
        static let announceSearchTableViewController = "AnnounceSearchTableViewController"
        static let mapKitAnnounceViewController = "MapKitAnnounceViewController"

    }

    
    static func configureTilteTextNavigationBar(view: UIViewController,title: TitleNavBar) {
        view.navigationItem.title = title.titleText
        view.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:Constants.Color.titleNavBar as Any,NSAttributedString.Key.font:Constants.FontText.title as Any]
    }
    
    enum TitleNavBar {
    case editAnnounce,choiceSemaine,detailAnnounce,filterAnnounce,firstMessage,conversation,chatMessaging(String),editProfil,dashboard
    
        var titleText: String {
            switch self {
            case .editAnnounce:
                return "Créer votre annonce"
            case .choiceSemaine:
                return "Choix des jours de garde"
            case .detailAnnounce:
                return "Annonce"
            case .filterAnnounce:
                return "Recherche avancée"
            case .firstMessage:
                return "Votre message"
            case .conversation:
                return "Mes conversations"
            case .chatMessaging(let text):
                return text
            case .editProfil:
                return "Profil"
            case .dashboard:
                return "Dashboard"
            }
        }
        
    }
    
}

