//
//  Person.swift
//  missingPersons
//
//  Created by Emre Dogan on 07/12/16.
//  Copyright © 2016 Emre Dogan. All rights reserved.
//

import UIKit
import ProjectOxfordFace

class Person {
    var faceID: String?
    var personImage: UIImage?
    
    init(personImage: UIImage) {
        self.personImage = personImage
        
    }
    
    func downloadFaceID() {
        if let img = personImage, let imgData = UIImageJPEGRepresentation(img, 0.8) {
            FaceService.instance.client.detectWithData(imgData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces: [MPOFace]!, err: NSError!) in
                if err == nil! {
                    var faceID: String?
                    for face in faces {
                        faceID = face.faceId
                        print("Face Id: \(faceID)")
                        break
                    }
                    
                    self.faceID = faceID
                    
                
            
                }
            })
            
        }
    }
}
