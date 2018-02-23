//
//  ReportViewController.swift
//  ChupitApp
//
//  Created by Marco Falanga on 11/02/18.
//  Copyright © 2018 Marco Falanga. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var playAgainButton: UIButton!
    @IBAction func shareAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Share", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Share All", style: .default, handler: { action in
            self.shareFunction(sharingMode: "ALL")
        }))

        
        alert.addAction(UIAlertAction(title: "Share Highlights", style: .default, handler: { action in
            self.shareFunction(sharingMode: "HIGHLIGHTS")
        }))
        alert.addAction(UIAlertAction(title: "Choose Pictures", style: .default, handler: { action in
            
            self.imageToPass = #imageLiteral(resourceName: "ChupitAppicon")
            self.titleToPass = "Select Pictures"
            //destVC interpreta il -1 per creare un array di tutte le foto di tutti gli utenti
            self.indexToPass = -1
            
            self.performSegue(withIdentifier: "infoUserVC", sender: self)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func shareFunction(sharingMode: String) {
        switch sharingMode {
        case "ALL":
            performSharing(images: createArrayOfAll())
            //share
        case "HIGHLIGHTS":
            performSharing(images: createArrayOfHighlights())
        default:
            
            break
        }
    }
    
    func performSharing(images: [UIImage]) {
        let shareScreen = UIActivityViewController(activityItems: images, applicationActivities: nil)
        shareScreen.completionWithItemsHandler = { (_, bool, _, _) in
            //self.sharing = false
            //self.isInSelectMode = false
        }
        
//        let popoverPresentationController = shareScreen.popoverPresentationController
//        popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
//        popoverPresentationController?.permittedArrowDirections = .any
        present(shareScreen, animated: true, completion: nil)
    }
    
    func createArrayOfAll() -> [UIImage] {
        let sortedUsers = Singleton.shared.users.sorted()
        var myArray: [UIImage] = []
        for user in sortedUsers {
            myArray.append(contentsOf: user.imagesArray)
        }
        return myArray
    }
    
    func createArrayOfHighlights() -> [UIImage] {
        let sortedUsers = Singleton.shared.users.sorted()
        var myArray: [UIImage] = []
        for user in sortedUsers {
            var randomIndexes: [Int] = []
            if user.imagesArray.count < 3 {
                myArray.append(contentsOf: user.imagesArray)
            } else {
                for _ in 0...2 {
                    var rand = 0
                    repeat {
                        rand = Int(arc4random_uniform(UInt32(user.imagesArray.count)))
                    }
                    while randomIndexes.contains(rand)
                    randomIndexes.append(rand)
                    myArray.append(user.imagesArray[rand])
                }
            }
        }
        return myArray
    }
    
    @IBAction func playAgainAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Play Again", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "New Game", style: .default, handler: { action in
            Singleton.shared.reset()
            
            let transition = CATransition()
            transition.type = kCATransitionFade
            transition.duration = 0.2
            
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "GameModeVC") as? GameModeViewController {
                self.view.window?.layer.add(transition, forKey: kCATransition)
                self.view.window?.rootViewController = controller
            }
        }))
        alert.addAction(UIAlertAction(title: "Repeat Game", style: .default, handler: { action in
            
            Singleton.shared.repeatGame()
            
            let transition = CATransition()
            transition.type = kCATransitionFade
            transition.duration = 0.2
            
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "GameNavVC") as? UINavigationController {
                self.view.window?.layer.add(transition, forKey: kCATransition)
                self.view.window?.rootViewController = controller
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    var imageToPass = UIImage()
    var titleToPass = String()
    var indexToPass = Int()
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Singleton.shared.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath as IndexPath) as! ReportTableViewCell
        
        let sortedUsers = Singleton.shared.users.sorted()
        let user = sortedUsers[indexPath.row]
        
        cell.userImageView.roundedImage()
        cell.userImageView.image = user.image
        cell.chupitoCounterLabel.text = "\(user.chupitos)"
        cell.chupitoImageView.image = #imageLiteral(resourceName: "chupito")
        cell.chupitosLabel.text = "\(user.chupitos)"
        cell.consecutiveLabel.text = "\(user.consecutiveChupitos)"
        cell.roundsLabel.text = "\(user.rounds)"        
        cell.positionLabel.text = "#\(indexPath.row + 1)"
        

        if user.imagesArray.isEmpty {
            cell.accessoryType = .none
        }
        
        return cell
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationVC = segue.destination as? InfoUserViewController {
            destinationVC.userPictureImage = imageToPass
            destinationVC.title = titleToPass
            destinationVC.indexFromTable = indexToPass
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sortedUsers = Singleton.shared.users.sorted()
        imageToPass = sortedUsers[indexPath.row].image
        titleToPass = "#\(indexPath.row+1) \(sortedUsers[indexPath.row].username)"
        indexToPass = indexPath.row
        
        if sortedUsers[indexPath.row].imagesArray.isEmpty {
            let alert = UIAlertController(title: sortedUsers[indexPath.row].username, message: "has no pictures!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Return", style: .cancel, handler: nil))
            
            present(alert, animated: true)
            
            return
        }
        
        performSegue(withIdentifier: "infoUserVC", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationController?.isToolbarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animateButtons()
    }
    
    func animateButtons() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
