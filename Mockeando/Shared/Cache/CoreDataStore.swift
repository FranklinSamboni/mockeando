//
//  CoreDataStore.swift
//  Mockeando
//
//  Created by Franklin Samboni on 17/12/22.
//

import CoreData

public class CoreDataStore {
    private static let modelName = "Model"
    private static let model: NSManagedObjectModel? = {
        guard let url = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
            return nil
        }
        return NSManagedObjectModel(contentsOf: url)
    }()

    private let container: NSPersistentContainer
    let context: NSManagedObjectContext

    public init(storeURL: URL) throws {
        guard let model = CoreDataStore.model else {
            throw NSError(domain: "Model not found", code: 0)
        }

        do {
            container = try Self.loadContainer(url: storeURL, modelName: CoreDataStore.modelName, model: model)
            context = container.newBackgroundContext()
        } catch {
            throw NSError(domain: "Failed to load persistent store container", code: 0)
        }
    }
    
    private static func loadContainer(url: URL, modelName: String, model: NSManagedObjectModel) throws -> NSPersistentContainer {
        let description = NSPersistentStoreDescription(url: url)
        let container = NSPersistentContainer(name: modelName, managedObjectModel: model)
        container.persistentStoreDescriptions = [description]

        var loadError: Swift.Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { throw $0 }
        
        return container
    }

}
