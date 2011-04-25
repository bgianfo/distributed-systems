//
//  RootViewController.h
//  distrivia
//
//  Created by Sticky Glazer on 4/25/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LeaderboardViewController;
@class RoundViewController;
@class LoginViewController;
@class JoinViewController;

@interface RootViewController : UIViewController {

    LeaderboardViewController *leadView;
    RoundViewController *roundView;
    LoginViewController *loginView;
    JoinViewController *joinView;
    
}

@property (retain, nonatomic) LeaderboardViewController *leadView;
@property (retain, nonatomic) RoundViewController *roundView;
@property (retain, nonatomic) LoginViewController *loginView;
@property (retain, nonatomic) JoinViewController *joinView;

@end
