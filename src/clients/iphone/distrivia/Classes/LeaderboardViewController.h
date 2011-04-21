//
//  LeaderboardViewController.h
//  distrivia
//
//  Created by Sticky Glazer on 4/21/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LeaderboardViewController : UIViewController {
	IBOutlet UITableView	*boardView;
	
}

@property (retain, nonatomic) IBOutlet UITableView *boardView;

@end
