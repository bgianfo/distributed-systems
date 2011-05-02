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
}

- (Question*) initWithData:(NSDictionary *)qData {
    Question q = [[Question alloc] init];
    //q.qid = [qData objectForKey:@"id"];
    q.question = [qData objectForKey:@"question"];
    q.choiceA = [qData objectForKey:@"a"];
    q.choiceB = [qData objectForKey:@"b"];
    q.choiceC = [qData objectForKey:@"c"];
    q.choiceD = [qData objectForKey:@"d"];
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
