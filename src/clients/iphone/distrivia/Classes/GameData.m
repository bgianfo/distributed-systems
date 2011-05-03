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

- (id) init {
    self = [super init];
    self.status = nil;
    self.token = nil;
    //self.gameId = nil;
    self.score = 0;
    
    return self;
}

- (BOOL) hasStarted {
    return [status isEqualToString:@"started"];
}

- (BOOL) isDone {
    return [status isEqual:@"done"];
}

- (int) getScore {
    return score;
}

- (NSString*) getToken {
    return token;
}

//- (NSString*) getGameId {
//    return gameId;
//}

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

//- (void) setGameId:(NSString*) newId {
//    [gameId retain];
//    gameId = newId;
//}

@end
