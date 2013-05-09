//
//  Created by Jamey McElveen on 5/8/13.
//  Copyright (c) 2012 ACS Technologies. All rights reserved.
//  www.acstechnologies.com
//

#import "TCClassInfo.h"
#import "TCPropertyInfo.h"


@interface TCClassInfo ()
+ (void)addPropertiesToDictionary:(NSMutableDictionary *)dictionary forClass:(Class)klass;
@end

@implementation TCClassInfo

- (id)initWithClass:(Class)subjectClass {
    self = [super init];
    if (self) {
        _subjectClass = subjectClass;
    }

    return self;
}

- (NSArray *)properties {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSDictionary *props = [TCClassInfo propertyDictionaryForClass:self.subjectClass];
    if(props != nil) {
        for (NSString *key in [props allKeys]) {
            TCPropertyInfo *pi = [[TCPropertyInfo alloc] initWithName:key attributes:props[key]];
            [result addObject:pi];
        }
    }
    return [[NSArray alloc] initWithArray:result];
}

+ (NSDictionary *)propertyDictionaryForClass:(Class)klass {

    if (klass == NULL) {
        return nil;
    }

    NSMutableDictionary *results = [[NSMutableDictionary alloc] init];

    [self addPropertiesToDictionary:results forClass:klass];

    // returning a copy here to make sure the dictionary is immutable
    return [NSDictionary dictionaryWithDictionary:results];
}

+ (void)addPropertiesToDictionary:(NSMutableDictionary *)dictionary forClass:(Class)klass {
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(klass, &outCount);
    @try {
        for (i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            const char *propName = property_getName(property);
            if(propName) {
                const char *propAttributes = property_getAttributes(property);
                NSString *propertyName = [NSString stringWithUTF8String:propName];
                NSString *propertyAttr = [NSString stringWithUTF8String:propAttributes];
                [dictionary setObject:propertyAttr forKey:propertyName];
            }
        }
    } @finally {
        free(properties);
    }

    if([klass superclass]) {
        [self addPropertiesToDictionary:dictionary forClass:[klass superclass]];
    }
}

@end