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


class MemeTableViewController:  UITableViewController, UITableViewDataSource {
    
    
    // To add a new Meme image, by launching the Meme Editor Screen
    @IBAction func addButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("MemeViewController") as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    var memes = [Meme]()
    
    // Overriding this function to check if the user has some Sent Memes to show first, or launch the Meme Editor directly
    override func viewWillAppear(animated: Bool) {
        
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
        
        if memes.count > 0 {
            
            super.viewWillAppear(true)
            println("You have \(memes.count) >0 SentMemes")
        
        } else if self.memes.count == 0 {
            
            let storyboard = self.storyboard
            let vc = storyboard!.instantiateViewControllerWithIdentifier("MemeViewController") as! UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
            println("You have \(memes.count) == 0 SentMemes")
        }
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SentMemeCell") as! UITableViewCell
        let sentMeme = self.memes[indexPath.row]
        
        cell.imageView?.image = sentMeme.memedImage
        cell.textLabel?.text = sentMeme.top
        cell.detailTextLabel?.text = sentMeme.bottom
        
        return cell
    }
    
    // To show up a selected Sent Meme in a separete view
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let memeDetailsController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailsViewController") as! MemeDetailsViewController
        memeDetailsController.meme = self.memes[indexPath.row]
        
        // To hide the bottom bar when pushed
        memeDetailsController.hidesBottomBarWhenPushed = true
        
        // I'm calling the anitamed as FALSE, to show up the memeDetailsController without showing the bottom tab bar for one second before complete dismiss, I looked it over the internet but in vain to get a better solution, sorry :(
        self.navigationController!.pushViewController(memeDetailsController, animated: false)
    }
}



