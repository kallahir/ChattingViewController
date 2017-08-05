//
//  ChattingViewController.swift
//  ChattingViewController
//
//  Created by Itallo Rossi Lucas on 03/08/17.
//  Copyright © 2017 kallahir. All rights reserved.
//

import UIKit

class ChattingViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var textMessages: [TextMessage] = []
    var messages: [String] = ["message01, kind of small-ish",
                              "message02, small",
                              "message03, woooow such a huge message what is that for? why dont you talk a little bit less... 'cause i dont want to!",
                              "message04, small? not this time, not this time"]
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: "MessageCell")
        collectionView?.keyboardDismissMode = .interactive
        
        navigationItem.title = "Chatting"
        
        setupInput()
        setupKeyboard()
        fillTextMessages()
    }
    
    func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardUp), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDown), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func handleKeyboardUp(notification: Notification){
        if let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            containerViewBottomAnchor?.constant = -keyboardFrame.height
            if let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double {
                UIView.animate(withDuration: duration, animations: { 
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func handleKeyboardDown(notification: Notification) {
        containerViewBottomAnchor?.constant = 0
        if let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double {
            UIView.animate(withDuration: duration, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }

    func setupInput(){
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        containerView.addSubview(inputTextField)
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor.lightGray
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func send() {
        if let message = inputTextField.text {
            if !message.isEmpty {
                textMessages.append(TextMessage(msgId: "-1", msgTimestamp: Date(), content: message, userId: "1"))
                collectionView?.reloadData()
                inputTextField.text = nil
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return textMessages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as! MessageCell
        configureCell(cell: cell, message: textMessages[indexPath.item])
        return cell
    }
    
    private func configureCell(cell: MessageCell, message: TextMessage) {
        cell.textView.text = message.msgContent
        if message.userId == "1" {
            cell.bubbleView.backgroundColor = MessageCell.blueBubble
            cell.textView.textColor = UIColor.white
            cell.profileImage.isHidden = true
            cell.bubbleRight?.isActive = true
            cell.bubbleLeft?.isActive = false
        } else {
            cell.bubbleView.backgroundColor = MessageCell.grayBubble
            cell.textView.textColor = UIColor.black
            cell.profileImage.isHidden = false
            cell.bubbleRight?.isActive = false
            cell.bubbleLeft?.isActive = true
        }
        cell.bubbleWidth?.constant = getFrameForText(content: message.msgContent).width + 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let height = getFrameForText(content: textMessages[indexPath.item].msgContent).height + 20
        
        return CGSize(width: width, height: height)
    }
    
    func getFrameForText(content: String) -> CGRect {
        let size = CGSize(width: 190, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: content).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    // MARK: Helper methods
    
    func fillTextMessages() {
        var count = 0
        messages.forEach { (message) in
            let txtMsg = TextMessage(msgId: "\(count)", msgTimestamp: Date(), content: message, userId: "1")
            textMessages.append(txtMsg)
            count += 1
        }
        messages.forEach { (message) in
            let txtMsg = TextMessage(msgId: "\(count)", msgTimestamp: Date(), content: message, userId: "2")
            textMessages.append(txtMsg)
            count += 1
        }
        messages.forEach { (message) in
            let txtMsg = TextMessage(msgId: "\(count)", msgTimestamp: Date(), content: message, userId: "1")
            textMessages.append(txtMsg)
            count += 1
        }
    }

}