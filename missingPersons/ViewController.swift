//
//  ViewController.swift
//  missingPersons
//
//  Created by Emre Dogan on 30/11/16.
//  Copyright © 2016 Emre Dogan. All rights reserved.
//

import UIKit
import ProjectOxfordFace
import SystemConfiguration


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
    
    
    @IBAction func cam1Source(_ sender: Any) {
        
        self.player1.faceID = nil
        choosePlayer1 = true
        
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)

        
        
        
    }
    
    
    
    @IBAction func cam2source(_ sender: Any) {
        
        self.player2.faceID = nil
        
        choosePlayer2 = true
        
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)

        
        
    }
    
    
    
    
    var choosePlayer1: Bool = false
    var choosePlayer2: Bool = false
    
    var iMinSessions = 6
    var iTryAgainSessions = 6

    
    let imagePicker = UIImagePickerController()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let image1 = UIImage(named: "profile")
        
        player1 = Person(personImage: image1!)
        player2 = Person(personImage: image1!)
        
        imagePicker.delegate = self
        
        // Create and add the view to the screen.
        
        // All done!
        
     //   progressHUD.backgroundColor = UIColor.black
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        rateMe()
        
        
        
    }
    
    
    func rateMe() {
        var neverRate = UserDefaults.standard.bool(forKey: "neverRate")
        var numLaunches = UserDefaults.standard.integer(forKey: "numLaunches") + 1
        
        if (!neverRate && (numLaunches == iMinSessions || numLaunches >= (iMinSessions + iTryAgainSessions + 1)))
        {
            showRateMe()
            numLaunches = iMinSessions + 1
        }
        UserDefaults.standard.set(numLaunches, forKey: "numLaunches")
    }
    
    func showRateMe() {
        
        
        
        var alert = UIAlertController(title: "Rate Us", message: "Thanks for using -Find My Twin-", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Rate my app", style: UIAlertActionStyle.default, handler: { alertAction in
            UIApplication.shared.openURL(NSURL(string : "https://itunes.apple.com/app/viewContentsUserReviews?id=1186301141") as! URL)
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No Thanks", style: UIAlertActionStyle.default, handler: { alertAction in
            UserDefaults.standard.set(true, forKey: "neverRate")
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Maybe Later", style: UIAlertActionStyle.default, handler: { alertAction in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
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
                
           //     self.checkForMatchBtn.isUserInteractionEnabled = false
                
                player1Img.image = pickedImage
                
                player1.personImage = pickedImage
                
                player1.downloadFaceID()
                
                self.checkForMatchBtn.setTitle("Check now", for: UIControlState())
                
                
//                self.checkForMatchBtn.setTitle("Please wait", for: UIControlState())
//                self.checkForMatchBtn.backgroundColor = UIColor.red
//                
//                delay(2) {
//                    self.checkForMatchBtn.setTitle("Check now", for: UIControlState())
//                    self.checkForMatchBtn.backgroundColor = UIColor.green
//                    self.checkForMatchBtn.isUserInteractionEnabled = true
//                    
//                }
                
                
                
            }
            
            if choosePlayer2 == true {
                
                self.checkForMatchBtn.setTitle("Check now", for: UIControlState())
                
           //     self.checkForMatchBtn.isUserInteractionEnabled = false
                
                
                player2Img.image = pickedImage
                
                player2.personImage = pickedImage
                
                player2.downloadFaceID()
                
//                self.checkForMatchBtn.setTitle("Please wait", for: UIControlState())
//                self.checkForMatchBtn.backgroundColor = UIColor.red
//                
//                delay(2) {
//                    self.checkForMatchBtn.setTitle("Check now", for: UIControlState())
//                    self.checkForMatchBtn.backgroundColor = UIColor.green
//                    self.checkForMatchBtn.isUserInteractionEnabled = true
//                    
//                }
                
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
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

    
//    func sayHello()
//    {
//        if player1.faceID == nil {
//            player1.downloadFaceID()
//        }
//        
//        if player2.faceID == nil {
//            player2.downloadFaceID()
//        }
//    }
    
    func showErrorAlert() {
        
        let alert = UIAlertController(title: "Error", message: "Check that you have valid internet connection and try again", preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func checkMatch(_ sender: AnyObject) {
        
        let progressHUD = ProgressHUD(text: "Analyzing")
        
        
        if player1Img.image == UIImage(named: "profile")! || player2Img.image == UIImage(named: "profile")! {
            
            
            let alert = UIAlertController(title: "Error", message: "Please select two images with human faces and try again", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            progressHUD.removeFromSuperview()
            UIApplication.shared.endIgnoringInteractionEvents()
            
        } else {
            
            
            
            self.view.addSubview(progressHUD)
            
            
            
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            delay(5) {
                
                
                print(self.player1.faceID)
                print(self.player2.faceID)
                
                
                
                
                if  self.player1.faceID == nil || self.player2.faceID == nil  {
                    
                    
                    
                    
                    if self.isInternetAvailable() == true {
                        
                        let alert = UIAlertController(title: "Error", message: "Please select two images with human faces and try again", preferredStyle: UIAlertControllerStyle.alert)
                        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
                        progressHUD.removeFromSuperview()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                    } else if self.isInternetAvailable() == false {
                        
                        self.showErrorAlert()
                        progressHUD.removeFromSuperview()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                        
                    }
                    
                    
                    
                } else {
                    
                    FaceService.instance.client?.verify(withFirstFaceId: self.player1.faceID, faceId2: self.player2.faceID, completionBlock: { (result:MPOVerifyResult?, err:Error?) in
                        
                        if err == nil {
                            
                            print(result?.confidence)
                            print(result?.isIdentical)
                            
                            let alert = UIAlertController(title: "Result", message: "Same Person: \(String(describing: result!.isIdentical).capitalized)\n Similarity Rate:  %\(String(format: "%.2f", Double((result?.confidence)!)*100))", preferredStyle: UIAlertControllerStyle.alert)
                            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                            alert.addAction(ok)
                            self.present(alert, animated: true, completion: nil)
                            progressHUD.removeFromSuperview()
                            UIApplication.shared.endIgnoringInteractionEvents()
                            
                            
                            
                        } else {
                            
                            print(result.debugDescription)
                            progressHUD.removeFromSuperview()
                            UIApplication.shared.endIgnoringInteractionEvents()
                            
                        }
                        
                        
                        
                        
                        
                    })
                    
                    
                    
                }
                
            }
            
        }
    
        
        
        
        
        
        
        
        
        
    }

}

