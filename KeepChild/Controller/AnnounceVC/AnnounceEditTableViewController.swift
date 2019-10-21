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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveAnnounce))
        Constants.configureTilteTextNavigationBar(view: self, title: .editAnnounce)
        self.navigationItem.rightBarButtonItem?.tintColor = Constants.Color.titleNavBar
        customTextViewPlaceholder(textView: descriptionTextView)
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
    
    @IBAction func switchDiurneTapped(sender: UISwitch) {
        if sender.isOn {
        } else {
            if nocturneSwitch.isOn == false {
                nocturneSwitch.setOn(true, animated: true)
            }
        }
    }
    @IBAction func switchNocturneTapped(sender: UISwitch) {
        if sender.isOn {
        } else {
            if diurneSwitch.isOn == false {
                diurneSwitch.setOn(true, animated: true)
            }
        }
    }

    //MARK: -View Func
    
    private func initView() {
        titleAnnounceTextField.text? = ""
        customTextViewPlaceholder(textView: descriptionTextView)
        priceAnnounceTextField.text = ""
    }

    //MARK: -Helpers Func
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
            //remove UserDefault "semaine"
            self.announceEdit.removeUserDefaultObject(forkey: "semaine")
            //storage announce
            self.addAnnounceInFirebase()
        }
    }

    //request for addAnnounce in firebase
    private func addAnnounceInFirebase() {
        announceEdit.addData(announce: self.announceEdit.announce) { [weak self] (bool) in
            guard let self = self else { return }
            guard bool == true else {
                self.presentAlert(title: "Annonce non envoyé", message: "Désolé, votre annonce n'a pas pu etre sauvegardée. Vérifiez votre connexion internet. Si le problème persiste contactez le développeur.")
                return
            }
            self.presentAlertWithActionSegue(title: "Annonce envoyé", message: "Félicitation, votre annonce a été enregistré.", withIdentifier: Constants.Segue.segueProfil)
            self.initView()
            //self.performSegue(withIdentifier: Constants.Segue.segueProfil, sender: nil)
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
            return true
        } else {
            return false
        }
    }

    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.segueProfil {
            if segue.destination is ProfilTableViewController {
            }
        }
    }

}

extension AnnounceEditTableViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Tapez votre description" {
            customTextView(textView: textView)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty == true {
            customTextViewPlaceholder(textView: textView)
        }
    }
    
    func customTextViewPlaceholder(textView: UITextView) {
        textView.text = "Tapez votre description"
        textView.textColor = Constants.Color.placeHolder
        textView.font = Constants.FontText.editText
        textView.returnKeyType = .done
    }
    
    func customTextView(textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.black
        textView.font = Constants.FontText.editText
    }
}

extension AnnounceEditTableViewController: AnnounceEditDelegate {
    func alert(_ title: String, _ message: String) {
        self.presentAlert(title: title, message: message)
    }
    
    
}
