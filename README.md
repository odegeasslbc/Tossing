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

## Technical Specs

### Database 
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
### UIDesign and Animation

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

Animation with more configurations
```swift
    func show(){
        showing = true
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.frame = self.finalFrame!
            }, completion: nil)
    }
```
