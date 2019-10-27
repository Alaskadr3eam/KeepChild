//
//  Semaine2TableViewController.swift
//  KeepChild
//
//  Created by Clément Martin on 26/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit

class SemaineTableViewController: UITableViewController {
    //MARK: - Outlet
    @IBOutlet var switchDay: [UISwitch]!
    //MARK: - Properties
    var announceEdit = AnnounceManager(firebaseServiceSession: FirebaseService(dataManager: ManagerFirebase()))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Constants.configureTilteTextNavigationBar(view: self, title: .choiceSemaine)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Enregistrer", style: .plain, target: self, action: #selector(saveSemaineSelection(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = Constants.Color.titleNavBar
    }
    // MARK: - Action
    @objc func saveSemaineSelection(_ sender: UIBarButtonItem) {
        announceEdit.encodeObjectInData(semaine: createSemaine())
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - Helpers
    private func switchTelIsClicked(_ sender: UISwitch) -> Bool {
        if sender.isOn {
            return true
        } else {
            return false
        }
    }
    
    private func createSemaine() -> Semaine {
        let semaine = Semaine(idUser: nil, lundi: switchTelIsClicked(switchDay[0]), mardi: switchTelIsClicked(switchDay[1]), mercredi: switchTelIsClicked(switchDay[2]), jeudi: switchTelIsClicked(switchDay[3]), vendredi: switchTelIsClicked(switchDay[4]), samedi: switchTelIsClicked(switchDay[5]), dimanche: switchTelIsClicked(switchDay[6]))
        return semaine
    }
}
