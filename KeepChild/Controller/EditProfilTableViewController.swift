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

class EditProfilTableViewController: UITableViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var prenomTextField: UITextField!
    @IBOutlet weak var pseudoTextField: UITextField!
    @IBOutlet weak var telTextField: UITextField!
    @IBOutlet weak var pictureProfil: UIImageView!

    
 
    var profilGestion = ProfilGestion()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        initTapGestureForAddPicture()
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveProfilUser))
   
        request()

        
    }

    func request() {
        guard let idUser = profilGestion.idUser else { return }
        profilGestion.retrieveProfilUser2(collection: "ProfilUser", field: "iDuser", equal: idUser) { [weak self] (error,profilUser) in
            guard let self = self else { return }
            guard error == nil else { return }
            guard profilUser != nil else { return }
            self.initView()
        }
    }

    func initTapGestureForAddPicture(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageIsTapped(_ :)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        pictureProfil.isUserInteractionEnabled = true
        pictureProfil.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageIsTapped(_ sender: UITapGestureRecognizer) {
        pictureProfil.contentMode = .scaleAspectFit
        //selectedImage = view.image
        pickPicture()
    }

    func initView() {
        let profil = profilGestion.profil
        if profil != nil {
            nameTextField.text = profil!.nom
            prenomTextField.text = profil!.prenom
            telTextField.text = String(profil!.tel)
            pseudoTextField.text = profil!.pseudo
        }
    }
    
    func createProfilUser() {
    /*    guard let name = nameTextField.text else { return }
        guard let prenom = prenomTextField.text else { return }
        guard let tel = telTextField.text else { return }
        guard let telInt = Int(tel) else { return }
        guard let pseudo = pseudoTextField.text else { return }
        guard let idUser = profilGestion.idUser else { return }
        
       let profilUserSave = ProfilUser(iDuser: idUser, nom: name, prenom: prenom, pseudo: pseudo, tel: telInt)
    
    let docData = try! FirestoreEncoder().encode(profilUserSave)
    Firestore.firestore().collection("ProfilUser").addDocument(data: docData) { error in
    if let error = error {
    print("Error writing document: \(error)")
    } else {
    print("Document successfully written!")
    }
    }*/
        
        guard let pictureDataCompress = pictureProfil.image?.jpeg(.low) else { print("rror save picture"); return }
        profilGestion.uploadPhotoProfil(imageData: pictureDataCompress) { (error, data) in
            guard error == nil else { return }
            guard data != nil else { return }
        }
    //uploadProfileImage(imageData: pictureProfilData!)
    }
    
    
   
    @objc func saveProfilUser() {
        createProfilUser()
    }

  /*  func uploadProfileImage(imageData: Data) {
        /*let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
         activityIndicator.startAnimating()
         activityIndicator.center = self.view.center
         self.view.addSubview(activityIndicator)*/
        
        
        let storageReference = Storage.storage().reference()
        let currentUser = Auth.auth().currentUser
        let profileImageRef = storageReference.child("usersProfil").child(currentUser!.uid).child("\(currentUser!.uid)-profileImage.jpg")
        
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        profileImageRef.putData(imageData, metadata: uploadMetaData) { (uploadedImageMeta, error) in
            
            // activityIndicator.stopAnimating()
            // activityIndicator.removeFromSuperview()
            
            if error != nil
            {
                print("Error took place \(String(describing: error?.localizedDescription))")
                return
            } else {
                
                //self.userProfileImageView.image = UIImage(data: imageData)
                
                print("Meta data of uploaded image \(String(describing: uploadedImageMeta))")
            }
        }
    }*/
    // MARK: - Table view data source



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

    
    // MARK: - Navigation

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


