//
//  Created by Jamey McElveen on 5/9/13.
//  Copyright (c) 2012 ACS Technologies. All rights reserved.
//  www.acstechnologies.com
//

#import <Foundation/Foundation.h>

typedef enum PrimitiveType : NSUInteger {
    PrimitiveTypeNone,
    PrimitiveTypeInt,
    PrimitiveTypeFloat,
    PrimitiveTypeBool

} PrimitiveType;

@interface TCPropertyInfo : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *typeName;
@property(nonatomic, strong) Class classType;
@property(nonatomic, assign) PrimitiveType primitiveType;
@property(nonatomic, strong) NSString *attributes;

- (instancetype) initWithName:(NSString *)name attributes:(NSString *)attributes;

@end