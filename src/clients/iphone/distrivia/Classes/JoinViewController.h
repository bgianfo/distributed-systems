//
//  JoinView.h
//  distrivia
//
//  Created by Sticky Glazer on 4/19/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundViewController.h"
#import "LeaderboardViewController.h"

@protocol JoinViewControllerDelegate;

@interface JoinViewController : UIViewController <RoundViewControllerDelegate> {

	IBOutlet UIButton	*pubBut;
    IBOutlet UIButton   *priJoinBut;
    IBOutlet UIButton   *priCreateBut;
    IBOutlet UIButton   *leadBut;
    IBOutlet UITextField    *nameField;
    IBOutlet UITextField    *passField;
    IBOutlet UIActivityIndicatorView    *activeIndicate;
	
}

@property (nonatomic, assign) id <JoinViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIButton *pubBut;
@property (nonatomic, retain) IBOutlet UIButton *priJoinBut;
@property (nonatomic, retain) IBOutlet UIButton *priCreateBut;
@property (nonatomic, retain) IBOutlet UIButton *leadBut;
@property (nonatomic, retain) IBOutlet UITextField *nameField;
@property (nonatomic, retain) IBOutlet UITextField *passField;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activeIndicate;

- (IBAction) joinPublic:(id)sender;
- (IBAction) viewLeaderboard:(id)sender;
- (IBAction) textFieldDoneEditing:(id)sender;
- (IBAction) backgroundTap:(id)sender;

@end
