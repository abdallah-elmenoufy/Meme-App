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
    
    var meme: Meme!
    
    // To get the Index of the selected Meme form Table or Collection views "for deletion purpose"
    var memeIndex: Int?
    
// MARK: - View life cycle method
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.imageViewCell!.image = meme.memedImage
    }
    
    @IBOutlet weak var imageViewCell: UIImageView!
    
// MARK: - Delete the shown Meme
    
    // Adding delete button
    @IBAction func deleteShownMeme() {
        
        // Prompt the user before processing the Delete action
        let alertController = UIAlertController(title: "DELETE!", message: "Are you sure to delete this Meme ?", preferredStyle: UIAlertControllerStyle.Alert)
        
        // Agreed to delete ?
        let okAction = UIAlertAction(title: "Yes",
            style: UIAlertActionStyle.Destructive)
            { (action) in
            self.deleteADetailedMeme()
            self.navigationController?.popViewControllerAnimated(true)
        }
        alertController.addAction(okAction)
        
        // Declined the deletion ?
        let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    // Delete A Meme funciton
    func deleteADetailedMeme() {
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(memeIndex!)
        self.imageViewCell!.image = nil
    }
    
    
// MARK: - Launch the MemeEditor Screen from the MemeDetailsViewController
    @IBAction func editButton() {
        let alertController = UIAlertController(title: "EDIT!", message: "This will delete the Meme, and open Meme Editor to star over, sure ?", preferredStyle: UIAlertControllerStyle.Alert)
        
        // Agreed to Edit ?
        let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive)
            {(action) in self.segueToMemeEditorWithDeletion()}
        alertController.addAction(okAction)
        
        // Declined to Edit ?
        let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(cancelAction)

        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func segueToMemeEditorWithDeletion() {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("MemeViewController") as! MemeViewController
        self.presentViewController(controller, animated: true)
            {(action) in self.deleteADetailedMeme()}
    }
}
    