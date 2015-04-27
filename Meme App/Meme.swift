//
//  Meme.swift
//  Meme App
//
//  Created by Abdallah ElMenoufy on 4/14/15.
//  Copyright (c) 2015 Abdallah ElMenoufy. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    
    var top: String?
    var bottom: String?
    var image: UIImage?
    var memedImage: UIImage?
    
    init(top: String, bottom: String, image: UIImage, memedImage: UIImage) {
        self.top = top
        self.bottom = bottom
        self.image = image
        self.memedImage = memedImage
    }
}