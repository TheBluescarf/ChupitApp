//
//  GameModeViewController.swift
//  ChupitApp
//
//  Created by Marco Falanga on 08/02/18.
//  Copyright © 2018 Marco Falanga. All rights reserved.
//

import UIKit

class GameModeViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var bgImageView: UIImageView!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    var doneButton = UIButton()
    
    var isPickerOn = false
    
    @IBOutlet weak var messageLabel: UILabel!
    
    func messageAnimation(string: String, substring: String) {
        messageLabel.isHidden = false
        let myString = string + "\n" + substring
        let attributedString = NSMutableAttributedString(string: myString)
        
        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "YellowjacketRotate", size: 20), range: NSMakeRange(0, string.count))
        
        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "YellowjacketRotate", size: 10), range: NSMakeRange(string.count + 1, substring.count))
        
        messageLabel.attributedText = attributedString
        
        UIView.animate(withDuration: 4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.curveEaseOut], animations: {
            self.messageLabel.transform = CGAffineTransform(scaleX: 2, y: 2)
        }, completion: { finish in
            //self.messageLabel.text = ""
            //self.messageLabel.isHidden = true
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
    
    @IBAction func textField(_ sender: UITextField) {
        //let tintColor: UIColor = UIColor(red: 101.0/255.0, green: 98.0/255.0, blue: 164.0/255.0, alpha: 1.0)
        let tintColor: UIColor = .myOrange
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
        picker.tintColor = tintColor
        picker.center.x = inputView.center.x
        inputView.addSubview(picker) // add date picker to UIView
        doneButton = UIButton(frame: CGRect(x: (self.view.frame.size.width - 130), y: 0, width: 130, height: 50))
        doneButton.setTitle("Done", for: UIControlState.normal)
        doneButton.setTitle("Done", for: UIControlState.highlighted)
        doneButton.setTitleColor(tintColor, for: UIControlState.normal)
        doneButton.setTitleColor(tintColor, for: UIControlState.highlighted)
        doneButton.titleLabel?.font = UIFont(name: "YellowjacketRotate", size: 17)
        inputView.addSubview(doneButton) // add Button to UIView
        doneButton.addTarget(self, action: #selector(doneButton(_:)), for: UIControlEvents.touchUpInside) // set button click event
        
        let centeredLabel = UILabel(frame: CGRect(x: (self.view.frame.size.width/2) - 33, y: 0, width: 130, height: 50))
        centeredLabel.text = "Players"
        centeredLabel.font = UIFont(name: "YellowjacketRotate", size: 17)
        inputView.addSubview(centeredLabel)
        
        let cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 130, height: 50))
        cancelButton.setTitle("Cancel", for: UIControlState.normal)
        cancelButton.setTitle("Cancel", for: UIControlState.highlighted)
        cancelButton.setTitleColor(tintColor, for: UIControlState.normal)
        cancelButton.setTitleColor(tintColor, for: UIControlState.highlighted)
        cancelButton.titleLabel?.font = UIFont(name: "YellowjacketRotate", size: 17)
        inputView.addSubview(cancelButton) // add Button to UIView
        cancelButton.addTarget(self, action: #selector(cancelPicker(_:)), for: UIControlEvents.touchUpInside) // set button click event
        sender.inputView = inputView
    }
    
    @objc func doneButton(_ sender: UIButton) {
        pickerTextField.resignFirstResponder()
        iconImageView.alpha = 0
        bgImageView.alpha = 0
        playButton.alpha = 0
        messageAnimation(string: "Selfie Time", substring: "be prepared!\nTake your selfies!")
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
    var pickerData: [String] = []
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 98
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedPickerData = pickerData[row] as String
        
        Singleton.shared.playersNumber = Int(selectedPickerData)!
        
        
        //        let transition = CATransition()
        //        transition.type = kCATransitionFade
        //        transition.duration = 0.2
        //
        //        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "FirstVC") as? ViewController {
        //            self.view.window?.layer.add(transition, forKey: kCATransition)
        //            self.view.window?.rootViewController = controller
        //        }
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        for i in 2...100 {
            pickerData.append("\(i)")
        }
        return pickerData[row]
    }
    
    
    var picker: UIPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        picker = UIPickerView(frame: CGRect(x: 0, y: 40, width: 0, height: 0))
        pickerTextField.delegate = self
        picker.delegate = self
        picker.dataSource = self
        Singleton.shared.playersNumber = 2
        Sounds.shared.playBackgroundMusic(fileName: "Soft_Chupito.mp3")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelPicker(_:)))
        self.view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.animateTextField(textField: textField, up:true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        self.animateTextField(textField: textField, up:false)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

