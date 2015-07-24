//
//  MDDataManager.h
//  md
//
//  Created by Levi Kennedy on 7/23/15.
//  Copyright (c) 2015 Levi Kennedy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MDDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (instancetype) initWithAppGroupDirectory:(NSURL *)appGroupDirectory;

@end
