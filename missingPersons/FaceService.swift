//
//  FaceService.swift
//  missingPersons
//
//  Created by Emre Dogan on 07/12/16.
//  Copyright © 2016 Emre Dogan. All rights reserved.
//

import Foundation
import ProjectOxfordFace

class FaceService {
    static let instance = FaceService()
    
    let client = MPOFaceServiceClient(subscriptionKey: "3111d1eadbed4e47ba35b67f25500784")
    }