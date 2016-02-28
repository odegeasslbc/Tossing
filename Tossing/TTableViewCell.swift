//
//  TTableViewCell.swift
//  Tossing
//
//  Created by 刘炳辰 on 16/2/15.
//  Copyright © 2016年 刘炳辰. All rights reserved.
//

import UIKit

protocol TTableViewCellDelegate{
    func check()
}

class TTableViewCell: MaterialTableViewCell {
    var checked:Bool = false
    //var mainView:UIView?
    
    var sign:FlatButton?
    
    var tDelegate: TTableViewCellDelegate?
    
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
            sign?.backgroundColor = UIColor.grayColor()
        }
        
        UIView.animateWithDuration(0.4, animations: {
            self.sign?.frame = CGRectMake(self.frame.width-35, self.frame.height/2-12, 35, 24)
        })
        UIView.transitionWithView(self.textLabel!, duration: 0.4, options: [.CurveEaseInOut, .TransitionFlipFromLeft], animations: {
            self.textLabel?.textAlignment = .Left
            }, completion: nil)
    }
    
    func hideSign(){
        UIView.animateWithDuration(0.4, animations: {
            self.sign?.frame = CGRectMake(self.frame.width, self.frame.height/2-12, 35, 24)
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
        
        sign = FlatButton(frame: CGRectMake(self.frame.width, self.frame.height/2-12, 35, 24))
        sign?.backgroundColor = red_light
        sign?.addTarget(self, action: "setFavor", forControlEvents: UIControlEvents.TouchUpInside)
        //sign?.layer.cornerRadius = 10
        
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
