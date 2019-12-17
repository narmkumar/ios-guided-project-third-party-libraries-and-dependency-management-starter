//
//  MessageThreadsTableViewController.swift
//  Message Board
//
//  Created by Spencer Curtis on 8/7/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

enum Keys: String {
    case currentUser = "currentUser"
    case segue = "ViewMessageDetail"
    
}

class MessageThreadsTableViewController: UITableViewController {

    // MARK: - Properties
    
    let messageThreadController = MessageThreadController()
    
    @IBOutlet weak var threadTitleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUserDictionary = UserDefaults.standard.value(forKey: Keys.currentUser.rawValue) as? [String : String ] {
            let currentUser = Sender(dictionary: currentUserDictionary)
            messageThreadController.currentUser = currentUser
        } else {
            // Create an alert that asks the user for a username and sves it to User Defaults
            let alert = UIAlertController(title: "Set a username", message: nil, preferredStyle: .alert)
            var usernameTextField: UITextField!
            
            alert.addTextField { (textfield) in
                textfield.placeholder = "Username:"
                usernameTextField = textfield
            }
            
            let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
                // Take the text field's tet and save it to User Defaults
                let displayName = usernameTextField.text ?? "No Name"
                let id = UUID().uuidString
                let sender = Sender(senderId: id, displayName: displayName)
                
                UserDefaults.standard.set(sender.dictionaryRepresents, forKey: Keys.currentUser.rawValue)
                self.messageThreadController.currentUser = sender
            }
            
            alert.addAction(submitAction)
            present(alert, animated: true, completion: nil)
            
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        messageThreadController.fetchMessageThreads {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func createThread(_ sender: Any) {
        threadTitleTextField.resignFirstResponder()
        
        guard let threadTitle = threadTitleTextField.text else { return }
        
        threadTitleTextField.text = ""
        
        messageThreadController.createMessageThread(with: threadTitle) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageThreadController.messageThreads.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageThreadCell", for: indexPath)
        
        cell.textLabel?.text = messageThreadController.messageThreads[indexPath.row].title

        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Keys.segue.rawValue {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? MessageDetailViewController else { return }
            
            destinationVC.messageThreadController = messageThreadController
            destinationVC.messageThread = messageThreadController.messageThreads[indexPath.row]
        }
    }
    
}
