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
    IBOutlet UIButton   *priButton;
    IBOutlet UIButton   *leadButton;
	
}

@property (nonatomic, assign) id <JoinViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIButton *pubButton;
@property (nonatomic, retain) IBOutlet UIButton *priButton;
@property (nonatomic, retain) IBOutlet UIButton *leadButton;

- (IBAction) joinPublic:(id)sender;

@end
