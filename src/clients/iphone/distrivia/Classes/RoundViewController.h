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

}

@property (nonatomic, assign) id <RoundViewControllerDelegate> delegate;


@end
