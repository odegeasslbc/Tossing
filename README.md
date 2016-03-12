# Tossing
A decision-make helper

## Description:
You can use this app to create many "lists" which each list contains several choices, 
this app will return you one choice randomly to help you make the decision, 
just like tossing a coin.

#####For example: 
You can create a list called "what to eat", and in the list you add "pizza", "steak" and "MacDonald",
it will randomly return you an item to help you decide what to eat for the meal. 

And you have another list called "working schedual", then you add "prepare for cs exam", "writing the paper",
"nap for 10 min" and "play basketball to relax", it can help you make a schedual what to do next, but randomly!

Demo of the app:

![alt tag](https://cloud.githubusercontent.com/assets/9973368/13720484/1a1b77f6-e7d8-11e5-870d-c14b6a376080.gif)

![alt tag](https://cloud.githubusercontent.com/assets/9973368/13720432/7edbd200-e7d6-11e5-8b98-cb072ea2d198.gif)

## Technical Specs

###1. Database 
####1. Sqlite by FMDB
Use sqlite as database and operate by an implementation of FMDB:
```swift
    private func initDB(){
        let defaultManager = NSFileManager.defaultManager()
        dbFilePath = defaultManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!.URLByAppendingPathComponent("tosse.db").path!
        print(dbFilePath)
        
        let dbListCreateStatements = "CREATE TABLE IF NOT EXISTS LISTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, TITLE TEXT, STAR BOOL)";
        let dbItemCreateStatements = "CREATE TABLE IF NOT EXISTS ITEMS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, HOST TEXT)";
        
        
        let personDB = FMDatabase(path: dbFilePath)
        
        if personDB == nil{
            print("Error:\(personDB.lastErrorMessage())")
        }else{
            if personDB.open(){
                if !personDB.executeStatements(dbListCreateStatements){
                    print("Error:\(personDB.lastErrorMessage())")
                }
                if !personDB.executeStatements(dbItemCreateStatements){
                    print("Error:\(personDB.lastErrorMessage())")
                }
            }
            personDB.close()
        }
    }
```
```swift
        let db = FMDatabase(path: dbFilePath)
        guard db.open() 
        else {
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
```

#### 2. CoreData
For the convenience of saving only one background image, I simply use CoreData provided by Apple.

** Note that a large number of images is not recommended to store in sandbox, saving the url of each image is prefered, for both storage concern and efficiency concern.

```swift
    func getDocumentsURL() -> NSURL {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return documentsURL
    }

    func fileInDocumentsDirectory(filename: String) -> String {
    
        let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
        return fileURL.path!
    
    }

    func saveImage(image:UIImage){
        let imgData = UIImagePNGRepresentation(image)
        let imagePath = fileInDocumentsDirectory("background_image")
        _ = imgData?.writeToFile(imagePath, atomically: true)
    }

    func loadImage() {
        let imagePath = fileInDocumentsDirectory("background_image")
        let image = UIImage(contentsOfFile: imagePath)
        if(image != nil){
            bgimg = image
        }
        bg.image = bgimg
    }
```

#### 3. Plist (property list)
Saving settings and configurations into a plist is an easy and fast way to keep light data instead of using a database.
Accordingly, we cannot perform complex operations and manage a large amount of data in table by such a method.

```swift

    func saveBlur(blur:String){
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("Theme.plist")
        let data: NSMutableArray = [blur]
        
        data.writeToFile(path, atomically: true)
    }
    
    func loadBlur() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("Theme.plist")
        let fileManager = NSFileManager.defaultManager()
        
        // Check if file exists
        if(!fileManager.fileExistsAtPath(path))
        {
            print("no")
            // If it doesn't, copy it from the default file in the Resources folder
            let bundle = NSBundle.mainBundle().pathForResource("Theme", ofType: "plist")
            do{
                try fileManager.copyItemAtPath(bundle!, toPath: path)
            }catch{
                print(error)
            }
        }
        let data = NSMutableArray(contentsOfFile: path)
        if(data != nil){
            if data![0] as! String == "no"{
                shouldBlur = false
            }else{
                shouldBlur = true
            }
        }
    }
```
###2. UIDesign and Animation

####1. Animation between UIViewControllers
```swift
class CircleTransitionForwardAnimator: NSObject, UIViewControllerAnimatedTransitioning{
    weak var transitionContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.7
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // 1
        self.transitionContext = transitionContext
        
        // 2
        let containerView = transitionContext.containerView()
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! ListViewController
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! SettingViewController
        let button = fromViewController.btn_list
        
        UIView.animateWithDuration(0.1, delay: 0.7, options: UIViewAnimationOptions.CurveLinear, animations: {
            fromViewController.blurView.frame = blurInitialFrame
        }, completion: nil)
        // 3
        containerView!.addSubview(toViewController.view)
        
        // 4
        let circleMaskPathInitial = UIBezierPath(ovalInRect: button.frame)
        let circleMaskPathFinal = UIBezierPath(ovalInRect: CGRectInset(button.frame, -1000, -1000))
        
        // 5
        let maskLayer = CAShapeLayer()
        maskLayer.path = circleMaskPathFinal.CGPath
        toViewController.view.layer.mask = maskLayer
        
        // 6
        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = circleMaskPathInitial.CGPath
        maskLayerAnimation.toValue = circleMaskPathFinal.CGPath
        maskLayerAnimation.duration = self.transitionDuration(self.transitionContext!)
        maskLayerAnimation.delegate = self
        maskLayer.addAnimation(maskLayerAnimation, forKey: "CircleAnimation")
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        self.transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled())
        self.transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view.layer.mask = nil
    }
}
```
![alt tag](https://cloud.githubusercontent.com/assets/9973368/13720435/8953bba8-e7d6-11e5-8f34-2f5a546cdff6.gif)
####2. Animation of UIViews
```swift
    func check() {
        queryLists()
        
        UIView.animateWithDuration(0.5, animations: {
            table_listTable.center = CGPointMake(-screen.width/2, screen.height/2-20)
            }, completion:
            {finished in
                UIView.animateWithDuration(0.1, animations: {
                    table_listTable.reloadRowsAtIndexPaths(table_listTable.indexPathsForVisibleRows!, withRowAnimation: .None)
                    }, completion: {
                    finished in
                        table_listTable.center = CGPointMake(screen.width*2, screen.height/2-20)

                        UIView.animateWithDuration(0.5, animations: {
                            table_listTable.center = CGPointMake(screen.width/2, screen.height/2-20)
                            }, completion: nil)
                })
        })
        
    }
```
![alt tag](https://cloud.githubusercontent.com/assets/9973368/13720434/85e0da46-e7d6-11e5-8919-16192ba729a3.gif)

Animation with more configurations
```swift
    func show(){
        showing = true
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.frame = self.finalFrame!
            }, completion: nil)
    }
```
![alt tag](https://cloud.githubusercontent.com/assets/9973368/13720433/83e48e86-e7d6-11e5-8ad3-f1df76795ef8.gif)
###3. Force Touch Features

####1. Pop and Peak Preview
```swift
extension ListViewController: UIViewControllerPreviewingDelegate {
    
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
```
####2. Shortcut and Quick Start
It requires a override of several functions in Appdelegate class.
An extra DIY function to receive and manage a shortcut request is highly recommend as a transit

```swift
@available(iOS 9.0, *)
    func handleShortCutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {
        var handled = false
        //Get type string from shortcutItem
        if let shortcutType = ShortcutType.init(rawValue: shortcutItem.type) {
            
            switch shortcutType {
            case .quick:
                
                let db = FMDatabase(path: dbFilePath)
                guard db.open() else {
                    print("Error:\(db.lastErrorMessage())")
                    return handled
                }
                
                let queryPersonStatement = "SELECT * FROM LISTS"
                
                var favorList = List(title:"",star: true)
                
                lists.removeAll(keepCapacity: false)
                if let resultSet = db.executeQuery(queryPersonStatement,withArgumentsInArray: nil){
                    while resultSet.next(){
                        let title = resultSet.stringForColumn("TITLE")
                        let star = resultSet.boolForColumn("STAR")
                        
                        lists.append(List(title: title,star: star))
                        if(star){
                            favorList = List(title: title,star: star)
                        }
                    }
                }
                db.close()
                if(favorList.title != ""){
                    let detailVC = DetailViewController(title: favorList.title)
                    window?.rootViewController?.dismissViewControllerAnimated(false, completion: nil)
                    window?.rootViewController?.presentViewController(detailVC, animated: false, completion: nil)
                }else{
                    let alert = SCLAlertView()
                    alert.showWarning("Pick a Favoriate", subTitle: "you can choose a list to quick start in editing mode", closeButtonTitle: "Ok, get it!", duration: 5)
                }
                handled = true
            case .add:
                let addVC = AddNewViewController()
                window?.rootViewController?.dismissViewControllerAnimated(false, completion: nil)
                window?.rootViewController?.presentViewController(addVC, animated: false, completion: nil)
                handled = true
            }
        }
        return handled
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        initDB()
        
        var launchedFromShortcut = false
        if #available(iOS 9.0, *) {
            if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem {
                launchedFromShortcut = true
                handleShortCutItem(shortcutItem)
                
            }
        } else {
            // Fallback on earlier versions
        }
        return launchedFromShortcut
    }
```



