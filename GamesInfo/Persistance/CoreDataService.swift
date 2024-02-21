//
//  CoreDataService.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/18/24.
//

import CoreData
import Foundation

protocol LocalPersistable {}

final class CoreDataService: LocalPersistable {

    static let shared = CoreDataService()

    private let logger: AppLogger = .init()

    private init() {}

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { [weak self] storeDescription, error in
            if let error = error as NSError? {
                self?.logger.fault("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func addGenres(_ genres: [String]) {
        genres.forEach {
            let model = GenreEntity(context: persistentContainer.viewContext)
            model.id = UUID()
            model.genre = $0
        }
    }

    func fetchGenres() throws -> [GenreEntity]? {
        let context = persistentContainer.viewContext
        return try context.fetch(GenreEntity.fetchRequest()) as? [GenreEntity]
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                logger.fault("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
