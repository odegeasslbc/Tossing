//
//  TableAlertView.swift
//  Tossing
//
//  Created by 刘炳辰 on 16/2/22.
//  Copyright © 2016年 刘炳辰. All rights reserved.
//

import UIKit

class ResultView: UIView {
    
    var initFrame:CGRect?
    var finalFrame:CGRect?
    
    var btn_delete:FlatButton?
    var label_result:LTMorphingLabel?
    var label_count: LTMorphingLabel?
    var showing = false
    
    func show(){
        showing = true
        UIView.animateWithDuration(0.5, animations: {
            self.frame = self.finalFrame!
            }, completion: nil)
    }
    
    func hide(){
        showing = false
        UIView.animateWithDuration(0.5, animations: {
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
        
        label_result = LTMorphingLabel(frame: CGRectMake(15, 60, width-30, height-110))
        label_result?.text = "1"
        label_result!.backgroundColor = UIColor.clearColor()
        label_result!.textAlignment = .Center
        label_result!.textColor = UIColor.blackColor()
        label_result!.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 60)
        label_result!.adjustsFontSizeToFitWidth = true
        label_result!.morphingEffect = .Fall
        self.addSubview(label_result!)
        
        label_count = LTMorphingLabel(frame: CGRectMake(10, 10, 40, 40))
        label_count?.text = "1"
        label_count!.backgroundColor = UIColor.clearColor()
        label_count!.textAlignment = .Center
        label_count!.textColor = UIColor(red: 0.964, green: 0.276, blue: 0.244, alpha: 1)
        label_count!.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        label_count!.adjustsFontSizeToFitWidth = true
        label_count!.morphingEffect = .Fall
        self.addSubview(label_count!)
        
        btn_delete = FlatButton()
        btn_delete?.frame = CGRectMake(width-90, height-50, 80, 40)
        btn_delete!.pulseColor = UIColor(red: 0.964, green: 0.276, blue: 0.244, alpha: 1)
        btn_delete!.pulseScale = false
        btn_delete!.setTitle("close", forState: .Normal)
        btn_delete!.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btn_delete?.addTarget(self, action: "hide", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(btn_delete!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
