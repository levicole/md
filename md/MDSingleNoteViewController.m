//
//  MDSingleNoteViewController.m
//  md
//
//  Created by Levi Kennedy on 7/15/15.
//  Copyright (c) 2015 Levi Kennedy. All rights reserved.
//

#import "MDSingleNoteViewController.h"

@interface MDSingleNoteViewController () <UITextFieldDelegate, UITextViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *bodyTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBottomConstraint;
@property (strong, nonatomic) NSString *noteTitle;
@property (strong, nonatomic) NSString *noteBody;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

@end

@implementation MDSingleNoteViewController

@synthesize note = _note;

- (IBAction)shareNote:(id)sender {
    NSMutableArray *itemsToShare = [NSMutableArray array];
    
    if (self.bodyTextView.text.length > 0) {
        [itemsToShare addObject:self.bodyTextView.text];
    }
    
    if ([itemsToShare count] > 0) {
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
        [self resignFirstResponder];
        [self presentViewController:activityVC animated:YES completion:nil];
    }
}

- (void)saveNote {
    // set up a delegate to call a save method on the collectionviewcontroller
    [self.note setValue:self.titleTextField.text forKey:@"title"];
    [self.note setValue:self.bodyTextView.text   forKey:@"body"];
    [self.note setValue:[NSDate date] forKey:@"dateModified"];

    [self.delegate saveNote:self.note];
    // colelciton view controller needs to be a NSFetchedResultsControllerDelegate
    // on changes to the NSFetchedResultsController, update UIcollectionView
    // use self.colelctionView insertItemsAtIndexPaths
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // set the titleTextField as the firstResponder
    self.titleTextField.delegate = self;
    self.bodyTextView.delegate = self;
    [self enableDataDetectors];
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewTapped:)];
    self.tapGesture.delegate = self;
    self.tapGesture.numberOfTapsRequired = 1;
    [self.bodyTextView addGestureRecognizer:self.tapGesture];
    
    if (self.noteTitle != nil) {
        [self.titleTextField setText:self.noteTitle];
        self.title = self.noteTitle;
    }
    if (self.noteBody != nil) {
        [self.bodyTextView setText:_noteBody ];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void) setNote:(NSManagedObject *)note {
    _note = note;
    self.noteTitle = [self.note valueForKey:@"title"];
    self.noteBody  = [self.note valueForKey:@"body"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWillShow:(NSNotification *)sender {
    NSValue *frameValue = sender.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect frame  = frameValue.CGRectValue;
    CGRect newFrame = [self.navigationController.view convertRect:frame fromView:nil];
    self.textViewBottomConstraint.constant = CGRectGetHeight(newFrame) - 10;
    
    [self.view layoutIfNeeded];
}

- (void)keyboardWillHide:(NSNotification *)sender {
    self.textViewBottomConstraint.constant = 10;
    [self.view layoutIfNeeded];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self saveNote];
    [super viewWillDisappear:animated];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"did this work");
    [self saveNote];
}

- (void) textViewTapped:(UIGestureRecognizer *)sender {
//    CGPoint location = [sender locationInView:self.bodyTextView];
//    NSLog(@"%@", NSStringFromCGPoint(location));
//    UITextPosition *tapPosition = [self.bodyTextView closestPositionToPoint:location];
//    UITextRange *rangeOfTap = [self.bodyTextView.tokenizer rangeEnclosingPosition:tapPosition withGranularity:UITextGranularityWord inDirection:UITextLayoutDirectionRight];
//    NSInteger loc = [self.bodyTextView offsetFromPosition:[self.bodyTextView beginningOfDocument] toPosition:rangeOfTap.start];
//    NSInteger length   = [self.bodyTextView offsetFromPosition:rangeOfTap.start toPosition:rangeOfTap.end];
//    NSRange rangeOfTappedWord = NSMakeRange(loc, length);
    
    [self disableDataDetectors];
    
    [self.bodyTextView becomeFirstResponder];
}


#pragma mark - UITextViewDelegate

- (void) textViewDidEndEditing:(UITextView *)textView {
    [self enableDataDetectors];
}

- (void) showSaveButton {
    self.navigationItem.rightBarButtonItem.tintColor = nil;
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - misc

- (void) enableDataDetectors {
    self.bodyTextView.editable = NO;
    self.bodyTextView.selectable = YES;
    self.bodyTextView.dataDetectorTypes = UIDataDetectorTypeAll;
}

- (void) disableDataDetectors {
    self.bodyTextView.dataDetectorTypes = UIDataDetectorTypeNone;
    self.bodyTextView.selectable = NO;
    self.bodyTextView.editable = YES;
}

@end
