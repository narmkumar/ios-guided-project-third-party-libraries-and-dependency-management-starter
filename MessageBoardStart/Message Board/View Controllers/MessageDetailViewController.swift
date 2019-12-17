//
//  MessageDetailViewController.swift
//  Message Board
//
//  Created by Niranjan Kumar on 12/17/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class MessageDetailViewController: MessagesViewController, InputBarAccessoryViewDelegate {
    
    var messageThread: MessageThread?
    var messageThreadController: MessageThreadController?
    
    private lazy var formatter: DateFormatter = {
        let result = DateFormatter()
        result.dateStyle = .medium
        result.timeStyle = .medium
        return result
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageInputBar.delegate = self
        
    }
    
}

extension MessageDetailViewController: MessagesDataSource {
    // Required Delegate Methods:
    func currentSender() -> SenderType {
        if let currentUser = messageThreadController?.currentUser {
            return currentUser
        } else {
            return Sender(senderId: "foo", displayName: "bar")
        }
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        messageThread?.messages.count ?? 0
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        guard let message = messageThread?.messages[indexPath.item] else {
            fatalError("No message found in thread.")
        }
        return message
    }
}

