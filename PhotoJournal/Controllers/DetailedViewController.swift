//
//  DetailedViewController.swift
//  PhotoJournal
//
//  Created by Olimpia on 1/14/19.
//  Copyright © 2019 Olimpia. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {
    
    var currentPhoto: PhotoJournal?
    public var imageIndex: Int?
    private var imagePickerViewController: UIImagePickerController!
    private var textPlaceHolder = "Photo description..."
    private var isEditingLinst = false
    
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var textFromUser: UITextView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var photoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFromUser.isEditable = true
        photoImage.contentMode = .scaleToFill
        updateUI()
        setupImagePickerViewController()
       setUpTextView()
        
    }
    
    private func setUpTextView() {
        textFromUser.delegate = self
        textFromUser.text = textPlaceHolder
        textFromUser.textColor = .lightGray 
        
    }
    
    private func setupImagePickerViewController(){
        imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraButton.isEnabled = false
        }
        if let currentPic = currentPhoto {
            photoImage.image = UIImage.init(data: currentPic.imageData)
        }
        if let currentThatPic = currentPhoto {
            textFromUser.text = currentThatPic.description
        }
    }
    
    
    
    private func updateUI() {
        if let photoJournal = PhotoJournalModel.getPhotoJournal() {
            let theImage = UIImage(data: photoJournal.imageData)
            photoImage.image! = theImage!
        } else {
            print("photo journal does not exist")
        }
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    private func savePhoto(image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            let photoJournal = PhotoJournal.init(createdAt: "Date", imageData: imageData, description: "Description")
         
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
        guard let text = textFromUser.text else { return }
        guard let image = photoImage.image else { return }
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            let date = Date()
            let isoDateFormatter = ISO8601DateFormatter()
            isoDateFormatter.formatOptions = [.withFullDate, .withFullTime, .withTimeZone, .withInternetDateTime, .withDashSeparatorInDate]
            let timestamp = isoDateFormatter.string(from: date)
            let photo = PhotoJournal.init(createdAt: timestamp, imageData: imageData, description: text)
            if let imageIndex = imageIndex, let currentPhoto = currentPhoto {
                 PhotoJournalModel.update(photo: photo, index: imageIndex)
           
            } else {
                PhotoJournalModel.addPhoto(photo: photo)
                
            }
            }
        dismiss(animated: true, completion: nil)
            
    }
    
    
    @IBAction func photoLibrary(_ sender: Any) {
        imagePickerViewController.sourceType = .photoLibrary
        self.present(imagePickerViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func cameraButton(_ sender: UIBarButtonItem) {
        imagePickerViewController.sourceType = .camera
        self.present(imagePickerViewController, animated: true , completion: nil)
    }
    
//    private func disableTextViewEditing(isEditingLinst: Bool) {
//        textFromUser.isEditable = isEditingLinst
//     
//    }
//    
//    @objc private func doneEditing() {
//       disableTextViewEditing(isEditingLinst: false)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editing(_:)))
//        
//        guard let itemTitle = textFromUser.text,
//            let itemDescription = photoImage.image else {
//               
//                return
//        }
//        
//        let itemToBeUpdated = PhotoJournal.init(createdAt: , imageData: itemDescription, description: itemTitle)
//        //(title: itemTitle, description: itemDescription, createdAt: item.createdAt)
//        
//        if let index = ItemsModel.getItems().firstIndex(of: item) {
//            ItemsModel.update(item: itemToBeUpdated, atIndex: index)
//        }
//    }
}
    



extension DetailedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            photoImage.image = image
            savePhoto(image: image)
        } else {
            print("Original image is nil")
           
        }
         dismiss(animated: true , completion: nil)
    }
}

extension DetailedViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textFromUser.text == textPlaceHolder {
            textFromUser.text = ""
             textFromUser.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            if textView == textFromUser {
                textView.text = textPlaceHolder
                textView.textColor = .lightGray
            }
        }
    }
}
