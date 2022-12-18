//
//  CoreDataStore+Posts.swift
//  Mockeando
//
//  Created by Franklin Samboni on 17/12/22.
//

import CoreData

extension CoreDataStore: PostsLoader {
    
    public func load(completion: @escaping (Response) -> Void) {
        let context = context
        context.perform {
            do {
                let request = NSFetchRequest<ManagedPost>(entityName: ManagedPost.entity().name!)
                request.returnsObjectsAsFaults = false
                let result = try context.fetch(request)
                
                let posts  = result.map { self.map(managed: $0) }
                
                completion(.success(posts))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
}

extension CoreDataStore: PostCache {
    
    public func save(posts: [Post], completion: @escaping (Bool) -> Void) {
        let context = context
        context.perform {
            let ids = posts.map { $0.id }
            
            let request = NSFetchRequest<ManagedPost>(entityName: ManagedPost.entity().name!)
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "ANY id IN %@", ids)
            
            do {
                let result = try context.fetch(request)
                let savedItemIds = result.map { $0.id }
                
                let newItems = posts.filter { !savedItemIds.contains(Int64($0.id)) }
                
                _ = newItems.map { item in
                    let managed = ManagedPost(context: context)
                    managed.id = Int64(item.id)
                    managed.userId = Int64(item.userId)
                    managed.title = item.title
                    managed.body = item.body
                    managed.isFavorite = item.isFavorite
                    return managed
                }

                try context.save()
                completion(true)
                
            } catch {
                print("Error saving: \(error)")
                completion(false)
            }
        }
    }
    
    public func delete(postIds: [Int], completion: @escaping (Bool) -> Void) {
        let context = context
        context.perform {
            let request = NSFetchRequest<ManagedPost>(entityName: ManagedPost.entity().name!)
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "ANY id IN %@", postIds)
            
            do {
                let result = try context.fetch(request)
                let _  = result.map(context.delete(_:))
                
                try context.save()
                completion(true)
                
            } catch {
                print("Error deleting: \(error)")
                completion(false)
            }
        }
    }
    
    public func favorite(postId: Int) {
        favoriteAction(postId: postId, isFavorite: true)
    }
    
    public func unfavorite(postId: Int) {
        favoriteAction(postId: postId, isFavorite: false)
    }
    
    private func favoriteAction(postId: Int, isFavorite: Bool) {
        let context = context
        context.perform {
            let request = NSFetchRequest<ManagedPost>(entityName: ManagedPost.entity().name!)
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "id = %d", postId)
            
            do {
                let result = try context.fetch(request)
                let managed = result.first
                managed?.isFavorite = isFavorite
                
                try context.save()
            } catch {
                print("Error in favoriteAction: \(error)")
            }
        }
    }
    
    private func map(managed: ManagedPost) -> Post {
        Post(userId: Int(managed.userId),
             id: Int(managed.id),
             title: managed.title ?? "",
             body: managed.body ?? "",
             isFavorite: managed.isFavorite)
    }
}
