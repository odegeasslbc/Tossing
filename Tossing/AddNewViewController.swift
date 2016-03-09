//
//  AddNewViewController.swift
//  Tossing
//
//  Created by 刘炳辰 on 16/2/15.
//  Copyright © 2016年 刘炳辰. All rights reserved.
//

import UIKit

extension AddNewViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TTableViewCell", forIndexPath: indexPath) as! TTableViewCell
        
        let item = items[indexPath.section]
        cell.textLabel?.text = item
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        //table_itemTable.cellForRowAtIndexPath(indexPath)?.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
    }
    
    func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        //table_itemTable.cellForRowAtIndexPath(indexPath)?.backgroundColor = UIColor.whiteColor()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let itemName = tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text!
        
        let alert = SCLAlertView()
        
        alert.addButton("Delete", action: {
            self.items.removeAtIndex(indexPath.section)
            tableView.deleteSections(NSIndexSet(index:indexPath.section), withRowAnimation: .Right)
            if(self.items.count==0){
                if(self.label_new.text == "" || self.label_new.text == "New"){
                    self.btn_list.normal()
                }
            }
        })
        alert.showNotice(itemName!, subTitle: "are you sure to delete it?",closeButtonTitle: "Cancel")
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = clear
        return view
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return screen.height/10
    }
    

}

extension AddNewViewController: UITextFieldDelegate{

    func textFieldDidBeginEditing(textField: UITextField) {
        self.view.addSubview(uiview_blockView)
        
        self.view.bringSubviewToFront(textField)
        if(textField.tag == 1){
            self.view.bringSubviewToFront(self.btn_add)
        }else if(textField.tag == 2){
            self.view.bringSubviewToFront(self.btn_done)
        }
        
        //textField.borderStyle = UITextBorderStyle.RoundedRect
        
        UIView.animateWithDuration(0.3, animations: {
            textField.frame = CGRectMake(30, screen.height-350, screen.width-160, 50)
            if(textField.tag == 1){
                self.btn_add.frame = CGRectMake(screen.width-120, screen.height-350, 100,50)
                self.btn_add.backgroundColor = red_light
                self.btn_add.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            }else if(textField.tag == 2){
                self.btn_done.frame = CGRectMake(screen.width-120, screen.height-350, 100,50)
                self.btn_done.backgroundColor = red_light
                self.btn_done.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                
            }
            }, completion: nil)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        UIView.animateWithDuration(0.3, animations: {
            if(textField.tag == 1){
                textField.frame = CGRectMake(30, screen.height*3/4, screen.width-160, 40)
                self.btn_add.frame = CGRectMake(screen.width-120, screen.height*3/4, 100,50)
                self.btn_add.backgroundColor = light
                self.btn_add.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                
            }else if(textField.tag == 2){
                textField.frame = CGRectMake(30, screen.height*3/4+60, screen.width-160, 40)
                self.btn_done.frame = CGRectMake(screen.width-120, screen.height*3/4+60, 100,50)
                self.btn_done.backgroundColor = light
                self.btn_done.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            }
            }, completion: {
                finished in
                if(textField.tag == 2){
                   textField.text = "" 
                }
                self.uiview_blockView.removeFromSuperview()
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if(textField.tag == 2){
            //label_new.text = textField_title.text!
            //label_new.textColor = red_light
        }
        return true
    }

}

class AddNewViewController: UIViewController{
    
    let label_new = UILabel(frame: CGRectMake(18, 30, screen.width-130, 60))
    
    let table_itemTable = TTableView(frame: CGRectMake(30, 100, screen.width-60, screen.height*3/4-130))
    
    let textField_newItem = TextField(frame: CGRectMake(30, screen.height*3/4, screen.width-160, 40))
    let textField_title = TextField(frame: CGRectMake(30, screen.height*3/4 + 60, screen.width-160, 40))
    
    let btn_add = FlatButton(frame: CGRectMake(screen.width-120, screen.height*3/4, 100,50))
    let btn_done = FlatButton(frame: CGRectMake(screen.width-120, screen.height*3/4+60, 100,50))

    let btn_list = TossButton(frame: CGRectMake(screen.width-110, 30, 100, 55), normalText: "Back", highlightText: "Save")

    let uiview_blockView = UIVisualEffectView(frame: CGRectMake(0, 0, screen.width, screen.height))
    
    var items = [String]()
    
    let bg = UIImageView(frame: screen)

    
    //**** functions ****
    func backToList(){
        if(label_new.text == "New" && items.count == 0){
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else if checkTitle(){
            if(label_new.text == "New" && label_new.text != ""){
                let alert = SCLAlertView()
                alert.addButton("let her die", action: {
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                alert.showError("Can't save it", subTitle: "she wants to have a name to be remembered", closeButtonTitle: "alright sweety")
            }
            
            else if(self.items.count == 0){
                let alert = SCLAlertView()
                alert.addButton("quit directly", action: {
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                alert.showError("Can't save it", subTitle: "a list can't be a list without any items in it", closeButtonTitle: "ok, add")
            }
                
            else if(label_new.text != "New" && label_new.text != nil && self.items.count != 0 ){
                let db = FMDatabase(path: dbFilePath)
                
                guard db.open() else {
                    print("Error:\(db.lastErrorMessage())")
                    return
                }
                
                let list = label_new.text
                
                for item in items{
                    let insertPersonStatement = "INSERT INTO ITEMS (NAME,HOST) VALUES (?,?)"
                    do{
                        try db.executeUpdate(insertPersonStatement, values: [item,list ?? NSNull()])
                    }catch{
                        print("Error:\(error)")
                    }
                }
                
                let insertPersonStatement = "INSERT INTO LISTS (TITLE, STAR) VALUES (?,?)"
                do{
                    try db.executeUpdate(insertPersonStatement, values: [list!, false ?? NSNull()])
                    db.close()
                }catch{
                    db.close()
                    print("Error:\(error)")
                }
                self.view.endEditing(true)
                
                let alert = SCLAlertView()
                alert.showSuccess("Success", subTitle: "a new list has been saved", closeButtonTitle: "great", duration: 1)
                self.dismissViewControllerAnimated(true, completion: nil)
                
            }
            else{
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func add(){
        self.view.endEditing(true)

        if(textField_newItem.text != nil && textField_newItem.text != ""){
            
            if(textField_newItem.text?.characters.count > 18){
                let alert = SCLAlertView()
                alert.showError("Sorry", subTitle: "I can't remember such a long sentence right now", closeButtonTitle: "ok forgive you", duration: 3)
            }
            else{
                items.append(textField_newItem.text!)
                table_itemTable.reloadData()
                textField_newItem.text = ""
                btn_list.highLight()
            }
        }
    }
    
    func done(){
       
        if checkTitle(){
            if(textField_title.text != ""){
                label_new.text = textField_title.text
                label_new.textColor = red_light
                btn_list.highLight()
                textField_title.text = ""
            }
        }
        
        self.view.endEditing(true)
    }

    func checkTitle() -> Bool{
        let newTitle = textField_title.text
        let result = qurry()
        
        for title in result{
            if (newTitle == title) {
                textField_title.text = ""
                //label_new.text = "New"
                //label_new.textColor = UIColor.grayColor()
                let alert = SCLAlertView()
                alert.showError("Nope", subTitle: "the title already exists", closeButtonTitle: "ok", duration: 2)
                return false
            }
        }
        
        for char in (newTitle?.characters)!{
            if char == "'"{
                textField_title.text = ""
                //label_new.text = "New"
                //label_new.textColor = UIColor.grayColor()
                let alert = SCLAlertView()
                alert.showError("Nope", subTitle: "the title shouldn't contain signs ", closeButtonTitle: "ok", duration: 2)
                return false
            }
        }
        return true
    }
    
    func qurry() -> [String]{
        var titles:[String] = [String]()
        
        let db = FMDatabase(path: dbFilePath)
        guard db.open() else {
            print("Error:\(db.lastErrorMessage())")
            return [""]
        }
        
        let queryPersonStatement = "SELECT * FROM LISTS"
        
        if let resultSet = db.executeQuery(queryPersonStatement,withArgumentsInArray: nil){
            while resultSet.next(){
                let name = resultSet.stringForColumn("TITLE")
                    titles.append(name)
            }
        }
        db.close()
        
        return titles
    }
    //**** functions ****

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        textField_newItem.tag = 1
        textField_title.tag = 2
        
        let blurEffect = UIBlurEffect(style: .Dark)
        uiview_blockView.effect = blurEffect
        //uiview_blockView.alpha = 0.8
        
        //btn_list.center.x = self.view.frame.width - 50
        
        btn_list.addTarget(self, action: "backToList", forControlEvents: UIControlEvents.TouchUpInside)
        btn_list.pulseColor = red
        self.view.addSubview(btn_list)
        
        label_new.text = "New"
        label_new.font = UIFont(name: "AppleSDGothicNeo-Light", size: 50)
        label_new.backgroundColor = UIColor.clearColor()
        label_new.textColor = UIColor.grayColor()
        label_new.adjustsFontSizeToFitWidth = true
        //label_new.morphingEffect = LTMorphingEffect.Scale
        self.view.addSubview(label_new)
        
        
        let image = UIImage(named: "ic_close_white_3x")?.imageWithRenderingMode(.AlwaysTemplate)
        let clearButton: FlatButton = FlatButton()
        clearButton.pulseColor = MaterialColor.grey.base
        clearButton.pulseScale = false
        clearButton.tintColor = MaterialColor.grey.base
        clearButton.setImage(image, forState: .Normal)
        clearButton.setImage(image, forState: .Highlighted)
        
        textField_newItem.backgroundColor = UIColor.clearColor()
        textField_newItem.clearButtonMode = UITextFieldViewMode.WhileEditing
        textField_newItem.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 40)
        textField_newItem.delegate = self
        textField_newItem.placeholder = "New Item"
        textField_newItem.adjustsFontSizeToFitWidth = true
        textField_newItem.titleLabel = UILabel()
        textField_newItem.titleLabelColor = MaterialColor.grey.base
        textField_newItem.titleLabelActiveColor = red_light
        textField_newItem.clearButtonMode = .WhileEditing
        textField_newItem.clearButton = clearButton
        
        textField_title.backgroundColor = UIColor.clearColor()
        textField_title.clearButtonMode = UITextFieldViewMode.WhileEditing
        textField_title.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 40)
        textField_title.delegate = self
        textField_title.placeholder = "Set Title"
        textField_title.adjustsFontSizeToFitWidth = true
        textField_title.titleLabel = UILabel()
        textField_title.titleLabelColor = MaterialColor.grey.base
        textField_title.titleLabelActiveColor = red_light
        textField_title.clearButtonMode = .WhileEditing
        textField_title.clearButton = clearButton
        
        btn_add.backgroundColor=light
        btn_add.layer.cornerRadius = 5
        btn_add.setTitle("add", forState: UIControlState.Normal)
        btn_add.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn_add.setTitleColor(red_light, forState: UIControlState.Highlighted)
        btn_add.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 30)
        btn_add.addTarget(self, action: "add", forControlEvents: UIControlEvents.TouchUpInside)
        btn_add.pulseColor = red

        btn_done.backgroundColor=light
        btn_done.layer.cornerRadius = 5
        btn_done.setTitle("done", forState: UIControlState.Normal)
        btn_done.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn_done.setTitleColor(red_light, forState: UIControlState.Highlighted)
        btn_done.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 30)
        btn_done.addTarget(self, action: "done", forControlEvents: UIControlEvents.TouchUpInside)
        btn_done.pulseColor = red

        table_itemTable.backgroundColor = UIColor.clearColor()
        table_itemTable.dataSource = self
        table_itemTable.delegate = self
        table_itemTable.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.view.addSubview(table_itemTable)
        self.view.addSubview(textField_title)
        self.view.addSubview(textField_newItem)
        self.view.addSubview(btn_done)
        self.view.addSubview(btn_add)
        
        self.modalPresentationStyle = .Custom

        let bgimg = UIImage(named: "2")
        bg.image = bgimg
        
        let Effect = UIBlurEffect(style: .Light)
        let blurView = UIVisualEffectView(frame: self.view.frame)
        blurView.effect = Effect
        
        self.view.addSubview(blurView)
        self.view.sendSubviewToBack(blurView)
        
        self.view.addSubview(bg)
        self.view.sendSubviewToBack(bg)

        
        self.view.backgroundColor = UIColor.clearColor()

    }
    
    override func viewWillAppear(animated: Bool) {
        bg.image = UIImage(named: "2")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
