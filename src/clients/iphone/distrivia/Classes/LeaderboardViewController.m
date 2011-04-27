//
//  LeaderboardViewController.m
//  distrivia
//
//  Created by Sticky Glazer on 4/21/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "LeaderboardViewController.h"
#import "RootViewController.h"

@implementation LeaderboardViewController

@synthesize boardView;
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
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction) okClicked:(id)sender {
    [rootController switchToView:[rootController JOIN]];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	self.boardView = nil;
    self.rootController = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (void)dealloc {
	[boardView release];
    [rootController release];
    [super dealloc];
}


@end
