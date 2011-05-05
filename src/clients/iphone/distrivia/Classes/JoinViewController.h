//
//  JoinView.h
//  distrivia
//
//  Created by Sticky Glazer on 4/19/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LeaderboardViewController;
@class RootViewController;

@interface JoinViewController : UIViewController {

	IBOutlet UIButton	*pubBut;
    IBOutlet UIButton   *priJoinBut;
    IBOutlet UIButton   *priCreateBut;
    IBOutlet UIButton   *leadBut;
    IBOutlet UITextField    *nameField;
    IBOutlet UITextField    *passField;
    IBOutlet UIActivityIndicatorView    *activeIndicate;
    
    RootViewController *rootController;
	
}

@property (nonatomic, retain) IBOutlet UIButton *pubBut;
@property (nonatomic, retain) IBOutlet UIButton *priJoinBut;
@property (nonatomic, retain) IBOutlet UIButton *priCreateBut;
@property (nonatomic, retain) IBOutlet UIButton *leadBut;
@property (nonatomic, retain) IBOutlet UITextField *nameField;
@property (nonatomic, retain) IBOutlet UITextField *passField;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activeIndicate;
@property (nonatomic, retain) RootViewController *rootController;

- (IBAction) joinPublicPressed:(id)sender;
- (IBAction) joinPrivatePressed:(id)sender;
- (IBAction) viewLeaderboardPressed:(id)sender;
- (IBAction) textFieldDoneEditing:(id)sender;
- (IBAction) backgroundTap:(id)sender;

- (void) joinPrivateWithParameters:(NSArray*)parameters;
- (void) joinPrivateFailed;
- (void) joinPublic;
- (void) joinPublicFailed;
- (void) leaderboard;
- (void) startRound;
- (void) leaderboardFailed;
- (void) startLeaderboard;
- (void) toggleButtons;

@end
