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

    @IBOutlet weak var titleAnnounceTextField: UITextField!
    @IBOutlet weak var descriptionAnnounceTextField: UITextField!
    @IBOutlet weak var priceAnnounceTextField: UITextField!
    @IBOutlet weak var latitudeAnnounceTextField: UITextField!
    @IBOutlet weak var longitudeAnnounceTextField: UITextField!
    @IBOutlet weak var switchTel: UISwitch!
    
    @IBOutlet weak var diurneSwitch: UISwitch!
    @IBOutlet weak var nocturneSwitch: UISwitch!

    func momentDaySwitch(_ sender: UISwitch) -> Bool {
       
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
    
   // var diurnal = Bool()
   // var nocturne = Bool()
    
    var announceEdit = AnnounceEdit()
    var profilGestion = ProfilGestion()

   // var manageFireBase = ManageFireBase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // manageFireBase.idUser = UserDefaults.standard.string(forKey: "userID")!
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveAnnounce))

      profilGestion.decodeProfilSaved()
     //requestProfil()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // requestProfil()
        profilOrNot()
        
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


    @objc func saveAnnounce() {
       
        retriveGeoLocForAnnounce()
        
        //manageFireBase.addData(announce: announce)
        //alert pour dire message annonce sauvegarder ou echec
        //reinitView()
    }

    func enableTextfield(bool: Bool) {
        titleAnnounceTextField.isUserInteractionEnabled = bool
        descriptionAnnounceTextField.isUserInteractionEnabled = bool
        priceAnnounceTextField.isUserInteractionEnabled = bool
    }

    private func profilOrNot() {
        if CurrentUserManager.shared.profil == nil {
            enableTextfield(bool: false)
           // self.tableView.setEmptyMessage("Impossible d'éditer une annonce sans créer son profil.")
        } else {
            enableTextfield(bool: true)
           // self.tableView.restore()
        }
    }
    
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
    

    
    
    func switchTelIsClicked() -> Bool {
        if switchTel.isOn {
            return true
        }
        return false
    }
    //retrieve geoloc, create announce and addData in database.
    func retriveGeoLocForAnnounce() {
        //let number = Int.random(in: 0 ..< 10000000000)
        let idAnnounce = CurrentUserManager.shared.user.senderId
        //guard let semaine = decodeProfilSaved() else { return }
        let adressString = "(\(CurrentUserManager.shared.profil.postalCode) \(CurrentUserManager.shared.profil.city)"
        announceEdit.getCoordinate(addressString: adressString) { [weak self] (coordinate, error) in
            guard let self = self else { return }
            guard error == nil else { return }
            guard coordinate != nil else { return }
            //creation announce une fois les coordonnées recupérées
            self.createAnnounce()
            self.announceEdit.addData(announce: self.announceEdit.announce)
            //self.announceEdit.addSemaine(semaine: semaine, idDocument: idAnnounce)
            self.reinitView()
        }
    }
    private func createAnnounce() {
        guard
            let title = titleAnnounceTextField.text,
            let description = descriptionAnnounceTextField.text,
            let price = priceAnnounceTextField.text else {
                self.presentAlert(title: "Attention", message: "Tout les champs ne sont pas remplis")
                return
        }
        let tel = switchTelIsClicked()
        announceEdit.createAnnounce(title: title, description: description, price: price, tel: tel, day: momentDaySwitch(diurneSwitch), night: momentDaySwitch(nocturneSwitch))
    }
    
    func reinitView() {
        titleAnnounceTextField.text? = ""
        descriptionAnnounceTextField.text? = ""
        priceAnnounceTextField.text = ""
    }
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
