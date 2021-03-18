//
//   Model.swift
//  Notes
//
//  Created by Артем Соловьев on 17.03.2021.
//

import RealmSwift

class Note: Object{
    @objc dynamic var name = ""
    @objc dynamic var imageData: Data?
    
    convenience init(name: String, imageData: Data?){
        self.init()
        self.name = name
        self.imageData = imageData
    }
}
