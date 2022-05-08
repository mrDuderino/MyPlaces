//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Vladimir Strepitov on 05.05.2022.
//

import UIKit

struct Place {
    
    var name: String
    var location: String?
    var type: String?
    var image: UIImage?
    var restaurantImage: String?
    
    static var restPlaces = [
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
    
    static func getPlaces() -> [Place] {
        var places = [Place]()
        for place in restPlaces {
            places.append(Place(name: place, location: "SPB", type: "Restaurant", image: nil, restaurantImage: place))
        }

        return places
    }
}
