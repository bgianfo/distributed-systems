//
//  GameData.m
//  distrivia
//
//  Created by Brian Gianforcaro on 4/20/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "GameData.h"
#import "Question.h"

@implementation GameData

@synthesize question;
@synthesize username;
@synthesize gameId;
@synthesize leaderboard;

- (id) init {
    self = [super init];
    status = nil;
    token = nil;
    score = 0;
    
    return self;
}

- (BOOL) hasStarted {
    if ( status ) {
        return [status isEqualToString:@"started"];
    } else {
        return false;
    }
}

- (BOOL) isDone {
    if ( status ) {
        return [status isEqual:@"done"];   
    } else {
        return false;
    }
}

- (int) getScore {
    return score;
}

- (NSString*) getToken {
    return token;
}

- (NSString*) getGameId {
    return gameId;
}

- (void) setScore:(int) newScore {
    score = newScore;
}

- (void) setStatus:(NSString*) newStatus {
    [newStatus retain];
    status = newStatus;
}

- (void) setToken:(NSString*) apiToken {
    [apiToken retain];
    token = apiToken;
}

@end
