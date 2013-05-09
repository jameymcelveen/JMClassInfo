//
//  Created by Jamey McElveen on 5/8/13.
//  Copyright (c) 2012 ACS Technologies. All rights reserved.
//  www.acstechnologies.com
//

#import <Foundation/Foundation.h>
#import "objc/runtime.h"

@interface TCClassInfo : NSObject

@property(nonatomic, strong) Class subjectClass;
@property(nonatomic, readonly) NSArray *properties;

- (id)initWithClass:(Class)subjectClass;

@end

