//
//  GameData.m
//  distrivia
//
//  Created by Brian Gianforcaro on 4/20/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "GameData.h"


@implementation GameData

@synthesize gameId;

- (id) init {
    
    status = nil;
    username = nil;
    score = 0;
    
    
    return self;
}

- (BOOL) hasStarted {
    return [status isEqualToString:@"starting"];
}

- (BOOL) isDone {
    return [status isEqual:@"done"];
}

- (int) getScore {
    return score;
}

- (NSString*) getUser {
    return username;
}

- (void) setScore:(int) newScore {
    score = newScore;
}

- (void) setStatus:(NSString*) newStatus {
    [newStatus retain];
    status = newStatus;
}

- (void) setUser:(NSString*) user {
    [user retain];
    username = user;
}
@end
