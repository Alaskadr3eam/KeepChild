//
//  EditProfilTableViewController.swift
//  KeepChild
//
//  Created by Clément Martin on 17/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit

class EditProfilTableViewController: UITableViewController {
    
    //MARK: -Properties Outlet
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var prenomTextField: UITextField!
    @IBOutlet weak var pseudoTextField: UITextField!
    @IBOutlet weak var telTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var pictureProfil: CustomImageView!
    @IBOutlet weak var editProfilTableView: CustomTableView!
    @IBOutlet weak var saveButtonEdit: UIBarButtonItem!
    //MARK: -Propertie model
    var profilGestion = ProfilGestion(firebaseServiceSession: FirebaseService(dataManager: ManagerFirebase()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem?.tintColor = Constants.Color.titleNavBar
        self.navigationItem.leftBarButtonItem?.tintColor = Constants.Color.titleNavBar
        Constants.configureTilteTextNavigationBar(view: self, title: .editProfil)
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initView()
    }
    
    //MARK: -Action Func
    @objc func imageIsTapped(_ sender: UITapGestureRecognizer) {
        pictureProfil.contentMode = .scaleAspectFit
        pickPicture()
    }
    
    @IBAction func saveNewProfil(_ sender: Any) {
        switch textFieldIsEmpty() {
        case .accepted:
            (pictureProfil.image == Constants.Image.addUser) ? saveProfilNoPicture() : saveProfilWithPicture()
            navigationController?.popViewController(animated: true)
        case .rejeted(let error):
            self.presentAlert(title: "", message: error)
        }
    }
    
    @objc func updateProfilButton() {
        switch textFieldIsEmpty() {
        case .accepted:
            let update: [String: Any] = [
                "nom": nameTextField.text as Any,
                "prenom": prenomTextField.text as Any,
                "tel": telTextField.text as Any,
                "pseudo": pseudoTextField.text as Any,
                "iDuser": CurrentUserManager.shared.user.senderId as Any,
                "postalCode": postalCodeTextField.text as Any,
                "city": cityTextField.text as Any
            ]
            guard let documentID = CurrentUserManager.shared.profil.id else { return }
            if pictureProfil.image == Constants.Image.defaultImage {
                updateProfilNoPicture(collection: "ProfilUser", documentID: documentID, update: update)
            } else {
                updateProfilWithPicture(collection: "ProfilUser", documentID: documentID, update: update)
            }
            retrieveProfil()
        case .rejeted(let error):
            self.presentAlert(title: "", message: error)
        }
        
    }
    //MARK: -View Func
    //choice button save or update
    private func buttonNavigation() {
        if CurrentUserManager.shared.profil == nil {
            /* self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveProfilUser))*/
        } else {
            let updateButton = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(updateProfilButton))
            updateButton.tintColor = UIColor.white
            self.navigationItem.rightBarButtonItem = updateButton
        }
    }
    //func init tap gesture for add photo
    private func initTapGestureForAddPicture(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageIsTapped(_ :)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        pictureProfil.isUserInteractionEnabled = true
        pictureProfil.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func initView() {
        initTapGestureForAddPicture()
        guard let profil = CurrentUserManager.shared.profil else { return }
        nameTextField.text = profil.nom
        prenomTextField.text = profil.prenom
        telTextField.text = String(profil.tel)
        pseudoTextField.text = profil.pseudo
        cityTextField.text = profil.city
        postalCodeTextField.text = profil.postalCode
        pictureProfil.downloadCustom(idUserImage: profil.iDuser, contentMode: .scaleToFill)
        buttonNavigation()
    }
    
    //MARK: -Helpers Func
    private func textFieldIsEmpty() -> FromError {
        if nameTextField.text?.isEmpty == true {
            return .rejeted(NSLocalizedString("Champs nom non renseigné", comment: ""))
        }
        if prenomTextField.text?.isEmpty == true {
            return .rejeted(NSLocalizedString("Champs prénom non renseigné", comment: ""))
        }
        guard let tel = telTextField.text else { return .rejeted("erreur textfield") }
        if tel.count != 10 {
            return .rejeted(NSLocalizedString("Le numéro de téléphone doit contenir 10 chiffres", comment: ""))
        }
        if pseudoTextField.text?.isEmpty == true {
            return .rejeted(NSLocalizedString("Le pseudo doit ètre renseigné.", comment: ""))
        }
        if cityTextField.text?.isEmpty == true {
            return .rejeted(NSLocalizedString("La ville doit ètre renseigné.", comment: ""))
        }
        if postalCodeTextField.text?.isEmpty == true {
            return .rejeted(NSLocalizedString("Le code postal doit ètre renseigné.", comment: ""))
        }
        return .accepted
    }
    
    private func createProfilUser() -> ProfilUser? {
        guard let name = nameTextField.text else { return nil }
        guard let prenom = prenomTextField.text else { return nil }
        guard let tel = telTextField.text else { return nil }
        guard let pseudo = pseudoTextField.text else { return nil }
        guard let city = cityTextField.text else { return nil }
        guard let postalCode = postalCodeTextField.text else { return nil }
        let idUser = CurrentUserManager.shared.user.senderId
        let email = CurrentUserManager.shared.user.email
        
        return ProfilUser(id:"",iDuser: idUser, nom: name, prenom: prenom, pseudo: pseudo,mail: email, tel: tel, postalCode: postalCode, city: city)
    }
    //MARK: - Func Request
    private func uploadPictureProfil() {
        guard let pictureDataCompress = pictureProfil.image?.jpeg(.lowest) else { print("rror save picture"); return }
        profilGestion.uploadPhotoProfil(imageData: pictureDataCompress) { (error, data) in
            guard error == nil else { return }
            guard data != nil else { return }
        }
    }
    
    private func updateProfilWithPicture(collection: String, documentID: String, update: [String:Any]) {
        profilGestion.updateProfil(documentID: documentID, update: update) { (bool) in
            guard bool == true else {
                self.presentAlert(title: "Attention", message: "Une erreur s'est produite, vérifiez votre connexion internet. Si le problème persiste contactez le développeur")
                return
            }
            self.presentAlertWithActionNavPop(title: "Félicitation", message: "Profil mise à jour.")
            self.uploadPictureProfil()
        }
    }
    
    private func updateProfilNoPicture(collection: String, documentID: String, update: [String:Any]) {
        profilGestion.updateProfil(documentID: documentID, update: update) { (bool) in
            guard bool == true else {
                self.presentAlert(title: "Attention", message: "Une erreur s'est produite, vérifiez votre connexion internet. Si le problème persiste contactez le développeur")
                return
            }
            self.presentAlertWithActionNavPop(title: "Félicitation", message: "Profil mise à jour.")
        }
    }
    
    private func retrieveProfil() {
        let idUser = CurrentUserManager.shared.user.senderId
        profilGestion.retrieveProfilUser(field: "iDuser", equal: idUser) { [weak self] (error,bool) in
            guard let self = self else { return }
            guard error == nil, bool == true else {
                self.presentAlertWithActionNavPop(title: "Erreur", message: "Vérifier votre connexion, si le problème persiste contactez l'administrateur.")
                return }
        }
    }
    
    
    private func saveProfilWithPicture() {
        guard let profilUserSave = createProfilUser() else { return }
        profilGestion.addDataProfil(profil: profilUserSave) { [weak self] (bool) in
            guard let self = self else { return }
            guard bool == true else {
                self.presentAlertWithActionDismiss(title: "Attention", message: "Une erreur s'est produite, vérifiez votre connexion internet. Si le problème persiste contactez le développeur")
                return
            }
            self.presentAlertWithActionDismiss(title: "Félicitation", message: "Profil enregistré.")
            self.uploadPictureProfil()
        }
    }
    
    private func saveProfilNoPicture() {
        guard let profilUserSave = createProfilUser() else { return }
        profilGestion.addDataProfil(profil: profilUserSave) { (bool) in
            guard bool == true else {
                self.presentAlertWithActionDismiss(title: "Attention", message: "Une erreur s'est produite, vérifiez votre connexion internet. Si le problème persiste contactez le développeur")
                return
            }
            self.presentAlertWithActionDismiss(title: "Félicitation", message: "Profil enregistré.")
        }
    }
    //MARK: -TableView func
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.view
    }
}

extension EditProfilTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func pickPicture(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let actionsheet = UIAlertController(title: "Add Your Picture", message: "Choose option", preferredStyle: .actionSheet)
        actionsheet.addAction(UIAlertAction(title: "Library", style: .default, handler: { (action:UIAlertAction) in imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionsheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let imagePicker = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        pictureProfil.image = imagePicker
        
        dismiss(animated: true, completion: nil)
    }
}

extension EditProfilTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


