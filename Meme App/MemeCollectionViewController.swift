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

    
    // To add a new Meme image, by launching the Meme Editor Screen
    @IBAction func addButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("MemeViewController") as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    // MARK: - CollectionView life cycle methods **** //
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        collectionView!.reloadData()
        
        // In case no Sent Memes yet, jump to the MemeEditorVC directly
        if memes.count == 0 {
            let storyboard = self.storyboard
            let vc = storyboard!.instantiateViewControllerWithIdentifier("MemeViewController") as! UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
            
            println("CollectonViewDidAppear with \(memes.count) == 0 SentMemes")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = editButtonItem()
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        self.collectionView!.reloadData()
    }
    
    
    
    // MARK: - CollectionView DataSourceDelegate Methods **** //
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SentMemeItem", forIndexPath: indexPath) as! MemeCollectionViewCell
        let sentMeme = memes[indexPath.item]
        cell.memedImage.image = sentMeme.memedImage
        
        return cell
    }
    
    // To show up a selected Sent Meme in a separete view
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if self.editButtonItem().title == "Edit" {
        let memeDetailsController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailsViewController") as! MemeDetailsViewController
        memeDetailsController.hidesBottomBarWhenPushed = true
        memeDetailsController.meme = self.memes[indexPath.item]
        self.navigationController!.pushViewController(memeDetailsController, animated: false)
            println("MemeDetails are here")
            
        // To delete a Meme from the collection view when Edit button is clicked
        } else if self.editButtonItem().title == "Done" {
            let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
            memes = applicationDelegate.memes
            if memes.count > 0 {
            applicationDelegate.memes.removeAtIndex(indexPath.item)
            self.collectionView?.deleteItemsAtIndexPaths([indexPath] as [AnyObject])
                
            }
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

