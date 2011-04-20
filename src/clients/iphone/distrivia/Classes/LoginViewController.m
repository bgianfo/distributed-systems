//
//  distriviaViewController.m
//  distrivia
//
//  Created by Sticky Glazer on 4/19/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController

@synthesize userField;
@synthesize passField;



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction) login:(id)sender {
    NSString *username = [userField text];
    NSString *passwd = [passField text];
    if ([username length] == 0 || [passwd length] == 0) {
        UIAlertView *e = [[UIAlertView alloc] initWithTitle: @"Incomplete Information" 
                                                    message: @"Missing username or password"
                                                   delegate: self cancelButtonTitle: @"Ok" 
                                          otherButtonTitles: nil];
        [e show];
        [e release];
    }
     else {
        [self startJoin];
    }
}

- (IBAction) regis:(id)sender {
    NSString *username = [userField text];
    NSString *passwd = [passField text];
    if ([username length] == 0 || [passwd length] == 0) {
        UIAlertView *e = [[UIAlertView alloc] initWithTitle: @"Incomplete Information" 
                                                    message: @"Missing username or password"
                                                   delegate: self cancelButtonTitle: @"Ok" 
                                          otherButtonTitles: nil];
        [e show];
        [e release];
    } else {
     	[self startJoin];   
    }
}

- (IBAction) textFieldDoneEditing:(id)sender {
    [self login:sender];
    [sender resignFirstResponder];
}

- (IBAction) backgroundTap:(id)sender {
    [userField resignFirstResponder];
    [passField resignFirstResponder];
}

- (void)startJoin {
    JoinViewController *controller = [[JoinViewController alloc] initWithNibName:@"JoinView" bundle:nil];
	controller.delegate = self;
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
    self.userField = nil;
    self.passField = nil;
	[super viewDidUnload];
}


- (void)dealloc {
    [userField release];
    [passField release];
    [super dealloc];
}

@end
