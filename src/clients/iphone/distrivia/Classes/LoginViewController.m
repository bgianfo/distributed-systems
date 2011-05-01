//
//  distriviaViewController.m
//  distrivia
//
//  Created by Sticky Glazer on 4/19/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "LoginViewController.h"
#import "RootViewController.h"
#import "DistriviaAPI.h"

@implementation LoginViewController

@synthesize registerBut;
@synthesize loginBut;
@synthesize userField;
@synthesize passField;
@synthesize activeIndicate;
@synthesize rootController;



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



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
    UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 
                                                                   topCapHeight:0];
    [registerBut setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    [loginBut setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    
    UIImage *buttonImagePressed = [UIImage imageNamed:@"blueButton.png"];
    UIImage *stretchableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:12 
                                                                     topCapHeight:0];
    [registerBut setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
    [loginBut setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [userField setText:[defaults objectForKey:@"username"]];
    
    [super viewDidLoad];
}



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
    } else {
        [activeIndicate startAnimating];
        if ([DistriviaAPI loginWithData:[rootController gd] user:username pass:passwd]) {
			NSLog(@"Login Complete %@", [[rootController gd] getToken]);
			[self startJoin];
		} else {
            [activeIndicate stopAnimating];
			UIAlertView *e = [[UIAlertView alloc] initWithTitle: @"Invalid Login" 
														message: @"Invalid username/password"
													   delegate: self cancelButtonTitle: @"Ok" 
											  otherButtonTitles: nil];
			[e show];
			[e release];
		}
        //[self startJoin];
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
        [activeIndicate startAnimating];
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
    [activeIndicate stopAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[userField text] forKey:@"username"];
    [rootController switchToView:[rootController JOIN]];
}

- (void)errorOccurred {
    UIAlertView *e = [[UIAlertView alloc] initWithTitle: @"Service Unavailable" 
                                                message: @"Please try again"
                                               delegate: self cancelButtonTitle: @"Ok" 
                                      otherButtonTitles: nil];
    [e show];
    [e release];
}

- (void)serverResponse {
    UIAlertView *e = [[UIAlertView alloc] initWithTitle: @"Response" 
                                                message: @"What is it?"
                                               delegate: self cancelButtonTitle: @"Ok" 
                                      otherButtonTitles: nil];
    [e show];
    [e release];
    [self startJoin];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	NSLog(@"Memory Warning!");
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
    self.registerBut = nil;
    self.loginBut = nil;
    self.userField = nil;
    self.passField = nil;
    self.activeIndicate = nil;
    self.rootController = nil;
	[super viewDidUnload];
}


- (void)dealloc {
    [registerBut release];
    [loginBut release];
    [userField release];
    [passField release];
    [activeIndicate release];
    [rootController release];
    [super dealloc];
}

@end
