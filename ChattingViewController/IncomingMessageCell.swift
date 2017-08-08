//
//  IncomingMessageCell.swift
//  ChattingViewController
//
//  Created by Itallo Rossi Lucas on 07/08/17.
//  Copyright © 2017 kallahir. All rights reserved.
//

import UIKit

class IncomingMessageCell: UICollectionViewCell {
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.text = "SAMPLE"
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.clear
        textView.textColor = UIColor.black
        textView.isEditable = false
        return textView
    }()
    
    static let grayBubble = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = grayBubble
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bender")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    var bubbleWidth: NSLayoutConstraint?
    var bubbleLeft: NSLayoutConstraint?
    var bubbleLeftNoImage: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImage)
        addSubview(nameLabel)
        
        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImage.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        bubbleLeft = bubbleView.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 8)
        bubbleLeft?.priority = 1000
        bubbleLeftNoImage = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8)
        bubbleLeftNoImage?.priority = 500
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidth = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidth?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 12).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
