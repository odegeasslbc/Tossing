//
//  TTableViewCell.swift
//  Tossing
//
//  Created by 刘炳辰 on 16/2/15.
//  Copyright © 2016年 刘炳辰. All rights reserved.
//

import UIKit

let clear = UIColor.clearColor()
let light = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
let dark_1 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
let dark_7 = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.5)
let cellBgColor = UIColor(red: 238/255, green: 207/255, blue: 179/255, alpha: 1)

protocol TTableViewCellDelegate{
    func check()
}


class TTableViewCell: MaterialTableViewCell {
    var checked:Bool = false
    //var mainView:UIView?
    
    var sign:FlatButton?
    
    var tDelegate: TTableViewCellDelegate?
    
    var label: UILabel?
    
    func randomColor() -> UIColor{
        let r = CGFloat(200 + (Int(arc4random_uniform(UInt32(55)))))/255
        let g = CGFloat((Int(arc4random_uniform(UInt32(100)))))/255
        let b = CGFloat((Int(arc4random_uniform(UInt32(100)))))/255
        let color = UIColor(red: r, green: g, blue: b, alpha: 1)
        return color
    }
    
    func setFavor(){
        if(checked){
        }else{
            self.checked = true
            sign!.backgroundColor = red_light
            
            let newList = List(title:(self.textLabel?.text)!,star:true)
            
            let db = FMDatabase(path: dbFilePath)
            guard db.open() else {
                print("Error:\(db.lastErrorMessage())")
                return
            }
            
            var oldList:List = List(title: "", star: true)
            for item in lists{
                if item.star {
                    oldList = item
                }
            }
            print(oldList)
            
            let deleteListStatement1 = "DELETE FROM LISTS WHERE TITLE = '\(newList.title)'"
            if !db.executeStatements(deleteListStatement1) {
                print("error when delete")
            }
            
            let deleteListStatement2 = "DELETE FROM LISTS WHERE TITLE = '\(oldList.title)'"
            if !db.executeStatements(deleteListStatement2) {
                print("error when delete")
            }
            
            let insertPersonStatement = "INSERT INTO LISTS (TITLE, STAR) VALUES (?,?)"
            do{
                try db.executeUpdate(insertPersonStatement, values: [newList.title, true ?? NSNull()])
                
                if(oldList.title != ""){
                    try db.executeUpdate(insertPersonStatement, values: [oldList.title, false ?? NSNull()])
                }
                
                db.close()
                
            }catch{
                db.close()
                print("Error:\(error)")
            }
            
            self.tDelegate!.check()
        }
    }
    
    func showSign(){
        
        if(checked){
            sign?.backgroundColor = red_light
        }else{
            sign?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        }
        
        UIView.transitionWithView(self.textLabel!, duration: 0.5, options: [.CurveEaseInOut, .TransitionCrossDissolve], animations: {
            self.textLabel?.textAlignment = .Left
            self.sign?.frame = CGRectMake(self.frame.width-30, self.frame.height/2-12, 24, 24)

            }, completion: nil)
    }
    
    func hideSign(){

        UIView.transitionWithView(self.textLabel!, duration: 0.5, options: [.CurveEaseInOut, UIViewAnimationOptions.TransitionCrossDissolve], animations: {
            self.textLabel?.textAlignment = .Center
            self.sign?.frame = CGRectMake(self.frame.width, self.frame.height/2-12, 24, 24)

            }, completion: nil)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = clear
        
        self.selectionStyle = UITableViewCellSelectionStyle.None

        self.textLabel?.backgroundColor = clear
        self.textLabel?.textColor = dark_7
        self.textLabel?.font = UIFont(name: "AppleSDGothicNeo-Light", size: 40)
        self.textLabel?.textAlignment = NSTextAlignment.Center
        self.textLabel?.adjustsFontSizeToFitWidth = true

        
        let leftLabel = UILabel(frame: CGRectMake(0,0,5,screen.height/10))
        leftLabel.backgroundColor = randomColor()
        self.addSubview(leftLabel)
        
        let bgView = UIView(frame: CGRectMake(0,0,screen.width-40,screen.height/10))
        bgView.backgroundColor = dark_1
        self.addSubview(bgView)
        self.sendSubviewToBack(bgView)
        //self.backgroundColor = dark
        
        sign = FlatButton(frame: CGRectMake(self.frame.width, self.frame.height/2-12, 24, 24))
        sign?.backgroundColor = red_light
        sign?.addTarget(self, action: "setFavor", forControlEvents: UIControlEvents.TouchUpInside)
        sign?.layer.cornerRadius = 12
        
        self.addSubview(sign!)
        self.hideSign()
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
