//
//  AnnounceSearchTableViewController.swift
//  KeepChild
//
//  Created by Clément Martin on 13/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit
import Firebase


class AnnounceSearchTableViewController: UITableViewController {

    var announceList = AnnounceList()
    var manageFireBase = ManageFireBase()

    override func viewDidLoad() {
        super.viewDidLoad()
        manageFireBase.delegateManageFireBaseAnnounceSearch = self
        announceList.delegateAnnounceList = self
        manageFireBase.queryAnnounceAll = manageFireBase.createQueryAll(collection: "Announce2")
       // announceList.observeQuery()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         manageFireBase.readDataAnnounce()
        //announceList.readData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return manageFireBase.announceListData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let announce = manageFireBase.announceListData[indexPath.row]
        cell.textLabel!.text = announce.title
       // cell.detailTextLabel!.text = announce.description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        announceList.announce = manageFireBase.announceListData[indexPath.row]
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
        if segue.identifier == "DetailAnnounce" {
            if let vcDestination = segue.destination as? DetailAnnounceTableViewController {
                vcDestination.manageFireBase.idUser = announceList.announce.idUser
                vcDestination.detailAnnounce.announce = announceList.announce
            }
        }
    }
    

}
extension AnnounceSearchTableViewController: AnnounceListDelegate {
    func updateTableView() {
        tableView.reloadData()
    }
}

extension AnnounceSearchTableViewController: ManageFireBaseDelegateAnnounceSearch {
    func resultForRequestAnnounceSearch() {
        tableView.reloadData()
    }
}
