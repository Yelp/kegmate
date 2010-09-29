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




@dynamic amountHour;



- (float)amountHourValue {
	NSNumber *result = [self amountHour];
	return [result floatValue];
}

- (void)setAmountHourValue:(float)value_ {
	[self setAmountHour:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveAmountHourValue {
	NSNumber *result = [self primitiveAmountHour];
	return [result floatValue];
}

- (void)setPrimitiveAmountHourValue:(float)value_ {
	[self setPrimitiveAmountHour:[NSNumber numberWithFloat:value_]];
}





@dynamic amountUserHour;



- (float)amountUserHourValue {
	NSNumber *result = [self amountUserHour];
	return [result floatValue];
}

- (void)setAmountUserHourValue:(float)value_ {
	[self setAmountUserHour:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveAmountUserHourValue {
	NSNumber *result = [self primitiveAmountUserHour];
	return [result floatValue];
}

- (void)setPrimitiveAmountUserHourValue:(float)value_ {
	[self setPrimitiveAmountUserHour:[NSNumber numberWithFloat:value_]];
}





@dynamic amount;



- (float)amountValue {
	NSNumber *result = [self amount];
	return [result floatValue];
}

- (void)setAmountValue:(float)value_ {
	[self setAmount:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveAmountValue {
	NSNumber *result = [self primitiveAmount];
	return [result floatValue];
}

- (void)setPrimitiveAmountValue:(float)value_ {
	[self setPrimitiveAmount:[NSNumber numberWithFloat:value_]];
}





@dynamic date;






@dynamic keg;

	

@dynamic user;

	



@end
