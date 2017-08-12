//
//  ChattingViewController.swift
//  ChattingViewController
//
//  Created by Itallo Rossi Lucas on 03/08/17.
//  Copyright © 2017 kallahir. All rights reserved.
//

import UIKit

class ChattingViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let incomingCellId = "IncomingMessageCell"
    let outgoingCellId = "OutgoingMessageCell"
    
    var config: ChattingConfiguration!
    var textMessages: [TextMessage] = []
    var messages: [String] = ["message01, kind of small-ish",
                              "message02, small",
                              "message03, woooow such a huge message what is that for? why dont you talk a little bit less... 'cause i dont want to!",
                              "message04, small? not this time, not this time"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.contentInset    = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView?.alwaysBounceVertical    = true
        collectionView?.keyboardDismissMode     = .interactive
        collectionView?.register(IncomingMessageCell.self, forCellWithReuseIdentifier: incomingCellId)
        collectionView?.register(OutgoingMessageCell.self, forCellWithReuseIdentifier: outgoingCellId)
        
        navigationItem.title = self.config?.title

        self.setupKeyboard()
        self.fillTextMessages()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView?.scrollToItem(at: IndexPath(item: textMessages.count-1, section: 0), at: .bottom, animated: true)
    }
    
    lazy var inputContainerView: InputAccessoryView = {
        let view = InputAccessoryView()
        view.chattingViewController = self
        return view
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
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    }
    
    func keyboardDidShow(){
        if self.textMessages.count > 0 {
            let indexPath = IndexPath(item: self.textMessages.count - 1, section: 0)
            self.collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }
    
    func send() {
        if let message = inputContainerView.inputTextArea.text {
            if !message.isEmpty {
                let cleanMessage = message.trimmingCharacters(in: .whitespacesAndNewlines)
                textMessages.append(TextMessage(msgId: "-1",
                                                msgTimestamp: Date(),
                                                content: cleanMessage,
                                                userId: "1",
                                                userName: "me"))
                
                let newIndexPath = IndexPath(item: textMessages.count-1, section: 0)
                collectionView?.insertItems(at: [newIndexPath])
                collectionView?.scrollToItem(at: newIndexPath,
                                             at: UICollectionViewScrollPosition.bottom,
                                             animated: true)
                
                inputContainerView.inputTextArea.text = nil
                inputContainerView.invalidateIntrinsicContentSize()
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
        return configureCellType(collectionView: collectionView,
                                 indexPath: indexPath,
                                 message: textMessages[indexPath.item])
    }
    
    private func configureCellType(collectionView: UICollectionView, indexPath: IndexPath, message: TextMessage) -> UICollectionViewCell {
        if message.userId == "1" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: outgoingCellId, for: indexPath) as! OutgoingMessageCell
            cell.textView.text = message.msgContent
            cell.bubbleWidth?.constant = getFrameForText(content: message.msgContent).width + 32
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: incomingCellId, for: indexPath) as! IncomingMessageCell
        cell.textView.text = message.msgContent
        cell.nameLabel.text = message.userName
        cell.profileImage.isHidden = !self.config.showUserImage
        cell.bubbleWidth?.constant = getFrameForText(content: message.msgContent).width + 32
        
        if cell.profileImage.isHidden {
            cell.bubbleLeft?.isActive = false
            cell.bubbleLeftNoImage?.isActive = true
        } else {
            cell.bubbleLeft?.isActive = true
            cell.bubbleLeftNoImage?.isActive = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        var heightOutgoing: CGFloat = 0
        
        if textMessages[indexPath.item].userId != "1" {
            heightOutgoing = 16
        }
        let height = getFrameForText(content: textMessages[indexPath.item].msgContent).height + 20 + heightOutgoing
        
        return CGSize(width: width, height: height)
    }
    
    func getFrameForText(content: String) -> CGRect {
        let size = CGSize(width: 190, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: content).boundingRect(with: size,
                                                      options: options,
                                                      attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)],
                                                      context: nil)
    }
    
    // MARK: Helper methods
    func fillTextMessages() {
        var count = 0
        messages.forEach { (message) in
            let txtMsg = TextMessage(msgId: "\(count)", msgTimestamp: Date(), content: message, userId: "1", userName: "me")
            textMessages.append(txtMsg)
            count += 1
        }
        messages.forEach { (message) in
            let txtMsg = TextMessage(msgId: "\(count)", msgTimestamp: Date(), content: message, userId: "2", userName: "Bender")
            textMessages.append(txtMsg)
            count += 1
        }
        messages.forEach { (message) in
            let txtMsg = TextMessage(msgId: "\(count)", msgTimestamp: Date(), content: message, userId: "1", userName: "me")
            textMessages.append(txtMsg)
            count += 1
        }
    }

}
