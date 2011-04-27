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

@synthesize responseData;
@synthesize viewDelegate;

const static NSString* API_URL = @"https://distrivia.lame.ws";

+ (BOOL) loginWithData:(GameData*)gd user:(NSString*)userName pass:(NSString*)pass delegate:(UIViewController *)loginDelegate{ 
    viewDelegate = loginDelegate;
    NSString* fragment = [NSString stringWithFormat: @"/login/%@", userName];
    
    NSString* post = [NSString stringWithFormat:@"&pass=%@", pass];
    
    NSURLRequest* request = [DistriviaAPI createPost:post urlFrag:fragment];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    if ( conn ) {
        return true;
    } else {
        return false;
    }
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
    

    return request;
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.viewDelegate errorOccurred];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.viewDelegate serverResponse];
}
@end
