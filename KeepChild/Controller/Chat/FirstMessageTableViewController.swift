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
    
    var idAnnounceUser = String()
    var arrayMessage = [Message2]()
    var arrayMessageRep = [[String: Any]]()
    var announce: Announce!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

  
    @IBAction func validateMessage(_ sender: Any) {
        //let timeStamp = NSDate().timeIntervalSince1970
        //let now = NSDate()
        //let nowTimeStamp = self.getCurrentTimeStampWOMiliseconds(dateToConvert: now)

        //let message = Message(idUserSender: CurrentUserManager.shared.user.id, message: messageTxt.text, timeStamp: nowTimeStamp)
      // let message2 = Message2(text: messageTxt.text, senderName: sende, senderId: <#T##SenderType#>, date: <#T##Date#>)
        let message = Message2(text: messageTxt.text, user: CurrentUserManager.shared.user)
        arrayMessageRep.append(message.representation)
        arrayMessage.append(message)
        let conversation = Conversation(id: nil, name: announce.title, idUser1: CurrentUserManager.shared.user.senderId, idUser2: idAnnounceUser, arrayMessage: arrayMessageRep)
        //let encodedConversation = try! FirestoreEncoder().encode(conversation)
        Firestore.firestore().collection("Conversation").addDocument(data: conversation.representation)
       // Firestore.firestore().collection("Message").addDocument(data: message.representation)
    }
    
    @IBAction func `return`(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
