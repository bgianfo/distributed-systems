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
    NSMutableData *responseData;
    UIViewController *viewDelegate;
    
}
@property (retain, nonatomic) NSMutableData *responseData;
@property (retain, nonatomic) UIViewController *viewDelegate;

+ (BOOL) loginWithData:(GameData*)gd user:(NSString*)userName pass:(NSString*)pass delegate:(id)loginDelegate;

+ (NSMutableURLRequest*) createPost:(NSString*)post urlFrag:(NSString*)urlFragment;

@end
