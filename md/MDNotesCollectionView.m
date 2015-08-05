//
//  MDNotesCollectionView.m
//  md
//
//  Created by Levi Kennedy on 7/14/15.
//  Copyright (c) 2015 Levi Kennedy. All rights reserved.
//

#import "MDNotesCollectionView.h"
#import "MDNoteCollectionViewCell.h"
#import "MDSingleNoteViewController.h"
#import <CoreData/CoreData.h>

@interface MDNotesCollectionView () <MDNoteCollectionViewCellDelegate,MDSingleNoteViewControllerDelegate, NSFetchedResultsControllerDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObject *currentNote;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation MDNotesCollectionView

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.fetchedResultsController setDelegate:self];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.collectionView.frame), 44)];
    [self.searchBar setPlaceholder:@"Search Notes"];
    self.searchBar.delegate = self;
    [self.collectionView addSubview:self.searchBar];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
//    [self loadDumbyData];
}

- (void) loadDumbyData {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    for (int i = 0; i < 16; i++) {
        NSString *postTitle   = [NSString stringWithFormat:@"This is post %d", i];
        NSString *postBody    = [NSString stringWithFormat:@"This is body of post %d", i];
        NSDate   *date        = [NSDate dateWithTimeIntervalSinceNow: (60 * 24 * i)];
        NSManagedObject *note = [NSEntityDescription insertNewObjectForEntityForName:[entity name]
                                                              inManagedObjectContext:context];
        [note setValue:postTitle forKey:@"title"];
        [note setValue:postBody  forKey:@"body"];
        [note setValue:date      forKey:@"dateCreated"];
        [note setValue:date      forKey:@"dateModified"];
        
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Unable to save context due to error\n%@ %@", error, [error userInfo]);
            abort();
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    MDSingleNoteViewController *snVC = [segue destinationViewController];
    if (self.currentNote == nil) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
        snVC.note = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    } else {
        snVC.note = self.currentNote;
    }
    snVC.delegate = self;
    self.currentNote = nil;
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MDNoteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.delegate = self;
    cell.titleLabel.text = [managedObject valueForKey:@"title"];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark - NSFetchedResultsController / CoreData

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateModified" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
//    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

-(void)noteColletionViewCellPressed:(MDNoteCollectionViewCell *)cell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    self.currentNote = managedObject;
    
    [self performSegueWithIdentifier:@"toNoteDetailView" sender:self];
}

- (void) deleteNote:(MDNoteCollectionViewCell *)cell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (managedObject) {
        NSLog(@"Deleting");
        [self.fetchedResultsController.managedObjectContext deleteObject:managedObject];
    }
}

- (void)saveNote:(NSManagedObject *)note {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSError *error;
    NSLog(@"Saving");
    [context save:&error];
    if (error) {
        NSLog(@"error!");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    [self.collectionView reloadData];
}

#pragma mark - NSFetchedResultsControllerDelegate


- (void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            NSLog(@"Insert");
            break;
        }
        case NSFetchedResultsChangeDelete: {
            NSLog(@"Deleted");
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            NSLog(@"Update");
            break;
        }
        case NSFetchedResultsChangeMove: {
            NSLog(@"Move");
            //[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            //[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

# pragma mark - UISearchBarDelegate

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setText:@""];
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [self.fetchedResultsController.fetchRequest setPredicate:nil];
    
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    
    if (error != nil) {
        NSLog(@"Something went horribly wrong!");
    } else {
        [self.collectionView reloadData];
    }
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSFetchRequest *fr = self.fetchedResultsController.fetchRequest;
    NSLog(@"searchText: %@", searchText);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title CONTAINS %@", searchText];
    
    [fr setPredicate:predicate];
    
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    
    if (error != nil) {
        NSLog(@"Something went horribly wrong!");
    } else {
        [self.collectionView reloadData];
        [searchBar becomeFirstResponder];
    }
}
@end
