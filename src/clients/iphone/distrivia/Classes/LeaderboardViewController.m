//
//  LeaderboardViewController.m
//  distrivia
//
//  Created by Sticky Glazer on 4/21/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "LeaderboardViewController.h"
#import "RootViewController.h"
#import "GameData.h"
#import "DistriviaAPI.h"

@implementation LeaderboardViewController

@synthesize boardView;
@synthesize activeIndicate;
@synthesize rootController;
@synthesize leadData;

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
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    [self setLeadData: [[[rootController gd] leaderboard] keysSortedByValueUsingComparator:^(id obj1, id obj2) {
        if ([obj1 integerValue]  > [obj2 integerValue] ) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        if ([obj1 integerValue]  < [obj2 integerValue] ) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }]];
    [boardView reloadData];
    if ([[rootController gd] localLeaderboard]) {
        [activeIndicate startAnimating];
        [NSThread detachNewThreadSelector:@selector(localUpdater) toTarget:self withObject:nil];
    }
    
    [super viewWillAppear:animated];
}

- (IBAction) okClicked:(id)sender {
    [[rootController gd] setLocalLeaderboard:NO];
    if ([activeIndicate isAnimating]) {
        [activeIndicate stopAnimating];
    }
    [rootController switchToView:[rootController JOIN]];
}

- (void) localUpdater {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    while([[rootController gd] localLeaderboard]) {
        if ([DistriviaAPI statusWithData:[rootController gd]]) {
            NSLog(@"Updating...");
            [self performSelectorOnMainThread:@selector(updateLeaderboard) withObject:nil waitUntilDone:NO];
        }
        [NSThread sleepForTimeInterval:4.0];
    }
    [pool release];
}

- (void) updateLeaderboard {
    [self setLeadData: [[[rootController gd] leaderboard] keysSortedByValueUsingComparator:^(id obj1, id obj2) {
        if ([obj1 integerValue]  > [obj2 integerValue] ) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        if ([obj1 integerValue]  < [obj2 integerValue] ) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }]];
    [boardView reloadData];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	self.boardView = nil;
    self.activeIndicate = nil;
    self.leadData = nil;
    self.rootController = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	[boardView release];
    [activeIndicate release];
    [leadData release];
    [rootController release];
    [super dealloc];
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.leadData count];
}

- (UITableViewCell *) tableView:(UITableView*)tableView 
                                cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    static NSString *identifier = @"leadTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:identifier] autorelease];
    }
    NSUInteger row = [indexPath row];
    
    cell.textLabel.text = [leadData objectAtIndex:row];
    NSString *scoreText = [NSString stringWithFormat:@"%d", 
                           [[[[rootController gd] leaderboard] 
                            objectForKey:[leadData objectAtIndex:row]] intValue]];
    cell.detailTextLabel.text = scoreText;
    if ([[leadData objectAtIndex:row] isEqualToString:[[rootController gd] username]]) {
        [cell.detailTextLabel setTextColor:[UIColor greenColor]];
        [cell.textLabel setTextColor:[UIColor greenColor]];
    } else {
        [cell.detailTextLabel setTextColor:[UIColor whiteColor]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
    }
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView 
                        heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}


@end
