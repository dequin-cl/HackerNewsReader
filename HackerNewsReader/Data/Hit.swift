//
//  Hit.swift
//  HackerNewsReader
//
//  Created by Iván on 27-11-20.
//

import Foundation
import CoreData

extension Hit {
    
    /// Given a Hit DTO, this functions creates a Hit Core Data Object
    /// ~~~
    /// Hit.from(dto: hitDTO, in: viewContext)
    /// ~~~
    /// - Warning: This function will save on the Core Data context immediately
    /// - Parameters:
    ///   - dto: The Data Transfer Object obtained from the JSON file or network
    ///   - context: Core Data context to save the object
    /// - Returns: A Hit Core Data Managed Objects
    static func from(dto: HitDTO, in context: NSManagedObjectContext) -> Hit {
        let hit = Hit(context: context)
        
        hit.author = dto.author
        hit.createdAt = dto.createdAt
        hit.id = dto.objectID
        hit.storyTitle = dto.storyTitle
        hit.title = dto.title
        hit.storyURL = dto.storyURL
        hit.url = dto.url
        
        context.perform {
          do {
            try context.save()
          } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
          }
        }
        
        return hit
    }
}
