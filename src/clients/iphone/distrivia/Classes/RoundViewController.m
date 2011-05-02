//
//  RoundViewController.m
//  distrivia
//
//  Created by Sticky Glazer on 4/19/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "RoundViewController.h"
#import "RootViewController.h"
#import "Question.h"

@implementation RoundViewController

@synthesize question;
@synthesize aBut;
@synthesize bBut;
@synthesize cBut;
@synthesize dBut;
@synthesize pBar;
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
	[self deselectAll];
    [pBar setProgress:0.75];
    //Question* q = [[rootController gd] getQuestion];
    NSLog(@"Round Question: %@", [[rootController gd] getGameId]);
    //[question setText:[[[rootController gd] getQuestion] getQuestion]];
    //[aBut setTitle:[[[rootController gd] getQuestion] getChoiceA] forState:UIControlStateNormal];
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction) answerSelected:(id)sender {
	[self deselectAll];
	if (sender == aBut) {
		[aBut setBackgroundColor:[UIColor greenColor]];
	}
	else if (sender == bBut) {
		[bBut setBackgroundColor:[UIColor greenColor]];
	}
	else if (sender == cBut) {
		[cBut setBackgroundColor:[UIColor greenColor]];
	}
	else if (sender == dBut) {
		[dBut setBackgroundColor:[UIColor greenColor]];
	}
}

- (void) deselectAll {
	[aBut setBackgroundColor:[UIColor grayColor]];
	[bBut setBackgroundColor:[UIColor grayColor]];
	[cBut setBackgroundColor:[UIColor grayColor]];
	[dBut setBackgroundColor:[UIColor grayColor]];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
	self.question = nil;
	self.aBut = nil;
	self.bBut = nil;
	self.cBut = nil;
	self.dBut = nil;
    self.pBar = nil;
    self.rootController = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	[question release];
	[aBut release];
	[bBut release];
	[cBut release];
	[dBut release];
    [pBar release];
    [rootController release];
    [super dealloc];
}


@end
