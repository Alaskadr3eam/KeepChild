//
//  ConversationTableViewController.swift
//  KeepChild
//
//  Created by Clément Martin on 02/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ConversationTableViewController: UITableViewController {
    
    var manageConversation = ManageConversation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestConversation()
    }

    func requestConversation() {
        requestIdUser1()
    }

    func requestIdUser1() {
        manageConversation.arrayConversation.removeAll()
        manageConversation.retrieveConversion(field: "idUser1") { [weak self] (error, bool) in
            guard let self = self else { return }
            guard error == nil else { return }
            guard bool == true else {
                self.requestIdUser2()
                return
            }
            self.requestIdUser2()
        }
    }
    
    func requestIdUser2() {
        manageConversation.retrieveConversion(field: "idUser2") { [weak self] (error, bool) in
            guard let self = self else { return }
            guard error == nil else { return }
            guard bool == true else {
                //if no conversation -> display message
                self.tableViewIsEmpty()
                return
            }
            
            self.tableViewIsEmpty()
        }
    }

    private func tableViewIsEmpty() {
        if manageConversation.arrayConversation.count == 0 {
            //if no conversation -> display message
            self.tableView.setEmptyMessage("Aucune conversation en cours pour le moment.")
        } else {
            self.tableView.reloadData()
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return manageConversation.arrayConversation.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel!.text = manageConversation.arrayConversation[indexPath.row].name

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       manageConversation.conversation = manageConversation.arrayConversation[indexPath.row]
        let vc = MessageViewController(conversation: manageConversation.conversation)
        navigationController?.pushViewController(vc, animated: true)
       // performSegue(withIdentifier: "Chat", sender: nil)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
 /*   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Chat" {
            if let vcDestination = segue.destination as? ChatViewController {
                vcDestination.conversation = conversation
                
            }
        }
    }*/
 

}
