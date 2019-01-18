//
//  PhotoJournalModel.swift
//  PhotoJournal
//
//  Created by Olimpia on 1/14/19.
//  Copyright © 2019 Olimpia. All rights reserved.
//

import Foundation

final class PhotoJournalModel {
    
    private static var photos = [PhotoJournal]()
    
    static func getPhoto() -> [PhotoJournal]{
        let path = DataPersistenceManager.filepathToDocumentsDirectory(filename: filename).path
        if FileManager.default.fileExists(atPath: path) {
             if let data = FileManager.default.contents(atPath: path) {
            do {
                photos = try PropertyListDecoder().decode([PhotoJournal].self, from: data)
            } catch {
                print("Property list decoding error: \(error)")
                
               }
             } else {
                print("Data is nil")
            }
        } else {
            print("\(filename) does not exist")
            
        }
        photos = photos.sorted {$0.date > $1.date}
        return photos
    }
    private static let filename = "PhotoJournalList.plist"
    private init() {}
    
    static func savePhoto() {
        let path = DataPersistenceManager.filepathToDocumentsDirectory(filename: filename)
        do {
            let data = try PropertyListEncoder().encode(photos)
            try data.write(to: path, options: Data.WritingOptions.atomic)
        } catch {
            print("property list encoding error: \(error)")
        }
    }
    
    static func editPhotos(photo: PhotoJournal, atIndex index: Int) {
        photos.remove(at: index)
        photos.insert(photo, at: index)
        photos.sorted{$0.date > $1.date}
    }
    
    
    static func getPhotoJournal() -> PhotoJournal? {
        let path = DataPersistenceManager.filepathToDocumentsDirectory(filename: filename).path
        var photoJournal: PhotoJournal?
        if FileManager.default.fileExists(atPath: path) {
            if let data = FileManager.default.contents(atPath: path) {
                do {
                    photoJournal = try PropertyListDecoder().decode(PhotoJournal.self, from: data)
                } catch {
                    print("Property list Decoder error: \(error)")
                }
            } else {
                 print("getPhotoJournal - data is nil")
               
            }
           
        } else {
            print("\(filename) does not exist")
        }
          return photoJournal
    }
    
    static func addPhoto(photo: PhotoJournal) {
        photos.append(photo)
        savePhoto()
      
    }
    
    static func deleteFromSettings(atIndex index: Int) {
        photos.remove(at: index)
        savePhoto()
    }
    
    static func update(photo: PhotoJournal, index: Int) {
        photos[index] = photo
        savePhoto()
    }
    
 
    
}
