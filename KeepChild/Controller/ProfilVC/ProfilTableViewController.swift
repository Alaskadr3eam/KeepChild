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
    var manageConversation = ManageConversation()

    override func viewDidLoad() {
        super.viewDidLoad()
        profilGestion.lastConnexion = Auth.auth().currentUser?.metadata.lastSignInDate
        Constants.configureTilteTextNavigationBar(view: self, title: .dashboard)
        self.navigationItem.rightBarButtonItem?.tintColor = Constants.Color.titleNavBar
        self.navigationItem.leftBarButtonItem?.tintColor = Constants.Color.titleNavBar
        requestInitProfil()
        requestConversation()
        initView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestInitProfil()
        requestConversation()
        
    }
    //MARK: - Request
    private func requestInitProfil() {
        let idUser = CurrentUserManager.shared.user.senderId
        profilGestion.retrieveAnnounceUser(field: "idUser", equal: idUser) { [weak self] (error, announce) in
            guard let self = self else { return }
            guard error == nil else {
                self.tableView.reloadData()
                self.tableView.setEmptyMessage("Une erreur s'est produite, ", messageEnd: " vérifiez votre connexion internet. Si le problème persiste contactez le développeur", imageName: "smileyPleure")
                return
            }
            guard announce != nil else { return }
            if announce!.count == 0 {
                self.tableView.reloadData()
                self.tableView.setEmptyMessage("Vous n'avez pas d'annonces publiées pour le moment. Cliquez sur", messageEnd: "en bas à gauche de votre bar de navigation.", imageName: "edit")
            } else {
                self.tableView.reloadData()
            }
        }
    }

    private func requestConversation() {
        requestIdUser1()
    }
    
    private func requestIdUser1() {
        manageConversation.arrayConversation.removeAll()
        manageConversation.retrieveConversion(field: "idUser1") { [weak self] (error, bool) in
            guard let self = self else { return }
            guard error == nil else { return }
            guard bool == true else {
                self.requestIdUser2()
                return
            }
            self.requestIdUser2()
        }
    }
    
    private func requestIdUser2() {
        manageConversation.retrieveConversion(field: "idUser2") { [weak self] (error, bool) in
            guard let self = self else { return }
            guard error == nil else { return }
            guard bool == true else {
                self.initSetUpViewDasboard()
                return
            }
            self.initSetUpViewDasboard()
        }
    }
    //MARK: -Action Func
    @IBAction func logOut() {
        try! Auth.auth().signOut()
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: Constants.VCIdentifier.firstViewController) as! AuthViewController
            self.present(vc, animated: false,completion: nil)
        }
    }
    
    //MARK: -View
    private func initView() {
        guard let profil = CurrentUserManager.shared.profil else { return }
        profilView.pseudoLabel.text = profil.pseudo
        profilView.imageProfil.downloadCustom(idUserImage: profil.iDuser, contentMode: .scaleToFill)
    }
    
    private func initSetUpViewDasboard() {
        profilView.dashboardView.setUpView()
        profilView.dashboardView.labelCountAnnounce.text = "\(profilGestion.arrayProfilAnnounce.count)"
        profilView.dashboardView.labelCountConversation.text = "\(manageConversation.arrayConversation.count)"
        guard let lastCo = profilView.dashboardView.lastConnexionlabel.text else { return }
        let myString = lastCo + profilGestion.transformeDateInString()
        profilView.dashboardView.lastConnexionlabel.text = myString
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
        return cell
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Vos annonces publiées:"
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = Constants.FontText.editText
        header.textLabel?.frame = header.frame
        header.textLabel?.textAlignment = .center
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = Constants.Color.bleu
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        profilGestion.announceDetail = profilGestion.arrayProfilAnnounce[indexPath.row]
        performSegue(withIdentifier: Constants.Segue.segueDetailAnnounce, sender: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.segueEditProfil {
            if segue.destination is EditProfilTableViewController {
            }
        }
        if segue.identifier == Constants.Segue.segueDetailAnnounce {
            let navVC = segue.destination as! UINavigationController
            let detailAnnounceVC = navVC.viewControllers.first as! DetailAnnounceTableViewController
            detailAnnounceVC.detailAnnounce.announce = profilGestion.announceDetail
        }
    }
    

}
