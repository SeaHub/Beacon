//
//  ECVideoType.m
//  Beacon
//
//  Created by SeaHub on 2017/5/29.
//  Copyright © 2017年 Echo. All rights reserved.
//

#import "ECVideoType.h"
#import "ECReturningVideoType.h"

@implementation ECVideoType

- (instancetype)initWithReturningModel:(ECReturningVideoType *)model {
    if (self = [super init]) {
        _desc       = model.desc;
        _name       = model.name;
        _identifier = model.identifier;
    }
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"description: %@, name: %@, id: %@", _desc, _name, _identifier];
}

@end
