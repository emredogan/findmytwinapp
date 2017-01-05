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
    
   
    var player1 = Person(personImage: UIImage(named: "profile")!)
    var player2 = Person(personImage: UIImage(named: "profile")!)
    
    @IBOutlet weak var player1Img: UIImageView!
    
    @IBOutlet weak var player2Img: UIImageView!
    
    @IBOutlet weak var checkForMatchBtn: UIButton!
    
    
    
    
    
    @IBAction func player1Source(_ sender: AnyObject) {
        
        self.player1.faceID = nil
        choosePlayer1 = true
        
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func player2Source(_ sender: AnyObject) {
        
        self.player2.faceID = nil
        
        choosePlayer2 = true
        
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
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

    

    
    
    func delay(_ delay: Double, closure: @escaping ()->()) {
        
        
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: closure
        )
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            if choosePlayer1 == true {
                
                self.checkForMatchBtn.isUserInteractionEnabled = false
                
                player1Img.image = pickedImage
                
                player1.personImage = pickedImage
                
                player1.downloadFaceID()
                
                
                
                
                self.checkForMatchBtn.setTitle("Please wait", for: UIControlState())
                self.checkForMatchBtn.backgroundColor = UIColor.red
                
                delay(2) {
                    self.checkForMatchBtn.setTitle("Check now", for: UIControlState())
                    self.checkForMatchBtn.backgroundColor = UIColor.green
                    self.checkForMatchBtn.isUserInteractionEnabled = true
                    
                }
                
                
                
            }
            
            if choosePlayer2 == true {
                
                self.checkForMatchBtn.isUserInteractionEnabled = false
                
                
                player2Img.image = pickedImage
                
                player2.personImage = pickedImage
                
                player2.downloadFaceID()
                
                self.checkForMatchBtn.setTitle("Please wait", for: UIControlState())
                self.checkForMatchBtn.backgroundColor = UIColor.red
                
                delay(2) {
                    self.checkForMatchBtn.setTitle("Check now", for: UIControlState())
                    self.checkForMatchBtn.backgroundColor = UIColor.green
                    self.checkForMatchBtn.isUserInteractionEnabled = true
                    
                }
                
            }
            
            choosePlayer1 = false
            choosePlayer2 = false
            
        }
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    func loadPicker(_ gesture:UITapGestureRecognizer) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func showErrorAlert() {
        
        let alert = UIAlertController(title: "Error", message: "Please select two images with human faces and check that you have valid internet connection and try again", preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func checkMatch(_ sender: AnyObject) {
        
        print(self.player1.faceID)
        print(self.player2.faceID)
        
        
        if  self.player1.faceID == nil || self.player2.faceID == nil  {
            
            showErrorAlert()
            
            
        } else {
            
            FaceService.instance.client?.verify(withFirstFaceId: self.player1.faceID, faceId2: self.player2.faceID, completionBlock: { (result:MPOVerifyResult?, err:Error?) in
                
                if err == nil {
                    
                    print(result?.confidence)
                    print(result?.isIdentical)
                    
                    let alert = UIAlertController(title: "Result", message: "Same Person: \(String(describing: result!.isIdentical).capitalized)\n Similarity Rate:  %\(String(format: "%.2f", Double((result?.confidence)!)*100))", preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    
                    
                    
                } else {
                    
                    print(result.debugDescription)
                    
                }
                
                
                
                
                
            })


         
        }
        
        
        
    }

}

