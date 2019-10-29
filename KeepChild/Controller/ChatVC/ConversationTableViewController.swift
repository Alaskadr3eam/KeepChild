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
    @IBOutlet weak var conversationTableView: CustomTableView!
    //MARK: - Properties
    var manageConversation = ConversationManager(firebaseServiceSession: FirebaseService(dataManager: ManagerFirebase()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Constants.configureTilteTextNavigationBar(view: self, title: .conversation)
        tableView.setBackgroundView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestConversation()
        
    }
    //MARK: - Func Request
    private func requestConversation() {
        conversationTableView.setLoadingScreen()
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
    //MARK: - Func Helpers
    private func tableViewIsEmpty() {
        if manageConversation.arrayConversation.count == 0 {
            //if no conversation -> display message
            self.tableView.setEmptyMessage("Aucune conversation en cours pour le moment.", messageEnd: "", imageName: "smileyContent")
        } else {
            self.tableView.reloadData()
        }
        conversationTableView.removeLoadingScreen()
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
       /* if manageConversation.arrayMessage.count == 0 {
            return 0
        } else {*/
            return 1
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return manageConversation.arrayConversation.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let label = cell.textLabel else { return cell }
        label.text = manageConversation.arrayConversation[indexPath.row].name
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
        guard let conversationSecure = manageConversation.conversation else { return }
        let vc = MessageViewController(conversation: conversationSecure)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        requestConversation()
        tableView.scroll(to: .top, animated: true)
    }
}

extension UITableView {
    
    public func reloadData(_ completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion:{ _ in
            completion()
        })
    }
    
    func scroll(to: scrollsTo, animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
            switch to{
            case .top:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.scrollToRow(at: indexPath, at: .top, animated: animated)
                }
                break
            case .bottom:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                    self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
                }
                break
            }
        }
    }
    
    enum scrollsTo {
        case top,bottom
    }
}
