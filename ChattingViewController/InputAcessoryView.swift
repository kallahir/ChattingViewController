//
//  InputAcessoryView.swift
//  ChattingViewController
//
//  Created by Itallo Rossi Lucas on 08/08/17.
//  Copyright © 2017 kallahir. All rights reserved.
//

import UIKit

class InputAccessoryView: UIView, UITextViewDelegate {
    
    private let initialHeight: CGFloat = 51.5
    private let lineHeight: CGFloat = 15.2
    
    weak var chattingViewController: ChattingViewController? {
        didSet {
            self.sendButton.addTarget(self.chattingViewController, action: #selector(ChattingViewController.send), for: .touchUpInside)
        }
    }
    
    var numberOfLines: CGFloat = 0
    
    lazy var maxHeight: CGFloat = {
        return (self.numberOfLines * self.lineHeight) + self.initialHeight
    }()
    
    lazy var inputTextArea: UITextView = {
        let textArea = UITextView()
        textArea.translatesAutoresizingMaskIntoConstraints = false
        textArea.delegate = self
        textArea.isScrollEnabled = false
        textArea.font = UIFont.systemFont(ofSize: 16)
        textArea.layer.cornerRadius = 8
        textArea.layer.masksToBounds = true
        textArea.layer.borderColor = UIColor.lightGray.cgColor
        textArea.layer.borderWidth = 0.5
        return textArea
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "send"), for: .normal)
        button.alpha = 0.5
        button.isEnabled = false
        return button
    }()
    
    let separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.autoresizingMask = .flexibleHeight
        self.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        
        self.addSubview(self.sendButton)
        self.sendButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.sendButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
        self.sendButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        self.sendButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.addSubview(self.inputTextArea)
        self.inputTextArea.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        self.inputTextArea.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.inputTextArea.rightAnchor.constraint(equalTo: self.sendButton.leftAnchor).isActive = true
        self.inputTextArea.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -16).isActive = true
        
        self.addSubview(self.separatorLineView)
        self.separatorLineView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.separatorLineView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.separatorLineView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        self.separatorLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        get{
            // TODO: FIX MAX HEIGHT CALCULATION
            if self.bounds.height > self.maxHeight {
                self.inputTextArea.isScrollEnabled = true
                let textSize = self.inputTextArea.sizeThatFits(CGSize(width: self.inputTextArea.bounds.width, height: CGFloat.greatestFiniteMagnitude))
                if textSize.height > self.maxHeight {
                    return CGSize(width: self.bounds.width, height: self.bounds.height)
                }
            }
            self.inputTextArea.isScrollEnabled = false
            let textSize = self.inputTextArea.sizeThatFits(CGSize(width: self.inputTextArea.bounds.width, height: CGFloat.greatestFiniteMagnitude))
            return CGSize(width: self.bounds.width, height: textSize.height)
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        self.invalidateIntrinsicContentSize()
        let cleanMessage = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if !cleanMessage.isEmpty {
            self.sendButton.isEnabled = true
            self.sendButton.alpha = 1.0
        } else {
            self.sendButton.isEnabled = false
            self.sendButton.alpha = 0.5
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let newIndexPath = IndexPath(item: (self.chattingViewController?.textMessages.count)!-1, section: 0)
        self.chattingViewController?.collectionView?.scrollToItem(at: newIndexPath, at: .top, animated: true)
    }
    
}
