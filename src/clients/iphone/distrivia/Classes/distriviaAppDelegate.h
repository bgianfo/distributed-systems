//
//  distriviaAppDelegate.h
//  distrivia
//
//  Created by Sticky Glazer on 4/19/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;

@interface distriviaAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    LoginViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet LoginViewController *viewController;

@end

