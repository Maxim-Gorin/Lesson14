//
//  ToDoCoreData+CoreDataProperties.swift
//  
//
//  Created by Maxim Gorin on 04.02.2021.
//
//

import Foundation
import CoreData


extension ToDoCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoCoreData> {
        return NSFetchRequest<ToDoCoreData>(entityName: "ToDoCoreData")
    }

    @NSManaged public var title: String?

}
