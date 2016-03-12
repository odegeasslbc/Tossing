//
//  SettingViewController.swift
//  Tossing
//
//  Created by Bruce Liu on 3/8/16.
//  Copyright © 2016 刘炳辰. All rights reserved.
//

import UIKit
import ImagePicker
import CoreData
import AssetsLibrary

@objc(ImageEntity)
class ImageEntity: NSManagedObject {
    @NSManaged var imageData: NSData
}

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

extension SettingViewController: UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func systemImagePicker(){
        let pickerC = UIImagePickerController()
        
        pickerC.delegate = self
        
        self.presentViewController(pickerC, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        bgimg = image

        bg_view.image = bgimg

        saveImage(bgimg!)

        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
}


extension SettingViewController: ImagePickerDelegate{
    
    func imagePicker(){
        let pickerC = ImagePickerController()
        pickerC.imageLimit = 1
        
        Configuration.backgroundColor = red_light
        Configuration.mainColor = red_light
        Configuration.doneButtonTitle = "Finish"
        Configuration.noImagesTitle = "Sorry! There are no images here!"
        
        pickerC.delegate = self
        
        self.presentViewController(pickerC, animated: true, completion: nil)
    }
    
    
    
    func wrapperDidPress(images: [UIImage]){
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func doneButtonDidPress(images: [UIImage]){
        bgimg = images[0]
        bg_view.image = bgimg
        bg.image = bgimg
        saveImage(bgimg!)
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func cancelButtonDidPress(){
        self.dismissViewControllerAnimated(true, completion: nil);
    }
}

class SettingViewController: UIViewController, MaterialSwitchDelegate {

    @IBOutlet weak var btn_back: UIButton!
    
    let label_blur = UILabel(frame: CGRectMake(70, 100, screen.width/2, 30))
    
    let label_bg = UILabel(frame: CGRectMake(70, 160, screen.width/2, 50))
    
    let btn_imgpicker_frame = CGRectMake(screen.width-90, 170, 80, 50)
    
    var bg_view = UIImageView(frame: CGRectMake(10, 100, 54, 96))

    var blurSwitch = MaterialSwitch()
    let btn_imgPicker = FlatButton()
    
    
    @IBAction func back(sender: AnyObject) {
        //self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func saveBlur(blur:String){
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("Theme.plist")
        let data: NSMutableArray = [blur]
        
        data.writeToFile(path, atomically: true)
    }
    
    func materialSwitchStateChanged(control: MaterialSwitch) {
        if control.switchState == .On{
            shouldBlur = true
            saveBlur("yes")
            
        }else if control.switchState == .Off{
            shouldBlur = false
            saveBlur("no")
        }
    }
    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var sysswitch: UISwitch!
    
    @IBAction func `switch`(sender: AnyObject) {
        
        if sysswitch.enabled {
            shouldBlur = true
            saveBlur("yes")
        }else{
            shouldBlur = false
            saveBlur("no")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        //btn_back.setTitleColor(UIColor.blackColor(), forState: .Normal)
        //btn_back.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Light", size: 30)
        //btn_back.backgroundColor = light
        //self.view.backgroundColor = red
        
        label_blur.text = "Blur"
        label_bg.text = "Wallpaper"
        
        self.title = "settingVC"
        
        if(shouldBlur){
            blurSwitch.switchState = .On
        }else{
            blurSwitch.switchState = .Off
        }
        
        blurSwitch.switchSize = .Large
        blurSwitch.center = CGPoint(x: screen.width-50, y: 125)
        blurSwitch.delegate = self
        
        btn_imgPicker.frame = btn_imgpicker_frame
        //btn_imgPicker.backgroundColor = light
        btn_imgPicker.setTitle("pick", forState: .Normal)
        btn_imgPicker.addTarget(self, action: "systemImagePicker", forControlEvents: .TouchUpInside)
        btn_imgPicker.setTitleColor(dark_7, forState: .Normal)
        btn_imgPicker.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Light", size: 25)
        
        bg_view.image = bgimg
        
        btn_back.setTitleColor(light, forState: .Normal)
        
        
        self.view.addSubview(bg_view)
        
        self.view.addSubview(btn_imgPicker)
        self.view.addSubview(blurSwitch)
        
        self.view.addSubview(label_blur)
        self.view.addSubview(label_bg)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.view.bringSubviewToFront(blurSwitch)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate{
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if fromVC.title == "listVC"{
            return CircleTransitionForwardAnimator()
        }else if fromVC.title == "settingVC"{
            return CircleTransitionBackwardAnimator()
        }else{
            return nil
        }
    }
}

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

class CircleTransitionBackwardAnimator: NSObject, UIViewControllerAnimatedTransitioning{
    weak var transitionContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.8
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // 1
        self.transitionContext = transitionContext
        
        // 2
        let containerView = transitionContext.containerView()
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! SettingViewController
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! ListViewController
        let button = fromViewController.btn_back
        
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