//
//  AddNewViewController.swift
//  Tossing
//
//  Created by 刘炳辰 on 16/2/15.
//  Copyright © 2016年 刘炳辰. All rights reserved.
//

import UIKit

class AddNewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{
    
    //let stackView_stack = UIStackView(frame: CGRectMake(0, 0, screen.width, screen.height))
    let label_new = LTMorphingLabel(frame: CGRectMake(10, 0, screen.width-130, 80))
    let table_itemTable = TTableView(frame: CGRectMake(30, 100, screen.width-60, screen.height*3/4-130))
    let textField_newItem = UITextField(frame: CGRectMake(30, screen.height*3/4, screen.width-160, 50))
    let textField_title = UITextField(frame: CGRectMake(30, screen.height*3/4 + 60, screen.width-160, 50))
    
    let btn_add = FlatButton(frame: CGRectMake(screen.width-110, screen.height*3/4, 80,50))
    let btn_done = FlatButton(frame: CGRectMake(screen.width-120, screen.height*3/4+60, 100,50))
    let btn_list = FlatButton(frame: CGRectMake(screen.width-120, 30, 100, 55))

    let uiview_blockView = UIView(frame: CGRectMake(0, 0, screen.width, screen.height))
    
    var items = [String]()
    
    //step 1
    //var appDelegate: AppDelegate?
    //var managedContext: NSManagedObjectContext?
    

    //************ table view **************
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TTableViewCell", forIndexPath: indexPath) as! TTableViewCell
        
        let item = items[indexPath.row]
        cell.textLabel?.text = item
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
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
            self.items.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Right)
        })
        alert.showNotice(itemName!, subTitle: "are you sure to delete it?",closeButtonTitle: "Cancel")
    
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return screen.height/10
    }
    
    //************ table view **************
    
    //************ textField **************
    func textFieldDidBeginEditing(textField: UITextField) {
        self.view.addSubview(uiview_blockView)
        
        self.view.bringSubviewToFront(textField)
        if(textField.tag == 1){
            self.view.bringSubviewToFront(self.btn_add)
        }else if(textField.tag == 2){
            self.view.bringSubviewToFront(self.btn_done)
        }
        
        textField.borderStyle = UITextBorderStyle.RoundedRect
        
        UIView.animateWithDuration(0.3, animations: {
            textField.frame = CGRectMake(30, screen.height/2, screen.width-160, 50)
            if(textField.tag == 1){
                self.btn_add.frame = CGRectMake(screen.width-110, screen.height/2, 80,50)
                self.btn_add.backgroundColor = red_light
                self.btn_add.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            }else if(textField.tag == 2){
                self.btn_done.frame = CGRectMake(screen.width-120, screen.height/2, 100,50)
                self.btn_done.backgroundColor = red_light
                self.btn_done.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)

            }
            }, completion: nil)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        UIView.animateWithDuration(0.3, animations: {
            if(textField.tag == 1){
                textField.frame = CGRectMake(30, screen.height*3/4, screen.width-160, 50)
                self.btn_add.frame = CGRectMake(screen.width-110, screen.height*3/4, 80,50)
                self.btn_add.backgroundColor = UIColor.clearColor()
                self.btn_add.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)

            }else if(textField.tag == 2){
                textField.frame = CGRectMake(30, screen.height*3/4+60, screen.width-160, 50)
                self.btn_done.frame = CGRectMake(screen.width-120, screen.height*3/4+60, 100,50)
                self.btn_done.backgroundColor = UIColor.clearColor()
                self.btn_done.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                
                if(self.textField_title.text != ""){
                    self.label_new.text = self.textField_title.text!
                }
            }
            }, completion: {
                finished in
                textField.borderStyle = UITextBorderStyle.None
                self.uiview_blockView.removeFromSuperview()
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if(textField.tag == 2){
            label_new.text = textField_title.text!
        }
        return true
    }
    //************ textField **************
    
    func backToList(){
        if(textField_title.text == "" && self.items.count > 0){
            let alert = SCLAlertView()
            alert.addButton("let her die", action: {
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            alert.showError("Can't save it", subTitle: "she wants to have a name to be remembered", closeButtonTitle: "alright sweety")
        }
        
        else if(self.items.count == 0 && textField_title.text != ""){
            let alert = SCLAlertView()
            alert.addButton("quit directly", action: {
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            alert.showError("Can't save it", subTitle: "a list can't be a list without any items in it", closeButtonTitle: "add smartly")
        }
        
        else if(textField_title.text != nil && textField_title.text != "" && self.items.count != 0 ){
            let db = FMDatabase(path: dbFilePath)
            
            guard db.open() else {
                print("Error:\(db.lastErrorMessage())")
                return
            }
            
            let list = textField_title.text!
            
            for item in items{
                let insertPersonStatement = "INSERT INTO ITEMS (NAME,HOST) VALUES (?,?)"
                do{
                    try db.executeUpdate(insertPersonStatement, values: [item,list ?? NSNull()])
                }catch{
                    print("Error:\(error)")
                }
            }
            
            let insertPersonStatement = "INSERT INTO LISTS (TITLE) VALUES (?)"
            do{
                try db.executeUpdate(insertPersonStatement, values: [list ?? NSNull()])
                db.close()
            }catch{
                db.close()
                print("Error:\(error)")
            }
            self.view.endEditing(true)

            let alert = SCLAlertView()
            alert.showError("Success", subTitle: "a new list has been saved", closeButtonTitle: "great", duration: 1)
            self.dismissViewControllerAnimated(true, completion: nil)

        }
        else{
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    func add(){
        
        if(textField_newItem.text != nil && textField_newItem.text != ""){
                        
            items.append(textField_newItem.text!)
            table_itemTable.reloadData()
            
            self.view.endEditing(true)
            textField_newItem.text = ""
        }
    }
    
    func done(){
       self.view.endEditing(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //let fetchRequest = NSFetchRequest("")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        textField_newItem.tag = 1
        textField_title.tag = 2
        
        uiview_blockView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        //allocate all the positions in stack view
        //stackView_stack.frame = self.view.frame
        btn_list.center.x = self.view.frame.width - 50
        //table_listTable.center.x = stackView_stack.center.x
        
        btn_list.setTitle("List", forState: UIControlState.Normal)
        btn_list.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn_list.setTitleColor(red_light, forState: UIControlState.Highlighted)
        btn_list.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Light", size: 40)
        btn_list.backgroundColor = UIColor.clearColor()
        btn_list.addTarget(self, action: "backToList", forControlEvents: UIControlEvents.TouchUpInside)
        btn_list.pulseColor = red
        self.view.addSubview(btn_list)
        
        label_new.text = "New"
        label_new.font = UIFont(name: "AppleSDGothicNeo-Light", size: 50)
        label_new.backgroundColor = UIColor.clearColor()
        label_new.textColor = UIColor.grayColor()
        label_new.morphingEffect = LTMorphingEffect.Scale
        self.view.addSubview(label_new)
        
        textField_newItem.backgroundColor = UIColor.clearColor()
        textField_newItem.clearButtonMode = UITextFieldViewMode.WhileEditing
        textField_newItem.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 40)
        textField_newItem.delegate = self
        textField_newItem.placeholder = "New Item"
        textField_newItem.adjustsFontSizeToFitWidth = true
        
        textField_title.backgroundColor = UIColor.clearColor()
        textField_title.clearButtonMode = UITextFieldViewMode.WhileEditing
        textField_title.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 40)
        textField_title.delegate = self
        textField_title.placeholder = "Set Title"
        textField_title.adjustsFontSizeToFitWidth = true
        
        btn_add.backgroundColor=UIColor.clearColor()
        btn_add.layer.cornerRadius = 5
        btn_add.setTitle("add", forState: UIControlState.Normal)
        btn_add.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn_add.setTitleColor(red_light, forState: UIControlState.Highlighted)
        btn_add.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 30)
        btn_add.addTarget(self, action: "add", forControlEvents: UIControlEvents.TouchUpInside)
        btn_add.pulseColor = red

        btn_done.backgroundColor=UIColor.clearColor()
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

        let bgimg = UIImage(named: "snowhill")
        let bg = UIImageView(frame: screen)
        bg.image = bgimg
        
        self.view.addSubview(bg)
        self.view.sendSubviewToBack(bg)

        //self.view.addSubview(stackView_stack)
        self.view.backgroundColor = UIColor.clearColor()

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
