//
//  Card.h
//  blackjack
//
//  Created by Kevin on 2/23/14.
//  Copyright (c) 2014 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSMutableString * rank;
@property (strong, nonatomic) NSMutableString * suit;

-(NSString*) displayCard;

@end
