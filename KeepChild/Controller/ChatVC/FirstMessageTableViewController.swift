//
//  FirstMessageTableViewController.swift
//  KeepChild
//
//  Created by Clément Martin on 02/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import CodableFirebase
import MessageKit

class FirstMessageTableViewController: UITableViewController {
    //MARK: - Properties
    @IBOutlet weak var messageTxt: UITextView!

   // var manageFireBase = ManageFireBase()
    var idAnnounceUser = String()
    var arrayMessage = [Message]()
    var arrayMessageRep = [[String: Any]]()
    var announce: Announce!
    
    var isExisting: Bool = false
    var documentID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTxt.delegate = self
        //navItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(validateMessage1))
        customTextViewPlaceholder(textView: messageTxt)
        documentID = CurrentUserManager.shared.user.senderId + idAnnounceUser + announce.id!
        readConversation(documentID: documentID)
    }

    // MARK: -Action Func
    @objc func validateMessage1() {
        if textViewIsEmpty() == true {
            let message = Message(text: messageTxt.text, user: CurrentUserManager.shared.user)
            arrayMessageRep.append(message.representation)
            arrayMessage.append(message)
            let conversation = Conversation(id: nil, name: announce.title, idUser1: CurrentUserManager.shared.user.senderId, idUser2: idAnnounceUser, arrayMessage: arrayMessageRep)
            if isExisting == true {
                Firestore.firestore().collection("Conversation").document(documentID).updateData(["message" : FieldValue.arrayUnion(arrayMessageRep)])
            } else {
                Firestore.firestore().collection("Conversation").document(documentID).setData(conversation.representation)
            }
            
        }
    }
    @IBAction func validateMessage(_ sender: Any) {
        if textViewIsEmpty() == true {
            let message = Message(text: messageTxt.text, user: CurrentUserManager.shared.user)
            arrayMessageRep.append(message.representation)
            arrayMessage.append(message)
            let conversation = Conversation(id: nil, name: announce.title, idUser1: CurrentUserManager.shared.user.senderId, idUser2: idAnnounceUser, arrayMessage: arrayMessageRep)
            if isExisting == true {
                Firestore.firestore().collection("Conversation").document(documentID).updateData(["message" : FieldValue.arrayUnion(arrayMessageRep)])
            } else {
                Firestore.firestore().collection("Conversation").document(documentID).setData(conversation.representation)
            }
            
        }
    }

    @IBAction func `return`(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    //MARK: - Helpers
    private func readConversation(documentID: String) {
        DependencyInjection.shared.dataManager.readConversation(documentID: documentID) { [weak self] (bool) in
            guard let self = self else { return }
            guard bool == true else {
                return
            }
            self.isExisting = true
        }
        
       /* manageFireBase.readConversation(documentID: documentID) { (bool) in
            guard bool == true else {
                return
            }
            self.isExisting = true
        }*/
    }
    //on verifie que le champs message n'est pas vide
    private func textViewIsEmpty() -> Bool {
        guard let text = messageTxt.text else { return false }
        if text.isEmpty == true || text == "Tapez votre message" || text == " "{
            self.presentAlert(title: "Attention", message: "Votre message est vide")
            return false
        }
        return true
    }
}

extension FirstMessageTableViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Tapez votre message" {
            customTextView(textView: textView)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty == true {
            customTextViewPlaceholder(textView: textView)
        }
    }
    
    func customTextViewPlaceholder(textView: UITextView) {
        textView.text = "Tapez votre message"
        textView.textColor = UIColor.lightGray
        textView.font = UIFont(name: "verdana", size: 13.0)
        textView.returnKeyType = .done
    }
    
    func customTextView(textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.black
        textView.font = UIFont(name: "verdana", size: 18.0)
    }
}
