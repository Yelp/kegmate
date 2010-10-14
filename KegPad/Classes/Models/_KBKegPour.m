// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KBKegPour.m instead.

#import "_KBKegPour.h"

@implementation KBKegPourID
@end

@implementation _KBKegPour

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"KBKegPour" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"KBKegPour";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"KBKegPour" inManagedObjectContext:moc_];
}

- (KBKegPourID*)objectID {
	return (KBKegPourID*)[super objectID];
}




@dynamic hour;



- (int)hourValue {
	NSNumber *result = [self hour];
	return result ? [result intValue] : 0;
}

- (void)setHourValue:(int)value_ {
	[self setHour:[NSNumber numberWithInt:value_]];
}






@dynamic amount;



- (float)amountValue {
	NSNumber *result = [self amount];
	return result ? [result floatValue] : 0;
}

- (void)setAmountValue:(float)value_ {
	[self setAmount:[NSNumber numberWithFloat:value_]];
}






@dynamic date;






@dynamic keg;

	

@dynamic user;

	



@end
