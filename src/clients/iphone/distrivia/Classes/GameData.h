//
//  GameData.h
//  distrivia
//
//  Created by BitShift on 4/20/11.
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
    NSDictionary* leaderboard;
    Question* question;
    int score;
    BOOL localLeaderboard;
}

@property (retain, nonatomic) Question *question;
@property (retain, nonatomic) NSString *username;
@property (retain, nonatomic) NSString *gameId;
@property (retain, nonatomic) NSDictionary *leaderboard;

- (BOOL) hasStarted;
- (BOOL) isDone;
- (int) getScore;
- (NSString*) getToken;
- (NSString*) getGameId;
- (BOOL) localLeaderboard;

- (void) setScore:(int)score;
- (void) setStatus:(NSString*) newStatus;
- (void) setToken:(NSString*) apiToken;
- (void) setGameId:(NSString*) newId;
- (void) setLocalLeaderboard:(BOOL)local;

@end
