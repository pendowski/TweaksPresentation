//
//  NSMutableArray+Queue.m
//  TweaksPresentation
//
//  Created by Jarosław Pendowski on 16/08/15.
//  Copyright (c) 2015 Jarosław Pendowski. All rights reserved.
//

#import "NSMutableArray+Queue.h"

@implementation NSMutableArray (Queue)

- (void)q_push:(id)obj
{
    [self addObject:obj];
}

- (id)q_pop
{
    id obj = self.lastObject;
    if (obj) {
        [self removeObjectAtIndex:self.count - 1];
    }
    return obj;
}

@end
