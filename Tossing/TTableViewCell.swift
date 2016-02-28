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
    
    var sign:UIView?
    
    func btnSelected(){
        if(checked == false){
            checked = true
            selectBtn.backgroundColor = UIColor.redColor()
        }else{
            checked = false
            selectBtn.backgroundColor = UIColor.whiteColor()
        }
    }
    
    func showSign(){
        UIView.animateWithDuration(0.4, animations: {
            self.sign?.frame = CGRectMake(self.frame.width-30, 11, 18, 18)
        })
        UIView.transitionWithView(self.textLabel!, duration: 0.4, options: [.CurveEaseInOut, .TransitionFlipFromLeft], animations: {
            self.textLabel?.textAlignment = .Left
            }, completion: nil)
    }
    
    func hideSign(){
        UIView.animateWithDuration(0.4, animations: {
            self.sign?.frame = CGRectMake(self.frame.width, 11, 18, 18)
        })
        UIView.transitionWithView(self.textLabel!, duration: 0.4, options: [.CurveEaseInOut, UIViewAnimationOptions.TransitionFlipFromRight], animations: {
            self.textLabel?.textAlignment = .Center
            }, completion: nil)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clearColor()
        self.textLabel?.textColor = UIColor.blackColor()
        self.textLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 40)
        self.textLabel?.textAlignment = NSTextAlignment.Center
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.textLabel?.adjustsFontSizeToFitWidth = true
        
        sign = UIView(frame: CGRectMake(self.frame.width, self.frame.height/2-9, 18, 18))
        sign?.backgroundColor = red_light
        sign?.layer.cornerRadius = 9
        
        self.addSubview(sign!)
        
        pulseColor = red
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
