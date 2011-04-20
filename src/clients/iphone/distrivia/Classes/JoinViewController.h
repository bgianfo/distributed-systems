//
//  JoinView.h
//  distrivia
//
//  Created by Sticky Glazer on 4/19/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundViewController.h"

@protocol JoinViewControllerDelegate;

@interface JoinViewController : UIViewController <RoundViewControllerDelegate> {

	IBOutlet UIButton	*pubButton;
	
}

@property (nonatomic, assign) id <JoinViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIButton *pubButton;

- (IBAction) joinPublic:(id)sender;

@end
