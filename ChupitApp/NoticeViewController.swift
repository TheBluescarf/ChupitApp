//
//  NoticeViewController.swift
//  ChupitApp
//
//  Created by Marco Falanga on 23/02/18.
//  Copyright © 2018 Marco Falanga. All rights reserved.
//

import UIKit

class NoticeViewController: UIViewController {

    @IBOutlet weak var noticeButton: UIButton!
    
    var isFirstTime: Bool?
    
    @IBAction func noticeAction(_ sender: UIButton) {
        
        UserDefaults.standard.set(false, forKey: "FirstTime")
        
        let transition = CATransition()
        transition.type = kCATransitionFade
        transition.duration = 0.2
        
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "GameModeVC") as? GameModeViewController {
            self.view.window?.layer.add(transition, forKey: kCATransition)
            self.view.window?.rootViewController = controller
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isFirstTime = UserDefaults.standard.object(forKey: "FirstTime") as? Bool
        
        if isFirstTime != nil && isFirstTime == false {

            noticeButton.alpha = 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                let transition = CATransition()
                transition.type = kCATransitionFade
                transition.duration = 0.2
                
                if let controller = self.storyboard?.instantiateViewController(withIdentifier: "GameModeVC") as? GameModeViewController {
                    self.view.window?.layer.add(transition, forKey: kCATransition)
                    self.view.window?.rootViewController = controller
                }
            }
        }

        // Do any additional setup after loading the view.
    }
    
    func update() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
