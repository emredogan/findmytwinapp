//
//  ViewController.swift
//  missingPersons
//
//  Created by Emre Dogan on 30/11/16.
//  Copyright © 2016 Emre Dogan. All rights reserved.
//

import UIKit
import ProjectOxfordFace


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
   
    var player1 = Person?()
    var player2 = Person?()
    
    @IBOutlet weak var player1Img: UIImageView!
    
    @IBOutlet weak var player2Img: UIImageView!
    
    @IBOutlet weak var checkForMatchBtn: UIButton!
    
    
    
    
    
    @IBAction func player1Source(sender: AnyObject) {
        
        self.player1?.faceID = nil
        choosePlayer1 = true
        
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func player2Source(sender: AnyObject) {
        
        self.player2?.faceID = nil
        
        choosePlayer2 = true
        
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    
    
    
    
    var choosePlayer1: Bool = false
    var choosePlayer2: Bool = false
    
    let imagePicker = UIImagePickerController()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let image1 = UIImage(named: "profile")
        
        player1 = Person(personImage: image1!)
        player2 = Person(personImage: image1!)
        
        imagePicker.delegate = self
        
    }

    

    
    
    func delay(delay: Double, closure: ()->()) {
        
        
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            closure
        )
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            if choosePlayer1 == true {
                
                self.checkForMatchBtn.userInteractionEnabled = false
                
                player1Img.image = pickedImage
                
                player1?.personImage = pickedImage
                
                player1?.downloadFaceID()
                
                
                
                
                self.checkForMatchBtn.setTitle("Please wait", forState: .Normal)
                self.checkForMatchBtn.backgroundColor = UIColor.redColor()
                
                delay(2) {
                    self.checkForMatchBtn.setTitle("Check now", forState: .Normal)
                    self.checkForMatchBtn.backgroundColor = UIColor.greenColor()
                    self.checkForMatchBtn.userInteractionEnabled = true
                    
                }
                
                
                
            }
            
            if choosePlayer2 == true {
                
                self.checkForMatchBtn.userInteractionEnabled = false
                
                
                player2Img.image = pickedImage
                
                player2?.personImage = pickedImage
                
                player2?.downloadFaceID()
                
                self.checkForMatchBtn.setTitle("Please wait", forState: .Normal)
                self.checkForMatchBtn.backgroundColor = UIColor.redColor()
                
                delay(2) {
                    self.checkForMatchBtn.setTitle("Check now", forState: .Normal)
                    self.checkForMatchBtn.backgroundColor = UIColor.greenColor()
                    self.checkForMatchBtn.userInteractionEnabled = true
                    
                }
                
            }
            
            choosePlayer1 = false
            choosePlayer2 = false
            
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    func loadPicker(gesture:UITapGestureRecognizer) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func showErrorAlert() {
        
        let alert = UIAlertController(title: "Error", message: "Please select two images with human faces and check that you have valid internet connection and try again", preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func checkMatch(sender: AnyObject) {
        
        print(self.player1?.faceID)
        print(self.player2?.faceID)
        
        
        if  self.player1?.faceID == nil || self.player2?.faceID == nil  {
            
            showErrorAlert()
            
            
        } else {
            
            FaceService.instance.client.verifyWithFirstFaceId(self.player1?.faceID, faceId2: self.player2?.faceID, completionBlock: { (result:MPOVerifyResult!, err:NSError!) in
                
                if err == nil {
                    
                    print(result.confidence)
                    print(result.isIdentical)
                    
                    let alert = UIAlertController(title: "Result", message: "Same Person: \(String(result.isIdentical).capitalizedString)\n Similarity Rate:  %\(String(format: "%.2f", Double(result.confidence)*100))", preferredStyle: UIAlertControllerStyle.Alert)
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                    alert.addAction(ok)
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    
                    
                } else {
                    
                    print(result.debugDescription)
                    
                }
                
                
                
                
                
            })


         
        }
        
        
        
    }

}

