//
//  DetailViewController.swift
//  Tossing
//
//  Created by 刘炳辰 on 16/2/15.
//  Copyright © 2016年 刘炳辰. All rights reserved.
//

import UIKit

extension DetailViewController: LTMorphingLabelDelegate{

}

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{
    
    var items = [String]()
    
    let stackView_stack = UIStackView(frame: CGRectMake(0, 0, screen.width, screen.height))
    var label_title = UILabel(frame: CGRectMake(18, 30, screen.width-118, 60))
    let btn_list = UIButton(frame: CGRectMake(screen.width-100, 30, 100, 60))
    let effectView = UIView(frame: CGRectMake(0, 0, 1, 1))
    let table_itemTable = TTableView(frame: CGRectMake(30, 100, screen.width-60, screen.height*3/5-130))
    let uiview_blockView = UIView(frame: CGRectMake(0, 0, screen.width, screen.height))
    let textField_newItem = UITextField(frame: CGRectMake(30, screen.height*3/5, screen.width-160, 50))
    let btn_add = UIButton(frame: CGRectMake(screen.width-110, screen.height*3/5, 80,50))
    let btn_get = UIButton(frame: CGRectMake(screen.width/2-80,screen.height*3/5 + 80, 160, 140))
    var resultView: ResultView?
    
    var list:String?
    
    var gesture = UIPanGestureRecognizer()
    var getCounts = 1
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
            
            let db = FMDatabase(path: dbFilePath)
            guard db.open() else {
                print("Error:\(db.lastErrorMessage())")
                return
            }
            
            //in case of multip same results and not delete all of them, only pick one by id
            var id:Int32 = 0
            let queryStatement = "SELECT * FROM ITEMS WHERE HOST = '\(self.list!)'"
            if let resultSet = db.executeQuery(queryStatement,withArgumentsInArray: nil){
                while resultSet.next(){
                    if resultSet.stringForColumn("NAME") == itemName{
                        id = resultSet.intForColumn("ID")
                    }
                }
            }
            
            let deleteStatement = "DELETE FROM ITEMS WHERE ID = '\(id)' AND HOST = '\(self.list!)'"
            if !db.executeStatements(deleteStatement) {
                print("error when delete")
            }
            db.close()
        })
        alert.showNotice(itemName!, subTitle: "are you sure to delete it?",closeButtonTitle: "Cancel")
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return screen.height/10
    }
    
    //************ table view **************
    
    //************ textField **************
    func textFieldDidBeginEditing(textField: UITextField) {
        stackView_stack.addSubview(uiview_blockView)
        
        stackView_stack.bringSubviewToFront(textField)
        stackView_stack.bringSubviewToFront(self.btn_add)
        textField.borderStyle = UITextBorderStyle.RoundedRect
        
        UIView.animateWithDuration(0.3, animations: {
            textField.frame = CGRectMake(30, screen.height/2, screen.width-160, 50)
            self.btn_add.frame = CGRectMake(screen.width-110, screen.height/2, 80,50)
            }, completion: nil)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
    
        UIView.animateWithDuration(0.3, animations: {
            textField.frame = CGRectMake(30, screen.height*3/5, screen.width-160, 50)
            self.btn_add.frame = CGRectMake(screen.width-110, screen.height*3/5, 80,50)
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
    //************ textField **************
    
    
    func getItems(){
        let db = FMDatabase(path: dbFilePath)
        guard db.open() else {
            print("Error:\(db.lastErrorMessage())")
            return
        }
        
        let queryPersonStatement = "SELECT * FROM ITEMS"

        if let resultSet = db.executeQuery(queryPersonStatement,withArgumentsInArray: nil){
            while resultSet.next(){
                let name = resultSet.stringForColumn("NAME")
                let host = resultSet.stringForColumn("HOST")
                if(host == self.list!){
                    self.items.append(name)
                }
            }
        }
        db.close()
    }

    func backToList(){
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func btnAnime(){
        effectView.frame = CGRectMake(btn_list.center.x-10, btn_list.center.y-10, 20, 20)
        effectView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        self.stackView_stack.addSubview(effectView)
        effectView.layer.cornerRadius = 10
        UIView.animateWithDuration(1, animations: {
            self.effectView.frame = self.btn_list.frame
            }, completion: {
                finished in
                self.effectView.removeFromSuperview()
        })
    }
    
    func stopAnime(){
        effectView.removeFromSuperview()
    }
    
    func add(){
        if(textField_newItem.text != nil && textField_newItem.text != ""){
            
            let db = FMDatabase(path: dbFilePath)
            
            guard db.open() else {
                print("Error:\(db.lastErrorMessage())")
                return
            }
            
            let insertPersonStatement = "INSERT INTO ITEMS (NAME,HOST) VALUES (?,?)"
            do{
                try db.executeUpdate(insertPersonStatement, values: [self.textField_newItem.text!, self.list ?? NSNull()])
                db.close()
            }catch{
                db.close()
                print("Error:\(error)")
            }

            items.append(textField_newItem.text!)
            
            self.view.endEditing(true)
            textField_newItem.text = ""
            table_itemTable.reloadData()
        }
    }
    
    func get(){
        getItems()
        
        let t = items.count
        let nbr = Int(arc4random_uniform(UInt32(t)))
        
        if items.count != 0{
            let result = items[nbr]
            /*
            let blurEffect = UIBlurEffect(style: .ExtraLight)
            let blurredEffectView = UIVisualEffectView(effect: blurEffect)
            blurredEffectView.frame = table_itemTable.frame


            self.stackView_stack.addSubview(blurredEffectView)
            */
                resultView?.label_result?.text = result
                resultView?.label_count?.text = "\(self.getCounts)"
                self.getCounts += 1
            if(!resultView!.showing){
                resultView?.show()
            }
        
        }
    }
    
    func move(sender: UIPanGestureRecognizer){
        if sender == gesture{
            self.view.bringSubviewToFront(sender.view!)

            let trans = gesture.translationInView(self.view)
            sender.view?.center = CGPointMake((sender.view?.center.x)! + trans.x, sender.view!.center.y + trans.y)
            gesture.setTranslation(CGPointZero, inView: self.view)
        }
    }
    
    init(title:String){
        super.init(nibName: nil, bundle: nil)
        self.title = title
        label_title.text = title
        
        
        gesture.addTarget(self, action: "move:")
        
 
        for list in lists{
            if list == title{
                self.list = list
                break
            }
        }
        
        getItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = UIColor.whiteColor()
    
    uiview_blockView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    
    //allocate all the positions in stack view
    stackView_stack.frame = self.view.frame
    btn_list.center.x = stackView_stack.frame.width - 50
    //table_listTable.center.x = stackView_stack.center.x
    
    btn_list.setTitle("List", forState: UIControlState.Normal)
    btn_list.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
    btn_list.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Light", size: 50)
    btn_list.backgroundColor = UIColor.clearColor()
    btn_list.addTarget(self, action: "btnAnime", forControlEvents: UIControlEvents.TouchDown)
    btn_list.addTarget(self, action: "stopAnime", forControlEvents: UIControlEvents.TouchDragExit)
    btn_list.addTarget(self, action: "backToList", forControlEvents: UIControlEvents.TouchUpInside)
    stackView_stack.addSubview(btn_list)
    
    label_title.font = UIFont(name: "AppleSDGothicNeo-Light", size: 50)
    label_title.backgroundColor = UIColor.clearColor()
    label_title.textColor = UIColor.grayColor()
    label_title.adjustsFontSizeToFitWidth = true
    stackView_stack.addSubview(label_title)
    
    table_itemTable.backgroundColor = UIColor.whiteColor()
    table_itemTable.dataSource = self
    table_itemTable.delegate = self
    table_itemTable.separatorStyle = UITableViewCellSeparatorStyle.None
    stackView_stack.addSubview(table_itemTable)
    
    textField_newItem.backgroundColor = UIColor.whiteColor()
    textField_newItem.clearButtonMode = UITextFieldViewMode.WhileEditing
    textField_newItem.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 40)
    textField_newItem.delegate = self
    textField_newItem.placeholder = "New Item"
    textField_newItem.adjustsFontSizeToFitWidth = true
    stackView_stack.addSubview(textField_newItem)
    
    btn_add.backgroundColor=UIColor.clearColor()
    btn_add.layer.cornerRadius = 5
    btn_add.setTitle("Add", forState: UIControlState.Normal)
    btn_add.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
    btn_add.setTitleColor(UIColor.redColor(), forState: UIControlState.Highlighted)
    btn_add.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 40)
    btn_add.addTarget(self, action: "add", forControlEvents: UIControlEvents.TouchUpInside)
    stackView_stack.addSubview(btn_add)
    
    btn_get.backgroundColor=UIColor.clearColor()
    btn_get.setTitle("GET", forState: UIControlState.Normal)
    btn_get.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
    btn_get.setTitleColor(UIColor.redColor(), forState: UIControlState.Highlighted)
    btn_get.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Light", size: 60)
    btn_get.addTarget(self, action: "get", forControlEvents: UIControlEvents.TouchUpInside)
    stackView_stack.addSubview(btn_get)
    
    self.view.addSubview(stackView_stack)
        
        let frame = table_itemTable.frame
        let initFrame = CGRectMake(frame.minX, -frame.height, frame.width, frame.height)
        resultView = ResultView(initFrame: initFrame, finalFrame: frame)
        self.view.addSubview(resultView!)
    
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    // Dispose of any resources that can be recreated.
    }


}