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

+ (BOOL) loginWithData:(GameData*)gd user:(NSString*)userName pass:(NSString*)pass delegate:(UIViewController *)loginDelegate{ 
    viewDelegate = loginDelegate;
    NSString* fragment = [NSString stringWithFormat: @"/login/%@", userName];
    
    NSString* post = [NSString stringWithFormat:@"&pass=%@", pass];
    
    NSURLRequest* request = [DistriviaAPI createPost:post urlFrag:fragment];
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    if ( connection ) {
        NSLog(@"Connection Started");
        return true;
        responseData = [[NSMutableData data] retain];
    } else {
        return false;
    }
    [fragment release];
    [post release];
    [request release];
}

+ (NSMutableURLRequest*) createPost:(NSString*)post urlFrag:(NSString*)urlFragment {
    
    // Combine host url with API fragment 
    NSURL* url = [NSURL URLWithString: 
                    [NSString stringWithFormat:@"%@%@", API_URL, urlFragment]];
    
    // URL Encode our post data
    NSData* data = [post dataUsingEncoding: NSASCIIStringEncoding 
                             allowLossyConversion: YES];
    NSString* len = [NSString stringWithFormat:@"%d",[data length]];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];

    [request setURL: url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [request setValue:len forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" 
             forHTTPHeaderField:@"Current-Type"];
    [request setTimeoutInterval:30.0];
    

    return request;
}

- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"API: response");
    [responseData setLength:0];
}


- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data {
    NSLog(@"API: data");
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error {
    NSLog(@"API: error");
    [self.viewDelegate errorOccurred];
    
    [connection release];
    [responseData release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn {
    NSLog(@"API: finish");
    [self.viewDelegate serverResponse];
}
@end
