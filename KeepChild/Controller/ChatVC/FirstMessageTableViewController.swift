//
//  FirstMessageTableViewController.swift
//  KeepChild
//
//  Created by Clément Martin on 02/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase
import MessageKit

class FirstMessageTableViewController: UITableViewController {

    @IBOutlet weak var messageTxt: UITextView!
    var manageFireBase = ManageFireBase()
    var idAnnounceUser = String()
    var arrayMessage = [Message]()
    var arrayMessageRep = [[String: Any]]()
    var announce: Announce!
    
    var isExisting: Bool = false
    var documentID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTxt.delegate = self
        
        customTextViewPlaceholder(textView: messageTxt)
        //customTextView(textView: messageTxt)
        
        documentID = CurrentUserManager.shared.user.senderId + idAnnounceUser + announce.id!
        readConversation(documentID: documentID)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func readConversation(documentID: String) {
        manageFireBase.readConversation(documentID: documentID) { (bool) in
            guard bool == true else {
                return
            }
            self.isExisting = true
        }
    }

    // MARK: -Action Func
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
    //on verifie que le champs message n'est pas vide
    private func textViewIsEmpty() -> Bool {
        guard let text = messageTxt.text else { return false }
        if text.isEmpty == true || text == "Tapez votre message" || text == " "{
            self.presentAlert(title: "Attention", message: "Votre message est vide")
            return false
        }
        return true
    }
    
    @IBAction func `return`(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
       
    }

    func getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate) -> String {
        let objDateformat: DateFormatter = DateFormatter()
        objDateformat.dateFormat = "yyyy-MM-dd"
        let strTime: String = objDateformat.string(from: dateToConvert as Date)
        let objUTCDate: NSDate = objDateformat.date(from: strTime)! as NSDate
        let milliseconds: Int64 = Int64(objUTCDate.timeIntervalSince1970)
        let strTimeStamp: String = "\(milliseconds)"
        return strTimeStamp
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
