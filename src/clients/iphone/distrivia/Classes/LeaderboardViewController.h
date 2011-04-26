//
//  LeaderboardViewController.h
//  distrivia
//
//  Created by Sticky Glazer on 4/21/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface LeaderboardViewController : UIViewController {
	IBOutlet UITableView	*boardView;
	
    RootViewController *rootController;
}

@property (retain, nonatomic) IBOutlet UITableView *boardView;
@property (retain, nonatomic) RootViewController *rootController;

@end
