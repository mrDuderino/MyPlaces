//
//  StorageManager.swift
//  MyPlaces
//
//  Created by Vladimir Strepitov on 08.05.2022.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    static func saveObject(place: Place) {
        try! realm.write({
            realm.add(place)
        })
    }
    static func deleteObject(place: Place) {
        try! realm.write({
            realm.delete(place)
        })
    }
}


