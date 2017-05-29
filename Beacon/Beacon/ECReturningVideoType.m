//
//  ECReturningVideoType.m
//  Beacon
//
//  Created by SeaHub on 2017/5/29.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECReturningVideoType.h"
#import "ECVideoType.h"

static NSString *const kDescKey = @"desc";
static NSString *const kIDKey   = @"id";
static NSString *const kNameKey = @"name";

@implementation ECReturningVideoType

- (instancetype)initWithJSON:(NSDictionary *)json {
    if (self = [super init]) {
        _desc       = json[kDescKey];
        _identifier = json[kIDKey];
        _name       = json[kNameKey];
    }
    
    return self;
}

- (ECVideoType *)toRealObject {
    return [[ECVideoType alloc] initWithReturningModel:self];
}

@end
