//
//  Question.m
//  distrivia
//
//  Created by Sticky Glazer on 5/1/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "Question.h"


@implementation Question

@synthesize qid, question, choiceA, choiceB, choiceC, choiceD;

- (Question*) init {
    [super init];
    return self;
}

- (Question*) initWithDict:(NSDictionary *)qData {
    //Question q = [[[Question alloc] init] autorelease];
    [self setQid:[qData objectForKey:@"id"]];
    [self setQuestion:[qData objectForKey:@"question"]];
    [self setChoiceA:[qData objectForKey:@"a"]];
    [self setChoiceB:[qData objectForKey:@"b"]];
    [self setChoiceC:[qData objectForKey:@"c"]];
    [self setChoiceD:[qData objectForKey:@"d"]];
    
    return self;
}
/*
- (NSString*) getQuestion {
    return question;
}

- (NSString*) getChoiceA {
    return choiceA;
}

- (NSString*) getChoiceB {
    return choiceB;
}

- (NSString*) getChoiceC {
    return choiceC;
}

- (NSString*) getChoiceD {
    return choiceD;
}
*/
@end
