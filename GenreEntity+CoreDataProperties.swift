//
//  GenreEntity+CoreDataProperties.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/18/24.
//
//

import CoreData
import Foundation

extension GenreEntity {

    @nonobjc 
    public class func fetchRequest() -> NSFetchRequest<GenreEntity> {
        return NSFetchRequest<GenreEntity>(entityName: "GenreEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var genre: String

}

extension GenreEntity: Identifiable {}
