//
//  InfoUserViewController.swift
//  ChupitApp
//
//  Created by Marco Falanga on 12/02/18.
//  Copyright © 2018 Marco Falanga. All rights reserved.
//

import UIKit

class InfoUserViewController: UIViewController, DetailsDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var userPictureImage = UIImage()
    @IBOutlet weak var userPictureImageView: UIImageView!
    
    var selectedIndexPath: IndexPath!
    
    var myUser: User = User()
    var indexFromTable = Int()
    var images : [UIImageView] = []
    
     let numberOfItemsPerRow: CGFloat = 3.0
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 10.0)
    
    var paddingSpace = CGFloat()
    var availableWidth = CGFloat()
    var widthPerItem = CGFloat()
    
    fileprivate var selectedPhotos = [UIImageView]()
    
    var isInSelectMode = false
    
    var sharing: Bool = false {
        didSet {
            collectionView?.allowsMultipleSelection = sharing
            collectionView?.selectItem(at: nil, animated: true, scrollPosition: UICollectionViewScrollPosition())
            selectedPhotos.removeAll(keepingCapacity: false)
            
//            guard let shareButton = self.navigationItem.rightBarButtonItems?.first else {
//                return
//            }
//
//            guard sharing else {
//                navigationItem.setRightBarButtonItems([shareButton], animated: true)
//                return
//            }
//
//            navigationItem.setRightBarButtonItems([shareButton], animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paddingSpace = sectionInsets.left * (numberOfItemsPerRow + 1)
        availableWidth = view.frame.width - paddingSpace
        widthPerItem = availableWidth / numberOfItemsPerRow
        
        collectionView?.dataSource = self
        collectionView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectItems))
        
        
        let item = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))

        setToolbarItems([item], animated: true)
        
        navigationController?.isToolbarHidden = false
        
        //if indexFromTable è -1 setta un array di tutte le immagini di tutti gli utenti
        let myUsers = Singleton.shared.users.sorted()
        if indexFromTable == -1 {
            for user in myUsers {
                for image in user.imagesArray {
                    images.append(UIImageView(image: image))
                }
            }
        }
        else {
            myUser = myUsers[indexFromTable]
            
            for image in myUser.imagesArray {
                images.append(UIImageView(image: image))
            }
        }
        print("count di images: \(images.count)")
    }
    
    @objc func share(_ sender: Any) {
        if(sharing==true)
        {
            var imageArray = [UIImage]()
            
//            if selectedPhotos.count > 0 {
//                navigationController?.isToolbarHidden = false
//            }
            
            for selectedPhoto in selectedPhotos {
                if let thumbnail = selectedPhoto.image {
                    imageArray.append(thumbnail)
                }
            }
            
            if !imageArray.isEmpty {
                let shareScreen = UIActivityViewController(activityItems: imageArray, applicationActivities: nil)
                shareScreen.completionWithItemsHandler = { (_, bool, _, _) in
                    //self.sharing = false
                    //self.isInSelectMode = false
                }
                
                let popoverPresentationController = shareScreen.popoverPresentationController
                popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
                popoverPresentationController?.permittedArrowDirections = .any
                present(shareScreen, animated: true, completion: nil)
            }
            
            
        }
    }
    
    @objc func selectItems(_ sender: Any) {
        
        if isInSelectMode {
            isInSelectMode = false
            navigationItem.rightBarButtonItem?.tintColor = .myOrange
        } else {
            isInSelectMode = true
            navigationItem.rightBarButtonItem?.tintColor = .blue
        }
        
        
        if(selectedPhotos.isEmpty == true){
            
            sharing = !sharing
            return
        }
        
        if(sharing == true)
        {
            
            sharing = false
            return
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configNavbar()
        collectionView?.reloadData()
        
        
        let myUsers = Singleton.shared.users.sorted()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.hidesBarsOnTap = false
    }
    
    func configNavbar() {
        
        userPictureImageView.image = userPictureImage
        userPictureImageView.contentMode = .scaleAspectFill
        userPictureImageView.roundedImage()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        //cell.photoImageView.image = myUser.imagesArray[indexPath.row]
        cell.photoImageView.image = images[indexPath.row].image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        
        if(sharing == false){
            
            let image = images[indexPath.row].image
            
            self.selectedIndexPath = indexPath
            self.performSegue(withIdentifier: "ShowDetail", sender: image)
            
            
            
        }else{
            
            let photo = images[indexPath.row]
            selectedPhotos.append(photo)
        }
        
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "ShowDetail" {
            let detailVC = segue.destination as! DetailViewController
            detailVC.image = sender as! UIImage
            detailVC.index = selectedIndexPath
            detailVC.delegate = self
            
        }
        
    }
    
    func deletePhoto(withIndex i: Int?) {
        images[i!].isHidden=true
        images.remove(at: i!)
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        
        return true
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        
        guard sharing else {
            return
        }
        
        let photo = images[indexPath.row]
        
        if let index = selectedPhotos.index(of: photo) {
            selectedPhotos.remove(at: index)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    
    
    
    
    
}


extension InfoUserViewController: ZoomingViewController
{
    func zoomingBackgroundView(for transition: ZoomTransitioningDelegate) -> UIView? {
        return nil
    }
    
    func zoomingImageView(for transition: ZoomTransitioningDelegate) -> UIImageView? {
        if let indexPath = selectedIndexPath {
            let cell = collectionView?.cellForItem(at: indexPath) as! PhotoCell
            return cell.photoImageView
            
        }
        
        return nil
    }
}

