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

class ProfilTableViewController: UITableViewController {
    
    @IBOutlet weak var profilView: ProfilView!
    
    var manageFireBase = ManageFireBase()
    var profilGestion = ProfilGestion()
    var announceList = AnnounceList()

    override func viewDidLoad() {
        super.viewDidLoad()
        manageFireBase.delegateManageFirebase = self
        manageFireBase.idUser = UserDefaults.standard.string(forKey: "userID")!

        manageFireBase.queryAnnounceProfil = manageFireBase.createQuery(collection: "Announce2", field: "idUser")//Firestore.firestore().collection("Announce2").whereField("idUser", isEqualTo: manageFireBase.idUser)
        manageFireBase.queryProfil = manageFireBase.createQuery(collection: "ProfilUser", field: "iDuser")


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profilOrNotProfil()
        requestInitProfil()
    }
    //verify if user have a profil
    func profilOrNotProfil() -> Bool {
        
        if manageFireBase.profil == nil {
           // performSegue(withIdentifier: "EditProfil", sender: nil)
            return false
        } else {
            return true
        }
    }
    func requestInitProfil() {
       
            manageFireBase.retrieveProfilUser()
            manageFireBase.retrieveAnnounceUser2()
            //UserDefaults.standard.set(manageFireBase.profil, forKey: "userProfil")
        
       /* manageFireBase.retrieveProfilUser()
        manageFireBase.retrieveAnnounceUser2()*/
    }

    
    @IBAction func logOut() {
        try! Auth.auth().signOut()
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "firstViewController") as! AuthViewController
            // let vc = storyboard.instantiateInitialViewController(withIdentifier: "firstViewController") as! AuthViewController
            self.present(vc, animated: false,completion: nil)
        }
    }
    
    
    func initView() {
        if manageFireBase.profil != nil {
            profilView.pseudoLabel.text = manageFireBase.profil.pseudo
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return manageFireBase.announceProfil.count
        
    }
    
   

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellAnnounce", for: indexPath)
        if manageFireBase.announceProfil.count == 0 {
            return cell
        } else {
        let announce = manageFireBase.announceProfil[indexPath.row]

        cell.textLabel!.text = announce.title
        cell.detailTextLabel!.text = announce.price

        return cell
        }
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        manageFireBase.announceDetail = manageFireBase.announceProfil[indexPath.row]
        performSegue(withIdentifier: "DetailAnnounce", sender: nil)
    }
    
   
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
        if segue.identifier == "EditProfil" {
            if segue.destination is EditProfilTableViewController {
            }
        }
        if segue.identifier == "DetailAnnounce" {
            if let vcDestination = segue.destination as? DetailAnnounceTableViewController {
                vcDestination.manageFireBase.idUser = manageFireBase.idUser
                vcDestination.detailAnnounce.announce = manageFireBase.announceDetail
            }
        }
    }
    

}
extension ProfilTableViewController: ManageFireBaseDelegate {
    func resultForRequestAnnounce(announce: [Announce]) {
     /*   announceProfil = announce*/
        tableView.reloadData()
    }
    
    func resultForRequestProfil(profilUser: ProfilUser) {
        /*profil = profilUser*/
        self.initView()
    }
}
