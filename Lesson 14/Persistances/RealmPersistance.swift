//
//  RealmPersistance.swift
//  Lesson 14
//
//  Created by Maxim Gorin on 04.02.2021.
//

import Foundation
import RealmSwift

class RealmPersistance {
    static let shared = RealmPersistance()
    
    private let realm = try! Realm()
    
    func getAllToDos() -> [ToDoRealm] {
        let toDos = realm.objects(ToDoRealm.self)
        return toDos.toArray()
    }
    
    func add(_ toDo: ToDoRealm) {
        try! realm.write {
            realm.add(toDo)
        }
    }
    
    func remove(_ toDo: ToDoRealm) {
        try! realm.write {
            realm.delete(toDo)
        }
    }
}

class ToDoRealm: Object {
    @objc dynamic var title = ""
}

extension Results {
    func toArray() -> [Element] {
        return compactMap {
            $0
        }
    }
}
