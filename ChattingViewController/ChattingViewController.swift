//
//  ChattingViewController.swift
//  ChattingViewController
//
//  Created by Itallo Rossi Lucas on 03/08/17.
//  Copyright © 2017 kallahir. All rights reserved.
//

import UIKit

class ChattingViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextViewDelegate {

    var config: ChattingConfiguration?
    var textMessages: [TextMessage] = []
    var messages: [String] = ["message01, kind of small-ish",
                              "message02, small",
                              "message03, woooow such a huge message what is that for? why dont you talk a little bit less... 'cause i dont want to!",
                              "message04, small? not this time, not this time"]
    
    let inputTextArea: UITextView = {
        let textArea = UITextView()
        textArea.translatesAutoresizingMaskIntoConstraints = false
        textArea.font = UIFont.systemFont(ofSize: 16)
        textArea.layer.cornerRadius = 8
        textArea.layer.masksToBounds = true
        textArea.layer.borderColor = UIColor.lightGray.cgColor
        textArea.layer.borderWidth = 0.5
        return textArea
    }()
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    init(configuration: ChattingConfiguration) {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        self.config = configuration
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: "MessageCell")
        collectionView?.keyboardDismissMode = .interactive
        
        navigationItem.title = self.config?.title
        
        inputTextArea.delegate = self
        
//        setupKeyboard()
        fillTextMessages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView?.scrollToItem(at: IndexPath(item: textMessages.count-1, section: 0), at: UICollectionViewScrollPosition.top, animated: true)
    }
    
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = MessageCell.grayBubble
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
 
        containerView.addSubview(self.inputTextArea)
        self.inputTextArea.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        self.inputTextArea.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        self.inputTextArea.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputTextArea.heightAnchor.constraint(equalTo: containerView.heightAnchor, constant: -16).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor.lightGray
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        return containerView
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardUp), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDown), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func handleKeyboardUp(notification: Notification){
        print("KEYBOARD UP")
    }
    
    func handleKeyboardDown(notification: Notification) {
        print("KEYBOARD DOWN")
    }
    
    func send() {
        if let message = inputTextArea.text {
            if !message.isEmpty {
                let cleanMessage = message.trimmingCharacters(in: .whitespacesAndNewlines)
                textMessages.append(TextMessage(msgId: "-1", msgTimestamp: Date(), content: cleanMessage, userId: "1"))
                collectionView?.reloadData()
                collectionView?.scrollToItem(at: IndexPath(item: textMessages.count-1, section: 0), at: UICollectionViewScrollPosition.top, animated: true)
                inputTextArea.text = nil
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
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: 400)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let frame = NSString(string: textView.text!).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
        
        if frame.height > textView.frame.height {
            // TODO: DISCOVER THE RIGHT LOGIC TO PUT HERE
        }
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
            
            if cell.profileImage.isHidden {
                cell.bubbleLeft?.isActive = false
                cell.bubbleLeftNoImage?.isActive = true
            } else {
                cell.bubbleLeft?.isActive = true
                cell.bubbleLeftNoImage?.isActive = false
            }
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
