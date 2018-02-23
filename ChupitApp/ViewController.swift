//
//  ViewController.swift
//  ChupitApp
//
//  Created by Marco Falanga on 06/02/18.
//  Copyright © 2018 Marco Falanga. All rights reserved.
//

import UIKit



class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let reuseIdentifier = "cell"
    @IBOutlet weak var collectionView: UICollectionView!
    
    let picker = UIImagePickerController()
    var cameraButton = UIButton()
    var isPictureTaken = false
    var timer = Timer()
    var seconds = 3
    var timerLabel = UILabel()
    var playerLabel = UILabel()
    
    var count = 0
    
    var imageAnimationView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPlaceHolder()
        
        picker.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setPlaceHolder() {
        for _ in 0...Singleton.shared.playersNumber-1 {
            Singleton.shared.addOne(image: #imageLiteral(resourceName: "person-placeholder"))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        collectionView.reloadData()
        if count < Singleton.shared.playersNumber {
            collectionView.scrollToItem(at:IndexPath(item: count, section: 0), at: .right, animated: true)
        }
        
        if isPictureTaken {
            let transition = CATransition()
            transition.type = kCATransitionFade
            transition.duration = 0.2
            
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "GameNavVC") as? UINavigationController {
                self.view.window?.layer.add(transition, forKey: kCATransition)
                self.view.window?.rootViewController = controller
            }
        }
        else {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.allowsEditing = false
                picker.sourceType = UIImagePickerControllerSourceType.camera
                picker.cameraCaptureMode = .photo
                picker.modalPresentationStyle = .fullScreen
                picker.isToolbarHidden = true
                picker.isNavigationBarHidden = true
                picker.cameraDevice = .front
                picker.showsCameraControls = false
                
                let overlayView = UIView()
                overlayView.frame = self.view.frame
                overlayView.backgroundColor = .clear
                
                timerLabel = UILabel(frame: CGRect.init(x: 0, y: view.frame.height/2, width: self.view.frame.size.width, height: 150))
                timerLabel.textColor = .white
                timerLabel.textAlignment = .center
                timerLabel.font = UIFont(name: "YellowjacketRotate", size: 50)
                timerLabel.text = String(seconds)
                
                playerLabel = UILabel(frame: CGRect.init(x: 0, y: 10, width: self.view.frame.size.width, height: 150))
                playerLabel.textColor = .white
                playerLabel.textAlignment = .center
                playerLabel.font = UIFont(name: "YellowjacketRotate", size: 40)
                
                let randomInt: Int = Int(arc4random_uniform(UInt32(funnyNamesString.count)))
                playerLabel.text = funnyNamesString[randomInt]
                funnyNamesString.remove(at: randomInt)
                
                let circleView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height))
                
                circleView.center = self.view.center
                circleView.backgroundColor = .clear
                circleView.clipsToBounds = true
                
                overlayView.addSubview(circleView)
                overlayView.addSubview(collectionView)
                
                let radius = view.frame.width/2-30
                let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), cornerRadius: 0)
                let circlePath = UIBezierPath(roundedRect: CGRect(x: 30, y: self.view.frame.midY/2, width: 2 * radius, height: 2 * radius), cornerRadius: radius)
                path.append(circlePath)
                path.usesEvenOddFillRule = true
                let fillLayer = CAShapeLayer()
                fillLayer.path = path.cgPath
                fillLayer.fillRule = kCAFillRuleEvenOdd
                fillLayer.fillColor = UIColor(white: 0.5, alpha: 0.5).cgColor
                //fillLayer.opacity = 0.5
                circleView.layer.addSublayer(fillLayer)
                
//                let circlePath = UIBezierPath(arcCenter: CGPoint(x: 100,y: 100), radius: CGFloat(20), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
//
//                let shapeLayer = CAShapeLayer()
//                shapeLayer.path = circlePath.cgPath
//                shapeLayer.fillColor = UIColor.clear.cgColor
//                shapeLayer.strokeColor = UIColor.red.cgColor
//                shapeLayer.lineWidth = 500
//
//
//                overlayView.layer.addSublayer(shapeLayer)
                
//                let circle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.width))
//
//                circle.center = self.view.center
//                circle.layer.cornerRadius = circle.frame.width/2
//                circle.backgroundColor = .clear
//                circle.clipsToBounds = true
//                circle.layer.borderWidth = 500
//                circle.layer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor
    
//                overlayView.addSubview(circle)
                
                cameraButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                
                cameraButton.setImage(#imageLiteral(resourceName: "camera"), for: .normal)
                cameraButton.translatesAutoresizingMaskIntoConstraints = false
                overlayView.addSubview(cameraButton)
                
                
                
                
                
                overlayView.addSubview(timerLabel)
                overlayView.addSubview(playerLabel)
                overlayView.addSubview(imageAnimationView)
                collectionView.translatesAutoresizingMaskIntoConstraints = false
                timerLabel.translatesAutoresizingMaskIntoConstraints = false
                playerLabel.translatesAutoresizingMaskIntoConstraints = false
                
                imageAnimationView.translatesAutoresizingMaskIntoConstraints = false
                imageAnimationView.contentMode = .scaleAspectFill
                
                NSLayoutConstraint.activate([
                    
                    NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: overlayView, attribute: .top, multiplier: 1.0, constant: 30),
                    
                    NSLayoutConstraint(item: collectionView, attribute: .left, relatedBy: .equal, toItem: overlayView, attribute: .left, multiplier: 1.0, constant: 20),
                    
                    NSLayoutConstraint(item: collectionView, attribute: .right, relatedBy: .equal, toItem: overlayView, attribute: .right, multiplier: 1.0, constant: -20),
                    
                    NSLayoutConstraint(item: collectionView, attribute: .height, relatedBy: .equal, toItem: overlayView, attribute: .height, multiplier: 0.15, constant: 0),

                    NSLayoutConstraint(item: timerLabel, attribute: .centerX, relatedBy: .equal, toItem: overlayView, attribute: .centerX, multiplier: 1.0, constant: 0),
                    
                    NSLayoutConstraint(item: timerLabel, attribute: .centerY, relatedBy: .equal, toItem: overlayView, attribute: .centerY, multiplier: 1.0, constant: 0),
                    
                    NSLayoutConstraint(item: playerLabel, attribute: .bottom, relatedBy: .equal, toItem: overlayView, attribute: .bottom, multiplier: 1.0, constant: -20),
                    
                    NSLayoutConstraint(item: playerLabel, attribute: .centerX, relatedBy: .equal, toItem: overlayView, attribute: .centerX, multiplier: 1.0, constant: 0),
                    
                    NSLayoutConstraint(item: playerLabel, attribute: .width, relatedBy: .equal, toItem: overlayView, attribute: .width, multiplier: 0.7, constant: 0),
                    
                    NSLayoutConstraint(item: imageAnimationView, attribute: .centerX, relatedBy: .equal, toItem: overlayView, attribute: .centerX, multiplier: 1.0, constant: 0),

                    NSLayoutConstraint(item: imageAnimationView, attribute: .centerY, relatedBy: .equal, toItem: overlayView, attribute: .centerY, multiplier: 1.0, constant: 0),

                    NSLayoutConstraint(item: imageAnimationView, attribute: .width, relatedBy: .equal, toItem: overlayView, attribute: .width, multiplier: 0.5, constant: 0),

                    NSLayoutConstraint(item: imageAnimationView, attribute: .height, relatedBy: .equal, toItem: overlayView, attribute: .width, multiplier: 0.5, constant: 0),
                    
                    NSLayoutConstraint(item: cameraButton, attribute: .centerX, relatedBy: .equal, toItem: overlayView, attribute: .centerX, multiplier: 1.0, constant: 0),
                    
                    NSLayoutConstraint(item: cameraButton, attribute: .bottom, relatedBy: .equal, toItem: playerLabel, attribute: .top, multiplier: 1.0, constant: 0),
                    
                    NSLayoutConstraint(item: cameraButton, attribute: .width, relatedBy: .equal, toItem: overlayView, attribute: .width, multiplier: 0.2, constant: 0),
                    
                    NSLayoutConstraint(item: cameraButton, attribute: .height, relatedBy: .equal, toItem: overlayView, attribute: .width, multiplier: 0.2, constant:0)

                    ])
                
                playerLabel.adjustsFontSizeToFitWidth = true
                
                cameraButton.addTarget(self, action: #selector(takeNow), for: .touchUpInside)
                
                picker.cameraOverlayView = overlayView
                
                present(picker,animated: false) {
                    self.selfieCountdown()
                }
            }
            else {
                print("No camera")
                noCamera()
            }

        }
    }
    
    @objc func takeNow(sender: UIButton) {
        timer.invalidate()
        timerLabel.isHidden = true
        cameraButton.isUserInteractionEnabled = false
        picker.takePicture()
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    func selfieCountdown() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTime)), userInfo: nil, repeats: true)
    }
    
    @objc
    func updateTime() {
        seconds -= 1
        timerLabel.text = "\(seconds)"
        if seconds == 2 {
            timerLabel.textColor = .orange
        }
        if seconds == 1 {
            timerLabel.textColor = .red
        }
        if seconds == 0 {
            timer.invalidate()
            timerLabel.isHidden = true
            picker.takePicture()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
//        Singleton.shared.addOne(image: image)
//        print("______")
//        let viewController = storyboard?.instantiateViewController(withIdentifier: "GameVC") as! GameViewController
//        self.dismiss(animated: true, completion: nil)
//        show(viewController, sender: nil)
//        //present(viewController, animated: true, completion: nil)
//    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("PHOTO")
        seconds = 3
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
           Singleton.shared.replaceAtIndex(image: image, index: count)
            
            if count < Singleton.shared.users.count {
            Singleton.shared.users[count].username = playerLabel.text!
            }
            count += 1
        } else if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
           Singleton.shared.replaceAtIndex(image: image, index: count)
            if count < Singleton.shared.users.count {
                Singleton.shared.users[count].username = playerLabel.text!
            }
            count += 1
        }
        if count == Singleton.shared.playersNumber {
            isPictureTaken = true
        }
        imageAnimationAndReloadData()
        //self.dismiss(animated:false, completion: nil)
    }
    
    func reloadData() {

        timerLabel.text = "3"
        timerLabel.textColor = .white
        cameraButton.isUserInteractionEnabled = true
        
        //collectionView.reloadData()
        if count < Singleton.shared.playersNumber {
            collectionView.scrollToItem(at:IndexPath(item: count, section: 0), at: .right, animated: true)
        }
        
        print("\(count) di \(Singleton.shared.playersNumber) - \(isPictureTaken)")
        
        if isPictureTaken == true {
            let transition = CATransition()
            transition.type = kCATransitionFade
            transition.duration = 0.2
            
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "GameNavVC") as? UINavigationController {
                picker.dismiss(animated: true, completion: nil)
                self.view.window?.layer.add(transition, forKey: kCATransition)
                self.view.window?.rootViewController = controller
            }
        }
        else {
            timerLabel.isHidden = false
            seconds = 3
            collectionView.reloadData()
            //playerLabel.text = "Player \(count+1)"
            let randomInt: Int = Int(arc4random_uniform(UInt32(funnyNamesString.count)))
            playerLabel.text = funnyNamesString[randomInt]
            funnyNamesString.remove(at: randomInt)

            selfieCountdown()
        }
    }
    
    func imageAnimationAndReloadData() {
        imageAnimationView.image = #imageLiteral(resourceName: "right_arrow")
        //imageAnimationView.roundedImage()
        
        if count != Singleton.shared.playersNumber {
            imageAnimationView.alpha = 1
        }
        //eventuale animazione della image creata al centro
        UIView.animate(withDuration: 0.4, animations: {
            self.imageAnimationView.transform = CGAffineTransform(rotationAngle: 0.35)
            //self.imageAnimationView.alpha = 0
            self.collectionView.reloadData()
        }) { (finish) in
            UIView.animate(withDuration: 0.4, animations: {
                self.imageAnimationView.transform = CGAffineTransform(rotationAngle: -0.35)
                self.imageAnimationView.alpha = 0
            })
            
            self.reloadData()
        }
   }
}

extension ViewController: UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Singleton.shared.users.endIndex
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserViewCell
        
        let user = Singleton.shared.users[indexPath.row]
        
        cell.userImageView.roundedImage()
        cell.userImageView.image = user.image
        cell.chupitoImageView.image = #imageLiteral(resourceName: "chupito")
        cell.chupitoCounterLabel.text = "\(user.chupitos)"
        cell.chupitoCounterLabel.adjustsFontSizeToFitWidth = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row != count {
            cell.alpha = 0.5
        }
        
        if indexPath.row == count {
            cell.transform = CGAffineTransform(translationX: 0, y: -20).concatenating(CGAffineTransform(scaleX: 0.5, y: 0.5))
            cell.alpha = 0
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: [.curveEaseOut], animations: {
                cell.transform = .identity
                cell.alpha = 1
            })
        }
    }
}

