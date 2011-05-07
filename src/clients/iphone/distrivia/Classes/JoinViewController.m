//
//  JoinView.m
//  distrivia
//
//  Created by BitShift on 4/19/11.
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
@synthesize numField;
@synthesize activeIndicate;
@synthesize rootController;

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
    // Prepares the UI for loading the Global Leaderboard
    [self toggleButtons];
    [activeIndicate startAnimating];
    [NSThread detachNewThreadSelector:@selector(leaderboard) toTarget:self withObject:nil];
}

- (IBAction)joinPublicPressed:(id)sender {
    // Prepares the UI for joining a public game
    [activeIndicate startAnimating];
    [self toggleButtons];
    [NSThread detachNewThreadSelector:@selector(joinPublic) toTarget:self withObject:nil];
}

- (IBAction) joinPrivatePressed:(id)sender {
    // Prepares the UI for joining a private game
    NSString *gameName = [nameField text];
    NSString *gamePass = [passField text];
    if ([gameName length] == 0 || [gamePass length] == 0) {
        UIAlertView *e = [[UIAlertView alloc] initWithTitle: @"Incomplete Information" 
                                                    message: @"Missing game name or password"
                                                   delegate: self cancelButtonTitle: @"Ok" 
                                          otherButtonTitles: nil];
        [e show];
        [e release];
    } else {
        [activeIndicate startAnimating];
        [self toggleButtons];
        [NSThread detachNewThreadSelector:@selector(joinPrivateWithParameters:) toTarget:self 
                               withObject:[NSArray arrayWithObjects:gameName, gamePass, nil]];
    }
}

- (IBAction) createPrivatePressed:(id)sender {
    // Prepares the UI for creating a private game
    if ([[priCreateBut titleForState:UIControlStateNormal] isEqualToString:@"Start" ]) {
        [activeIndicate startAnimating];
        [self toggleButtons];
        [NSThread detachNewThreadSelector:@selector(startPrivate) toTarget:self withObject:nil];
        return;
    }
    NSString *gameName = [nameField text];
    NSString *gamePass = [passField text];
    NSString *numQ = [numField text];
    if ([gameName length] == 0 || [gamePass length] == 0) {
        UIAlertView *e = [[UIAlertView alloc] initWithTitle: @"Incomplete Information" 
                                                    message: @"Missing game name or password"
                                                   delegate: self cancelButtonTitle: @"Ok" 
                                          otherButtonTitles: nil];
        [e show];
        [e release];
    } else {
        [activeIndicate startAnimating];
        [self toggleButtons];
        [NSThread detachNewThreadSelector:@selector(createPrivateWithParameters:) toTarget:self 
                               withObject:[NSArray arrayWithObjects:gameName, gamePass, numQ, nil]];
    }
}

- (IBAction) textFieldDoneEditing:(id)sender {
    // Hides keyboard when 'DONE' is pressed
    [sender resignFirstResponder];
}

- (IBAction) backgroundTap:(id)sender {
    // Hides the keyboard on background tap
    [nameField resignFirstResponder];
    [passField resignFirstResponder];
    [numField resignFirstResponder];
}


- (void) joinPrivateWithParameters:(NSArray*)parameters {
    /* 
     Thread: Calls the join private game to the network 
     and responds accordingly
     */
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *gameName = [parameters objectAtIndex:0];
    NSString *gamePass = [parameters objectAtIndex:1];
    if ([DistriviaAPI joinPrivateWithData:[rootController gd] gameName:gameName passwd:gamePass]) {
        while (YES) {
            if ([DistriviaAPI statusWithData:[rootController gd]] && 
                [[rootController gd] hasStarted]) {
                break;
            }
            [NSThread sleepForTimeInterval:2];
        }
        [self performSelectorOnMainThread:@selector(startRound) withObject:nil waitUntilDone:NO];
    } else {
        [self performSelectorOnMainThread:@selector(joinPrivateFailed) withObject:nil waitUntilDone:NO];
    }
    [pool release];
}

- (void) joinPrivateFailed {
    // Displays an alert that joining the private game failed
    [self toggleButtons];
    [activeIndicate stopAnimating];
    UIAlertView *e = [[UIAlertView alloc] initWithTitle: @"Join Private failed" 
                                                message: @"Could not join private game"
                                               delegate: self cancelButtonTitle: @"Ok" 
                                      otherButtonTitles: nil];
    [e show];
    [e release];
}

- (void) createPrivateWithParameters:(NSArray*)parameters {
    /*
     Thread: Calls the create private game to the network and
     responds accordingly
     */
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *gameName = [parameters objectAtIndex:0];
    NSString *gamePass = [parameters objectAtIndex:1];
    NSString *numQ = [parameters objectAtIndex:2];
    if ([DistriviaAPI createPrivateWithData:[rootController gd] gameName:gameName
                                    passwd:gamePass numQuestions:numQ]) {
        [self performSelectorOnMainThread:@selector(privateCreated) withObject:nil waitUntilDone:NO];
    } else {
        [self performSelectorOnMainThread:@selector(createPrivateFailed) withObject:nil waitUntilDone:NO];
    }
    [pool release];
}

- (void) createPrivateFailed {
    // Displays an alert that creating a private game failed
    [self toggleButtons];
    [activeIndicate stopAnimating];
    UIAlertView *e = [[UIAlertView alloc] initWithTitle: @"Create Private failed" 
                                                message: @"Could not create private game"
                                               delegate: self cancelButtonTitle: @"Ok" 
                                      otherButtonTitles: nil];
    [e show];
    [e release];
}

- (void) privateCreated {
    // Prepares the UI for having created a private game
    [activeIndicate stopAnimating];
    [priCreateBut setTitle:@"Start" forState:UIControlStateNormal];
    [priCreateBut setEnabled:YES];
}

- (void) startPrivate {
    /*
     Thread: Calls the start private game to the network and
     responds accordingly
     */
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if ([DistriviaAPI startPrivateWithData:[rootController gd]]) {
        while (YES) {
            if ([DistriviaAPI statusWithData:[rootController gd]] && 
                [[rootController gd] hasStarted]) {
                break;
            }
            [NSThread sleepForTimeInterval:2];
        }
        [self performSelectorOnMainThread:@selector(startRound) withObject:nil waitUntilDone:NO];
    } else {
        [self performSelectorOnMainThread:@selector(startPrivateFailed) withObject:nil waitUntilDone:NO];
    }
    [pool release];
}

- (void) startPrivateFailed {
    // Displays an alert notifying that starting the private game failed
    [self toggleButtons];
    [activeIndicate stopAnimating];
    UIAlertView *e = [[UIAlertView alloc] initWithTitle: @"Start Private failed" 
                                                message: @"Could not start private game"
                                               delegate: self cancelButtonTitle: @"Ok" 
                                      otherButtonTitles: nil];
    [e show];
    [e release];
}

- (void) leaderboard {
    /*
     Thread: Calls to retrieve global leaderboard information to the network
     and responds accordingly
     */
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if ([DistriviaAPI globalLeaderboardWithData:[rootController gd]]) {
        [self performSelectorOnMainThread:@selector(startLeaderboard) withObject:nil waitUntilDone:NO];
    } else {
        [self performSelectorOnMainThread:@selector(leaderboardFailed) withObject:nil waitUntilDone:NO];
    }
    [pool release];
}

- (void) joinPublic {
    /*
     Thread: Calls the join public game to the network and
     responds accordingly
     */
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
    // Prepares the UI to switch to the Round View
    [activeIndicate stopAnimating];
    [self toggleButtons];
    [rootController switchToView:[rootController ROUND]];
}

- (void) startLeaderboard {
    // Prepares the UI to switch to the Leaderboard View
    [activeIndicate stopAnimating];
    [self toggleButtons];
    [rootController switchToView:[rootController LEADERBOARD]];
}

- (void) joinPublicFailed {
    // Displays an alert notifying that joining a public game failed
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
    // Displays an alert notifying that loading the global leaderboard failed
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
    // Toggles the buttons on the view. Disables if enabled and so forth
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
    self.numField = nil;
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
    [numField release];
    [activeIndicate release];
    [rootController release];
    [super dealloc];
}


@end
