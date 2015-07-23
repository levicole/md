//
//  MDNoteCollectionViewCell.h
//  md
//
//  Created by Levi Kennedy on 7/14/15.
//  Copyright (c) 2015 Levi Kennedy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MDNoteCollectionViewCell;

@protocol MDNoteCollectionViewCellDelegate <NSObject>

- (void)noteColletionViewCellPressed:(MDNoteCollectionViewCell *)cell;
- (void)deleteNote:(MDNoteCollectionViewCell *)cell;

@end

@interface MDNoteCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) NSObject <MDNoteCollectionViewCellDelegate> *delegate;

- (IBAction)readMorePressed:(id)sender;

@end
