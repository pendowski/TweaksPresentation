//
//  NSMutableArray+Queue.h
//  TweaksPresentation
//
//  Created by Jarosław Pendowski on 16/08/15.
//  Copyright (c) 2015 Jarosław Pendowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Queue)

- (void)q_push:(id)obj;
- (id)q_pop;

@end
