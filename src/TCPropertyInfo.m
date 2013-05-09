//
//  Created by Jamey McElveen on 5/9/13.
//  Copyright (c) 2012 ACS Technologies. All rights reserved.
//  www.acstechnologies.com
//

#import "TCPropertyInfo.h"

@interface TCPropertyInfo ()
+ (PrimitiveType)primitiveTypeFromTypeName:(NSString *)typeName;

+ (NSDictionary *)primitiveTypeMap;

+ (NSString *)getPropertyType:(NSString *)attributes;

+ (NSString *)structNameForStructAttributes:(NSString *)structAttributes;

+ (Class)classFromTypeName:(NSString *)typeName;
@end

@implementation TCPropertyInfo

- (instancetype)initWithName:(NSString *)name attributes:(NSString *)attributes {
    if (self = [super init]) {
        NSString *typeName = [TCPropertyInfo getPropertyType:attributes];
        _attributes = attributes;
        _name = name;
        _typeName = typeName;
        _classType = [TCPropertyInfo classFromTypeName:typeName];
        _primitiveType = [TCPropertyInfo primitiveTypeFromTypeName:typeName];
    }
    return self;
}

+ (NSString *)getPropertyType:(NSString *)attributes {
    // reference
    // https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1
    NSString *shortType = @"";
    NSArray *components = [attributes componentsSeparatedByString:@","];
    for (NSString *component in components) {
        if([component hasPrefix:@"T@"] && component.length == 2) {
            shortType =  @"id";
        } else if([component hasPrefix:@"T@"]) {
            shortType = [component substringWithRange:NSMakeRange(3, component.length - 4)];
        } else if([component hasPrefix:@"T{"]) {
            shortType = [self structNameForStructAttributes:component];
        } else if([component hasPrefix:@"T"]) {
            shortType = [component substringFromIndex:1];
        }
    }
    return [self fullTypeNameForShortTypeName:shortType];
}

 + (NSString *)structNameForStructAttributes:(NSString*)structAttributes {
    NSArray *components = [structAttributes componentsSeparatedByString:@"="];
     return [components[0] substringFromIndex:2];
 }

+ (NSString *)fullTypeNameForShortTypeName:(NSString *)typeName {
    static NSDictionary *typeMap = nil;
    if (typeMap == nil) {
        typeMap =
            @{
                @"c": @"char",
                @"i": @"int",
                @"s": @"short",
                @"l": @"long",
                @"q": @"long long",
                @"C": @"unsigned char",
                @"I": @"unsigned int",
                @"S": @"unsigned short",
                @"L": @"unsigned long",
                @"Q": @"unsigned long long",
                @"f": @"float",
                @"d": @"double",
                @"B": @"bool",
                @"v": @"void",
                @"*": @"char *",
                @"@": @"id",
                @"#": @"Class",
                @":": @"SEL",
                @"?": @"unknown"
            };

    }
    NSString *fullTypeName = typeMap[typeName];
    return fullTypeName ? : typeName;
}

+ (Class)classFromTypeName:(NSString *)typeName {
    return NSClassFromString(typeName);
}

+ (PrimitiveType)primitiveTypeFromTypeName:(NSString *)typeName {
    NSNumber *pt = [[TCPropertyInfo primitiveTypeMap] objectForKey:typeName];
    return  pt ? (PrimitiveType)[pt intValue] : PrimitiveTypeNone;

}

+ (NSDictionary *)primitiveTypeMap {
    static NSDictionary *_primitiveTypeMap = nil;
    if (_primitiveTypeMap == nil) {
        _primitiveTypeMap =
            @{
                @"bool" : [NSNumber numberWithInt:PrimitiveTypeBool],
                @"float" : [NSNumber numberWithInt:PrimitiveTypeFloat],
                @"int" : [NSNumber numberWithInt:PrimitiveTypeInt]
            };
    }
    return _primitiveTypeMap;
}

//static const char * getPropertyType(objc_property_t property) {
//    const char *attributes = property_getAttributes(property);
//    unichar
//    NSString *str = [NSString stringWithCharacters:NULL length:<#(NSUInteger)length#>];
//    printf("attributes=%s\n", attributes);
//    char buffer[1 + strlen(attributes)];
//    strcpy(buffer, attributes);
//    char *state = buffer, *attribute;
//    while ((attribute = strsep(&state, ",")) != NULL) {
//        if (attribute[0] == 'T' && attribute[1] != '@') {
//            // it's a C primitive type:
//            /*
//                if you want a list of what will be returned for these primitives, search online for
//                "objective-c" "Property Attribute Description Examples"
//                apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
//            */
//            return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
//        }
//        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
//            // it's an ObjC id type:
//            return "id";
//        }
//        else if (attribute[0] == 'T' && attribute[1] == '@') {
//            // it's another ObjC object type:
//            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
//        }
//    }
//    return "";
//}

@end