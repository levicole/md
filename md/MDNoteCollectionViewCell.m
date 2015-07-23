//
//  MDNoteCollectionViewCell.m
//  md
//
//  Created by Levi Kennedy on 7/14/15.
//  Copyright (c) 2015 Levi Kennedy. All rights reserved.
//

#import "MDNoteCollectionViewCell.h"

@implementation MDNoteCollectionViewCell

- (IBAction)readMorePressed:(id)sender {
    [self.delegate noteColletionViewCellPressed:self];
}

- (IBAction)deleteNote:(id)sender {
    [self.delegate deleteNote:self];
}

@end
