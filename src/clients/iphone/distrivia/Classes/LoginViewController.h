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
	IBOutlet UIButton *loginBut;
    IBOutlet UIButton *registerBut;
    IBOutlet UITextField *userField;
    IBOutlet UITextField *passField;
}

@property (retain, nonatomic) IBOutlet UIButton *loginBut;
@property (retain, nonatomic) IBOutlet UIButton *registerBut;
@property (retain, nonatomic) IBOutlet UITextField *userField;
@property (retain, nonatomic) IBOutlet UITextField *passField;

- (IBAction) login:(id)sender;

@end

