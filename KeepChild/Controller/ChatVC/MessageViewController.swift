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
    //MARK: - Properties
    var manageConversation = ConversationManager(firebaseServiceSession: FirebaseService(dataManager: ManagerFirebase()))
    private var messageListener: ListenerRegistration?
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    deinit {
        messageListener?.remove()
    }
    
    init(conversation: Conversation) {
        self.manageConversation.conversation = conversation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manageConversation.decodeConversationMessage()
        navigationItem.title = manageConversation.conversation.name
        Constants.configureTilteTextNavigationBar(view: self, title: .chatMessaging(manageConversation.conversation.name))
        initInputBar()
    }
    //MARK: - Init
    private func initInputBar() {
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.backgroundView.backgroundColor = UIColor(named: "bleu")
        messageInputBar.inputTextView.backgroundColor = .white
        messageInputBar.inputTextView.layer.cornerRadius = 20
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.allowsEditingTextAttributes = true
        scrollsToBottomOnKeyboardBeginsEditing = true
        messageInputBar.sendButton.setTitleColor(.primary, for: .normal)
        messageInputBar.sendButton.setTitleColor(
            UIColor.primary.withAlphaComponent(0.3),
            for: .highlighted)
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
    }
    //MARK: - Func Helpers
    private func save(_ message: Message) {
        manageConversation.transformeMessageInDic()
        let arrayMessage = manageConversation.messageDict as Any
        let update = ["message":arrayMessage]
        manageConversation.updateConversation(update: update) { [weak self] (bool) in
            guard let self = self else { return }
            guard bool == true else { return }
            self.messagesCollectionView.scrollToBottom()
        }
    }
}

extension MessageViewController: MessagesDisplayDelegate {
    
    private func backgroundColor(for message: Message, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .primary : .incomingMessage
    }
    
    func shouldDisplayHeader(for message: Message, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
        return false
    }
    
    private func messageStyle(for message: Message, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
    
}

extension MessageViewController: MessagesLayoutDelegate {
    
    func footerViewSize(for message: Message, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
    func heightForLocation(message: Message, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 0
    }
    
}

extension MessageViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(senderId: CurrentUserManager.shared.user.senderId, displayName: CurrentUserManager.shared.profil.pseudo)
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return manageConversation.messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return manageConversation.messages[indexPath.section]
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 12
    }
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        return NSAttributedString(string: "Read", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
    
}

extension MessageViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        let message = Message(text: text, user: CurrentUserManager.shared.user)
        // Here we can parse for which substrings were autocompleted
        guard let attributedText = messageInputBar.inputTextView.attributedText else { return }
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in
            
            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }
        
        let components = inputBar.inputTextView.components
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()
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
            if let str = component as? String {
                let message = Message(text: str, user: CurrentUserManager.shared.user)
                insertMessage(message)
            }
        }
    }
    
    func insertMessage(_ message: Message) {
        guard manageConversation.messages.contains(message) else {
            print("message present")
            return }
        manageConversation.messages.append(message)
        // Reload last section to update header/footer labels and insert a new one
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([manageConversation.messages.count - 1])
            if manageConversation.messages.count >= 2 {
                messagesCollectionView.reloadSections([manageConversation.messages.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        })
    }
    
    func isLastSectionVisible() -> Bool {
        guard !manageConversation.messages.isEmpty else { return false }
        let lastIndexPath = IndexPath(item: 0, section: manageConversation.messages.count - 1)
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
}

extension MessageViewController: MessageCellDelegate {
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        choiceInitial(message: message, avatarView: avatarView)
    }
    
    private func choiceInitial(message: MessageType, avatarView: AvatarView) {
        if isFromCurrentSender(message: message) {
            selectFirstChar(message: message, avatarView: avatarView)
        } else {
            selectFirstChar(message: message, avatarView: avatarView)
        }
    }
    
    private func selectFirstChar(message: MessageType, avatarView: AvatarView) {
        guard let letter = message.sender.displayName.first else { return }
        let letterString = String(letter)
        avatarView.initials = letterString
    }
    
}

