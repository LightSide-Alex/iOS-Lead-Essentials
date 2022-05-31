//
//  ManagedCache.swift
//  EssentialFeed
//
//  Created by Oleksandr Balan on 2021-12-18.
//

import CoreData

//It depends on your setup.
//
//Core Data is written in Obj-C, so if you're using manual codegen for your managed models,
//you need to set the @objc name matching the class name in the data model.
//Otherwise, the Obj-C code won't be able to access your class at runtime (it'll crash!).
@objc(ManagedCache)
class ManagedCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var feed: NSOrderedSet
    
    var localFeed: [LocalFeedImage] {
        return feed.compactMap { ($0 as? ManagedFeedImage)?.local }
    }
}

extension ManagedCache {
    static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
        let request = NSFetchRequest<ManagedCache>(entityName: ManagedCache.entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
    
    static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedCache {
        try find(in: context).map(context.delete)
        return ManagedCache(context: context)
    }
}
