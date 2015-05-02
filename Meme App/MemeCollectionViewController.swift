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
    
    var memes = [Meme]()
    
    // To add a new Meme image, by launching the Meme Editor Screen
    @IBAction func addButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("MemeViewController") as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = editButtonItem()
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
        self.collectionView!.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SentMemeItem", forIndexPath: indexPath) as! MemeCollectionViewCell
        let sentMeme = self.memes[indexPath.row]
        cell.memedImage.image = sentMeme.memedImage
        
        return cell
        
    }
    // To show up a selected Sent Meme in a separete view
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if self.editButtonItem().title == "Edit" {
        let memeDetailsController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailsViewController") as! MemeDetailsViewController
        memeDetailsController.hidesBottomBarWhenPushed = true
        memeDetailsController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(memeDetailsController, animated: false)
            
        } else if self.editButtonItem().title == "Done" {
            let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
            memes = applicationDelegate.memes
            memes.removeAtIndex(indexPath.row)
            var deletions: NSArray = [indexPath]
            self.collectionView?.deleteItemsAtIndexPaths(deletions as [AnyObject])
            println("You have now \(memes.count) Memes in CollectionView")
        }
    }
    
    // MARK: - UICollectionViewFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let memeDimension = self.view.frame.size.width / 3.0
        return CGSizeMake(memeDimension, memeDimension)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let leftRightInset = self.view.frame.size.width / 7.0
        return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset)
    }

    
}

