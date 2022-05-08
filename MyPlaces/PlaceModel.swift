//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Vladimir Strepitov on 05.05.2022.
//

import RealmSwift

class Place: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var location: String?
    @objc dynamic var type: String?
    @objc dynamic var imageData: Data?
    
    var restPlaces = [
        "KFC",
        "Phali Hinkali",
        "Bros Buritos",
        "Ketchup Burgers",
        "Tokio City",
        "Burger King",
        "Teremok",
        "Cofix",
        "Hitch",
        "DoDo Pizza"
    ]
    
    func savePlaces() {
        for place in restPlaces {
            let image = UIImage(named: place)
            guard let imageData = image?.pngData() else { return }
            
            let newPlace = Place()
            newPlace.name = place
            newPlace.location = "SPb"
            newPlace.type = "Cafe"
            newPlace.imageData = imageData
            
            StorageManager.saveObject(place: newPlace)
        }

    }
}
