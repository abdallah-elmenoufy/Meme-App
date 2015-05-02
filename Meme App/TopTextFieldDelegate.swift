//
//  TopTextFieldDelegate.swift
//  Meme App
//
//  Created by Abdallah ElMenoufy on 4/13/15.
//  Copyright (c) 2015 Abdallah ElMenoufy. All rights reserved.
//

import Foundation
import UIKit

class TopTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" {
            textField.text = ""
            textField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
  
}