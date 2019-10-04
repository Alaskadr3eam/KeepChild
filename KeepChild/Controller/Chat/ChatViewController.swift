//
//  ChatViewController.swift
//  KeepChild
//
//  Created by Clément Martin on 02/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit

/*class ChatViewController: UIViewController {

    var manageFireBase = ManageFireBase()

    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet var txtMsg: UITextField!

    @IBOutlet var bottomConst: NSLayoutConstraint!
    
    var conversation: Conversation!
    var arrayMessage = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bottomConst.constant = 0
        arrayMessage = conversation.arrayMessage
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnActionMsgSend(_ sender: Any) {
        if (txtMsg.text == "" || txtMsg.text == " ") {
            let alert = UIAlertController(title: "Alert", message: "Please type a Message", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let message = Message(idUserSender: CurrentUserManager.shared.user.id, message: txtMsg.text!, timeStamp: getCurrentTimeStamp())
            arrayMessage.append(message)
            let update = ["arrayMessage": arrayMessage]
            manageFireBase.updateData(collection: "Conversastion", documentID: conversation.id!, update: update) { (error, bool) in
                guard error == nil else { return }
                guard bool != false else { return }
                self.chatTableView.reloadData()
            }
        }
    }
    func getCurrentTimeStamp() -> String {
        return "\(Double(NSDate().timeIntervalSince1970 * 1000))"
    }
        

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = arrayMessage[indexPath.row]
        if message.idUserSender == CurrentUserManager.shared.user.id {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell2") as! Chat2TableViewCell
            cell2.lblSender.text = message.message
            cell2.lblSender.backgroundColor = UIColor(red: 0.09, green: 0.54, blue: 1, alpha: 1)
            cell2.lblSender.font = UIFont.systemFont(ofSize: 18)
            cell2.lblSender.textColor = .white
            cell2.lblSender?.layer.masksToBounds = true
            cell2.lblSender.layer.cornerRadius = 7
            return cell2
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ChatTableViewCell
            cell.lblReceiver.text = message.message
            cell.lblReceiver.backgroundColor = UIColor .lightGray
            cell.lblReceiver.font = UIFont.systemFont(ofSize: 18)
            cell.lblReceiver.textColor = UIColor.white
            cell.lblReceiver?.layer.masksToBounds = true
            cell.lblReceiver.layer.cornerRadius = 7
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}*/
