//
//  MessageViewController.swift
//  KeepChild
//
//  Created by Clément Martin on 03/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit
import FirebaseFirestore
import MessageKit
import InputBarAccessoryView

class MessageViewController: MessagesViewController {

    private var messages = [Message2]()
    private var messageDict = [[String : Any]]()
    private var conversation: Conversation
    private var manageFireBase = ManageFireBase()
    
    private var messageListener: ListenerRegistration?
    private var reference: CollectionReference?
    private let db = Firestore.firestore()
    
    deinit {
        messageListener?.remove()
    }

    init(conversation: Conversation) {
        self.conversation = conversation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        decodeConversationMessage()
        
        navigationItem.largeTitleDisplayMode = .never
        
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.tintColor = .primary
        messageInputBar.sendButton.setTitleColor(.primary, for: .normal)
        messageInputBar.sendButton.setTitleColor(
            UIColor.primary.withAlphaComponent(0.3),
            for: .highlighted)
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
        
        guard let id = conversation.id else { return }
        
        reference = db.collection(["Conversation", id, "message"].joined(separator: "/"))
        
        messageListener = reference?.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
            }
        }
        
        
    }

    private func handleDocumentChange(_ change: DocumentChange) {
        guard let message = Message2(document: change.document) else {
            return
        }
        
        switch change.type {
        case .added:
           /* if let url = message.downloadURL {
                downloadImage(at: url) { [weak self] image in
                    guard let `self` = self else {
                        return
                    }
                    guard let image = image else {
                        return
                    }
                    
                    message.image = image
                    self.insertNewMessage(message)
                }
            } else {*/
                insertMessage(message)
            //}
            
        default:
            break
        }
    }
    
    private func transformeMessageInDic() {
        for message in messages {
            messageDict.append(message.representation)
        }
    
    }
    

    private func save(_ message: Message2) {
        transformeMessageInDic()
        guard let id = conversation.id else { return }
        let arrayMessage = messageDict as Any
        let update = ["message":arrayMessage]
        
        Firestore.firestore().collection("Conversation").document(id).updateData(update) { (error) in
            if let e = error {
                print("Error sending message: \(e.localizedDescription)")
                return
            }
            
            self.messagesCollectionView.scrollToBottom()
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func decodeConversationMessage() {
        for message in conversation.arrayMessage! {
            let messageText = message["message"] as! String
            let id = message["senderID"] as! String
            let name = message["senderName"] as! String
            let timeInterval = message["created"] as! Timestamp
            //let converted = NSDate(timeIntervalSince1970: timeInterval / 1000)
            let date = timeInterval.dateValue()
            //let date = Date(timeIntervalSince1970: timeInterval)
           /* let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"*/
            let message2 = Message2(created: date, message: messageText, senderID: id, senderName: name)
            messages.append(message2)
        }
    }
}

extension MessageViewController: MessagesDisplayDelegate {
    
    private func backgroundColor(for message: Message2, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .primary : .incomingMessage
    }
    
    func shouldDisplayHeader(for message: Message2, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
        return false
    }
    
    private func messageStyle(for message: Message2, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
    
}

extension MessageViewController: MessagesLayoutDelegate {
    
    func avatarSize(for message: Message2, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    
    func footerViewSize(for message: Message2, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
    func heightForLocation(message: Message2, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 0
    }
}

extension MessageViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(senderId: CurrentUserManager.shared.user.senderId, displayName: CurrentUserManager.shared.profil.pseudo)
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
    /*func currentSender() -> Sender {
        return Sender(id: CurrentUserManager.shared.user.senderId, displayName: CurrentUserManager.shared.profil.pseudo)
    }*/
    
    /*func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }*/
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(
            string: name,
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .caption1),
                .foregroundColor: UIColor(white: 0.3, alpha: 1)
            ]
        )
    }
    
}

// MARK: - MessageInputBarDelegate

/*extension MessageViewController: MessageInputBarDelegate {
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        let message = Message2(text: text, user: CurrentUserManager.shared.user)
        messageInputBar.sendButton.startAnimating()
        save(message)
        inputBar.inputTextView.text = ""
    }
    
}*/

extension MessageViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
       /* let message = Message2(text: text, user: CurrentUserManager.shared.user)
        messageInputBar.sendButton.startAnimating()
        
        
        let components = messageInputBar.inputTextView.components
        inputBar.inputTextView.text = ""
        insertMessages(components)
        save(message)*/
        let message = Message2(text: text, user: CurrentUserManager.shared.user)
        // Here we can parse for which substrings were autocompleted
        let attributedText = messageInputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in
            
            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }
        
        let components = inputBar.inputTextView.components
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()
        
        // Send button activity animation
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = "Sending..."
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                self?.messageInputBar.sendButton.stopAnimating()
                self?.messageInputBar.inputTextView.placeholder = "Aa"
                self?.insertMessages(components)
                self?.messagesCollectionView.scrollToBottom(animated: true)
                self?.save(message)
            }
        }
        
    }

    private func insertMessages(_ data: [Any]) {
        for component in data {
            //let user = SampleData.shared.currentSender
            if let str = component as? String {
                let message = Message2(text: str, user: CurrentUserManager.shared.user)
                insertMessage(message)
            } /*else if let img = component as? UIImage {
                let message = Message2(image: img, user: user, messageId: UUID().uuidString, date: Date())
                insertMessage(message)
            }*/
        }
    }

    func insertMessage(_ message: Message2) {
        guard messages.contains(message) else {
            print("message present")
            return }
        messages.append(message)
        //messages.sort()
        // Reload last section to update header/footer labels and insert a new one
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messages.count - 1])
            if messages.count >= 2 {
                messagesCollectionView.reloadSections([messages.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        })
    }
    
    func isLastSectionVisible() -> Bool {
        
        guard !messages.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
 
}
