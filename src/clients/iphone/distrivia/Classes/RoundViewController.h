//
//  RoundViewController.h
//  distrivia
//
//  Created by Sticky Glazer on 4/19/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface RoundViewController : UIViewController {

	IBOutlet UILabel	*question;
	IBOutlet UIButton	*aBut;
	IBOutlet UIButton	*bBut;
	IBOutlet UIButton	*cBut;
	IBOutlet UIButton	*dBut;
    IBOutlet UIProgressView *pBar;
	
    RootViewController  *rootController;
    NSDate              *startTime;
    NSDate              *endTime;
	
}

@property (nonatomic, retain) IBOutlet UILabel *question;
@property (nonatomic, retain) IBOutlet UIButton *aBut;
@property (nonatomic, retain) IBOutlet UIButton *bBut;
@property (nonatomic, retain) IBOutlet UIButton *cBut;
@property (nonatomic, retain) IBOutlet UIButton *dBut;
@property (nonatomic, retain) IBOutlet UIProgressView *pBar;
@property (nonatomic, retain) RootViewController *rootController;
@property (nonatomic, retain) NSDate *startTime;
@property (nonatomic, retain) NSDate *endTime;

- (IBAction) answerSelected:(id)sender;
- (void) deselectAll;


@end
