//
//  Album.swift
//  DigiDress2.2
//
//  Created by AYANNA BODAKE on 7/9/24.
//

import Foundation
import UIKit

class Album {
    var name: String
    var photos: [UIImage]
    
    init(name: String, photos: [UIImage] = []){
        self.name = name
        self.photos = photos
    }
}
