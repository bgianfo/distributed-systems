//
//  RoundViewController.h
//  distrivia
//
//  Created by Sticky Glazer on 4/19/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RoundViewControllerDelegate;

@interface RoundViewController : UIViewController {

	IBOutlet UILabel	*question;
	IBOutlet UIButton	*aBut;
	IBOutlet UIButton	*bBut;
	IBOutlet UIButton	*cBut;
	IBOutlet UIButton	*dBut;
	
	
}

@property (nonatomic, assign) id <RoundViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UILabel *question;
@property (nonatomic, retain) IBOutlet UIButton *aBut;
@property (nonatomic, retain) IBOutlet UIButton *bBut;
@property (nonatomic, retain) IBOutlet UIButton *cBut;
@property (nonatomic, retain) IBOutlet UIButton *dBut;

- (IBAction) answerSelected:(id)sender;
- (void) deselectAll;


@end
