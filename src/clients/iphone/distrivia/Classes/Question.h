//
//  Question.h
//  distrivia
//
//  Created by Sticky Glazer on 5/1/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Question : NSObject {
    
@private
    int qid;
    NSString *question;
    NSString *choiceA;
    NSString *choiceB;
    NSString *choiceC;
    NSString *choiceD;
}

 - (Question*)  initWithDict:(NSDictionary*)qData;
- (NSString*)   getQuestion;
- (NSString*)   getChoiceA;
- (NSString*)   getChoiceB;
- (NSString*)   getChoiceC;
- (NSString*)   getChoiceD;

@end
