//
//  LeaderboardViewController.h
//  distrivia
//
//  Created by Sticky Glazer on 4/21/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface LeaderboardViewController : UIViewController 
    <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView	*boardView;
    NSArray                 *leadData;
	
    RootViewController *rootController;
}

@property (retain, nonatomic) IBOutlet UITableView *boardView;
@property (retain, nonatomic) NSArray *leadData;
@property (retain, nonatomic) RootViewController *rootController;

- (IBAction) okClicked:(id)sender;

@end
