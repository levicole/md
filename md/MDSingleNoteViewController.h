//
//  MDSingleNoteViewController.h
//  md
//
//  Created by Levi Kennedy on 7/15/15.
//  Copyright (c) 2015 Levi Kennedy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class MDSingleNoteViewController;

@protocol MDSingleNoteViewControllerDelegate <NSObject>

- (void) saveNote:(NSManagedObject *)note;

@end

@interface MDSingleNoteViewController : UIViewController

@property (nonatomic, strong) NSManagedObject *note;
@property (nonatomic, strong) NSObject <MDSingleNoteViewControllerDelegate> *delegate;

@end
