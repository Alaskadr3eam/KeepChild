//
//  Semaine2TableViewController.swift
//  KeepChild
//
//  Created by Clément Martin on 26/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit

class SemaineTableViewController: UITableViewController {

    @IBOutlet var switchDay: [UISwitch]!
    var navigationBar: UINavigationBar!
    
    var jour = [String]()
    var announceEdit = AnnounceEdit()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    func switchTelIsClicked(_ sender: UISwitch) -> Bool {
        
        if sender.isOn {
            //jour.append(returnDayForSwitch(sender))
            return true
        } else {
            return false
        }
        
    }
    
    

    func returnDayForSwitch(_ sender: UISwitch) -> String {
        switch sender.tag {
        case 0: return "Lundi"
        case 1: return "Mardi"
        case 2: return "Mercredi"
        case 3: return "Jeudi"
        case 4: return "Vendredi"
        case 5: return "Samedi"
        case 6: return "Dimanche"
        default : return ""
        }
    }

    func createJourForKeep() {
        for switchButton in switchDay {
            switchTelIsClicked(switchButton)
        }
    }

    func createSemaine() -> Semaine {
        let semaine = Semaine(idUser: nil, lundi: switchTelIsClicked(switchDay[0]), mardi: switchTelIsClicked(switchDay[1]), mercredi: switchTelIsClicked(switchDay[2]), jeudi: switchTelIsClicked(switchDay[3]), vendredi: switchTelIsClicked(switchDay[4]), samedi: switchTelIsClicked(switchDay[5]), dimanche: switchTelIsClicked(switchDay[6]))
        return semaine
    }
    @IBAction func saveSemaineSelection(_ sender: UIBarButtonItem) {
    announceEdit.encodeObjectInData(semaine: createSemaine())
    //UserDefaults.standard.set(jour, forKey: "jour")
    dismiss(animated: true, completion: nil)
    self.navigationController?.popViewController(animated: true)
    }

}
