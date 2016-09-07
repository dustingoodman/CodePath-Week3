//
//  MailboxViewController.swift
//  Carousel
//
//  Created by Goodman, Dustin on 9/5/16.
//  Copyright © 2016 Dustin Goodman. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var overlayImageView: UIImageView!
    
    @IBOutlet weak var helpImageView: UIImageView!
    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var feedImage: UIImageView!
    
    @IBOutlet weak var topMessage: UIView!
    @IBOutlet weak var messageContainer: UIView!
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var leftActionIcon: UIImageView!
    @IBOutlet weak var rightActionIcon: UIImageView!
    
    
    
    var tapGesture: UITapGestureRecognizer!
    var contentMenuPanGesture: UIPanGestureRecognizer!
    
    var messageHeight: CGFloat!
    var messageOriginalPosition: CGPoint!
    var archiveIcon: UIImage! = UIImage(named: "archive_icon")
    var deleteIcon: UIImage! = UIImage(named: "delete_icon")
    var listIcon: UIImage! = UIImage(named: "list_icon")
    var laterIcon: UIImage! = UIImage(named: "later_icon")
    
    var rescheduleImage: UIImage! = UIImage(named: "reschedule")
    var listImage: UIImage! = UIImage(named: "list")
    
    var actionBounds = [-50.0, 20, 270, 410]
    var archiveColor = UIColor(red: 0.384, green: 0.835, blue: 0.314, alpha: 1)
    var defaultColor = UIColor(red: 0.863, green: 0.863, blue: 0.863, alpha: 1)
    var deleteColor = UIColor(red: 0.894, green: 0.239, blue: 0.153, alpha: 1)
    var listColor = UIColor(red: 0.808, green: 0.588, blue: 0.384, alpha: 1)
    var laterColor = UIColor(red: 0.973, green: 0.796, blue: 0.153, alpha: 1)
    
    var leftIconBound: CGFloat = 60.0
    var rightIconBound: CGFloat = -60.0
    
    var leftIconOriginalPosition: CGFloat!
    var rightIconOriginalPosition: CGFloat!
    var messageImageOriginalPosition: CGFloat!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: 320, height: 1432)
        
       
        
        // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
        
        
        overlayView.alpha = 0
        
        _ = searchImageView.frame.width
        _ = feedImage.frame.height + searchImageView.frame.height + helpImageView.frame.height + topMessage.frame.height
        messageHeight = topMessage.frame.height

        
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(MailboxViewController.onEdgePan(_:)))
        edgeGesture.edges = UIRectEdge.Left
        contentView.addGestureRecognizer(edgeGesture)
        
        
        leftIconOriginalPosition = leftActionIcon.frame.origin.x
        rightIconOriginalPosition = rightActionIcon.frame.origin.x
        messageImageOriginalPosition = messageImageView.frame.origin.x

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func didMoveMessage(sender: UIPanGestureRecognizer) {
        
        if (sender.state == UIGestureRecognizerState.Began) {
            messageOriginalPosition = sender.view!.center
        } else if (sender.state == UIGestureRecognizerState.Changed) {
            let newPosition = messageOriginalPosition.x + sender.translationInView(view).x
            sender.view!.center = CGPoint(x: newPosition, y: messageOriginalPosition.y)
            
            if (Int(newPosition) <= Int(actionBounds[0])) {
                topMessage.backgroundColor = listColor
                rightActionIcon.image = listIcon
            } else if (Int(actionBounds[0]) <= Int(newPosition) &&
                Int(newPosition) <= Int(actionBounds[1])) {
                topMessage.backgroundColor = laterColor
                rightActionIcon.image = laterIcon
            } else if (Int(actionBounds[1]) <= Int(newPosition) &&
                Int(newPosition) <= Int(actionBounds[2])) {
                topMessage.backgroundColor = defaultColor
                rightActionIcon.image = laterIcon
            } else if (Int(actionBounds[2]) <= Int(newPosition) &&
                Int(newPosition) <= Int(actionBounds[3])) {
                leftActionIcon.image = archiveIcon
                topMessage.backgroundColor = archiveColor
            } else {
                topMessage.backgroundColor = deleteColor
                leftActionIcon.image = deleteIcon
            }
            
            leftActionIcon.alpha = CGFloat(sender.view!.frame.origin.x) / leftIconBound
            
            rightActionIcon.alpha = CGFloat(sender.view!.frame.origin.x) / rightIconBound
            
            print(sender.view!.frame.origin.x)
            
            if (sender.view!.frame.origin.x >= leftIconBound) {
                leftActionIcon.frame.origin.x = sender.view!.frame.origin.x - 40
            }
            
            if (sender.view!.frame.origin.x <= rightIconBound) {
                let rightEdge = sender.view!.frame.origin.x + sender.view!.frame.width
                print(rightEdge)
                rightActionIcon.frame.origin.x = rightEdge + 10
            }
            
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            let newPosition = sender.view!.center.x
            let currentYPos = sender.view!.center.y
            
            if (Int(newPosition) <= Int(actionBounds[0])) {
                print("list it")
                
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.messageContainer.center = CGPoint(x: -600, y: currentYPos)
                    }, completion: { (completed: Bool) -> Void in
                        
                        UIView.animateWithDuration(0.25, animations: { () -> Void in
                            self.overlayImageView.image = self.listImage
                            self.overlayView.alpha = 1
                        })
                })
            } else if (Int(actionBounds[0]) <= Int(newPosition) &&
                Int(newPosition) <= Int(actionBounds[1])) {
                
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.messageContainer.center = CGPoint(x: -600, y: currentYPos)
                    }, completion: { (completed: Bool) -> Void in
                        
                        UIView.animateWithDuration(0.25, animations: { () -> Void in
                            self.overlayImageView.image = self.rescheduleImage
                            self.overlayView.alpha = 1
                        })
                })
                print("later it")
            } else if (Int(actionBounds[1]) <= Int(newPosition) &&
                Int(newPosition) <= Int(actionBounds[2])) {
                
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    sender.view!.center = self.messageOriginalPosition
                    }, completion: { (completed: Bool) -> Void in
                        self.leftActionIcon.frame.origin.x = self.leftIconOriginalPosition
                        self.rightActionIcon.frame.origin.x = self.rightIconOriginalPosition
                })
                
                print("default it")
            } else if (Int(actionBounds[2]) <= Int(newPosition) &&
                Int(newPosition) <= Int(actionBounds[3])) {
                
                
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.messageContainer.center = CGPoint(x: 600, y: currentYPos)
                    }, completion: { (completed: Bool) -> Void in
                        
                        self.resetMessage()
                        
                        UIView.animateWithDuration(0.5, animations: { () -> Void in
                            self.feedImage.center.y -= self.messageHeight
                        })
                })
                
                print("archive it")
            } else {
                print("delete it")
                
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.messageContainer.center = CGPoint(x: 600, y: currentYPos)
                    }, completion: { (completed: Bool) -> Void in
                        
                        self.resetMessage()
                        
                        UIView.animateWithDuration(0.5, animations: { () -> Void in
                            self.feedImage.center.y -= self.messageHeight
                        })
                })
            }
        }
    }
    
    @IBAction func doRemoveOverlay(sender: UITapGestureRecognizer) {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            sender.view!.alpha = 0
        }) { (completed: Bool) -> Void in
            self.resetMessage()
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.feedImage.center.y -= self.messageHeight
            })
        }
    }
    
    
    func onEdgePan(gesture: UIScreenEdgePanGestureRecognizer){
        let translation = gesture.translationInView(view)
        if (gesture.state == .Began || gesture.state == .Changed) {
            contentView.frame.origin.x = translation.x
        } else if (gesture.state == .Ended) {
            if (contentView.frame.origin.x > 150) {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.contentView.frame.origin.x =  270
                    }, completion: { (completed: Bool) -> Void in
                        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(MailboxViewController.didTapOpenMenu(_:)))
                        self.contentView.addGestureRecognizer(self.tapGesture)
                        
                        self.contentMenuPanGesture = UIPanGestureRecognizer(target: self, action: #selector(MailboxViewController.didPanOpenMenu(_:)))
                        self.contentView.addGestureRecognizer(self.contentMenuPanGesture)
                })
            } else {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.contentView.frame.origin.x = 0
                })
            }
        }
    }
    
    func didTapOpenMenu(gesture: UITapGestureRecognizer) {
        print("tapped")
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            gesture.view!.frame.origin.x = 0
            gesture.view!.removeGestureRecognizer(self.contentMenuPanGesture)
        })
        
    }
    
    func didPanOpenMenu(gesture: UIPanGestureRecognizer) {
        if (gesture.state == .Began || gesture.state == .Changed) {
            gesture.view!.frame.origin.x = gesture.translationInView(view).x + 270
            print(gesture.view!.frame.origin.x)
        } else if (gesture.state == .Ended) {
            if (contentView.frame.origin.x > 150) {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.contentView.frame.origin.x =  270
                })
            } else {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.contentView.frame.origin.x = 0
                    gesture.view!.removeGestureRecognizer(self.tapGesture)
                    gesture.view!.removeGestureRecognizer(self.contentMenuPanGesture)
                })
            }
        }
    }

 
    func resetMessage (){
        delay(2, closure: { () -> () in
            self.topMessage.backgroundColor = self.defaultColor
            self.messageContainer.frame.origin.x = 0
            self.leftActionIcon.image = self.archiveIcon
            self.rightActionIcon.image = self.laterIcon
            self.leftActionIcon.frame.origin.x = self.leftIconOriginalPosition
            self.rightActionIcon.frame.origin.x = self.rightIconOriginalPosition
            self.messageImageView.frame.origin.x = self.messageImageOriginalPosition
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.feedImage.center.y += self.messageHeight
            })
        })
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
