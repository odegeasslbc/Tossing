//
//  TTableView.swift
//  Tossing
//
//  Created by 刘炳辰 on 16/2/15.
//  Copyright © 2016年 刘炳辰. All rights reserved.
//

import UIKit

class TTableView: UITableView {


    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: UITableViewStyle.Plain)
        self.backgroundColor = UIColor.redColor()
    }
    
    init(frame: CGRect) {
        super.init(frame: frame,  style: UITableViewStyle.Plain)
        self.registerClass(TTableViewCell.self, forCellReuseIdentifier: "TTableViewCell")
        
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)

    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
