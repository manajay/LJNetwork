//
//  ExpressCell.swift
//  LJNetwork
//
//  Created by manajay on 2018/3/8.
//  Copyright © 2018 manajay. All rights reserved.
//

import UIKit

class ExpressCell: UITableViewCell {
    
    lazy var nodeLbl: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 10)
        label.accessibilityIdentifier = "nodeLbl"
        label.layer.cornerRadius = 5
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.layer.borderWidth = 1
        label.layer.masksToBounds = true
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        addSubview(nodeLbl)
    }
}
