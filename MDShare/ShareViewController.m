//
//  ShareViewController.m
//  MDShare
//
//  Created by Levi Kennedy on 7/23/15.
//  Copyright (c) 2015 Levi Kennedy. All rights reserved.
//

#import "ShareViewController.h"
#import "MDDataManager.h"
#import <CoreData/CoreData.h>

@interface ShareViewController ()

@property (nonatomic, strong) MDDataManager *dataManager;

@end

@implementation ShareViewController

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (void)didSelectPost {
    NSManagedObjectContext *context = self.dataManager.managedObjectContext;
    NSEntityDescription    *entity  = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:context];
    NSManagedObject *note = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    
    [note setValue:self.contentText forKey:@"body"];
    [note setValue:self.contentText forKey:@"title"];
    NSDate *today = [NSDate date];
    [note setValue:today forKey:@"dateCreated"];
    [note setValue:today forKey:@"dateModified"];
    
    NSError *error;
    [self.dataManager.managedObjectContext save:&error];
    
    if (error != nil) {
        NSLog(@"Error! %@\n%@", error, error.localizedDescription);
    }
    
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

- (MDDataManager *)dataManager {
    if (_dataManager != nil) {
        return _dataManager;
    }
    _dataManager = [[MDDataManager alloc] initWithAppGroupDirectory:[self applicationDocumentsDirectory]];
    return _dataManager;
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.levicole.md" in the application's documents directory.
    return [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.levicole.md"];
}

@end
