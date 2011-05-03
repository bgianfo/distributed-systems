//
//  DistriviaAPI.h
//  distrivia
//
//  Created by Brian Gianforcaro on 4/20/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GameData;


@interface DistriviaAPI : NSObject {
    
}

+ (BOOL) loginWithData:(GameData*)gd user:(NSString*)userName pass:(NSString*)pass;
+ (BOOL) registerWithData:(GameData*)gd user:(NSString*)userName pass:(NSString*)pass;
+ (BOOL) joinPublicWithData:(GameData*)gd;
+ (BOOL) statusWithData:(GameData*)gd;
+ (BOOL) answerWithData:(GameData*)gd answer:(NSString*)answer timeTaken:(int)time;

+ (NSMutableURLRequest*) createPost:(NSString*)post urlFrag:(NSString*)urlFragment;

@end
