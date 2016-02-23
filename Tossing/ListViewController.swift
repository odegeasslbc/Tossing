//
//  ViewController.swift
//  Tossing
//
//  Created by 刘炳辰 on 16/2/15.
//  Copyright © 2016年 刘炳辰. All rights reserved.
//

import UIKit

let screen = UIScreen.mainScreen().bounds

var lists = [String]()
let table_listTable = TTableView(frame: CGRectMake(30, 110, screen.width-60, 350))

var dbFilePath: String!

extension ListViewController:  UIViewControllerPreviewingDelegate {
    
    //pop
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        showViewController(previewVC!, sender: self)
    }
    
    //peak
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = table_listTable.indexPathForRowAtPoint(location),
            cell = table_listTable.cellForRowAtIndexPath(indexPath) else{ return nil}
        
        let title = cell.textLabel?.text
        previewVC = DetailViewController(title: title!)
        
        previewVC!.preferredContentSize = CGSize(width: screen.width-60, height: screen.height/3)
        previewingContext.sourceRect = cell.frame
        
        return previewVC
    }
}

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    let stackView_stack = UIStackView(frame: CGRectMake(0, 0, screen.width, screen.height))
    let btn_add = FabButton(frame: CGRectMake(screen.width/2 - 32, screen.height-100, 64, 64))
    let label_list = UILabel(frame: CGRectMake(18, 30, screen.width-18, 60))
    let animeView_effectView = UIView(frame: CGRectMake(0, 0, 1, 1))
    let btn_edit = FlatButton(frame: CGRectMake(screen.width-110, 30, 100, 55))

    var previewVC:DetailViewController?
    var canEditing = 0
    //************ table view **************
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TTableViewCell", forIndexPath: indexPath) as! TTableViewCell
        
        let list = lists[indexPath.row]
        cell.textLabel?.text = list
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        //table_listTable.cellForRowAtIndexPath(indexPath)?.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
    }
    
    func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        //table_listTable.cellForRowAtIndexPath(indexPath)?.backgroundColor = UIColor.whiteColor()
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete){
           print("lalala")
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(canEditing == 0){
            let title = table_listTable.cellForRowAtIndexPath(indexPath)?.textLabel?.text
            let newVC = DetailViewController(title: title!)
            //newVC.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
            self.presentViewController(newVC, animated: true, completion: nil)
        
        }else if(canEditing == 1){
            
            let listTitle = tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text!
            let alert = SCLAlertView()
            
            alert.addButton("Delete", action: {
                lists.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Right)
                
                let db = FMDatabase(path: dbFilePath)
                guard db.open() else {
                    print("Error:\(db.lastErrorMessage())")
                    return
                }
                
                let deleteListStatement = "DELETE FROM LISTS WHERE TITLE = '\(listTitle!)'"
                let deleteItemStatement = "DELETE FROM ITEMS WHERE HOST = '\(listTitle!)'"
                if !db.executeStatements(deleteListStatement) {
                    print("error when delete")
                }
                if !db.executeStatements(deleteItemStatement) {
                    print("error when delete")
                }
                db.close()
            })
            alert.showNotice(listTitle!, subTitle: "are you sure to delete it?",closeButtonTitle: "Cancel")
        
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return screen.height/10
    }
    
    //************ table view **************
    
    //************ FMDB ******
    

    
    //************ FMDB ******
    
    func showNewAdd(){
        let newVC = AddNewViewController()
        self.presentViewController(newVC, animated: true, completion: nil)
    }
    
    func edit(){
        if(canEditing==0){
            canEditing = 1
            btn_edit.backgroundColor = UIColor(red: 0.964, green: 0.276, blue: 0.244, alpha: 1)
            btn_edit.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }else{
            canEditing = 0
            btn_edit.backgroundColor = UIColor.clearColor()
            btn_edit.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //allocate all the positions in stack view
        stackView_stack.frame = self.view.frame
        btn_add.center.x = stackView_stack.center.x
        table_listTable.center.x = stackView_stack.center.x
        
        label_list.text = "List"
        label_list.font = UIFont(name: "AppleSDGothicNeo-Light", size: 50)
        label_list.backgroundColor = UIColor.clearColor()
        label_list.textColor = UIColor.grayColor()
        stackView_stack.addSubview(label_list)
        
        table_listTable.dataSource = self
        table_listTable.delegate = self
        table_listTable.separatorStyle = UITableViewCellSeparatorStyle.None
        stackView_stack.addSubview(table_listTable)
        

        let img: UIImage? = UIImage(named: "add_circle")
        btn_add.setImage(img, forState: .Normal)
        btn_add.setImage(img, forState: .Highlighted)
        btn_add.layer.cornerRadius = 32
        btn_add.addTarget(self, action: "showNewAdd", forControlEvents: UIControlEvents.TouchUpInside)
        stackView_stack.addSubview(btn_add)
        
        btn_edit.setTitle("Edit", forState: UIControlState.Normal)
        btn_edit.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn_edit.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Light", size: 41)
        btn_edit.titleLabel?.textAlignment = NSTextAlignment.Center
        btn_edit.addTarget(self, action: "edit", forControlEvents: .TouchUpInside)
        stackView_stack.addSubview(btn_edit)
        
        self.view.addSubview(stackView_stack)
        
        if traitCollection.forceTouchCapability == .Available{
            registerForPreviewingWithDelegate(self, sourceView: table_listTable)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func queryLists(){
        
        lists.removeAll(keepCapacity: false)
        let db = FMDatabase(path: dbFilePath)
        guard db.open() else {
            print("Error:\(db.lastErrorMessage())")
            return
        }
        
        let queryPersonStatement = "SELECT * FROM LISTS"
        if let resultSet = db.executeQuery(queryPersonStatement,withArgumentsInArray: nil){
            while resultSet.next(){
                let title = resultSet.stringForColumn("TITLE")
                lists.append(title)
            }
        }
        db.close()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        queryLists()
        
        table_listTable.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

