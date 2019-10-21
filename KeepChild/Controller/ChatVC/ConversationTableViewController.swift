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
        Constants.configureTilteTextNavigationBar(view: self, title: .conversation)
        tableView.setBackgroundView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestConversation()
    }

    private func requestConversation() {
        requestIdUser1()
    }
    
    private func requestIdUser1() {
        manageConversation.arrayConversation.removeAll()
        manageConversation.retrieveConversion(field: "idUser1") { [weak self] (error, bool) in
            guard let self = self, error == nil else { return }
            self.requestIdUser2()
        }
    }
    
    private func requestIdUser2() {
        manageConversation.retrieveConversion(field: "idUser2") { [weak self] (error, bool) in
            guard let self = self, error == nil else { return }
            self.tableViewIsEmpty()
        }
    }

     private func tableViewIsEmpty() {
        if manageConversation.arrayConversation.count == 0 {
            //if no conversation -> display message
            self.tableView.setEmptyMessage("Aucune conversation en cours pour le moment.", messageEnd: "", imageName: "smileyContent")
        } else {
            self.tableView.reloadData()
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if manageConversation.arrayMessage.count == nil {
            return 0
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return manageConversation.arrayConversation.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = manageConversation.arrayConversation[indexPath.row].name
        if let messageArray = manageConversation.arrayConversation[indexPath.row].arrayMessage {
            if let lastMessage = messageArray.last {
                cell.detailTextLabel?.text = (lastMessage["message"] as! String)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = Constants.Color.bleu
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       manageConversation.conversation = manageConversation.arrayConversation[indexPath.row]
        let vc = MessageViewController(conversation: manageConversation.conversation)
        navigationController?.pushViewController(vc, animated: true)
       // performSegue(withIdentifier: "Chat", sender: nil)
    }

}
