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
    NSString *qid;
    NSString *question;
    NSString *choiceA;
    NSString *choiceB;
    NSString *choiceC;
    NSString *choiceD;
}

@property (retain, nonatomic) NSString *qid;
@property (retain, nonatomic) NSString *question;
@property (retain, nonatomic) NSString *choiceA;
@property (retain, nonatomic) NSString *choiceB;
@property (retain, nonatomic) NSString *choiceC;
@property (retain, nonatomic) NSString *choiceD;

- (Question*)  initWithDict:(NSDictionary*)qData;
//- (NSString*)   getQuestion;
//- (NSString*)   getChoiceA;
//- (NSString*)   getChoiceB;
//- (NSString*)   getChoiceC;
//- (NSString*)   getChoiceD;

@end
