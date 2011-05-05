//
//  DistriviaAPI.m
//  distrivia
//
//  Created by Brian Gianforcaro on 4/20/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "DistriviaAPI.h"
#import "GameData.h"
#import "JSONKit.h"
#import "Question.h"

@implementation DistriviaAPI

const static NSString* API_URL = @"https://distrivia.lame.ws";
const static NSString* API_ERROR=@"err";

// Logs in to the server with given username/password
+ (BOOL) loginWithData:(GameData*)gd user:(NSString*)userName pass:(NSString*)pass { 
    NSString* fragment = [NSString stringWithFormat: @"/login/%@", userName];
    NSString* post = [NSString stringWithFormat:@"password=%@", pass];
    NSURLRequest* request = [DistriviaAPI createPost:post urlFrag:fragment];
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error: &error];    
    BOOL success;
    
    if ( !data ) {
        NSLog(@"Connection Error: %@", [error localizedDescription]);
        success = false;
    } else {
        NSString* token = [[NSString alloc] initWithData: data
                                            encoding: NSUTF8StringEncoding];
        NSRange textRange;
        textRange =[API_ERROR rangeOfString: token];
        if ( textRange.location == NSNotFound ) {
            [gd setToken: token];
            [gd setUsername:userName];
            //NSLog(@"Successful response: %@", [gd getToken]);
            success = true;
        } else {
            NSLog(@"Login Error");
            success = false;
        }
        [token release];
    }
    return success;
}

// Registers the given username/password with the server
+ (BOOL) registerWithData:(GameData*)gd user:(NSString*)userName pass:(NSString*)pass {
    NSString* fragment = [NSString stringWithFormat: @"/register/%@", userName];
    NSString* post = [NSString stringWithFormat:@"password=%@", pass];
    NSURLRequest* request = [DistriviaAPI createPost:post urlFrag:fragment];
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error: &error];    
    BOOL success;
    
    if ( !data ) {
        NSLog(@"Connection Error: %@", [error localizedDescription]);
        success = false;
    } else {
        NSString* token = [[NSString alloc] initWithData: data
                                                encoding: NSUTF8StringEncoding];
        NSRange textRange;
        textRange =[API_ERROR rangeOfString: token];
        if ( textRange.location == NSNotFound ) {
            //NSLog(@"Successful response: %@", token);
            success = true;
        } else {
            NSLog(@"Register Error");
            success = false;
        }
        [token release];
    }
    if (success) {
        fragment = [NSString stringWithFormat: @"/login/%@", userName];
        request = [DistriviaAPI createPost:post urlFrag:fragment];
        error = nil;
        data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error: &error];
        
        if ( !data ) {
            NSLog(@"Connection Error: %@", [error localizedDescription]);
            success = false;
        } else {
            NSString* token = [[NSString alloc] initWithData: data
                                                    encoding: NSUTF8StringEncoding];
            NSRange textRange;
            textRange =[API_ERROR rangeOfString: token];
            if ( textRange.location == NSNotFound ) {
                [gd setToken: token];
                //NSLog(@"Successful response: %@", [gd getToken]);
                success = true;
            } else {
                NSLog(@"Login Error");
                success = false;
            }
            [token release];
        }
    }
    return success;
}

// Contacts Server to join a public game
// Inputs: gd
// Return boolean
+ (BOOL) joinPublicWithData:(GameData*)gd {
    NSString* fragment = @"/public/join";
    NSString* post = [NSString stringWithFormat:@"authToken=%@&user=%@", [gd getToken], [gd username]];
    NSURLRequest* request = [DistriviaAPI createPost:post urlFrag:fragment];
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error: &error];    
    BOOL success = false;
    
    if ( !data ) {
        NSLog(@"Connection Error: %@", [error localizedDescription]);
    } else {
        NSString* response = [[NSString alloc] initWithData: data
                                                encoding: NSUTF8StringEncoding];
        NSRange textRange;
        textRange =[API_ERROR rangeOfString: response];
        if ( textRange.location == NSNotFound ) {
            //NSLog(@"Successful response: %@", response);
            JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
            NSDictionary *items = [jsonKitDecoder objectWithData:data];
            if ([items objectForKey:@"status"]) {
                [gd setGameId:[items objectForKey:@"id"]];
                success = true;
            }
        } else {
            NSLog(@"API Error");
        }
        [response release];
    }
    return success;
}


// Contacts the server to get the status of the given game
+ (BOOL) statusWithData:(GameData*)gd {
    NSString* fragment = [NSString stringWithFormat: @"/game/%@", [gd gameId]];
    NSString* post = [NSString stringWithFormat:@"authToken=%@", [gd getToken]];
    NSURLRequest* request = [DistriviaAPI createPost:post urlFrag:fragment];
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error: &error];    
    BOOL success = false;
    
    if ( !data ) {
        NSLog(@"Connection Error: %@", [error localizedDescription]);
    } else {
        NSString* response = [[NSString alloc] initWithData: data
                                                   encoding: NSUTF8StringEncoding];
        NSRange textRange;
        textRange =[API_ERROR rangeOfString: response];
        if ( textRange.location == NSNotFound ) {
            //NSLog(@"Successful response: %@", response);
            JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
            NSDictionary *items = [jsonKitDecoder objectWithData:data];
            [gd setStatus:[items objectForKey:@"gamestatus"]];
            if ([gd hasStarted]) {
                Question *q = [[Question alloc] initWithDict:items];
                [gd setQuestion:q];
                [q release];
            }
            [gd setLocalLeaderboard:YES];
            [gd setLeaderboard:[items objectForKey:@"leaderboard"]];
            success = true;
        } else {
            NSLog(@"API Error");
        }
        [response release];
    }
    return success;
}

// Commits user's answer to the server and gets the next information
+ (BOOL) answerWithData:(GameData*)gd answer:(NSString*)answer timeTaken:(int)time {
    NSString* fragment = [NSString stringWithFormat: @"/game/%@/question/%@", [gd gameId], [[gd question] qid]];
    NSString* post = [NSString stringWithFormat:@"authToken=%@&user=%@&time=%d&a=%@", [gd getToken], 
                      [gd username], time, answer];
    NSURLRequest* request = [DistriviaAPI createPost:post urlFrag:fragment];
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error: &error];    
    BOOL success = false;
    
    if ( !data ) {
        NSLog(@"Connection Error: %@", [error localizedDescription]);
    } else {
        NSString* response = [[NSString alloc] initWithData: data
                                                   encoding: NSUTF8StringEncoding];
        NSRange textRange;
        textRange =[API_ERROR rangeOfString: response];
        if ( textRange.location == NSNotFound ) {
            //NSLog(@"Successful response: %@", response);
            JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
            NSDictionary *items = [jsonKitDecoder objectWithData:data];
            [gd setStatus:[items objectForKey:@"gamestatus"]];
            if ([gd hasStarted]) {
                Question *q = [[Question alloc] initWithDict:items];
                [gd setQuestion:q];
                [q release];
                [gd setScore:[[[items objectForKey:@"leaderboard"] objectForKey:[gd username]] intValue]];
            } else{
                [gd setQuestion:nil];
                [gd setLocalLeaderboard:YES];
                [gd setLeaderboard:[items objectForKey:@"leaderboard"]];
            }
            success = true;
        } else {
            NSLog(@"API Error");
        }
        [response release];
    }
    return success;
}



+ (BOOL) globalLeaderboardWithData:(GameData*)gd {
    NSString* fragment = [NSString stringWithFormat: @"/leaderboard/0", [gd getToken]];
    NSString* post = [NSString stringWithFormat:@"authToken=%@", [gd getToken]];
    NSURLRequest* request = [DistriviaAPI createPost:post urlFrag:fragment];
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error: &error];    
    BOOL success = false;
    
    if ( !data ) {
        NSLog(@"Connection Error: %@", [error localizedDescription]);
    } else {
        NSString* response = [[NSString alloc] initWithData: data
                                                   encoding: NSUTF8StringEncoding];
        NSRange textRange;
        textRange =[API_ERROR rangeOfString: response];
        if ( textRange.location == NSNotFound ) {
            //NSLog(@"Successful response: %@", response);
            JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
            NSDictionary *items = [jsonKitDecoder objectWithData:data];
            [gd setLocalLeaderboard:NO];
            [gd setLeaderboard:items];
            success = true;
        } else {
            NSLog(@"API Error");
        }
        [response release];
    }
    return success;
}


+ (BOOL) joinPrivateWithData:(GameData*)gd gameName:(NSString*)gamename passwd:(NSString*)pass {
    NSString* fragment = @"/private/join";
    NSString* post = [NSString stringWithFormat:@"authToken=%@&password=%@&user=%@&name=%@", 
                            [gd getToken], pass, [gd username], gamename];
    NSURLRequest* request = [DistriviaAPI createPost:post urlFrag:fragment];
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error: &error];    
    BOOL success = false;
    
    if ( !data ) {
        NSLog(@"Connection Error: %@", [error localizedDescription]);
    } else {
        NSString* response = [[NSString alloc] initWithData: data
                                                   encoding: NSUTF8StringEncoding];
        NSRange textRange;
        textRange =[API_ERROR rangeOfString: response];
        if ( textRange.location == NSNotFound ) {
            //NSLog(@"Successful response: %@", response);
            JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
            NSDictionary *items = [jsonKitDecoder objectWithData:data];
            if ([items objectForKey:@"status"]) {
                [gd setGameId:[items objectForKey:@"id"]];
                success = true;
            }
        } else {
            NSLog(@"API Error");
        }
        [response release];
    }
    return success;
}



+ (NSMutableURLRequest*) createPost:(NSString*)post urlFrag:(NSString*)urlFragment {

    // Clear cache so we don't try to get the same response.
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    // Combine host url with API fragment 
    NSURL* url = [NSURL URLWithString: 
                    [NSString stringWithFormat:@"%@%@", API_URL, urlFragment]];
    
    // URL Encode our post data
    NSData* data = [post dataUsingEncoding: NSASCIIStringEncoding 
                             allowLossyConversion: NO];
    NSString* len = [NSString stringWithFormat:@"%d",[data length]];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];

    [request setURL: url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [request setValue:len forHTTPHeaderField:@"Content-Length"];
    [request setTimeoutInterval:30.0];

    return request;
}
@end
