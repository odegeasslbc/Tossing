//
//  TTableViewCell.swift
//  Tossing
//
//  Created by 刘炳辰 on 16/2/15.
//  Copyright © 2016年 刘炳辰. All rights reserved.
//

import UIKit

class TTableViewCell: MaterialTableViewCell {
    var checked:Bool = false
    var selectBtn:UIButton!
    //var mainView:UIView?
    
    func btnSelected(){
        if(checked == false){
            checked = true
            selectBtn.backgroundColor = UIColor.redColor()
        }else{
            checked = false
            selectBtn.backgroundColor = UIColor.whiteColor()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clearColor()
        self.textLabel?.textColor = UIColor.blackColor()
        self.textLabel?.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 40)
        self.textLabel?.textAlignment = NSTextAlignment.Center
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.textLabel?.adjustsFontSizeToFitWidth = true
        
        selectBtn = UIButton(frame: CGRectMake(self.frame.width, 11, 18, 18))
        selectBtn.backgroundColor = UIColor.whiteColor()
        selectBtn.layer.cornerRadius = 9
        selectBtn.addTarget(self, action: "btnSelected", forControlEvents: UIControlEvents.TouchDown)
        //self.addSubview(selectBtn)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
