//
//  DetailViewController.swift
//  Tossing
//
//  Created by 刘炳辰 on 16/2/15.
//  Copyright © 2016年 刘炳辰. All rights reserved.
//

import UIKit

extension DetailViewController: UITableViewDataSource, UITableViewDelegate{
    //************ table view **************
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
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = clear
        return view
    }


}

extension DetailViewController: UITextFieldDelegate{

    func textFieldDidBeginEditing(textField: UITextField) {
        
        self.view.addSubview(uiview_blockView)
        
        self.view.bringSubviewToFront(textField)
        self.view.bringSubviewToFront(self.btn_add)
        
        self.resultView?.hide()
        
        UIView.animateWithDuration(0.3, animations: {
            textField.frame = CGRectMake(30, screen.height-350, screen.width-160, 50)
            self.btn_add.frame = CGRectMake(screen.width-110, screen.height-350, 80,50)
            self.btn_add.backgroundColor = red_light
            self.btn_add.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            }, completion: nil)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        UIView.animateWithDuration(0.3, animations: {
            textField.frame = CGRectMake(30, screen.height*3/5, screen.width-160, 40)
            self.btn_add.frame = CGRectMake(screen.width-110, screen.height*3/5, 80,50)
            }, completion: {
                finished in
                textField.borderStyle = UITextBorderStyle.None
                self.uiview_blockView.removeFromSuperview()
                
                self.btn_add.backgroundColor = light
                self.btn_add.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }

}

class DetailViewController: UIViewController{
    
    var items = [String]()
    
    //let stackView_stack = UIStackView(frame: CGRectMake(0, 0, screen.width, screen.height))
    var label_title = UILabel(frame: CGRectMake(18, 30, screen.width-118, 60))
    
    let table_itemTable = TTableView(frame: CGRectMake(30, 100, screen.width-60, screen.height*3/5-130))
    
    let uiview_blockView = UIVisualEffectView(frame: CGRectMake(0, 0, screen.width, screen.height))
    
    let textField_newItem = TextField(frame: CGRectMake(30, screen.height*3/5, screen.width-160, 40))

    let btn_add = FlatButton(frame: CGRectMake(screen.width-110, screen.height*3/5, 80,50))
    let btn_get = FlatButton(frame: CGRectMake(screen.width/2-80,screen.height*3/5 + 80, 160, 140))
    
    let btn_list = TossButton(frame: CGRectMake(screen.width-110, 30, 100, 55), normalText: "Back", highlightText: "Back")

    var resultView: ResultView?
    
    var list:String?
    
    let bg = UIImageView(frame: screen)

    var gesture = UIPanGestureRecognizer()
    var getCounts = 1
        //************ table view **************
    
    
    
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
        self.resultView?.removeFromSuperview()
        print("prase")
        self.navigationController?.popToRootViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func add(){
        if(textField_newItem.text != nil && textField_newItem.text != ""){
            
            if(textField_newItem.text?.characters.count > 18){
                let alert = SCLAlertView()
                alert.showError("Sorry", subTitle: "I can't remember such a long sentence right now", closeButtonTitle: "ok forgive you", duration: 3)
            }else{
                items.append(textField_newItem.text!)
                
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
                
                self.view.endEditing(true)
                textField_newItem.text = ""
                
                items.removeAll(keepCapacity: false)
                
                self.getItems()
                table_itemTable.reloadData()
            }
        }
    }
    
    func get(){
        
        if(getCounts == 1){

            self.view.addSubview(resultView!)
        }
        
        getItems()
        
        let t = items.count
        let nbr = Int(arc4random_uniform(UInt32(t)))
        
        if items.count != 0{
            let result = items[nbr]

            let charCount = result.characters.count
            
            if(charCount<5){
                resultView?.label_result?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 90)
            }else if(charCount<9){
                resultView?.label_result?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 50)
            }else{
                resultView?.label_result?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
            }
            
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
            if list.title == title{
                self.list = list.title
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
    
        let blurEffect = UIBlurEffect(style: .Light)
        uiview_blockView.effect = blurEffect
        
        btn_list.addTarget(self, action: "backToList", forControlEvents: UIControlEvents.TouchUpInside)
        btn_list.pulseColor = red
        self.view.addSubview(btn_list)
        
        label_title.font = UIFont(name: "AppleSDGothicNeo-Light", size: 50)
        label_title.backgroundColor = UIColor.clearColor()
        label_title.textColor = red_light
        label_title.adjustsFontSizeToFitWidth = true
        self.view.addSubview(label_title)
        
        table_itemTable.backgroundColor = UIColor.clearColor()
        table_itemTable.dataSource = self
        table_itemTable.delegate = self
        table_itemTable.separatorStyle = UITableViewCellSeparatorStyle.None
        self.view.addSubview(table_itemTable)
        
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
        
        let image = UIImage(named: "ic_close_white_3x")?.imageWithRenderingMode(.AlwaysTemplate)
        let clearButton: FlatButton = FlatButton()
        clearButton.pulseColor = MaterialColor.grey.base
        clearButton.pulseScale = false
        clearButton.tintColor = MaterialColor.grey.base
        clearButton.setImage(image, forState: .Normal)
        clearButton.setImage(image, forState: .Highlighted)
        
        textField_newItem.clearButton = clearButton
        
        self.view.addSubview(textField_newItem)
        
        btn_add.backgroundColor = light
        btn_add.layer.cornerRadius = 5
        btn_add.setTitle("add", forState: UIControlState.Normal)
        btn_add.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn_add.setTitleColor(red_light, forState: UIControlState.Highlighted)
        btn_add.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 30)
        btn_add.addTarget(self, action: "add", forControlEvents: UIControlEvents.TouchUpInside)
        btn_add.pulseColor = red
        self.view.addSubview(btn_add)
        
        btn_get.backgroundColor = light
        btn_get.setTitle("GET", forState: UIControlState.Normal)
        btn_get.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn_get.setTitleColor(red_light, forState: UIControlState.Highlighted)
        btn_get.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Light", size: 60)
        btn_get.addTarget(self, action: "get", forControlEvents: UIControlEvents.TouchUpInside)
        btn_get.pulseColor = red
        self.view.addSubview(btn_get)
        
        let frame = CGRectMake(10, table_itemTable.frame.minY, screen.width-20, table_itemTable.frame.height)
        let initFrame = CGRectMake(frame.minX, -frame.height, frame.width, frame.height)
        resultView = ResultView(initFrame: initFrame, finalFrame: frame)
        
        bg.image = bgimg
        
        let Effect = UIBlurEffect(style: .Light)
        let blurView = UIVisualEffectView(frame: self.view.frame)
        blurView.effect = Effect
        
        self.view.addSubview(blurView)
        self.view.sendSubviewToBack(blurView)
        
        self.view.addSubview(bg)
        self.view.sendSubviewToBack(bg)
    }
    
    override func viewWillAppear(animated: Bool) {
        bg.image = UIImage(named: "3")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

struct RegexHelper {
    let regex: NSRegularExpression
    
    init(_ pattern: String) throws {
        try regex = NSRegularExpression(pattern: pattern,
            options: .CaseInsensitive)
    }
    
    func match(input: String) -> Bool {
        let matches = regex.matchesInString(input,
            options: [],
            range: NSMakeRange(0, input.characters.count))
        return matches.count > 0
    }
}
