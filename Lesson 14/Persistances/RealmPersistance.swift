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
            toDo.id = incrementID()
            realm.add(toDo)
        }
    }
    
    func remove(_ toDo: ToDoRealm) {
        try! realm.write {
            realm.delete(toDo)
        }
    }
    
    func update(_ toDo: ToDoRealm) {
        try! realm.write {
           realm.add(toDo, update: .modified)
        }
    }
    
    private func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(ToDoRealm.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}

class ToDoRealm: Object {
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var completed = false
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension Results {
    func toArray() -> [Element] {
        return compactMap {
            $0
        }
    }
}
