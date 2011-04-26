//
//  RootViewController.m
//  distrivia
//
//  Created by Sticky Glazer on 4/25/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "RootViewController.h"
#import "LeaderboardViewController.h"
#import "RoundViewController.h"
#import "LoginViewController.h"
#import "JoinViewController.h"



@implementation RootViewController

@synthesize leadView;
@synthesize roundView;
@synthesize loginView;
@synthesize joinView;

NSString * const LOGIN = @"LoginView";
NSString * const JOIN = @"JoinView";
NSString * const ROUND = @"RoundView";
NSString * const LEADERBOARD = @"LeaderboardView";

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    LoginViewController *lCont = [[LoginViewController alloc] initWithNibName:LOGIN bundle:nil];
    JoinViewController *jCont = [[JoinViewController alloc] initWithNibName:JOIN bundle:nil];
    RoundViewController *rCont = [[RoundViewController alloc] initWithNibName:ROUND bundle:nil];
    LeaderboardViewController *ldCont = [[LeaderboardViewController alloc] initWithNibName:LEADERBOARD bundle:nil];
    self.loginView = lCont;
    [self.loginView setRootController:self];
    self.joinView = jCont;
    [self.joinView setRootController:self];
    self.roundView = rCont;
    [self.roundView setRootController:self];
    self.leadView = ldCont;
    [self.leadView setRootController:self];
    [self.view insertSubview:lCont.view atIndex:0];
    [lCont release];
    [jCont release];
    [rCont release];
    [ldCont release];
    [super viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

// Switches the view shown to the user with a flip from right animation
- (void)switchToView:(NSString*)v {
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:1.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight 
                           forView:self.view cache:YES];
    if (v == LOGIN) {
        
    } else if (v == JOIN) {
        [joinView viewWillAppear:YES];
        [loginView viewWillDisappear:YES];
        [self.loginView.view removeFromSuperview];
        [self.view insertSubview:self.joinView.view atIndex:0];
        [loginView viewDidDisappear:YES];
        [joinView viewDidAppear:YES];
    } else if (v == ROUND) {
        [roundView viewWillAppear:YES];
        [joinView viewWillDisappear:YES];
        [joinView.view removeFromSuperview];
        [self.view insertSubview:self.roundView.view atIndex:0];
        [joinView viewDidDisappear:YES];
        [roundView viewDidAppear:YES];
    } else if (v == LEADERBOARD) {
        
    }
    [UIView commitAnimations];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    self.leadView = nil;
    self.roundView = nil;
    self.loginView = nil;
    self.joinView = nil;
    [super viewDidUnload];
}


- (void)dealloc {
    [leadView release];
    [roundView release];
    [loginView release];
    [joinView release];
    [super dealloc];
}


@end
