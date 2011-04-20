//
//  LoginViewController.h
//  distrivia
//
//  Created by Sticky Glazer on 4/19/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JoinViewController.h"

@interface LoginViewController : UIViewController <JoinViewControllerDelegate> {
    IBOutlet UITextField *userField;
    IBOutlet UITextField *passField;
}

@property (retain, nonatomic) IBOutlet UITextField *userField;
@property (retain, nonatomic) IBOutlet UITextField *passField;

- (IBAction) login:(id)sender;
- (IBAction) regis:(id)sender;
- (IBAction) textFieldDoneEditing:(id)sender;
- (IBAction) backgroundTap:(id)sender;

- (void) startJoin;

@end

