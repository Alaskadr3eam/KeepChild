//
//  AnnounceEditTableViewController.swift
//  KeepChild
//
//  Created by Clément Martin on 14/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit
import FirebaseAuth
import CodableFirebase
import FirebaseFirestore

class AnnounceEditTableViewController: UITableViewController {
    
    //MARK: -Properties Outlet
    @IBOutlet weak var titleAnnounceTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var priceAnnounceTextField: UITextField!
    @IBOutlet weak var switchTel: UISwitch!
    @IBOutlet weak var diurneSwitch: UISwitch!
    @IBOutlet weak var nocturneSwitch: UISwitch!

    //MARK: -Properties models
    var announceEdit = AnnounceEdit()
    var profilGestion = ProfilGestion()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        announceEdit.delegate = self
        //announceEdit.removeUserDefaultObject(forkey: "semaine")
        self.navigationItem.title = "Créer votre annonce"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveAnnounce))
        descriptionTextView.layer.borderColor = UIColor.gray.cgColor
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.cornerRadius = 10
        descriptionTextView.delegate = self
        tableView.footerView(forSection: 1)
        
    }

    //func for decode object in userDefault
    func decodeProfilSaved() -> Semaine? {
        if let savedProfil = UserDefaults.standard.object(forKey: "Semaine") as? Data {
            if let semaineLoaded = try? JSONDecoder().decode(Semaine.self, from: savedProfil) {
                return semaineLoaded
            }
        }
        return nil
    }
    
    // MARK: - Table view data source

    //MARK: -Action Func
    @objc func saveAnnounce() {
        if textFieldIsEmpty() == true {
            retriveGeoLocForAnnounce()
            
        }
    }

    //MARK: -View Func
    func reinitView() {
        titleAnnounceTextField.text? = ""
        descriptionTextView.text? = ""
        priceAnnounceTextField.text = ""
    }

    //MARK: -Helpers Func
   /* private func enableTextfield(bool: Bool) {
        titleAnnounceTextField.isUserInteractionEnabled = bool
        descriptionAnnounceTextField.isUserInteractionEnabled = bool
        priceAnnounceTextField.isUserInteractionEnabled = bool
    }*/

    private func textFieldIsEmpty() -> Bool {
        let title = "Attention"
        if titleAnnounceTextField.text?.isEmpty == true {
            let message = "Titre de l'annonce non remplie. Il faut que tout les champs soit renseignés."
            self.presentAlert(title: title, message: message)
            return false
        }
        if descriptionTextView.text?.isEmpty == true {
            let message = "Description non remplie. Il faut que tout les champs soit renseignés."
            self.presentAlert(title: title, message: message)
            return false
        }
        if priceAnnounceTextField.text?.isEmpty == true {
            let message = "Prix non remplie. Il faut que tout les champs soit renseignés."
            self.presentAlert(title: title, message: message)
            return false
        }
        let semaine = announceEdit.decodedDataInObject()
        if semaine == nil {
            let message = "Attention, vous n'avez pas sélectionné les jours de la semaine ou vous étiez disponnible."
            self.presentAlert(title: title, message: message)
            return false
        }
       return true
    }

    private func switchTelIsClicked() -> Bool {
        if switchTel.isOn {
            return true
        }
        return false
    }

    //retrieve geoloc, create announce and addData in database.
    private func retriveGeoLocForAnnounce() {
        let adressString = "(\(CurrentUserManager.shared.profil.postalCode) \(CurrentUserManager.shared.profil.city)"
        announceEdit.getCoordinate(addressString: adressString) { [weak self] (coordinate, error) in
            guard let self = self else { return }
            guard error == nil else { return }
            guard coordinate != nil else { return }
            //creation announce une fois les coordonnées recupérées
            self.createAnnounce()
            //storage announce
            //self.announceEdit.addData(announce: self.announceEdit.announce)
            self.addAnnounceInFirebase()
            //remove UserDefault "semaine"
            self.announceEdit.removeUserDefaultObject(forkey: "semaine")
            self.reinitView()
        }
    }

    //request for addAnnounce in firebase
    private func addAnnounceInFirebase() {
        announceEdit.addData(announce: self.announceEdit.announce) { [weak self] (bool) in
            guard let self = self else { return }
            guard bool == true else {
                self.presentAlert(title: "Annonce non envoyé", message: "Désolé, votre annonce n'a pas pu etre sauvegardée. Vérifiez votre connexion internet.")
                return
            }
            self.presentAlert(title: "Annonce envoyé", message: "Félicitation, votre annonce a été enregistré.")
        }
    }

    private func createAnnounce() {
        guard
            let title = titleAnnounceTextField.text,
            let description = descriptionTextView.text,
            let price = priceAnnounceTextField.text else {
                self.presentAlert(title: "Attention", message: "Tout les champs ne sont pas remplis")
                return
        }
        let tel = switchTelIsClicked()
        announceEdit.createAnnounce(title: title, description: description, price: price, tel: tel, day: momentDaySwitch(diurneSwitch), night: momentDaySwitch(nocturneSwitch))
    }

    private func momentDaySwitch(_ sender: UISwitch) -> Bool {
        
        if sender.isOn {
            //sender.thumbTintColor = UIColor.yellow
            //mommentDayLabel.text = "Jour"
            return true
        } else {
            // sender.thumbTintColor = UIColor.black
            //mommentDayLabel.text = "Nuit"
            return false
        }
        //return false
    }

   /* private func profilOrNot() {
        if CurrentUserManager.shared.profil == nil {
            enableTextfield(bool: false)
           // self.tableView.setEmptyMessage("Impossible d'éditer une annonce sans créer son profil.")
        } else {
            enableTextfield(bool: true)
           // self.tableView.restore()
        }
    }*/
    
   /* private func requestProfil() {
        guard let idUser = profilGestion.idUser else { return }
        profilGestion.retrieveProfilUser2(collection: "ProfilUser", field: "iDuser", equal: idUser) { [weak self] (error, profil) in
            guard let self = self else { return }
            guard error == nil else {
                return
            }
            guard profil != nil else {
                self.setEmptyMessage("essaie")
                return
                
            }
            self.tableView.restore()
            self.enableTextfield(bool: true)
        }
        //self.profilOrNot()
    }*/
    

    
    
    
    
    
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AnnounceEditTableViewController: UITextViewDelegate {
    
}

extension AnnounceEditTableViewController: AnnounceEditDelegate {
    func alert(_ title: String, _ message: String) {
        self.presentAlert(title: title, message: message)
    }
    
    
}
