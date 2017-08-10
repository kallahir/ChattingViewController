//
//  InitialViewController.swift
//  ChattingViewController
//
//  Created by Itallo Rossi Lucas on 08/08/17.
//  Copyright © 2017 kallahir. All rights reserved.
//

import UIKit

class InitialViewController: UITableViewController {
    
    let initialCellId = "InitialTableCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(InitialTableCell.self, forCellReuseIdentifier: initialCellId)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(openChattingView))
        navigationItem.title = "Configuration"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: initialCellId, for: indexPath) as! InitialTableCell
        cell.textLabel?.text = "ITEM \(indexPath.row+1)"
        cell.activator.isOn = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
 
    func openChattingView() {
        let configuration = ChattingConfiguration(title: "Chatting Title", showUserImage: true)
        let chattingView = ChattingViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chattingView.config = configuration
        navigationController?.pushViewController(chattingView, animated: true)
    }
    
}
