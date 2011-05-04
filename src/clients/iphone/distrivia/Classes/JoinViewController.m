//
//  JoinView.m
//  distrivia
//
//  Created by Sticky Glazer on 4/19/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "JoinViewController.h"
#import "LeaderboardViewController.h"
#import "RootViewController.h"
#import "DistriviaAPI.h"
#import "GameData.h"
#import "Question.h"

@implementation JoinViewController

@synthesize pubBut;
@synthesize priJoinBut;
@synthesize priCreateBut;
@synthesize leadBut;
@synthesize nameField;
@synthesize passField;
@synthesize activeIndicate;
@synthesize rootController;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
    UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 
                                                                                   topCapHeight:0];
    [priJoinBut setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    [priCreateBut setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    [pubBut setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    [leadBut setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    
    UIImage *buttonImagePressed = [UIImage imageNamed:@"blueButton.png"];
    UIImage *stretchableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:12 
                                                                                     topCapHeight:0];
    [priJoinBut setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
    [priCreateBut setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
    [pubBut setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
    [leadBut setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
    [super viewDidLoad];
}

- (IBAction) viewLeaderboardPressed:(id)sender {
    [self toggleButtons];
    [activeIndicate startAnimating];
    [NSThread detachNewThreadSelector:@selector(leaderboard) toTarget:self withObject:nil];
}

- (IBAction)joinPublicPressed:(id)sender {
    [activeIndicate startAnimating];
    [self toggleButtons];
    [NSThread detachNewThreadSelector:@selector(joinPublic) toTarget:self withObject:nil];
}

- (IBAction) textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction) backgroundTap:(id)sender {
    [nameField resignFirstResponder];
    [passField resignFirstResponder];
}

- (void) leaderboard {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if ([DistriviaAPI globalLeaderboardWithData:[rootController gd]]) {
        [self performSelectorOnMainThread:@selector(startLeaderboard) withObject:nil waitUntilDone:NO];
    } else {
        [self performSelectorOnMainThread:@selector(leaderboardFailed) withObject:nil waitUntilDone:NO];
    }
    [pool release];
}

- (void) joinPublic {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if ([DistriviaAPI joinPublicWithData:[rootController gd]]) {
        while (YES) {
            if ([DistriviaAPI statusWithData:[rootController gd]] && 
                                    [[rootController gd] hasStarted]) {
                break;
            }
            [NSThread sleepForTimeInterval:2];
        }
        [self performSelectorOnMainThread:@selector(startRound) withObject:nil waitUntilDone:NO];
    } else {
        [self performSelectorOnMainThread:@selector(joinPublicFailed) withObject:nil waitUntilDone:NO];
    }
    [pool release];
}

- (void) startRound {
    [activeIndicate stopAnimating];
    [self toggleButtons];
    [rootController switchToView:[rootController ROUND]];
}

- (void) startLeaderboard {
    [activeIndicate stopAnimating];
    [self toggleButtons];
    [rootController switchToView:[rootController LEADERBOARD]];
}

- (void) joinPublicFailed {
    [self toggleButtons];
    [activeIndicate stopAnimating];
    UIAlertView *e = [[UIAlertView alloc] initWithTitle: @"Join Public failed" 
                                                message: @"Could not join public game"
                                               delegate: self cancelButtonTitle: @"Ok" 
                                      otherButtonTitles: nil];
    [e show];
    [e release];
}

- (void) leaderboardFailed {
    [self toggleButtons];
    [activeIndicate stopAnimating];
    UIAlertView *e = [[UIAlertView alloc] initWithTitle: @"Global Leaderboard Failed" 
                                                message: @"Could not load leaderboard"
                                               delegate: self cancelButtonTitle: @"Ok" 
                                      otherButtonTitles: nil];
    [e show];
    [e release];
}
    
- (void) toggleButtons {
    [priJoinBut setEnabled:![priJoinBut isEnabled]];
    [priCreateBut setEnabled:![priCreateBut isEnabled]];
    [pubBut setEnabled:![pubBut isEnabled]];
    [leadBut setEnabled:![leadBut isEnabled]];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
	self.pubBut = nil;
    self.priJoinBut = nil;
    self.priCreateBut = nil;
    self.leadBut = nil;
    self.nameField = nil;
    self.passField = nil;
    self.activeIndicate = nil;
    self.rootController = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	[pubBut release];
    [priJoinBut release];
    [priCreateBut release];
    [leadBut release];
    [nameField release];
    [passField release];
    [activeIndicate release];
    [rootController release];
    [super dealloc];
}


@end
