//
//  DetailAnnounceTableViewController.swift
//  KeepChild
//
//  Created by Clément Martin on 17/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth
import FirebaseFirestore
import CodableFirebase

class DetailAnnounceTableViewController: UITableViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cpLabel: UILabel!
    @IBOutlet weak var locMapKit: MKMapView!
    @IBOutlet weak var pseudoLabel: UILabel!
    @IBOutlet weak var modifyButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var detailAnnounce = DetailAnnounce()
    var profilGestion = ProfilGestion()
    
    //var manageFireBase = ManageFireBase()

    //var userId = String()
    //var profil: ProfilUser!

    override func viewDidLoad() {
        super.viewDidLoad()
        //manageFireBase.delegateManageFireBaseDetailAnnounce = self
        //profilGestion.delegateProfilGestion = self
        //manageFireBase.idUser = UserDefaults.standard.string(forKey: "userID")!
        
       // manageFireBase.queryProfil = manageFireBase.createQuery(collection: "ProfilUser", field: "iDuser")
        
        //retrieveProfilUser()
        //retrieveProfilUser()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        request()
    }
    func request() {
       // guard let idUser = detailAnnounce.idUser else { return }
        let idUser = detailAnnounce.announce.idUser
        detailAnnounce.retrieveProfilUser(collection: "ProfilUser", field: "iDuser", equal: idUser) { [weak self] (error, profilUser) in
            guard let self = self else { return }
            guard error == nil else { return }
            guard profilUser != nil else { return }
            self.initView()
        }
    }
    // MARK: - Table view data source

    func initView() {
        let announce = detailAnnounce.announce
        titleLabel.text = announce?.title
        priceLabel.text = announce?.price
        descriptionLabel.text = announce?.description
        pseudoLabel.text = detailAnnounce.profil.pseudo
    }
    
    @IBAction func deleteAnnounce() {
        if detailAnnounce.idUser == detailAnnounce.announce.idUser {
        detailAnnounce.deleteAnnounce(announceId: detailAnnounce.announce.id!)
        }
    }
    
  /* func retrieveProfilUser() {
        let idUserAnnouce = detailAnnounce.announce.idUser
        Firestore.firestore().collection("ProfilUser").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("erreur : \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let profil = try! FirestoreDecoder().decode(ProfilUser.self, from: document.data())
                    self.profilGestion.arrayProfil.append(profil)
                    print(document.documentID, document.data())
                    
                }
                for profil in self.profilGestion.arrayProfil {
                    if profil.iDuser == idUserAnnouce {
                        self.profil = profil
                    }
                }
                self.initView()
            }
        }
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
/*extension DetailAnnounceTableViewController: ProfilGestionDelegate {
    func initViewEditProfil() {
    }
    
    func initViewDetailAnnounce() {
        initView()
    }
    
    
}*/
