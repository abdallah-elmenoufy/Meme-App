//
//  MemeViewController.swift
//  Meme App
//
//  Created by Abdallah ElMenoufy on 4/13/15.
//  Copyright (c) 2015 Abdallah ElMenoufy. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    
    // Connecting the IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    
    
    
    // Declaring the delegates for both text fields "Not that mandatory in the udacity's requests, but I made them for future enhancments if required by clients ;)
    var topTextFieldDelegate = TopTextFieldDelegate()
    var bottomTextFieldDelegate = BottomTextFieldDelegate()
    
    // Instantiating the UIImagePickerController
    let imagePickerController = UIImagePickerController()
    
    // Setting the text fields' text attributes
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!,
        NSStrokeWidthAttributeName: NSNumber(float: -4.0)
    ]
    
    
    // Cancel Button
    @IBAction func cancelButton() {
        
        // Cancels the Meme-ing process and returns the MemeVC to its defauls
        imageView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        shareButton.enabled = false
        
        // Alert the user if he hasn't sent any Memes yet and trying to Cancel the MemeEditorVC to show the Sent Memes VC
        if (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count == 0 {
            let alertController = UIAlertController(title: "Oops!", message: "You haven't sent any memes yet :)", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Okay, let's Meme", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
        } else if (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count > 0 {
        
        // Bring the Semt Memes VC onto the stack VC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("TabBarOfSentMemes") as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
            
        }
    }

    
    // General purpose picking an Image function
    func pickingImage() {
        imageView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imagePickerController.delegate = self
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    // Picking an image from Camera Roll - saved album
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        pickingImage()
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    }
    
    // Picking an image snapped by the device's cameras
    @IBAction func pickAnImageFromCamera (sender: AnyObject) {
        pickingImage()
        imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
    }
    
    func defaultSettings() {
        // Defaults of the text fields when app first launches
        topTextField.text = "TOP"
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.text = "BOTTOM"
        bottomTextField.textAlignment = NSTextAlignment.Center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       defaultSettings()
        
        // Disable the shareButton when app first launches, before user's selected an image
        shareButton.enabled = false
        
        // Calling the text fields's text attributes when app first launches
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        // Calling the text fields delegates
        self.topTextField.delegate = topTextFieldDelegate
        self.bottomTextField.delegate = bottomTextFieldDelegate
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        defaultSettings()
        
        // Checking if the device's camera is available or not?
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        
        // To adhere to keyboard's appearance mechanism
        self.subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // To adhere to keyboard's disappearance mechanism
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // Showing the selected image in the editor after picking-up is accomplished successfully
    func imagePickerController(imagePickerController: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = originalImage
            self.imageView.contentMode = UIViewContentMode.ScaleToFill
            
            // Enable the shareButton after user has successfully selected an image
            shareButton.enabled = true
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // Dismissing the image picker controller when user cancels the picking process
        func imagePickerControllerDidCancel(imagePickerView: UIImagePickerController) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    
    
    // Describe the keyboard's notification subscribtion
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Describe the keyboard's notification un-subscribtion
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // How the keyboard will show ?
    func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    // How the keyboard will hide ?
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    // Measuring the keyboard's height, to be used in show/hide keyboard's frame functions
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    // Implemnt the Share button fuction
    @IBAction func shareToSocialMedia() {
        var sharedMeme = generateMemedImage()
        let sharingController = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        self.presentViewController(sharingController, animated: true, completion: nil)
        
        // Save any Sent Memes inside the app,
        sharingController.completionWithItemsHandler = {
            (activity, success, items, error) in
            self.saveASentMeme()
            
       // and show the Sent Memes View Selector after saving the Sent Meme
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("TabBarOfSentMemes") as! UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
        
        }
    }
    
    
    // Saving the Sent Meme into an array of Memes inside AppDelegate
    func saveASentMeme() {
        var meme = Meme(top: topTextField.text!, bottom: bottomTextField.text!, image: imageView.image!, memedImage: generateMemedImage())
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        var memoz = (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count
        
        println("You have \(memoz) Memes Sent")
    }
    
    
    // Generating a Meme Image
    func generateMemedImage() -> UIImage {
        // Render the current view to a Memed Image
        self.topToolBar.hidden = true
        self.bottomToolBar.hidden = true
    
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.topToolBar.hidden = false
        self.bottomToolBar.hidden = false
        
        
        return memedImage
    }
    
}







