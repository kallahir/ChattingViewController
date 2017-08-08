//
//  InitialTableCell.swift
//  ChattingViewController
//
//  Created by Itallo Rossi Lucas on 08/08/17.
//  Copyright © 2017 kallahir. All rights reserved.
//

import UIKit

class InitialTableCell: UITableViewCell {
    
    let activator: UISwitch = {
        let switcher = UISwitch()
        switcher.translatesAutoresizingMaskIntoConstraints = false
        return switcher
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        addSubview(activator)
        
        activator.leftAnchor.constraint(equalTo: (textLabel?.rightAnchor)!, constant: -40).isActive = true
        activator.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        activator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
