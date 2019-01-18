//
//  ViewController.swift
//  PhotoJournal
//
//  Created by Olimpia on 1/14/19.
//  Copyright © 2019 Olimpia. All rights reserved.
//

import UIKit

class PhotoJournalViewController: UIViewController {
    private var isEditingLinst = false
    
    private var savedPhotos = [PhotoJournal]() {
        didSet {
            collectionView.reloadData()
        }
    }

     private var imagePickerViewController: UIImagePickerController!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       collectionView.delegate = self
       collectionView.dataSource = self
        savedPhotos = PhotoJournalModel.getPhoto()
       print("testing!")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        savedPhotos = PhotoJournalModel.getPhoto()
    }
    
    
    @IBAction func addPictureButton(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "DetailedView") as? DetailedViewController else { return }
        vc.modalTransitionStyle = .coverVertical
     present(vc, animated: true, completion: nil)
    }
    

    @IBAction func seetingsButton(_ sender: UIButton) {
     
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
       let saveAction = UIAlertAction(title: "Edit", style: .default, handler: {(action) in
            PhotoJournalModel.editPhotos(photo: self.savedPhotos[sender.tag], atIndex: sender.tag)
             let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "DetailedView") as? DetailedViewController else { return }
            vc.imageIndex = sender.tag
        vc.currentPhoto = self.savedPhotos[sender.tag]
            //vc.textFromUser = self.
            self.present(vc, animated: true, completion: nil)})
        
        
        
        let shareOption = UIAlertAction(title: "Share", style: .default, handler: {(action) in  let shareText = self.savedPhotos[sender.tag].description
            if let image = UIImage.init(data: self.savedPhotos[sender.tag].imageData) {
               let viewController = UIActivityViewController(activityItems: [shareText, image], applicationActivities: [])
                self.present(viewController, animated: true)
            }})
    
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
       
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            PhotoJournalModel.deleteFromSettings(atIndex: sender.tag)
            self.savedPhotos = PhotoJournalModel.getPhoto() })
            
           
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        optionMenu.addAction(shareOption)
        self.present(optionMenu, animated: true, completion: nil)
       
        
        }
    
    
    
    }


extension PhotoJournalViewController: UICollectionViewDelegate  {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {

            } else {
                print("Original image is nil")
            }
            dismiss(animated: true, completion: nil)
            
        }
    }
}

extension PhotoJournalViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedPhotos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoJournalCell", for: indexPath) as? PhotoJournalCell else { return UICollectionViewCell() }
        
        let item = PhotoJournalModel.getPhoto()[indexPath.row]

        cell.dateAndtime.text! = item.createdAt
        cell.nameOfTask.text! = item.description
        cell.imageHolder.image! = UIImage.init(data: item.imageData)!
        cell.layer.cornerRadius = 30

        return cell 
    }


}
