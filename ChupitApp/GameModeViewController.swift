//
//  GameModeViewController.swift
//  ChupitApp
//
//  Created by Marco Falanga on 08/02/18.
//  Copyright © 2018 Marco Falanga. All rights reserved.
//

import UIKit
import AVFoundation

class GameModeViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    //doneButton is the button inside the picker to choose the number of players
    var doneButton = UIButton()
    // if picker is already on, playButtonAction will be different
    var isPickerOn = false
    // picker inside a view shown by tapping play
    var picker: UIPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker = UIPickerView(frame: CGRect(x: 0, y: 40, width: 0, height: 0))
        pickerTextField.delegate = self
        picker.delegate = self
        picker.dataSource = self
        Sounds.shared.playBackgroundMusic(fileName: "Soft_Chupito.mp3")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelPicker(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    //show message, completion handler: go to ViewController
    func messageAnimation(string: String, substring: String) {
        DispatchQueue.main.async {
            self.messageLabel.isHidden = false
            let myString = string + "\n" + substring
            let attributedString = NSMutableAttributedString(string: myString)
            
            attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "YellowjacketRotate", size: 20) as Any, range: NSMakeRange(0, string.count))
            
            attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "YellowjacketRotate", size: 10) as Any, range: NSMakeRange(string.count + 1, substring.count))
            
            self.messageLabel.attributedText = attributedString
            
            UIView.animate(withDuration: 4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.curveEaseOut], animations: {
                self.messageLabel.transform = CGAffineTransform(scaleX: 2, y: 2)
            }, completion: { finish in
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                    self.messageLabel.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                }, completion: { (finish) in
                    self.messageLabel.text = ""
                    self.messageLabel.isHidden = true
                    
                    let transition = CATransition()
                    transition.type = kCATransitionFade
                    transition.duration = 0.2
                    
                    if let controller = self.storyboard?.instantiateViewController(withIdentifier: "FirstVC") as? ViewController {
                        self.view.window?.layer.add(transition, forKey: kCATransition)
                        self.view.window?.rootViewController = controller
                    }
                })
            })
        }
    }
    
    @IBAction func textField(_ sender: UITextField) {
        let tintColor: UIColor = .myOrange
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
        
        inputView.translatesAutoresizingMaskIntoConstraints = false
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.tintColor = tintColor
        //picker.center.x = inputView.center.x
        inputView.addSubview(picker) // add picker to UIView
        
        //doneButton = UIButton(frame: CGRect(x: (self.view.frame.size.width - 130), y: 0, width: 130, height: 50))
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setTitle("Done", for: UIControlState.normal)
        doneButton.setTitle("Done", for: UIControlState.highlighted)
        doneButton.setTitleColor(tintColor, for: UIControlState.normal)
        doneButton.setTitleColor(tintColor, for: UIControlState.highlighted)
        doneButton.titleLabel?.font = UIFont(name: "YellowjacketRotate", size: 17)
        inputView.addSubview(doneButton) // add Button to UIView
        doneButton.addTarget(self, action: #selector(doneButton(_:)), for: UIControlEvents.touchUpInside) // set button click event
        
        //let centeredLabel = UILabel(frame: CGRect(x: (self.view.frame.size.width/2) - 33, y: 0, width: 130, height: 50))
        let centeredLabel = UILabel()
        centeredLabel.translatesAutoresizingMaskIntoConstraints = false
        centeredLabel.text = "Players"
        centeredLabel.font = UIFont(name: "YellowjacketRotate", size: 17)
        centeredLabel.textColor = .white
        inputView.addSubview(centeredLabel)
        
        //let cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 130, height: 50))
        let cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Cancel", for: UIControlState.normal)
        cancelButton.setTitle("Cancel", for: UIControlState.highlighted)
        cancelButton.setTitleColor(tintColor, for: UIControlState.normal)
        cancelButton.setTitleColor(tintColor, for: UIControlState.highlighted)
        cancelButton.titleLabel?.font = UIFont(name: "YellowjacketRotate", size: 17)
        inputView.addSubview(cancelButton) // add Button to UIView
        
        let minusButton = UIButton()
        minusButton.tag = 0
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        minusButton.setTitle("-", for: UIControlState.normal)
        minusButton.setTitle("-", for: UIControlState.highlighted)
        minusButton.setTitleColor(tintColor, for: UIControlState.normal)
        minusButton.setTitleColor(tintColor, for: UIControlState.highlighted)
        minusButton.titleLabel?.font = UIFont(name: "YellowjacketRotate", size: 50)
        inputView.addSubview(minusButton) // add Button to UIView
        
        let plusButton = UIButton()
        plusButton.tag = 1
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.setTitle("+", for: UIControlState.normal)
        plusButton.setTitle("+", for: UIControlState.highlighted)
        plusButton.setTitleColor(tintColor, for: UIControlState.normal)
        plusButton.setTitleColor(tintColor, for: UIControlState.highlighted)
        plusButton.titleLabel?.font = UIFont(name: "YellowjacketRotate", size: 50)
        inputView.addSubview(plusButton) // add Button to UIView
        
        //set constraints
        centeredLabel.topAnchor.constraint(equalTo: inputView.topAnchor, constant: 5).isActive = true
        centeredLabel.centerXAnchor.constraint(equalTo: inputView.centerXAnchor).isActive = true
        doneButton.rightAnchor.constraint(equalTo: inputView.rightAnchor, constant: -6.0).isActive = true
        doneButton.centerYAnchor.constraint(equalTo: centeredLabel.centerYAnchor).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: inputView.leftAnchor, constant: 6.0).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: centeredLabel.centerYAnchor).isActive = true
        picker.centerYAnchor.constraint(equalTo: inputView.centerYAnchor).isActive = true
        picker.leadingAnchor.constraint(equalTo: inputView.leadingAnchor).isActive = true
        picker.trailingAnchor.constraint(equalTo: inputView.trailingAnchor).isActive = true
        
        minusButton.centerYAnchor.constraint(equalTo: inputView.centerYAnchor).isActive = true
        minusButton.centerXAnchor.constraint(equalTo: inputView.centerXAnchor, constant: -100).isActive = true
        
        plusButton.centerYAnchor.constraint(equalTo: inputView.centerYAnchor).isActive = true
        plusButton.centerXAnchor.constraint(equalTo: inputView.centerXAnchor, constant: 100).isActive = true
        
        minusButton.addTarget(self, action: #selector(minusOrPlus(_:)), for: UIControlEvents.touchUpInside)
        plusButton.addTarget(self, action: #selector(minusOrPlus(_:)), for: UIControlEvents.touchUpInside)
        
        cancelButton.addTarget(self, action: #selector(cancelPicker(_:)), for: UIControlEvents.touchUpInside) // set button click event
        sender.inputView = inputView
        
        inputView.backgroundColor = .black
        picker.backgroundColor = .black
        picker.showsSelectionIndicator = true
    }
    
    @objc func minusOrPlus(_ sender: UIButton) {
        if sender.tag == 0 {
            if picker.selectedRow(inComponent: 0) == 0 {
                return
            } else {
                picker.selectRow(picker.selectedRow(inComponent: 0) - 1, inComponent: 0, animated: true)
            }
        }
        if sender.tag == 1 {
            if picker.selectedRow(inComponent: 0) == picker.numberOfRows(inComponent: 0) {
                return
            } else {
                picker.selectRow(picker.selectedRow(inComponent: 0) + 1, inComponent: 0, animated: true)
            }
        }
    }
    
    @objc func doneButton(_ sender: UIButton) {
        Singleton.shared.playersNumber = picker.selectedRow(inComponent: 0) + 2
        pickerTextField.resignFirstResponder()
        iconImageView.alpha = 0
        bgImageView.alpha = 0
        playButton.alpha = 0
        
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            messageAnimation(string: "Selfie Time", substring: "be prepared!\nTake your selfies!")
        }
        else {
            showRequestCamera()
        }
    }
    
    func showRequestCamera() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted) in
            if granted {
                self.messageAnimation(string: "Selfie Time", substring: "be prepared!\nTake your selfies!")
            } else {
                self.showCameraRequestAlert()
            }
        })
    }
    
    func showCameraRequestAlert() {
        let alert = UIAlertController(title: "Camera Access Request", message: "To play this game, please allow camera access!", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            DispatchQueue.main.async {
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:])
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
            self.showCameraRequestAlert()
        }))
        
        self.present(alert, animated: true)
    }
    
    @objc func cancelPicker(_ sender: UIButton) {
        //Remove view when select cancel
        isPickerOn = false
        pickerTextField.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    @IBAction func playAction(_ sender: UIButton) {
        if isPickerOn == false {
            isPickerOn = true
            pickerTextField.becomeFirstResponder()
        }
        else {
            Singleton.shared.playersNumber = picker.selectedRow(inComponent: 0) + 2
            
            let transition = CATransition()
            transition.type = kCATransitionFade
            transition.duration = 0.2
            
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "FirstVC") as? ViewController {
                self.view.window?.layer.add(transition, forKey: kCATransition)
                self.view.window?.rootViewController = controller
            }
        }
    }
    
    @IBOutlet weak var pickerTextField: UITextField!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 98
    }
    
    // The data to return for the row and component (column) that's being passed in
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        for i in 2...100 {
//            pickerData.append("\(i)")
//        }
//        return pickerData[row]
//    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "YellowjacketRotate", size: 17)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = "\(row+2)"
        pickerLabel?.textColor = .white
        return pickerLabel!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // --- MOVE THE VIEW UP/DOWN IF KEYBOARD (PICKER) APPEARS/DISAPPEARS
    
    //move the view up/down if keyboard (or picker) appears/disappers
    func animateTextField(textField: UITextField, up: Bool)
    {
        let movementDistance:CGFloat = -130
        let movementDuration: Double = 0.3
        
        var movement:CGFloat = 0
        if up
        {
            movement = movementDistance
        }
        else
        {
            movement = -movementDistance
        }
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    //if keyboard (or picker) appears move the view up
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.animateTextField(textField: textField, up:true)
    }
    //if keyboard (or picker) disappears move the view down
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        self.animateTextField(textField: textField, up:false)
    }
    
    // --- STATUS BAR
    
    //hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

