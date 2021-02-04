//
//  CoreDataPersistance.swift
//  Lesson 14
//
//  Created by Maxim Gorin on 04.02.2021.
//

import Foundation
import UIKit
import CoreData

class CoreDataPersistance: UIViewController {
    static let shared = CoreDataPersistance()
    private let request = NSFetchRequest<ToDoCoreData>(entityName: "ToDoCoreData")

    var context: NSManagedObjectContext {
        getContext()
    }
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    func getAllToDos() -> [ToDoCoreData] {
        request.predicate = .none
        
        if let result = try? context.fetch(request)
        {
            return result
        }
        
        return [ToDoCoreData]()
    }
    
    private func getOneToDo(_ toDo: ToDoCoreData) -> ToDoCoreData? {
        request.predicate = NSPredicate(format: "SELF = %@", toDo.objectID)
        
        if let result = try? context.fetch(request) {
            return result.first
        }
        
        return nil
    }
    
    func add(title: String, date: Date, completed: Bool = false) {
        let toDo = ToDoCoreData(context: context)
        toDo.title = title
        toDo.date = date
        toDo.completed = completed

        save(context: context)
    }
    
    func remove(_ toDo: ToDoCoreData) {
        context.delete(toDo)

        save(context: context)
    }
    
    func update(_ toDo: ToDoCoreData) -> ToDoCoreData? {
        request.predicate = NSPredicate(format: "SELF = %@", toDo.objectID)
        if let result = try? context.fetch(request), !result.isEmpty {
            result.first?.setValue(!toDo.completed, forKey: "completed")
            save(context: context)
        }
        
        return getOneToDo(toDo)
    }
    
    private func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            print("Unexpected error")
        }
    }
}
