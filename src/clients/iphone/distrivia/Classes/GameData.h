//
//  GameData.h
//  distrivia
//
//  Created by Brian Gianforcaro on 4/20/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GameData : NSObject {
@private
    NSString * status;
    NSString * token;
    NSString * username;
    NSString *gameId;
    int score;
}

@property (retain, nonatomic) NSString *gameId;

- (BOOL) hasStarted;

- (BOOL) isDone;

- (int) getScore;

- (NSString*) getUser;

- (void) setScore:(int)score;

- (void) setStatus:(NSString*) status;

- (void) setUser:(NSString*) user;
@end
