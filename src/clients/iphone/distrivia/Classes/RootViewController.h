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
    
    NSString * const LOGIN;
    NSString * const JOIN;
    NSString * const ROUND;
    NSString * const LEADERBOARD;
    
}

@property (retain, nonatomic) LeaderboardViewController *leadView;
@property (retain, nonatomic) RoundViewController *roundView;
@property (retain, nonatomic) LoginViewController *loginView;
@property (retain, nonatomic) JoinViewController *joinView;
@property (retain, nonatomic) NSString *LOGIN;
@property (retain, nonatomic) NSString *JOIN;
@property (retain, nonatomic) NSString *ROUND;
@property (retain, nonatomic) NSString *LEADERBOARD;

- (void)switchToView:(NSString*)v;

@end
