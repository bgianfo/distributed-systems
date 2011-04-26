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
    self.loginView = lCont;
    [self.view insertSubview:lCont.view atIndex:0];
    [lCont release];
    [super viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
