//
//  MemeDetailsViewController.swift
//  Meme App
//
//  Created by Abdallah ElMenoufy on 4/22/15.
//  Copyright (c) 2015 Abdallah ElMenoufy. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailsViewController: UIViewController {
    
    @IBOutlet weak var imageViewCell: UIImageView!
    
    var meme: Meme!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem = editButtonItem()
        self.imageViewCell!.image = meme.memedImage
        
    }
    
}