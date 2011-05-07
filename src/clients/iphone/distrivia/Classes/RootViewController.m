//
//  RootViewController.m
//  distrivia
//
//  Created by BitShift on 4/25/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "RootViewController.h"
#import "LeaderboardViewController.h"
#import "RoundViewController.h"
#import "LoginViewController.h"
#import "JoinViewController.h"
#import "GameData.h"

@implementation RootViewController

@synthesize leadView;
@synthesize roundView;
@synthesize loginView;
@synthesize joinView;
@synthesize LOGIN;
@synthesize JOIN;
@synthesize ROUND;
@synthesize LEADERBOARD;
@synthesize gd;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    gd = [[GameData alloc] init];
    
    // Setup references to each view so they can be loaded quickly in and out
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
    
    self.LOGIN = @"LoginView";
    self.JOIN = @"JoinView";
    self.ROUND = @"RoundView";
    self.LEADERBOARD = @"LeaderboardView";
}

// Switches the view shown to the user with a flip from right animation
- (void)switchToView:(NSString*)v {
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:1.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight 
                           forView:self.view cache:YES];
    if (v == JOIN) {
        if (self.loginView.view.superview != nil) {
            [joinView viewWillAppear:YES];
            [loginView viewWillDisappear:YES];
            [self.loginView.view removeFromSuperview];
            [self.view insertSubview:self.joinView.view atIndex:0];
            [loginView viewDidDisappear:YES];
            [joinView viewDidAppear:YES];
        } else if (self.leadView.view.superview != nil ) {
            [joinView viewWillAppear:YES];
            [leadView viewWillDisappear:YES];
            [self.leadView.view removeFromSuperview];
            [self.view insertSubview:self.joinView.view atIndex:0];
            [leadView viewDidDisappear:YES];
            [joinView viewDidAppear:YES];
        }
    } else if (v == ROUND) {
        [roundView viewWillAppear:YES];
        [joinView viewWillDisappear:YES];
        [joinView.view removeFromSuperview];
        [self.view insertSubview:self.roundView.view atIndex:0];
        [joinView viewDidDisappear:YES];
        [roundView viewDidAppear:YES];
    } else if (v == LEADERBOARD) {
        if (self.joinView.view.superview != nil) {
            [leadView viewWillAppear:YES];
            [joinView viewWillDisappear:YES];
            [joinView.view removeFromSuperview];
            [self.view insertSubview:self.leadView.view atIndex:0];
            [joinView viewDidDisappear:YES];
            [leadView viewDidAppear:YES];
        } else if (self.roundView.view.superview != nil) {
            [leadView viewWillAppear:YES];
            [roundView viewWillDisappear:YES];
            [roundView.view removeFromSuperview];
            [self.view insertSubview:self.leadView.view atIndex:0];
            [roundView viewDidDisappear:YES];
            [leadView viewDidAppear:YES];
        }
    }
    [UIView commitAnimations];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
	NSLog(@"RootViewController Memory Warning");
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    self.leadView = nil;
    self.roundView = nil;
    self.loginView = nil;
    self.joinView = nil;
    self.LOGIN = nil;
    self.JOIN = nil;
    self.ROUND = nil;
    self.LEADERBOARD = nil;
    self.gd = nil;
    [super viewDidUnload];
}


- (void)dealloc {
    [leadView release];
    [roundView release];
    [loginView release];
    [joinView release];
    [LOGIN release];
    [JOIN release];
    [ROUND release];
    [LEADERBOARD release];
    [gd release];
    [super dealloc];
}


@end
