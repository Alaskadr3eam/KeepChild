//
//  ProfilTableViewController.swift
//  KeepChild
//
//  Created by Clément Martin on 14/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import CodableFirebase
import CoreLocation

class ProfilTableViewController: UITableViewController {
    //MARK: - Properties
    @IBOutlet weak var profilView: ProfilView!
    //model for vc
    var profilGestion = ProfilGestion()

    override func viewDidLoad() {
        super.viewDidLoad()
        requestInitProfil()
        initView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestInitProfil()
    }

    private func requestInitProfil() {
        let idUser = CurrentUserManager.shared.user.senderId
        profilGestion.retrieveAnnounceUser(field: "idUser", equal: idUser) { [weak self] (error, announce) in
            guard let self = self else { return }
            guard error == nil else { return }
            guard announce != nil else { return }
            if announce!.count == 0 {
                self.tableView.setEmptyMessage("Vous n'avez pas d'annonce publiée pour le moment.")
            } else {
                self.tableView.reloadData()
            }
        }
      /*  profilGestion.retrieveAnnunceUser(collection: "Announce2", field: "idUser", equal: idUser) { [weak self] (error,announce) in
            guard let self = self else { return }
            guard error == nil else { return }
            guard announce != nil else { return }
            if announce!.count == 0 {
                self.tableView.setEmptyMessage("Vous n'avez pas d'annonce publiée pour le moment.")
            } else {
                self.tableView.reloadData()
            }
        }*/
    }
    //MARK: -Action Func
    @IBAction func logOut() {
        try! Auth.auth().signOut()
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "firstViewController") as! AuthViewController
            self.present(vc, animated: false,completion: nil)
        }
    }
    
    //MARK: -View
    func initView() {
        guard let profil = CurrentUserManager.shared.profil else { return }
        profilView.pseudoLabel.text = /*profilGestion.*/profil.pseudo
        profilView.imageProfil.downloadCustom(idUserImage: profil.iDuser, contentMode: .scaleToFill)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profilGestion.arrayProfilAnnounce.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellAnnounce", for: indexPath)
        if profilGestion.arrayProfilAnnounce.count == 0 {
            return cell
        } else {
        let announce = profilGestion.arrayProfilAnnounce[indexPath.row]
        cell.textLabel!.text = announce.title
        cell.detailTextLabel!.text = announce.price
        return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        profilGestion.announceDetail = profilGestion.arrayProfilAnnounce[indexPath.row]
        performSegue(withIdentifier: "DetailAnnounce", sender: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditProfil" {
            if segue.destination is EditProfilTableViewController {
            }
        }
        if segue.identifier == "DetailAnnounce" {
            if let vcDestination = segue.destination as? DetailAnnounceTableViewController {
                vcDestination.detailAnnounce.announce = profilGestion.announceDetail
            }
        }
    }
    

}
