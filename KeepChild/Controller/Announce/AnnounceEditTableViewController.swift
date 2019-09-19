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

    var announceEdit = AnnounceEdit()

   // var manageFireBase = ManageFireBase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // manageFireBase.idUser = UserDefaults.standard.string(forKey: "userID")!
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveAnnounce))

        
     
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Table view data source


    @objc func saveAnnounce() {
    
        guard let announce = createAnnounce() else { return }
        
        announceEdit.addData(announce: announce)
        //manageFireBase.addData(announce: announce)
        //alert pour dire message annonce sauvegarder ou echec
        reinitView()
    }
    
    private func createAnnounce() -> Announce? {
        guard let idUser = announceEdit.idUser else { return nil }
        let title = titleAnnounceTextField.text!
        let description = descriptionAnnounceTextField.text!
        let price = priceAnnounceTextField.text!
        return Announce(id: nil,idUser: idUser , title: title, description: description, price: price)
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
