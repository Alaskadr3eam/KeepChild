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

    var manageFireBase = ManageFireBase()
    
    var arrayConversation = [Conversation]()

    var arrayMessage = [Message2]()
    
    var conversation: Conversation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestInit()
    }
    func requestInit() {
        requestIdUser1()
    }
    func requestIdUser1() {
        arrayConversation.removeAll()
        manageFireBase.retrieveConversationUser(field: "idUser1") { [weak self] (error, conversation) in
            guard let self = self else { return }
            guard error == nil else { return }
            guard conversation != nil else {
                self.requestIdUser2()
                return }
            guard let resulConv = conversation else { return }
            self.arrayConversation = resulConv
            self.requestIdUser2()
        }
    }
    
    func requestIdUser2() {
        manageFireBase.retrieveConversationUser(field: "idUser2") { [weak self] (error, conversation) in
            guard let self = self else { return }
            guard error == nil else { return }
            guard conversation != nil else {
                //if no conversation -> display message
                self.tableViewIsEmpty()
                 //self.tableView.reloadData()
                return }
            guard let resulConv = conversation else { return }
            for conv in resulConv {
                self.arrayConversation.append(conv)
            }
            self.tableViewIsEmpty()
            
        }
    }

    private func tableViewIsEmpty() {
        if self.arrayConversation.count == 0 {
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
        return arrayConversation.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel!.text = arrayConversation[indexPath.row].name

        return cell
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       conversation = arrayConversation[indexPath.row]
        let vc = MessageViewController(conversation: conversation)
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
