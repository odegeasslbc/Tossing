//
//  EditButton.swift
//  Tossing
//
//  Created by 刘炳辰 on 2/25/16.
//  Copyright © 2016 刘炳辰. All rights reserved.
//

import UIKit

class TossButton: FlatButton {

    var textLabel:LTMorphingLabel!
    
    var normalText:String?
    var highlightText: String?
    
    func rdEffect(t:Int) -> LTMorphingEffect{
        let nbr = Int(arc4random_uniform(UInt32(t)))
        switch nbr{
        case 0:
            return LTMorphingEffect.Fall
        case 1:
            return LTMorphingEffect.Pixelate
        case 2:
            return LTMorphingEffect.Evaporate
        case 3:
            return LTMorphingEffect.Scale
        case 4:
            return LTMorphingEffect.Sparkle
        case 5:
            return LTMorphingEffect.Burn
        case 6:
            return LTMorphingEffect.Anvil
        default:
            return .Fall
        }
    }
    
    func highLight(){
        self.backgroundColor = red_light
        textLabel.textColor = UIColor.whiteColor()
        textLabel.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 35)
    
        textLabel.morphingEffect = rdEffect(4)
        textLabel.text = highlightText!
    }
    
    func normal(){
        self.backgroundColor = UIColor.clearColor()
        textLabel.textColor = UIColor.blackColor()
        textLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 35)
        
        textLabel.morphingEffect = rdEffect(5)
        textLabel.text = normalText!
    }
    
    init(frame: CGRect, normalText: String, highlightText: String) {
        super.init(frame:frame)
        
        self.normalText = normalText
        self.highlightText = highlightText
        
        textLabel = LTMorphingLabel(frame:CGRectMake(0,-15,frame.width,frame.height+15))
        textLabel.textAlignment = NSTextAlignment.Center
        textLabel.backgroundColor = UIColor.clearColor()
        
        normal()
                
        self.addSubview(textLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
