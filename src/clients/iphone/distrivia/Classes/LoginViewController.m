//
//  distriviaViewController.m
//  distrivia
//
//  Created by BitShift on 4/19/11.
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

// Responds to the login button being pressed.
// Completes UI Actions to log in a player
- (IBAction) loginPressed:(id)sender {
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
        [registerBut setEnabled:NO];
        [loginBut setEnabled:NO];
        [NSThread detachNewThreadSelector:@selector(loginWithParameters:) toTarget:self 
                                withObject:[NSArray arrayWithObjects:username, passwd, nil]];
    }
}

// Responds to the register button being pressed.
// Completes UI Actions to register a player
- (IBAction) registerPressed:(id)sender {
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
        [registerBut setEnabled:NO];
        [loginBut setEnabled:NO];
        [NSThread detachNewThreadSelector:@selector(registerWithParameters:) toTarget:self 
                               withObject:[NSArray arrayWithObjects:username, passwd, nil]];
    }
}

// Releases the keyboard and logs in the user when 'DONE' is pressed
- (IBAction) textFieldDoneEditing:(id)sender {
    [self loginPressed:sender];
    [sender resignFirstResponder];
}

// Hides the keyboard
- (IBAction) backgroundTap:(id)sender {
    [userField resignFirstResponder];
    [passField resignFirstResponder];
}

// Thread: Calls login on network and responds to the main thread accordingly
- (void) loginWithParameters:(NSArray*)parameters {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *username = [parameters objectAtIndex:0];
    NSString *passwd = [parameters objectAtIndex:1];
    if ([DistriviaAPI loginWithData:[rootController gd] user:username pass:passwd]) {
        [self performSelectorOnMainThread:@selector(startJoin) withObject:nil waitUntilDone:NO];
    } else {
        [self performSelectorOnMainThread:@selector(loginFailed) withObject:nil waitUntilDone:NO];
    }
    [pool release];
}

// Thread: Calls register on network and responds to the main thread accordingly
- (void) registerWithParameters:(NSArray *)parameters {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *username = [parameters objectAtIndex:0];
    NSString *passwd = [parameters objectAtIndex:1];
    if ([DistriviaAPI registerWithData:[rootController gd] user:username pass:passwd]) {
        [self performSelectorOnMainThread:@selector(startJoin) withObject:nil waitUntilDone:NO];
    } else {
        [self performSelectorOnMainThread:@selector(registerFailed) withObject:nil waitUntilDone:NO];
    }
    [pool release];
}

// Prepares the UI for switching to the Join View
- (void) startJoin {
    [activeIndicate stopAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[userField text] forKey:@"username"];
    [rootController switchToView:[rootController JOIN]];
}

// Displays an Alert that the login failed
- (void) loginFailed {
    [activeIndicate stopAnimating];
    [registerBut setEnabled:YES];
    [loginBut setEnabled:YES];
    UIAlertView *e = [[UIAlertView alloc] initWithTitle: @"Invalid Login" 
                                                message: @"Invalid username/password"
                                               delegate: self cancelButtonTitle: @"Ok" 
                                      otherButtonTitles: nil];
    [e show];
    [e release];
}

// Displays an Alert that the registration failed
- (void) registerFailed {
    [activeIndicate stopAnimating];
    [registerBut setEnabled:YES];
    [loginBut setEnabled:YES];
    UIAlertView *e = [[UIAlertView alloc] initWithTitle: @"Registration Failed" 
                                                message: @"Username already in use"
                                               delegate: self cancelButtonTitle: @"Ok" 
                                      otherButtonTitles: nil];
    [e show];
    [e release];
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
