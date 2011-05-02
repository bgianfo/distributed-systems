//
//  Question.m
//  distrivia
//
//  Created by Sticky Glazer on 5/1/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "Question.h"


@implementation Question

- (Question*) init {
    [super init];
    return self;
}

- (Question*) initWithDict:(NSDictionary *)qData {
    //Question q = [[[Question alloc] init] autorelease];
    //q.qid = [qData objectForKey:@"id"];
    question = [qData objectForKey:@"question"];
    choiceA = [qData objectForKey:@"a"];
    choiceB = [qData objectForKey:@"b"];
    choiceC = [qData objectForKey:@"c"];
    choiceD = [qData objectForKey:@"d"];
    
    return self;
}

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

@end
