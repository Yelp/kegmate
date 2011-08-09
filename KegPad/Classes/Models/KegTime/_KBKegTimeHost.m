// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KBKegTimeHost.m instead.

#import "_KBKegTimeHost.h"

@implementation KBKegTimeHostID
@end

@implementation _KBKegTimeHost

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"KBKegTimeHost" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"KBKegTimeHost";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"KBKegTimeHost" inManagedObjectContext:moc_];
}

- (KBKegTimeHostID*)objectID {
	return (KBKegTimeHostID*)[super objectID];
}




@dynamic ipAddress;






@dynamic name;






@dynamic port;



- (int)portValue {
	NSNumber *result = [self port];
	return result ? [result intValue] : 0;
}

- (void)setPortValue:(int)value_ {
	[self setPort:[NSNumber numberWithInt:value_]];
}








@end
