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
    /// - Parameters:
    ///   - dto: The Data Transfer Object obtained from the JSON file or network
    ///   - context: Core Data context to save the object
    /// - Returns: A Hit Core Data Managed Objects
    static func from(_ dto: HitDTO, in context: NSManagedObjectContext) -> Hit {
        let hit = Hit(context: context)
        
        hit.author = dto.author
        hit.createdAt = dto.createdAt
        hit.id = dto.objectID
        hit.storyTitle = dto.storyTitle
        hit.title = dto.title
        hit.storyURL = dto.storyURL
        hit.url = dto.url
                
        return hit
    }
}
