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

extern NSString * const LOGIN;
extern NSString * const JOIN;
extern NSString * const ROUND;
extern NSString * const LEADERBOARD;

@property (retain, nonatomic) LeaderboardViewController *leadView;
@property (retain, nonatomic) RoundViewController *roundView;
@property (retain, nonatomic) LoginViewController *loginView;
@property (retain, nonatomic) JoinViewController *joinView;

- (void)switchToView:(NSString*)v;

@end
