//
//  LoginViewController.h
//  distrivia
//
//  Created by BitShift on 4/19/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface LoginViewController : UIViewController {
    IBOutlet UIButton *registerBut;
    IBOutlet UIButton *loginBut;
    IBOutlet UITextField *userField;
    IBOutlet UITextField *passField;
    IBOutlet UIActivityIndicatorView *activeIndicate;
    
    RootViewController *rootController;
}

@property (retain, nonatomic) IBOutlet UIButton *registerBut;
@property (retain, nonatomic) IBOutlet UIButton *loginBut;
@property (retain, nonatomic) IBOutlet UITextField *userField;
@property (retain, nonatomic) IBOutlet UITextField *passField;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activeIndicate;
@property (retain, nonatomic) RootViewController *rootController;

- (IBAction) loginPressed:(id)sender;
- (IBAction) registerPressed:(id)sender;
- (IBAction) textFieldDoneEditing:(id)sender;
- (IBAction) backgroundTap:(id)sender;

- (void) startJoin;
- (void) loginWithParameters:(NSArray*)parameters;
- (void) registerWithParameters:(NSArray*)parameters;
- (void) loginFailed;
- (void) registerFailed;

@end

