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
	return result ? [result floatValue] : 0;
}

- (void)setAmountHourValue:(float)value_ {
	[self setAmountHour:[NSNumber numberWithFloat:value_]];
}






@dynamic amountUserHour;



- (float)amountUserHourValue {
	NSNumber *result = [self amountUserHour];
	return result ? [result floatValue] : 0;
}

- (void)setAmountUserHourValue:(float)value_ {
	[self setAmountUserHour:[NSNumber numberWithFloat:value_]];
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
