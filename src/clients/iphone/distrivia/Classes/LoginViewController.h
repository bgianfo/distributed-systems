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
}

@property (retain, nonatomic) IBOutlet UIButton *loginBut;

- (IBAction) login:(id)sender;

@end

