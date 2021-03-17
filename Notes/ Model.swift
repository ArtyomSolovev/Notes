//
//   Model.swift
//  Notes
//
//  Created by Артем Соловьев on 17.03.2021.
//

import UIKit

struct Note{
    var name: String
    var uiimage: UIImage?
    var image: String?
    
    static let names = ["1", "2","kk"]

    static func getInf()  -> [Note]{
        var notes = [Note]()
        
        for note in names{
            notes.append(Note(name: note, image: note))
        }
        
        return notes
    }
}
