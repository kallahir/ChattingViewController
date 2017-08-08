//
//  InputAcessoryView.swift
//  ChattingViewController
//
//  Created by Itallo Rossi Lucas on 08/08/17.
//  Copyright © 2017 kallahir. All rights reserved.
//

import UIKit

class InputAccessoryView: UIView, UITextViewDelegate {
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.autoresizingMask = .flexibleHeight
        self.addSubview(self.inputTextArea)
        self.inputTextArea.delegate = self
        self.inputTextArea.isScrollEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        get{
            let textSize = self.inputTextArea.sizeThatFits(CGSize(width: self.inputTextArea.bounds.width, height: CGFloat.greatestFiniteMagnitude))
            return CGSize(width: self.bounds.width, height: textSize.height)
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        self.invalidateIntrinsicContentSize()
    }
    
}
