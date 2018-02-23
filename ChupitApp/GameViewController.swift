//
//  GameViewController.swift
//  ChupitApp
//
//  Created by Marco Falanga on 07/02/18.
//  Copyright © 2018 Marco Falanga. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ChildToParentProtocol {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var trackingLabel: UILabel!
    @IBOutlet weak var trackingView: UIView!
    
    //@IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    weak var interactionDelegate: GameInteractionProtocol?
    
    var count: Int = 0
    var appendedPoints: Int = 0
    
    //bool per settare azione diversa in takePicture()
    var isForCollection: Bool = false
    
    @IBAction func takePictureAction(_ sender: UIButton) {
        
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            picker.isToolbarHidden = true
            picker.isNavigationBarHidden = true
            picker.cameraDevice = .front
            picker.showsCameraControls = false
            
            self.navigationController?.isNavigationBarHidden = true
            let overlayView = UIView()
            overlayView.frame = self.view.frame
            overlayView.backgroundColor = .clear
            
            timerLabel = UILabel(frame: CGRect.init(x: 0, y: view.frame.height/2, width: self.view.frame.size.width, height: 150))
            timerLabel.textColor = .white
            timerLabel.textAlignment = .center
            timerLabel.font = UIFont(name: "YellowjacketRotate", size: 50)
            timerLabel.text = String(seconds)
            
            let randomLabel = UILabel(frame: CGRect.init(x: 0, y: 10, width: self.view.frame.size.width, height: 150))
            randomLabel.textColor = .white
            randomLabel.textAlignment = .center
            randomLabel.font = UIFont(name: "YellowjacketRotate", size: 17)
            randomLabel.adjustsFontSizeToFitWidth = true
            randomLabel.lineBreakMode = .byWordWrapping
            randomLabel.numberOfLines = 0
            
            randomLabel.text = funnyPhotosString[Int(arc4random_uniform(UInt32(funnyPhotosString.count)))]
            
            let cameraButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            
            cameraButton.setImage(#imageLiteral(resourceName: "camera"), for: .normal)
            cameraButton.translatesAutoresizingMaskIntoConstraints = false
            overlayView.addSubview(cameraButton)
            
            overlayView.addSubview(randomLabel)
            timerLabel.translatesAutoresizingMaskIntoConstraints = false
            randomLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            backButton.setTitle("Cancel", for: .normal)
            backButton.titleLabel?.textColor = .white
            backButton.titleLabel?.adjustsFontSizeToFitWidth = true
            backButton.translatesAutoresizingMaskIntoConstraints = false
            overlayView.addSubview(backButton)
            
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: randomLabel, attribute: .top, relatedBy: .equal, toItem: overlayView, attribute: .top, multiplier: 1.0, constant: 30),
                
                NSLayoutConstraint(item: randomLabel, attribute: .centerX, relatedBy: .equal, toItem: overlayView, attribute: .centerX, multiplier: 1.0, constant: 0),
                
                NSLayoutConstraint(item: cameraButton, attribute: .centerX, relatedBy: .equal, toItem: overlayView, attribute: .centerX, multiplier: 1.0, constant: 0),
                
                NSLayoutConstraint(item: cameraButton, attribute: .bottom, relatedBy: .equal, toItem: overlayView, attribute: .bottom, multiplier: 1.0, constant: -50),
                
                NSLayoutConstraint(item: cameraButton, attribute: .width, relatedBy: .equal, toItem: overlayView, attribute: .width, multiplier: 0.2, constant: 0),
                
                NSLayoutConstraint(item: cameraButton, attribute: .height, relatedBy: .equal, toItem: overlayView, attribute: .width, multiplier: 0.2, constant:0),
                
                NSLayoutConstraint(item: backButton, attribute: .left, relatedBy: .equal, toItem: overlayView, attribute: .left, multiplier: 1.0, constant: 20),
                
                NSLayoutConstraint(item: backButton, attribute: .centerY, relatedBy: .equal, toItem: cameraButton, attribute: .centerY, multiplier: 1.0, constant: 0),
                
                NSLayoutConstraint(item: backButton, attribute: .width, relatedBy: .equal, toItem: overlayView, attribute: .width, multiplier: 0.2, constant: 0),
                
                NSLayoutConstraint(item: backButton, attribute: .height, relatedBy: .equal, toItem: overlayView, attribute: .width, multiplier: 0.2, constant:0)
                
                ])
            
            isForCollection = true
            
            cameraButton.addTarget(self, action: #selector(takeNow), for: .touchUpInside)
            
            backButton.addTarget(self, action: #selector(dismissPicker), for: .touchUpInside)
            
            picker.cameraOverlayView = overlayView
            
            present(picker,animated: false) {
            }
        }
        else {
            print("No camera")
            noCamera()
        }
    }
    
    // 0 red, 1 black
    var choice: Int?
    
    var isConsecutive = false
    
    let picker = UIImagePickerController()
    var timer = Timer()
    var seconds = 3
    var timerLabel = UILabel()
    var playerLabel = UILabel()
    
    @objc func dismissPicker(_ sender: UIButton) {
        self.navigationController?.isNavigationBarHidden = false
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPlayerAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Do you want to add a new player?", message: "It will be the next one!", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
            self.setNewPlayer()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        
    }
    
    
    
    
    func setNewPlayer() {
        //SE SONO IN ARKIT AGGIUNGO UN PERSONAGGIO DI DEFAULT - NO PICKER!!!
        if GameUtils.shared.mode == .ARKit {
            Singleton.shared.addOneAtIndex(image: #imageLiteral(resourceName: "person-placeholder"), index: count+1)
            if count < Singleton.shared.users.count {
                let randomInt: Int = Int(arc4random_uniform(UInt32(funnyNamesString.count)))
                playerLabel.text = funnyNamesString[randomInt]
                funnyNamesString.remove(at: randomInt)
                Singleton.shared.users[count+1].username = playerLabel.text!
            }
            Singleton.shared.playersNumber += 1
            collectionView.reloadData()
            return
        }
        
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            picker.isToolbarHidden = true
            picker.isNavigationBarHidden = true
            picker.cameraDevice = .front
            picker.showsCameraControls = false
            
            self.navigationController?.isNavigationBarHidden = true
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
            
            let cameraButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            
            cameraButton.setImage(#imageLiteral(resourceName: "camera"), for: .normal)
            cameraButton.translatesAutoresizingMaskIntoConstraints = false
            overlayView.addSubview(cameraButton)
            
            timerLabel.translatesAutoresizingMaskIntoConstraints = false
            playerLabel.translatesAutoresizingMaskIntoConstraints = false
            overlayView.addSubview(timerLabel)
            overlayView.addSubview(playerLabel)
            
            
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: timerLabel, attribute: .centerX, relatedBy: .equal, toItem: overlayView, attribute: .centerX, multiplier: 1.0, constant: 0),
                
                NSLayoutConstraint(item: timerLabel, attribute: .centerY, relatedBy: .equal, toItem: overlayView, attribute: .centerY, multiplier: 1.0, constant: 0),
                
                NSLayoutConstraint(item: playerLabel, attribute: .bottom, relatedBy: .equal, toItem: overlayView, attribute: .bottom, multiplier: 1.0, constant: -20),
                
                NSLayoutConstraint(item: playerLabel, attribute: .centerX, relatedBy: .equal, toItem: overlayView, attribute: .centerX, multiplier: 1.0, constant: 0),
                
                NSLayoutConstraint(item: playerLabel, attribute: .width, relatedBy: .equal, toItem: overlayView, attribute: .width, multiplier: 0.7, constant: 0),
                
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
    
    @objc func takeNow(sender: UIButton) {
        timer.invalidate()
        timerLabel.isHidden = true
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
    
    @objc func updateTime() {
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("PHOTO")
        
        if isForCollection == true {
            isForCollection = false
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                Singleton.shared.addImageInCollectionAtUserIndex(image: image, index: count)
                self.navigationController?.isNavigationBarHidden = false
                self.dismiss(animated:false, completion: nil)
            } else if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                Singleton.shared.addImageInCollectionAtUserIndex(image: image, index: count)
                self.navigationController?.isNavigationBarHidden = false
                self.dismiss(animated:false, completion: nil)
            }
        }
        else {
            seconds = 3
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                Singleton.shared.addOneAtIndex(image: image, index: count+1)
                if count < Singleton.shared.users.count {
                    Singleton.shared.users[count+1].username = playerLabel.text!
                }
                Singleton.shared.playersNumber += 1
                
                self.navigationController?.isNavigationBarHidden = false
                self.dismiss(animated:false, completion: nil)
                collectionView.reloadData()
            } else if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                Singleton.shared.addOneAtIndex(image: image, index: count+1)
                if count < Singleton.shared.users.count {
                    Singleton.shared.users[count+1].username = playerLabel.text!
                }
                Singleton.shared.playersNumber += 1
                self.navigationController?.isNavigationBarHidden = false
                self.dismiss(animated:false, completion: nil)
                collectionView.reloadData()
            }
        }
    }
    
    @objc func leaveTable(_ sender: UIButton) {
        let alert = UIAlertController(title: "Quit", message: "Have your last chupito and see you soon!", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Bye bye \(Singleton.shared.users[count].username)!", style: .default, handler: { action in
            Singleton.shared.users[self.count].isActive = false
            self.nextPlayer()
            self.collectionView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "End Game", style: .destructive, handler: { action in
            self.preEndGame()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func preEndGame() {
        let alert = UIAlertController(title: "Are you sure?", message: "If you confirm, the game will end!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "End Game", style: .destructive, handler: { action in
            self.endGame()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        choice = sender.tag
        
        showCard()
    }
    
    func goToReportController() {
        endGame()
    }
    
    func switchController(type: String) {
        let oldController = childViewControllers.last!
        oldController.willMove(toParentViewController: nil)
        
        switch type {
        case "AR":
            let newController = storyboard!.instantiateViewController(withIdentifier: "arkitGameViewController") as! ArkitGameViewController
            addChildViewController(newController)
            newController.view.frame = oldController.view.frame
            newController.delegate = self
            transition(from: oldController, to: newController, duration: 0.25, options: .transitionCrossDissolve, animations: {}, completion: { _ in
                oldController.removeFromParentViewController()
                newController.didMove(toParentViewController: self)
            })
        case "SCN":
            let newController = storyboard!.instantiateViewController(withIdentifier: "scenekitGameViewController") as! ScenekitGameViewController
            addChildViewController(newController)
            newController.delegate = self
            newController.view.frame = oldController.view.frame
            transition(from: oldController, to: newController, duration: 0.25, options: .transitionCrossDissolve, animations: {}, completion: { _ in
                oldController.removeFromParentViewController()
                newController.didMove(toParentViewController: self)
            })
        default:
            break
        }
    }
    
    func hideChoices(hide: Bool) {
        print("hide function")
        switch hide {
        case true:
            rightButton.isHidden = true
            leftButton.isHidden = true
            //photoButton.isHidden = true
        case false:
            rightButton.isHidden = false
            leftButton.isHidden = false
            if GameUtils.shared.mode != .ARKit {
                //photoButton.isHidden = false
            }
        }
    }
    
    func showTrackingLabel(hide: Bool) {
        trackingView.isHidden = hide
    }
    
    
    func winPick(win: Bool) {
        switch win {
        case true:
            messageAnimation(string: "You win!", substring: "Next player...")
            winAnimation()
        case false:
            messageAnimation(string: "You lose!", substring: "Have your chupito and try again!")
            loseAnimation()
        }
    }
    
    func winOrLoseBeforeAnimation(value: String) {
        switch value {
        case "Win":
            //win stuffs
            break
        case "Lose":
            //lose stuffs
            break
        default:
            break
            //default stuffs
        }
    }
    
    func deckTapped() {
        print("deck tapped")
        //deck premuto nella scena //// delegate
    }
    
    func showCard() {
        if let choice = choice {
            interactionDelegate?.choiceButton!(color: choice)
        }
    }
    
    func winAnimation() {
        isConsecutive = false
        nextPlayer()
        collectionView.reloadData()
        
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        //            self.cardLabel.text = "Hidden Card"
        //            self.cardLabel.textColor = .lightGray
        //        }
    }
    
    func loseAnimation() {
        
        if isConsecutive == false {
            isConsecutive = true
        }
        else {
            Singleton.shared.users[count].consecutiveChupitos += 1
        }
        
        Singleton.shared.users[count].chupitos += 1
        collectionView.reloadData()
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        //            self.cardLabel.text = "Hidden Card"
        //            self.cardLabel.textColor = .lightGray
        //        }
        
    }
    
    func nextPlayer() {
        var playersNotActive = 0
        
        repeat {
            count += 1
            if count == Singleton.shared.users.count {
                count = 0
            }
            if Singleton.shared.users[count].isActive == false {
                playersNotActive += 1
            }
            if playersNotActive >= Singleton.shared.users.count {
                endGame()
                break
            }
            //da testare
            Singleton.shared.users[count].rounds += 1
            collectionView.reloadData()
            collectionView.scrollToItem(at:IndexPath(item: count, section: 0), at: .centeredHorizontally, animated: true)
        } while Singleton.shared.users[count].isActive == false
        
        //usernameLabel.text = Singleton.shared.users[count].username
        self.title = Singleton.shared.users[count].username
        
        messageAnimation(string: "\(Singleton.shared.users[count].username)", substring: " it's up to you!")
    }
    
    func endGame() {
        print("FINE GIOCO!!!!")
        GameUtils.shared.state = .gameOver
        let transition = CATransition()
        transition.type = kCATransitionFade
        transition.duration = 0.2
        
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "endGameNavigationVC") as? UINavigationController {
            self.view.window?.layer.add(transition, forKey: kCATransition)
            self.view.window?.rootViewController = controller
        }
    }
    
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var leftButton: UIButton!
    
    let reuseIdentifier = "cell"
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        //        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        (childViewControllers.last as! ScenekitGameViewController).delegate = self
        gameSession()
        setupNavBar()
        
        animateButtons()
        
        animateTracking()
        
        messageAnimation(string: "Let's start!", substring: "make your choice!")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func messageAnimation(string: String, substring: String) {
        messageLabel.isHidden = false
        let myString = string + "\n" + substring
        let attributedString = NSMutableAttributedString(string: myString)
        
        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "YellowjacketRotate", size: 20), range: NSMakeRange(0, string.count))
        
        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "YellowjacketRotate", size: 10), range: NSMakeRange(string.count + 1, substring.count))
        
        messageLabel.attributedText = attributedString
        
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.curveEaseOut], animations: {
            self.messageLabel.transform = CGAffineTransform(scaleX: 2, y: 2)
        }, completion: { finish in
            //self.messageLabel.text = ""
            //self.messageLabel.isHidden = true
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.messageLabel.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }, completion: { (finish) in
                self.messageLabel.text = ""
                self.messageLabel.isHidden = true
            })
        })
    }
    
    func animateTracking() {
//        UIView.transition(with: trackingLabel,
//                          duration: 0.25,
//                          options: [.autoreverse, .repeat, .transitionCrossDissolve],
//                          animations: {
//                            for _ in 0...2 {
//                                self.trackingLabel.text?.append(".")
//                            }
//            }, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { _ in
            if self.appendedPoints >= 3 {
                self.appendedPoints = 0
                self.trackingLabel.text = "Looking for horizontal plane"
            } else {
                self.appendedPoints += 1
                self.trackingLabel.text?.append(".")
            }
        })
    }
    
    func gameSession() {
        Singleton.shared.users[0].rounds += 1
        //usernameLabel.text = Singleton.shared.users[0].username
        self.title = Singleton.shared.users[0].username
    }
    
    func animateButtons() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.autoreverse, .repeat, .allowUserInteraction], animations: {
            self.leftButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.rightButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }, completion: nil)
    }
    
    func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(takePictureAction(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Quit", style: .plain, target: self, action: #selector(leaveTable(_:)))
    }
}

extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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
        cell.usernameLabel.text = "\(user.username)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(Singleton.shared.users[indexPath.row].isActive)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let myCell = cell as! UserViewCell
        
        if indexPath.row != count {
            myCell.alpha = 0.5
            myCell.usernameLabel.alpha = 0.3
            myCell.backgroundColor = .clear
            myCell.bgView.alpha = 0
        }
        else {
            myCell.usernameLabel.alpha = 1
            myCell.bgView.alpha = 1
            myCell.alpha = 1
            
            //add circle
            let circle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: myCell.userImageView.frame.width, height: myCell.userImageView.frame.width))
            
            circle.center = myCell.userImageView.center
            circle.layer.cornerRadius = circle.frame.width/2
            circle.backgroundColor = .myOrange
            circle.clipsToBounds = true
            //            circle.layer.borderWidth = 1
            //            circle.layer.borderColor = UIColor.lightGray.cgColor
            circle.alpha = 0.5
            
            myCell.bgView.addSubview(circle)
            
            pulsingAnimation(view: circle)
            
        }
        if Singleton.shared.users[indexPath.row].isActive == false {
            myCell.alpha = 0.3
            //add exclusion image
            myCell.isActiveImageView.alpha = 1
        }
        else {
            myCell.isActiveImageView.alpha = 0
        }
    }
    
    private func pulsingAnimation(view: UIView) {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.2
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        view.layer.add(animation, forKey: "pulsing")
    }
}
