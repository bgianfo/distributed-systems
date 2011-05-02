//
//  GameData.h
//  distrivia
//
//  Created by Brian Gianforcaro on 4/20/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Question;

@interface GameData : NSObject {
@private
    NSString* status;
    NSString* token;
    NSString* username;
    NSString* gameId;
    Question* question;
    int score;
}

- (BOOL) hasStarted;
- (BOOL) isDone;
- (int) getScore;
- (NSString*) getUser;
- (NSString*) getToken;
- (NSString*) getGameId;
- (Question*) getQuestion;

- (void) setScore:(int)score;
- (void) setStatus:(NSString*) newStatus;
- (void) setUser:(NSString*) user;
- (void) setToken:(NSString*) apiToken;
- (void) setGameId:(NSString*) newId;
- (void) setQuestion:(Question*)quest

@end
