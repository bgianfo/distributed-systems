//
//  GameData.m
//  distrivia
//
//  Created by BitShift on 4/20/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "GameData.h"
#import "Question.h"

@implementation GameData

@synthesize question;
@synthesize username;
@synthesize gameId;
@synthesize leaderboard;

// Initializes the object with default values
- (id) init {
    self = [super init];
    status = nil;
    token = nil;
    score = 0;
    localLeaderboard = NO;
    
    return self;
}

// Returns YES if the game has started
- (BOOL) hasStarted {
    if ( status ) {
        return [status isEqualToString:@"started"];
    } else {
        return false;
    }
}

// Returns YES if the game is done
- (BOOL) isDone {
    if ( status ) {
        return [status isEqual:@"done"];   
    } else {
        return false;
    }
}

// Returns the score
- (int) getScore {
    return score;
}

// Returns the authorization token
- (NSString*) getToken {
    return token;
}

// Returns the game ID
- (NSString*) getGameId {
    return gameId;
}

// Returns YES if the leaderboard is local, NO if global
- (BOOL) localLeaderboard {
    return localLeaderboard;
}

// Sets the score to the given score
- (void) setScore:(int) newScore {
    score = newScore;
}

// Sets the status to the given status
- (void) setStatus:(NSString*) newStatus {
    [newStatus retain];
    status = newStatus;
}

// Sets the authorization token to the given token
- (void) setToken:(NSString*) apiToken {
    [apiToken retain];
    token = apiToken;
}

// Sets whether the leaderboard is local.
- (void) setLocalLeaderboard:(BOOL)local {
    localLeaderboard = local;
}

@end
