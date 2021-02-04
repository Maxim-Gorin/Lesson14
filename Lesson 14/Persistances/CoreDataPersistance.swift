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

    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    func getAllToDos() -> [ToDoCoreData] {
        if let result = try? getContext().fetch(request)
        {
            return result
        }
        
        return [ToDoCoreData]()
    }
    
    func add(_ title: String) {
        let context: NSManagedObjectContext = getContext()

        let newToDo = ToDoCoreData(context: context)
        newToDo.title = title
                
        save(context: context)
    }
    
    func remove(_ toDo: ToDoCoreData) {
        let context: NSManagedObjectContext = getContext()
        context.delete(toDo)

        save(context: context)
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
