//
//  DistriviaAPI.m
//  distrivia
//
//  Created by Brian Gianforcaro on 4/20/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "DistriviaAPI.h"
#import "GameData.h"

@implementation DistriviaAPI

@synthesize viewDelegate;

const static NSString* API_URL = @"https://distrivia.lame.ws";

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
        NSLog(@"Successful response: %@", token);
        [gd setToken: token];
        [data release];
        success = true;
    }
                     
    [fragment release];
    [post release];
    [request release];
    
    return success;
}

+ (NSMutableURLRequest*) createPost:(NSString*)post urlFrag:(NSString*)urlFragment {
    
    // Combine host url with API fragment 
    NSURL* url = [NSURL URLWithString: 
                    [NSString stringWithFormat:@"%@%@", API_URL, urlFragment]];
    
    NSLog(@"URL Fragment %@", url );
    
    // URL Encode our post data
    NSData* data = [post dataUsingEncoding: NSASCIIStringEncoding 
                             allowLossyConversion: NO];
    NSString* len = [NSString stringWithFormat:@"%d",[data length]];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];

    [request setURL: url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [request setValue:len forHTTPHeaderField:@"Content-Length"];
    //[request setValue:@"application/x-www-form-urlencoded" 
    //         forHTTPHeaderField:@"Current-Type"];
    [request setTimeoutInterval:30.0];
    

    return request;
}
@end
