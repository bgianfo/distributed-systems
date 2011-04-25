//
//  JoinView.m
//  distrivia
//
//  Created by Sticky Glazer on 4/19/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "JoinViewController.h"
#import "RoundViewController.h"
#import "LeaderboardViewController.h"


@implementation JoinViewController

@synthesize pubBut;
@synthesize priJoinBut;
@synthesize priCreateBut;
@synthesize leadBut;
@synthesize nameField;
@synthesize passField;
@synthesize activeIndicate;

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


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction) viewLeaderboard:(id)sender {
	LeaderboardViewController *controller = [[LeaderboardViewController alloc]
											 initWithNibName:@"LeaderboardView" 
											 bundle:nil];
	controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}

- (IBAction)joinPublic:(id)sender {
	RoundViewController *controller = [[RoundViewController alloc] initWithNibName:@"RoundView" bundle:nil];
	controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}

- (IBAction) textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction) backgroundTap:(id)sender {
    [nameField resignFirstResponder];
    [passField resignFirstResponder];
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
    [super dealloc];
}


@end
