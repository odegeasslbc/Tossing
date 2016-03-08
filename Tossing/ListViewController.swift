//
//  ViewController.swift
//  Tossing
//
//  Created by 刘炳辰 on 16/2/15.
//  Copyright © 2016年 刘炳辰. All rights reserved.
//

import UIKit

let screen = UIScreen.mainScreen().bounds

var lists = [List]()
let table_listTable = TTableView(frame: CGRectMake(30, 100, screen.width-60, screen.height-240))

var dbFilePath: String!

var bgColor = UIColor(red: 1, green: 160/255, blue: 165/255, alpha: 1)

struct List {
    let title:String
    var star:Bool
}

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
        if #available(iOS 9.0, *) {
            previewingContext.sourceRect = cell.frame
        } else {
            // Fallback on earlier versions
        }
        
        return previewVC
    }
}

extension ListViewController:UITableViewDataSource, UITableViewDelegate, TTableViewCellDelegate{
    
    func check() {
        queryLists()
        
        UIView.animateWithDuration(0.5, animations: {
            table_listTable.center = CGPointMake(-screen.width/2+30, screen.height/2-20)
            }, completion:
            {finished in
                UIView.animateWithDuration(0.1, animations: {
                    table_listTable.reloadRowsAtIndexPaths(table_listTable.indexPathsForVisibleRows!, withRowAnimation: .None)
                    }, completion: {
                    finished in
                        table_listTable.center = CGPointMake(screen.width*3/2-30, screen.height/2-20)

                        UIView.animateWithDuration(0.5, animations: {
                            table_listTable.center = CGPointMake(screen.width/2, screen.height/2-20)
                            }, completion: nil)
                })
        })
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TTableViewCell", forIndexPath: indexPath) as! TTableViewCell
        
        let list = lists[indexPath.section]
        cell.textLabel?.text = list.title
        cell.checked = list.star
        cell.tDelegate = self
        
        if(canEditing==0){
            cell.hideSign()
        }else{
            cell.showSign()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return lists.count
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
            let title = (table_listTable.cellForRowAtIndexPath(indexPath) as! TTableViewCell).textLabel?.text
            let newVC = DetailViewController(title: title!)
            //newVC.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
            self.presentViewController(newVC, animated: true, completion: nil)
            
        }else if(canEditing == 1){
            
            let listTitle = tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text!
            let alert = SCLAlertView()
            
            alert.addButton("Delete", action: {
                lists.removeAtIndex(indexPath.section)
                tableView.deleteSections(NSIndexSet(index:indexPath.section), withRowAnimation: .Right)
                
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
    
    //************ table view **************

}

class ListViewController: UIViewController{
    
    
    //let stackView_stack = UIStackView(frame: CGRectMake(0, 0, screen.width, screen.height))
    let label_list = UILabel(frame: CGRectMake(18, 30, screen.width-18, 60))
    let animeView_effectView = UIView(frame: CGRectMake(0, 0, 1, 1))
    
    let btn_edit = EditButton(frame: CGRectMake(screen.width-110, 30, 100, 55))
    let btn_add = FabButton(frame: CGRectMake(screen.width/2 - 32, screen.height-110, 64, 64))

    var previewVC:DetailViewController?
    var canEditing = 0
    
    func showNewAdd(){
        let newVC = AddNewViewController()
        self.presentViewController(newVC, animated: true, completion: nil)
    }
    
    func edit(){
        if(canEditing==0){
            canEditing = 1
            btn_edit.editing()
            table_listTable.reloadData()
        }else{
            canEditing = 0
            btn_edit.normal()
            table_listTable.reloadData()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.modalPresentationStyle = .Custom
        
        //allocate all the positions in stack view
        //stackView_stack.frame = self.view.frame
        btn_add.center.x = self.view.center.x
        table_listTable.center.x = self.view.center.x
        
        label_list.text = "List"
        label_list.font = UIFont(name: "AppleSDGothicNeo-Light", size: 50)
        label_list.backgroundColor = UIColor.clearColor()
        label_list.textColor = red_light
        self.view.addSubview(label_list)
        
        table_listTable.dataSource = self
        table_listTable.delegate = self
        table_listTable.separatorStyle = UITableViewCellSeparatorStyle.None
        self.view.addSubview(table_listTable)
        

        let img: UIImage? = UIImage(named: "add_circle")
        btn_add.setImage(img, forState: .Normal)
        btn_add.setImage(img, forState: .Highlighted)
        btn_add.layer.cornerRadius = 32
        btn_add.addTarget(self, action: "showNewAdd", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn_add)
        
        //btn_edit.setTitle("", forState: UIControlState.Normal)
        //btn_edit.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        //btn_edit.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Light", size: 41)
        //btn_edit.titleLabel?.textAlignment = NSTextAlignment.Center
        btn_edit.addTarget(self, action: "edit", forControlEvents: .TouchUpInside)
        self.view.addSubview(btn_edit)
        
        //self.view.addSubview(stackView_stack)
        let bgimg = UIImage(named: "11")
        let bg = UIImageView(frame: screen)
        bg.image = bgimg
        
        let blurEffect = UIBlurEffect(style: .Light)
        let blurView = UIVisualEffectView(frame: self.view.frame)
        blurView.effect = blurEffect
        
        self.view.addSubview(blurView)
        self.view.sendSubviewToBack(blurView)
        
        self.view.addSubview(bg)
        self.view.sendSubviewToBack(bg)
        
        canEditing = 0
        
        //self.view.backgroundColor = bgColor
        if #available(iOS 9.0, *) {
            if traitCollection.forceTouchCapability == .Available{
                registerForPreviewingWithDelegate(self, sourceView: table_listTable)
            }
        } else {
            // Fallback on earlier versions
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
                let star = resultSet.boolForColumn("STAR")
                if star{
                    lists.insert(List(title: title, star: star), atIndex: 0)
                }else{
                    lists.append(List(title: title, star: star))
                }
            }
        }
        db.close()
        
        //table_listTable.reloadData()
        
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

