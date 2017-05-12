//
//  ViewController.swift
//  NowTvSampleRemote
//
//  Created by Winton, Simon (Associate Software Developer) on 28/11/2016.
//  Copyright © 2016 Winton, Simon (Associate Software Developer). All rights reserved.
//

import UIKit
import NowTvRemote

class RemoteViewController: UIViewController, UITextFieldDelegate
{

    var remoteController: RemoteController!
    
    
    @IBOutlet weak var searchTxtBox: UITextField!
    @IBOutlet weak var clickView: UIView!

    
    override func viewDidLoad()
    {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        view.addSubview(searchTxtBox)
        self.searchTxtBox.delegate = self
        remoteController = DeviceManager.sharedInstance.remoteControl
    }
    
    
    @IBAction func rightPressed(_ sender: Any)
    {
        remoteController.buttonPressed(remoteControlButton: .right)
    }
   
    @IBAction func upPressed(_ sender: Any)
    {
        remoteController.buttonPressed(remoteControlButton: .up)
    }
    
    @IBAction func leftPressed(_ sender: Any)
    {
        remoteController.buttonPressed(remoteControlButton: .left)
    }
    
    @IBAction func downPressed(_ sender: Any)
    {
        remoteController.buttonPressed(remoteControlButton: .down)
    }
    
    @IBAction func okPressed(_ sender: Any)
    {
        remoteController.buttonPressed(remoteControlButton: .select)
    }

    @IBAction func rewindPressed(_ sender: Any)
    {
        remoteController.throwContent(contentID: "1412", contentType: .Live)
//        remoteController.buttonPressed(remoteControlButton: .rewind)
    }
    
    @IBAction func playPressed(_ sender: Any)
    {
        remoteController.buttonPressed(remoteControlButton: .play)
    }
    @IBAction func fastForwardPressed(_ sender: Any)
    {
        remoteController.buttonPressed(remoteControlButton: .fastForward)
    }
    @IBAction func backPressed(_ sender: Any)
    {
        remoteController.buttonPressed(remoteControlButton: .back)
    }
    @IBAction func homePressed(_ sender: Any)
    {
        remoteController.buttonPressed(remoteControlButton: .home)
    }
    
    @IBAction func Keyboard(_ sender: Any) {

        clickView.isHidden = false
        self.searchTxtBox.keyboardType = UIKeyboardType.alphabet
        self.searchTxtBox.autocorrectionType = .no
        self.searchTxtBox.text = "                        "
        self.searchTxtBox.returnKeyType = UIReturnKeyType.done
        self.searchTxtBox.becomeFirstResponder()

    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
        clickView.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let charStr  = string
        let char = string.cString(using: String.Encoding.utf8)!
        
        
        let isBackSpace = strcmp(char, "\\b")
        if (isBackSpace == -92)
        {
            print("Backspace")
            //rokuHandler.keyboardControlHttpRequest(character: "Backspace")
            remoteController.buttonPressed(remoteControlButton: .rewind)
        }
        else
        {
            print(charStr)
            let url = remoteController.baseURL + "keypress/Lit_" + charStr
            print(url)
            remoteController.sendCustomRequest(url: url)
            
            //rokuHandler.keyboardControlHttpRequest(character: charStr)
        }
        
        // Returns true to confirm text change
        return true
    }
    
}

