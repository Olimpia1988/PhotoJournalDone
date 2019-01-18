//
//  DataPersistenceManager.swift
//  PhotoJournal
//
//  Created by Olimpia on 1/14/19.
//  Copyright © 2019 Olimpia. All rights reserved.
//

import Foundation

final class DataPersistenceManager {
    
    
    static func documentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    static func filepathToDocumentsDirectory(filename: String) -> URL {
        return documentsDirectory().appendingPathComponent(filename)
    }
}
