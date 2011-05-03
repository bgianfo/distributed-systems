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
    IBOutlet UILabel    *score;
	IBOutlet UIButton	*aBut;
	IBOutlet UIButton	*bBut;
	IBOutlet UIButton	*cBut;
	IBOutlet UIButton	*dBut;
    IBOutlet UIButton   *submitBut;
    IBOutlet UIProgressView *pBar;
    IBOutlet UIActivityIndicatorView *activeIndicate;
	
    RootViewController  *rootController;
    NSDate              *startTime;
    NSDate              *endTime;
    NSString            *selection;
	
}

@property (nonatomic, retain) IBOutlet UILabel *question;
@property (nonatomic, retain) IBOutlet UILabel *score;
@property (nonatomic, retain) IBOutlet UIButton *aBut;
@property (nonatomic, retain) IBOutlet UIButton *bBut;
@property (nonatomic, retain) IBOutlet UIButton *cBut;
@property (nonatomic, retain) IBOutlet UIButton *dBut;
@property (nonatomic, retain) IBOutlet UIButton *submitBut;
@property (nonatomic, retain) IBOutlet UIProgressView *pBar;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activeIndicate;
@property (nonatomic, retain) RootViewController *rootController;
@property (nonatomic, retain) NSDate *startTime;
@property (nonatomic, retain) NSDate *endTime;
@property (nonatomic, retain) NSString *selection;

- (IBAction) answerSelected:(id)sender;
- (IBAction) submitPressed:(id)sender;

- (void) deselectAll;
- (void) setupDisplay;
- (void) submitAnswer;
- (void) submitAnswerFailed;
- (void) nextQuestion;


@end
