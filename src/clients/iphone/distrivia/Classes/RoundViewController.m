//
//  RoundViewController.m
//  distrivia
//
//  Created by Sticky Glazer on 4/19/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "RoundViewController.h"
#import "RootViewController.h"
#import "Question.h"
#import "GameData.h"
#import "DistriviaAPI.h"

@implementation RoundViewController

@synthesize question;
@synthesize score;
@synthesize aBut;
@synthesize bBut;
@synthesize cBut;
@synthesize dBut;
@synthesize pBar;
@synthesize submitBut;
@synthesize activeIndicate;
@synthesize rootController;
@synthesize startTime, endTime;
@synthesize selection;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [question setNumberOfLines:3];
    [question setLineBreakMode:UILineBreakModeWordWrap];
    [question setAdjustsFontSizeToFitWidth:YES];
    [aBut.titleLabel setLineBreakMode:UILineBreakModeWordWrap];
    [bBut.titleLabel setLineBreakMode:UILineBreakModeWordWrap];
    [cBut.titleLabel setLineBreakMode:UILineBreakModeWordWrap];
    [dBut.titleLabel setLineBreakMode:UILineBreakModeWordWrap];
    [aBut.titleLabel setTextAlignment:UITextAlignmentCenter];
    [bBut.titleLabel setTextAlignment:UITextAlignmentCenter];
    [cBut.titleLabel setTextAlignment:UITextAlignmentCenter];
    [dBut.titleLabel setTextAlignment:UITextAlignmentCenter];
    [self setupDisplay];
    [super viewDidLoad];
}

- (IBAction) answerSelected:(id)sender {
    [self setEndTime:[[NSDate alloc] init]];
    NSLog(@"Time: %f", [endTime timeIntervalSinceDate:startTime]/1);
	[self deselectAll];
	if (sender == aBut) {
		[aBut setBackgroundColor:[UIColor greenColor]];
        [self setSelection:@"a"];
	}
	else if (sender == bBut) {
		[bBut setBackgroundColor:[UIColor greenColor]];
        [self setSelection:@"b"];
	}
	else if (sender == cBut) {
		[cBut setBackgroundColor:[UIColor greenColor]];
        [self setSelection:@"c"];
	}
	else if (sender == dBut) {
		[dBut setBackgroundColor:[UIColor greenColor]];
        [self setSelection:@"d"];
	}
}

- (IBAction) submitPressed:(id)sender {
    [submitBut setEnabled:NO];
    [activeIndicate startAnimating];
    [NSThread detachNewThreadSelector:@selector(submitAnswer) toTarget:self withObject:nil];
}

- (void) setupDisplay {
    [pBar setProgress:0.0];
    Question *q = [[rootController gd] question];
    [question setText:[q question]];
    [aBut setTitle:[q choiceA] forState:UIControlStateNormal];
    [bBut setTitle:[q choiceB] forState:UIControlStateNormal];
    [cBut setTitle:[q choiceC] forState:UIControlStateNormal];
    [dBut setTitle:[q choiceD] forState:UIControlStateNormal];
    NSString *newScore = [NSString stringWithFormat:@"%d", [[rootController gd] getScore]];
    [score setText:newScore];
    [self deselectAll];
    [self setStartTime:[[NSDate alloc] init]];
    
}

- (void) deselectAll {
	[aBut setBackgroundColor:[UIColor grayColor]];
	[bBut setBackgroundColor:[UIColor grayColor]];
	[cBut setBackgroundColor:[UIColor grayColor]];
	[dBut setBackgroundColor:[UIColor grayColor]];
}

- (void) submitAnswer {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if ([DistriviaAPI answerWithData:[rootController gd] answer:selection 
                           timeTaken:[endTime timeIntervalSinceDate:startTime]]) {
        [self performSelectorOnMainThread:@selector(nextQuestion) withObject:nil waitUntilDone:NO];
    } else {
        [self performSelectorOnMainThread:@selector(submitAnswerFailed) withObject:nil waitUntilDone:NO];
    }
    [pool release];
}

- (void) nextQuestion {
    [activeIndicate stopAnimating];
    [self deselectAll];
    [submitBut setEnabled:YES];
    [self setupDisplay];
}

- (void) submitAnswerFailed {
    [submitBut setEnabled:YES];
    [activeIndicate stopAnimating];
    UIAlertView *e = [[UIAlertView alloc] initWithTitle: @"Submit Answer Failed" 
                                                message: @"Could not submit answer"
                                               delegate: self cancelButtonTitle: @"Ok" 
                                      otherButtonTitles: nil];
    [e show];
    [e release];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
	self.question = nil;
    self.score = nil;
	self.aBut = nil;
	self.bBut = nil;
	self.cBut = nil;
	self.dBut = nil;
    self.submitBut = nil;
    self.pBar = nil;
    self.activeIndicate = nil;
    self.rootController = nil;
    self.startTime = nil;
    self.endTime = nil;
    self.selection = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	[question release];
    [score release];
	[aBut release];
	[bBut release];
	[cBut release];
	[dBut release];
    [submitBut release];
    [pBar release];
    [activeIndicate release];
    [rootController release];
    [startTime release];
    [endTime release];
    [selection release];
    [super dealloc];
}


@end
