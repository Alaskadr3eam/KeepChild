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
    
    var manageConversation = ConversationGestion(firebaseServiceSession: FirebaseService(dataManager: ManagerFirebase()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Constants.configureTilteTextNavigationBar(view: self, title: .firstMessage)
        self.navigationItem.rightBarButtonItem?.tintColor = Constants.Color.titleNavBar
        self.navigationItem.leftBarButtonItem?.tintColor = Constants.Color.titleNavBar
        messageTxt.delegate = self
        customTextViewPlaceholder(textView: messageTxt)
        manageConversation.createOrRetrieveDocumentID()
        manageConversation.readConversation()
    }
    
    // MARK: -Action Func
    @IBAction func validateMessage(_ sender: Any) {
        if textViewIsEmpty() == true {
            manageConversation.prepareSendMessage(text: messageTxt.text)
            //alert mesaage bien envoyé
            self.presentAlertWithActionDismiss(title: "Envoyé", message: "Message envoyé")
        }
    }
    
    @IBAction func `return`(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    //MARK: - Helpers
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
        textView.font = UIFont(name: "verdana", size: 15.0)
    }
}
