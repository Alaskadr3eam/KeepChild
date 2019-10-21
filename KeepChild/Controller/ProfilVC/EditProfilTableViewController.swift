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
    var profilGestion = ProfilGestion()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem?.tintColor = Constants.Color.titleNavBar
        self.navigationItem.leftBarButtonItem?.tintColor = Constants.Color.titleNavBar
        Constants.configureTilteTextNavigationBar(view: self, title: .editProfil)
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: -Action Func
    @objc func imageIsTapped(_ sender: UITapGestureRecognizer) {
        pictureProfil.contentMode = .scaleAspectFit
        pickPicture()
    }

    @IBAction func saveNewProfil(_ sender: Any) {
        textFieldIsEmpty()
        if pictureProfil.image == Constants.Image.addUser {
            saveProfilNoPicture()
        } else {
            saveProfilWithPicture()
        }
        navigationController?.popViewController(animated: true)
    }
    @objc func saveProfilUser() {
        textFieldIsEmpty()
        if pictureProfil.image == Constants.Image.addUser {
            saveProfilNoPicture()
        } else {
            saveProfilWithPicture()
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func updateProfilButton() {
        textFieldIsEmpty()
        let update: [String: Any] = [
            "name": nameTextField.text as Any,
            "prenom": prenomTextField.text as Any,
            "telInt": Int(telTextField.text!) as Any,
            "pseudo": pseudoTextField.text as Any,
            "idUser": profilGestion.idUser as Any,
            "postalCode": profilGestion.postalCode,
            "ville": profilGestion.city
        ]
        guard let documentID = CurrentUserManager.shared.profil.id else { return }
        updateProfil(collection: "ProfilUser", documentID: documentID, update: update)
        retrieveProfil()
    }

    //MARK: -View Func
    //choice button save or update
    private func buttonNavigation() {
        if CurrentUserManager.shared.profil == nil {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveProfilUser))
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
    private func textFieldIsEmpty() -> Void {
        let title = "Attention"
        if nameTextField.text?.isEmpty == true {
            let message = "Champs du nom non remplie. Il faut que tout les champs soit renseignés."
            return self.presentAlert(title: title, message: message)
        }
        if prenomTextField.text?.isEmpty == true {
            let message = "Champs du prénom non remplie. Il faut que tout les champs soit renseignés."
            return self.presentAlert(title: title, message: message)
        }
        if telTextField.text?.isEmpty == true {
            let message = "Champs du téléphone non remplie. Il faut que tout les champs soit renseignés."
            return self.presentAlert(title: title, message: message)
        }
        if pseudoTextField.text?.isEmpty == true {
            let message = "Champs du pseudo non remplie. Il faut que tout les champs soit renseignés."
            return self.presentAlert(title: title, message: message)
        }
        if cityTextField.text?.isEmpty == true {
            let message = "Champs de la ville non remplie. Il faut que tout les champs soit renseignés."
            return self.presentAlert(title: title, message: message)
        }
        if postalCodeTextField.text?.isEmpty == true {
            let message = "Champs du code postal non remplie. Il faut que tout les champs soit renseignés."
            return self.presentAlert(title: title, message: message)
        }
    }
    private func createProfilUser() -> ProfilUser? {
        guard let name = nameTextField.text else { return nil }
        guard let prenom = prenomTextField.text else { return nil }
        guard let tel = telTextField.text else { return nil }
        guard let telInt = Int(tel) else { return nil }
        guard let pseudo = pseudoTextField.text else { return nil }
        guard let city = cityTextField.text else { return nil }
        guard let postalCode = postalCodeTextField.text else { return nil }
        let idUser = CurrentUserManager.shared.user.senderId
        let email = CurrentUserManager.shared.user.email
        
        return ProfilUser(id:"",iDuser: idUser, nom: name, prenom: prenom, pseudo: pseudo,mail: email, tel: telInt, postalCode: postalCode, city: city)
    }
    
    private func uploadPictureProfil() {
        guard let pictureDataCompress = pictureProfil.image?.jpeg(.lowest) else { print("rror save picture"); return }
        profilGestion.uploadPhotoProfil(imageData: pictureDataCompress) { (error, data) in
            guard error == nil else { return }
            guard data != nil else { return }
        }
    }

    private func updateProfil(collection: String, documentID: String, update: [String:Any]) {
        profilGestion.updateProfil(documentID: documentID, update: update) { (bool) in
            guard bool == true else {
                self.presentAlert(title: "Attention", message: "Une erreur s'est produite, vérifiez votre connexion internet. Si le problème persiste contactez le développeur")
                return
            }
            self.presentAlert(title: "Félicitation", message: "Profil mise à jour.")
        }
      /*  profilGestion.updateProfil(collection: collection, documentID: documentID, update: update) { (error, bool) in
            guard error == nil else { return }
            guard bool != nil else { return }
        }*/
    }
    private func retrieveProfil() {
         CurrentUserManager.shared.profil = nil
        let idUser = CurrentUserManager.shared.user.senderId
        DependencyInjection.shared.dataManager.retrieveProfilUser(field: "iDuser", equal: idUser) { [weak self] (error, profilUser) in
            guard let self = self else { return }
            guard error == nil else { return }
            guard let profil = profilUser else {
                self.performSegue(withIdentifier: "EditProfil", sender: nil)
                return }
            CurrentUserManager.shared.addProfil(profilUser: profil[0])
            self.dismiss(animated: true, completion: nil)
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
        //uploadPictureProfil()
        //dismiss(animated: true, completion: nil)
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
        //profilGestion.addDataProfil(profil: profilUserSave)
        //dismiss(animated: true, completion: nil)
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



