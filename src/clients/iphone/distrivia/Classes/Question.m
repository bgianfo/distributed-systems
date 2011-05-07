//
//  Question.m
//  distrivia
//
//  Created by BitShift on 5/1/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "Question.h"


@implementation Question

@synthesize qid, question, choiceA, choiceB, choiceC, choiceD;

// Initializes the object with the information provided in the NSDictionary
// Returns itself
- (id) initWithDict:(NSDictionary *)qData {
    self = [super init];
    [self setQid:[qData objectForKey:@"qid"]];
    [self setQuestion:[qData objectForKey:@"question"]];
    [self setChoiceA:[qData objectForKey:@"a"]];
    [self setChoiceB:[qData objectForKey:@"b"]];
    [self setChoiceC:[qData objectForKey:@"c"]];
    [self setChoiceD:[qData objectForKey:@"d"]];
    
    return self;
}
@end
