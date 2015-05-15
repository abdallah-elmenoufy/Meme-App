//
//  MemeCollectionViewController.swift
//  Meme App
//
//  Created by Abdallah ElMenoufy on 4/18/15.
//  Copyright (c) 2015 Abdallah ElMenoufy. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    var memes: [Meme]!
    var editModeEnabled = false
    
    // Add the Edit button as a LeftNavigationBarButton
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    // Associate a delete function to the Edit button
    @IBAction func editButtonTapped(sender: AnyObject) {
        if(editModeEnabled == false) {
            // Put the collection view in edit mode
            editButton.title = "Done"
            self.editButton.style = .Done
            editModeEnabled = true
            
            // Loop through the collectionView's visible cells
            for item in self.collectionView!.visibleCells() as! [MemeCollectionViewCell] {
                var indexPath: NSIndexPath = self.collectionView!.indexPathForCell(item as MemeCollectionViewCell)!
                var cell: MemeCollectionViewCell = self.collectionView!.cellForItemAtIndexPath(indexPath) as! MemeCollectionViewCell!
                cell.deleteButton.hidden = false // Show all of the delete buttons to allow user to delete
            }
        } else {
            // Take the collection view out of edit mode
            editButton.style = .Plain
            editButton.title = "Edit"
            editModeEnabled = false
            
            // Loop through the collectionView's visible cells
            for item in self.collectionView!.visibleCells() as! [MemeCollectionViewCell] {
                var indexPath: NSIndexPath = self.collectionView!.indexPathForCell(item as MemeCollectionViewCell)!
                var cell: MemeCollectionViewCell = self.collectionView!.cellForItemAtIndexPath(indexPath) as! MemeCollectionViewCell!
                cell.deleteButton.hidden = true  // Hide all of the delete buttons to deny the delete action
            }
        }
    }

    
    // To add a new Meme image, by launching the Meme Editor Screen
    @IBAction func addButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("MemeViewController") as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
// MARK: - CollectionView life cycle methods //
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        editButton.title = "Edit"
        collectionView!.reloadData()
        
        // In case no Sent Memes yet, jump to the MemeEditorVC directly
        if memes.count == 0 {
            let storyboard = self.storyboard
            let vc = storyboard!.instantiateViewControllerWithIdentifier("MemeViewController") as! UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        self.collectionView!.reloadData()
    }
    
    
// MARK: - CollectionView DataSourceDelegate Methods **** //
    
    // Get the collection view's cells count
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    // Return the Cell
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // Create the cell and load it with data
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SentMemeItem", forIndexPath: indexPath) as! MemeCollectionViewCell
        let sentMeme = memes[indexPath.item]
        cell.memedImage.image = sentMeme.memedImage
        
        // Deal with the associated small delete button
        if self.editButton.title == "Edit" {
            cell.deleteButton.hidden = true
        } else {
            cell.deleteButton.hidden = false
        }
        
        // Give the delete button an index number
        cell.deleteButton.layer.setValue(indexPath.row, forKey: "index")
        
        // Add an action function to the delete button
        cell.deleteButton.addTarget(self, action: "deleteAMeme:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    // To show up a selected Sent Meme in a large separete view
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        
        // Show the selected meme in a large scaled view called MemeDetailsViewController
        let memeDetailsController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailsViewController") as! MemeDetailsViewController
            memeDetailsController.hidesBottomBarWhenPushed = true
            memeDetailsController.meme = self.memes[indexPath.item]
        
            // Pass the choosed index to the MemeDetailsViewController for deletion purpose "if requested by user"
            memeDetailsController.memeIndex = indexPath.item
            self.navigationController!.pushViewController(memeDetailsController, animated: false)
    }
    
    
// MARK: - UICollectionViewFlowLayout - 2 methods
    // Get the cell's size in the CollectionView Grid
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let memeDimension = self.view.frame.size.width / 3.0
        return CGSizeMake(memeDimension, memeDimension)
    }
    
    // Get the margins to apply to the items in the CollectionView
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let leftRightInset = self.view.frame.size.width / 7.0
        return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset)
    }
    
    
// MARK: The navigation bar's Edit button functions
    
    func deleteAMeme(sender:UIButton) {
        // Put the index number of the delete button in a constant
        let i: Int = (sender.layer.valueForKey("index")) as! Int
        
        // Remove the Meme from the shared data source
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(i)
        
        // Remove the Meme from the collection view's dataSource
        memes.removeAtIndex(i)
        
        // Refresh the collection view
        self.collectionView!.reloadData()
    }

}

