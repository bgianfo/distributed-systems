//
//  RoundViewController.m
//  distrivia
//
//  Created by BitShift on 4/19/11.
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
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated {
    // Sets up the round display when the view appears
    [self setupDisplay];
    [super viewDidAppear:animated];
}

- (IBAction) answerSelected:(id)sender {
    /* 
     Reacts to an answer being selected. Sets the selection
     variable and changes the UI accordingly
     */
    [self setEndTime:[[NSDate alloc] init]];
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
    [self updateProgress];
}

- (IBAction) submitPressed:(id)sender {
    // Responds to the submit button being pressed. Sets up the UI for sending answer
    if (selection != nil) {
        [submitBut setEnabled:NO];
        [activeIndicate startAnimating];
        [NSThread detachNewThreadSelector:@selector(submitAnswer) toTarget:self withObject:nil];
    }
}

- (void) setupDisplay {
    // Sets up the view with Q/A information and current score
    [pBar setProgress:0.0];
    Question *q = [[rootController gd] question];
    [question setText:[q question]];
    [aBut setTitle:[q choiceA] forState:UIControlStateNormal];
    [bBut setTitle:[q choiceB] forState:UIControlStateNormal];
    [cBut setTitle:[q choiceC] forState:UIControlStateNormal];
    [dBut setTitle:[q choiceD] forState:UIControlStateNormal];
    NSString *newScore = [NSString stringWithFormat:@"%d", [[rootController gd] getScore]];
    if ([newScore isEqualToString:[score text]]) {
        [score setTextColor:[UIColor redColor]];
    } else {
        [score setTextColor:[UIColor greenColor]];
    }
    [score setText:newScore];
    [self deselectAll];
    [self setStartTime:[[NSDate alloc] init]];
    [NSThread detachNewThreadSelector:@selector(progressUpdater) toTarget:self withObject:nil];
}

- (void) deselectAll {
    // Deselects all answer buttons and resets selection variable
    self.selection = nil;
	[aBut setBackgroundColor:[UIColor grayColor]];
	[bBut setBackgroundColor:[UIColor grayColor]];
	[cBut setBackgroundColor:[UIColor grayColor]];
	[dBut setBackgroundColor:[UIColor grayColor]];
}

- (void) submitAnswer {
    /*
     Thread: Calls the network to submit the users answer and
     responds accordingly
     */
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int timeTaken = [[NSNumber numberWithFloat:[endTime timeIntervalSinceDate:startTime]*1000] intValue];
    if ([DistriviaAPI answerWithData:[rootController gd] answer:selection 
                           timeTaken:timeTaken]) {
        if ([[rootController gd] hasStarted]) {
            [self performSelectorOnMainThread:@selector(nextQuestion) withObject:nil waitUntilDone:NO];
        } else {
            [self performSelectorOnMainThread:@selector(roundFinished) withObject:nil waitUntilDone:NO];
        }

    } else {
        [self performSelectorOnMainThread:@selector(submitAnswerFailed) withObject:nil waitUntilDone:NO];
    }
    [pool release];
}

- (void) nextQuestion {
    // Sets up the UI to respond to the next question
    [activeIndicate stopAnimating];
    [self deselectAll];
    [submitBut setEnabled:YES];
    [self setupDisplay];
}

- (void) submitAnswerFailed {
    // Displays an alert to notify that submitting the answer failed
    [submitBut setEnabled:YES];
    [activeIndicate stopAnimating];
    UIAlertView *e = [[UIAlertView alloc] initWithTitle: @"Submit Answer Failed" 
                                                message: @"Could not submit answer"
                                               delegate: self cancelButtonTitle: @"Ok" 
                                      otherButtonTitles: nil];
    [e show];
    [e release];
}

- (void) progressUpdater {
    /*
     Thread: Makes periodic calls to update the progress bar of the
     time remaining to answer the question
     */
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    for (int i = 0; i<44; i++) {
        if (selection == nil) {
            [self performSelectorOnMainThread:@selector(updateProgress) withObject:nil waitUntilDone:NO];
        }
        [NSThread sleepForTimeInterval:0.25];
    }
    [pool release];
}

- (void) updateProgress {
    // Updates the progress bar with the current time left to answer the question
    NSDate *now = [[NSDate alloc] init];
    [pBar setProgress:[now timeIntervalSinceDate:startTime]/10.0];
    [now release];
}
         
- (void) roundFinished {
    // Sets up the UI to switch to the local leaderboard view
    [self deselectAll];
    [activeIndicate stopAnimating];
    [submitBut setEnabled:YES];
    [rootController switchToView:[rootController LEADERBOARD]];
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
