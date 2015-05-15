//
//  MemeTableViewController.swift
//  Meme App
//
//  Created by Abdallah ElMenoufy on 4/18/15.
//  Copyright (c) 2015 Abdallah ElMenoufy. All rights reserved.
//

import Foundation
import UIKit
import Dispatch


class MemeTableViewController:  UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    var memes: [Meme]!
    
    // To add a new Meme image, by launching the Meme Editor Screen
    @IBAction func addButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("MemeViewController") as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
  
// MARK: - View life cycle functions - 3 Cycles
    override func viewWillAppear(animated: Bool) {
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        tableView.reloadData()
        tableView.rowHeight = 90
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        tableView.reloadData()
        
        // Check if the user has some Sent Memes to show first, or launch the Meme Editor directly
        if memes.count == 0 {
            let storyboard = self.storyboard
            let vc = storyboard!.instantiateViewControllerWithIdentifier("MemeViewController") as! UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add an Edit button as Left Bar Button Item
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    
    
// MARK:- Implementing the UITableViewDelegate and UITableViewDataSource (7) methods
    
    // (1) How many cells to be returned ?
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    // (2) Getting cell's items
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SentMemeCell") as! UITableViewCell
        let sentMeme = memes[indexPath.row]
        cell.imageView?.image = sentMeme.memedImage
        cell.imageView?.sizeToFit()
        cell.textLabel?.text = sentMeme.top
        cell.detailTextLabel?.text = sentMeme.bottom
        
        return cell
    }
    
    // (3) To show up a selected Sent Meme in a separete view
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let memeDetailsController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailsViewController") as! MemeDetailsViewController
        memeDetailsController.meme = memes[indexPath.row]
        
        // Pass the choosed index to the MemeDetailsViewController for deletion purpose "if requested by user"
        memeDetailsController.memeIndex = indexPath.row
        
        // To hide the bottom bar when pushed
        memeDetailsController.hidesBottomBarWhenPushed = true
        
        // I'm calling the anitamed as FALSE, to show up the memeDetailsController without showing the bottom tab bar for one second before complete dismiss, I looked it over the internet but in vain to get a better solution, sorry :(
        self.navigationController!.pushViewController(memeDetailsController, animated: false)
    }
    
    
    // (4) To delete a Sent Meme from the table view using either Swipe to left, or when the Delete Button is shown and tapped after pressing the Edit left-bar-button "incorprated with the below overriden functions - (1), (2) and (3)"
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            memes.removeAtIndex(indexPath.row)
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            tableView.reloadData()
        }
    }
    
    // (5) Move a row to another location Up/Down
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let movedRow = self.memes.removeAtIndex(sourceIndexPath.row)
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(sourceIndexPath.row)
        
        // Match the model array with the current UITableView after a successful row-move
        memes.insert(movedRow, atIndex: destinationIndexPath.row)
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.insert(movedRow, atIndex: destinationIndexPath.row)
    }
    
    // (5) - 1)
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    // (5) - 2)
    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // 5) - 3)
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView!.setEditing(editing, animated: animated)
    }

}




