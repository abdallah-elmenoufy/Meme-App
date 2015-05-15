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
    

// MARK: - TextFields and their associated functions/attributes/delegates
    
    // Declaring the delegates for both text fields "Not that mandatory in the udacity's requests, but I made them for future enhancments if required by clients ;)
    var topTextFieldDelegate = TopTextFieldDelegate()
    var bottomTextFieldDelegate = BottomTextFieldDelegate()
    
    // Setting the text fields' text attributes
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: NSNumber(float: -3.0)
    ]
    
    // Defaults of the text fields when app first launches
    func defaultSettings() {
        topTextField.text = "TOP"
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.text = "BOTTOM"
        bottomTextField.textAlignment = NSTextAlignment.Center
    }
    

// MARK: - UIImagePickerController and its associated functions //
    
    // Instantiating the UIImagePickerController
    let imagePickerController = UIImagePickerController()

    // Showing the selected image in the editor after picking-up is accomplished successfully
    func imagePickerController(imagePickerController: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = originalImage
            self.imageView.contentMode = UIViewContentMode.ScaleToFill
            
            // Enable the shareButton after user has successfully selected an image
            shareButton.enabled = true
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // Dismissing the image picker controller when user cancels the picking process
    func imagePickerControllerDidCancel(imagePickerView: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
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
    
    
    
// MARK:- View Life Cycles - (3) Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSettings()
        
        // Disable the shareButton when app first launches, before user's selected an image
        shareButton.enabled = false
        
        // Calling the text fields's text attributes when app first launches
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.borderStyle = UITextBorderStyle.None
        bottomTextField.borderStyle = UITextBorderStyle.None
        
        // Calling the text fields delegates
        self.topTextField.delegate = topTextFieldDelegate
        self.bottomTextField.delegate = bottomTextFieldDelegate
        
        // Add the small (x) button in the text fields
        topTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        bottomTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        
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


// MARK: - Interactions with the Keyboard while editing the textFields //
    
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
        // Get the keyboard's height in case ONLY botton textfield is being edited
        if bottomTextField.editing {
            let userInfo = notification.userInfo
            let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
            return keyboardSize.CGRectValue().height
            
        } else {
            // Return 0, not to shift the entire view up while editing the top textfield
            return 0
        }
    }
   
    
// MARK: - Share to socialMedia using UIActivityViewController
    
    // Implemnt the Share button fuction
    @IBAction func shareToSocialMedia() {
        let sharedMeme = generateMemedImage()
        let sharingController = UIActivityViewController(activityItems: [sharedMeme], applicationActivities: nil)
        presentViewController(sharingController, animated: true, completion: nil)
        
        // Save any Sent Memes inside the app,
        sharingController.completionWithItemsHandler = {
            (activity, success, items, error) in
            if success {
                // Save the activity-passed Meme into the SharedDataContainer inside the AppDelegate using the following funciton
                self.saveASentMeme()
                
                // and show the Sent Memes View Selector after saving the Sent Meme
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("TabBarOfSentMemes") as! UIViewController
                self.presentViewController(vc, animated: true, completion: nil)
            }
        }
    }
    

// MARK: - Generating and Saving the Meme
    
    // Saving the Sent Meme into an array of Memes inside AppDelegate
    func saveASentMeme() {
        var meme = Meme(top: topTextField.text!, bottom: bottomTextField.text!, image: imageView.image!, memedImage: generateMemedImage())
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    // Generating a Meme Image
    func generateMemedImage() -> UIImage {
        
        // Hide the Top and Bottom toolbars before rendering the image
        self.topToolBar.hidden = true
        self.bottomToolBar.hidden = true
        
        // Render the current view to a Memed Image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show the Top and Bottom toolbars again after successfully rendering the image
        self.topToolBar.hidden = false
        self.bottomToolBar.hidden = false
        
        return memedImage
    }

    
    
// MARK:- Cancel button has 4 cases to process, each has its own UIAlertViewController with its related UIAlertActions; please see the following //
    
    @IBAction func cancelButton() {
        var x = (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count
        var y = Int(x > 0)
        
        // Switching on the Meme array.count
        switch x {
            
        // (1) User hasn't sent any Memes yet, and didn't picked an Image as well
        case 0 where self.imageView.image == nil:
            let alertController = UIAlertController(title: "Oops!", message: "You haven't sent any memes yet :)", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Okay, let's Meme", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            break;
            
        // (2) User hasn't sent any Memes yet, but has picked an Image
        case 0 where self.imageView.image != nil:
            let alertController = UIAlertController(title: "CANCEL!", message: "This will dismiss the unsaved Meme, sure ?", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Yes", style: .Destructive) {(action) in self.reset()}
            alertController.addAction(okAction)
            let cancelAction = UIAlertAction(title: "No", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            break;
            
        // (3) User has some Sent Memes, but didn't pick an Image yet
        case y where self.imageView.image == nil:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("TabBarOfSentMemes") as! UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
            break;
           
        // (4) User has some Sent Memes, and picked an Image to start editing it
        case y where self.imageView.image != nil:
            let alertController = UIAlertController(title: "CANCEL!", message: "This will dismiss the unsaved Meme and open Sent Memes, sure ?", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "No", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let resetAction = UIAlertAction(title: "Dismiss Only", style: .Destructive) {(action) in self.reset()}
            alertController.addAction(resetAction)
            
            let okAction = UIAlertAction(title: "Yes", style: .Destructive) { (action) in
                self.reset()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("TabBarOfSentMemes") as! UIViewController
                self.presentViewController(vc, animated: true, completion: nil)
            }
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            break;
            
        default:
            break;
        }
    }
    
    // Cancels the Meme-ing process and returns the MemeEditorVC to its defauls
    func reset() {
        imageView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        shareButton.enabled = false
    }
}







