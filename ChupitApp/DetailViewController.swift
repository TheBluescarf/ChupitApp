//
//  DetailViewController.swift
//  ChupitApp
//
//  Created by Marco Falanga on 21/02/18.
//  Copyright © 2018 Marco Falanga. All rights reserved.
//

import UIKit

protocol DetailsDelegate: class {
    func deletePhoto(withIndex i: Int?)
}



class DetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var categoryImageView: UIImageView!
    
    var image: UIImage!
    var index : IndexPath = IndexPath()
    weak var delegate: DetailsDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        
        scrollView.delegate=self
        
        categoryImageView.image = image
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
        
        navigationController?.isToolbarHidden = false
        
        let item = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        
        setToolbarItems([item], animated: true)
        
    }
    
    @objc func share(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: [categoryImageView.image as Any], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true)
    }
    
    @objc func doubleTapped() {
        
        if(self.scrollView.zoomScale > self.scrollView.minimumZoomScale){
            
            self.scrollView.setZoomScale(self.scrollView.minimumZoomScale, animated: true)
            
        }else{
            
            self.scrollView.setZoomScale(self.scrollView.maximumZoomScale, animated: true)
            
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        categoryImageView.isUserInteractionEnabled = true
        self.navigationController?.hidesBarsOnTap = true
    }
    
    
    @IBAction func exportButton(_ sender: Any) {
        
        let activityVC = UIActivityViewController(activityItems: [categoryImageView.image as Any], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.categoryImageView
    }
    
    
    
}



extension DetailViewController : ZoomingViewController
{
    func zoomingBackgroundView(for transition: ZoomTransitioningDelegate) -> UIView? {
        return nil
    }
    
    func zoomingImageView(for transition: ZoomTransitioningDelegate) -> UIImageView? {
        return categoryImageView
    }
}

