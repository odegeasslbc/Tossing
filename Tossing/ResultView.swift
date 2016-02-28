//
//  TableAlertView.swift
//  Tossing
//
//  Created by 刘炳辰 on 16/2/22.
//  Copyright © 2016年 刘炳辰. All rights reserved.
//

import UIKit

let red = UIColor(red: 0.964, green: 0.276, blue: 0.244, alpha: 1)
let red_light = UIColor(red: 0.964, green: 0.276, blue: 0.244, alpha: 0.8)


class ResultView: UIView {
    
    var initFrame:CGRect?
    var finalFrame:CGRect?
    
    var btn_delete:FlatButton?
    var label_result:LTMorphingLabel?
    var label_count: LTMorphingLabel?
    var showing = false
    
    func show(){
        showing = true
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.frame = self.finalFrame!
            }, completion: nil)
    }
    
    func hide(){
        showing = false
        UIView.animateWithDuration(0.6, animations: {
            self.frame = self.initFrame!
            }, completion: nil)
    }
    
    init(initFrame: CGRect, finalFrame: CGRect) {
        super.init(frame: initFrame)
        self.initFrame = initFrame
        self.finalFrame = finalFrame
        
        let width = finalFrame.width
        let height = finalFrame.height
        
        self.backgroundColor = UIColor.whiteColor()
        
        label_result = LTMorphingLabel(frame: CGRectMake(0, 0, width, height-50))
        label_result?.text = "1"
        label_result!.backgroundColor = UIColor.clearColor()
        label_result!.textAlignment = .Center
        label_result!.textColor = UIColor.whiteColor()
        label_result!.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 90)
        label_result?.adjustsFontSizeToFitWidth = true
        //self.detailView = label_result
        self.addSubview(label_result!)
        
        label_count = LTMorphingLabel(frame: CGRectMake(0, -10, 60, 60))
        label_count?.text = "1"
        label_count!.backgroundColor = UIColor.clearColor()
        label_count!.textAlignment = .Center
        label_count!.textColor = UIColor(red: 0.964, green: 0.276, blue: 0.244, alpha: 1)
        label_count!.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 40)
        label_count!.adjustsFontSizeToFitWidth = true
        label_count!.morphingEffect = .Fall
        self.addSubview(label_count!)
        //self.titleLabel = label_count
        
        btn_delete = FlatButton()
        btn_delete?.frame = CGRectMake(width-80, height-40, 80, 40)
        btn_delete!.pulseColor = UIColor.whiteColor()
        btn_delete!.pulseScale = true
        btn_delete!.setTitle("close", forState: .Normal)
        btn_delete!.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn_delete?.addTarget(self, action: "hide", forControlEvents: UIControlEvents.TouchUpInside)
        
        //let btn = FlatButton()
        //self.rightButtons = [btn_delete!, btn]
        
        self.layer.cornerRadius = 5
        self.addSubview(btn_delete!)
        
        self.backgroundColor=UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
