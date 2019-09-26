//
//  EditProfilTableViewController.swift
//  KeepChild
//
//  Created by Clément Martin on 17/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import CodableFirebase
import FirebaseStorage
import CoreLocation

class EditProfilTableViewController: UITableViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var prenomTextField: UITextField!
    @IBOutlet weak var pseudoTextField: UITextField!
    @IBOutlet weak var telTextField: UITextField!
    @IBOutlet weak var pictureProfil: CustomImageView!

    @IBOutlet weak var editProfilTableView: CustomTableView!
    let locationManager = CLLocationManager()
    
    var profilGestion = ProfilGestion()
    
    var isSelected = false
    
    func locIsOkOrNot() {
        if profilGestion.lat != nil && profilGestion.long != nil {
            isSelected = true
            tableView.reloadData()
        }
        isSelected = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initTapGestureForAddPicture()
        buttonNavigation()
   
        profilGestion.decodeProfilSaved()
        initView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locIsOkOrNot()
    }
    //func for retrieve location user.
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            guard let lat = locationManager.location?.coordinate.latitude else { return }
            guard let long = locationManager.location?.coordinate.longitude else { return }
            profilGestion.lat = lat
            profilGestion.long = long
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    //choice button save or update
    private func buttonNavigation() {
        if profilGestion.profil == nil {
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
    
    @objc func imageIsTapped(_ sender: UITapGestureRecognizer) {
        pictureProfil.contentMode = .scaleAspectFit
        pickPicture()
    }

    private func initView() {
        guard let profil = profilGestion.profil else { return }
        nameTextField.text = profil.nom
        prenomTextField.text = profil.prenom
        telTextField.text = String(profil.tel)
        pseudoTextField.text = profil.pseudo
        pictureProfil.downloadCustom(idUserImage: profil.iDuser, contentMode: .scaleToFill)
        buttonNavigation()
        
    }
    
    private func createProfilUser() -> ProfilUser? {
        guard let name = nameTextField.text else { return nil }
        guard let prenom = prenomTextField.text else { return nil }
        guard let tel = telTextField.text else { return nil }
        guard let telInt = Int(tel) else { return nil }
        guard let pseudo = pseudoTextField.text else { return nil }
        let idUser = CurrentUserManager.shared.user.id
        let postalCode = profilGestion.postalCode
        let city = profilGestion.city
        let email = CurrentUserManager.shared.user.email
        
        return ProfilUser(id:"",iDuser: idUser, nom: name, prenom: prenom, pseudo: pseudo,mail: email, tel: telInt, postalCode: postalCode, city: city/*, coordinate: coordinate*/ )
    }
    
    private func uploadPictureProfil() {
        guard let pictureDataCompress = pictureProfil.image?.jpeg(.low) else { print("rror save picture"); return }
        profilGestion.uploadPhotoProfil(imageData: pictureDataCompress) { (error, data) in
            guard error == nil else { return }
            guard data != nil else { return }
        }
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
       // let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        if indexPath.row == 5 {
            cellAdresseListenner()
        }
        if indexPath.row == 4 {
            checkLocationAuthorizationStatus()
            locIsOkOrNot()
            //isSelected = true
            //editProfilTableView.geoLocCell.accessoryView!.isHidden = false
        //    cell.accessoryView?.isHidden = true
        }
        //...
    }

    func cellAdresseListenner() {

        let alert = UIAlertController(title: "Register", message: "Register", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let postalCodeFiel = alert.textFields![0].text else { return }
            guard let cityField = alert.textFields![1].text else { return }
            
            self.profilGestion.postalCode = postalCodeFiel
            self.profilGestion.city = cityField
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField { (textEmail) in
            textEmail.placeholder = "Enter your Postal Code"
        }
        alert.addTextField { (textPassword) in
            textPassword.placeholder = "Enter your city"
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func updateProfil(collection: String, documentID: String, update: [String:Any]) {
        profilGestion.updateProfil(collection: collection, documentID: documentID, update: update) { (error, bool) in
            guard error == nil else { return }
            guard bool != nil else { return }
        }
    }
    
    private func saveProfilWithPicture() {
        guard let profilUserSave = createProfilUser() else { return }
        profilGestion.addDataProfil(profil: profilUserSave)
        uploadPictureProfil()
        dismiss(animated: true, completion: nil)
    }

    private func saveProfilNoPicture() {
        guard let profilUserSave = createProfilUser() else { return }
        profilGestion.addDataProfil(profil: profilUserSave)
        dismiss(animated: true, completion: nil)
    }
   
    @objc func saveProfilUser() {
        if pictureProfil.image == UIImage(named: "addUser") {
            saveProfilNoPicture()
        } else {
            saveProfilWithPicture()
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func updateProfilButton() {
        let update: [String: Any] = [
            "name": nameTextField.text as Any,
            "prenom": prenomTextField.text as Any,
            "telInt": Int(telTextField.text!) as Any,
            "pseudo": pseudoTextField.text as Any,
            "idUser": profilGestion.idUser as Any,
            "postalCode": profilGestion.postalCode,
            "ville": profilGestion.city
        ]
        guard let documentID = profilGestion.profil.id else { return }
        updateProfil(collection: "ProfilUser", documentID: documentID, update: update)
    }

  
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
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
        
        //imgForCoreData = UIImagePN
        dismiss(animated: true, completion: nil)
       
        
    }
}
/*extension EditProfilTableViewController: ProfilGestionDelegate {
    func initViewDetailAnnounce() {

    }
    
    func initViewEditProfil() {
       // initView()
    }
    
    
}*/


