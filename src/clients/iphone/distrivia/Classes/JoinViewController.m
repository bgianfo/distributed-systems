//
//  JoinView.m
//  distrivia
//
//  Created by Sticky Glazer on 4/19/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "JoinViewController.h"


@implementation JoinViewController

@synthesize delegate;
@synthesize pubButton;
@synthesize priButton;
@synthesize leadButton;

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
    [priButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    [pubButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    [leadButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    
    UIImage *buttonImagePressed = [UIImage imageNamed:@"blueButton.png"];
    UIImage *stretchableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:12 
                                                                                     topCapHeight:0];
    [priButton setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
    [pubButton setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
    [leadButton setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction)joinPublic:(id)sender {
	RoundViewController *controller = [[RoundViewController alloc] initWithNibName:@"RoundView" bundle:nil];
	controller.delegate = self;
	controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
	self.delegate = nil;
	self.pubButton = nil;
    self.priButton = nil;
    self.leadButton = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	[pubButton release];
    [priButton release];
    [leadButton release];
    [super dealloc];
}


@end
