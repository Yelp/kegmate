// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KBKegTemperature.m instead.

#import "_KBKegTemperature.h"

@implementation KBKegTemperatureID
@end

@implementation _KBKegTemperature

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"KBKegTemperature" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"KBKegTemperature";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"KBKegTemperature" inManagedObjectContext:moc_];
}

- (KBKegTemperatureID*)objectID {
	return (KBKegTemperatureID*)[super objectID];
}




@dynamic temperature;



- (float)temperatureValue {
	NSNumber *result = [self temperature];
	return [result floatValue];
}

- (void)setTemperatureValue:(float)value_ {
	[self setTemperature:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveTemperatureValue {
	NSNumber *result = [self primitiveTemperature];
	return [result floatValue];
}

- (void)setPrimitiveTemperatureValue:(float)value_ {
	[self setPrimitiveTemperature:[NSNumber numberWithFloat:value_]];
}





@dynamic temperatureHour;



- (float)temperatureHourValue {
	NSNumber *result = [self temperatureHour];
	return [result floatValue];
}

- (void)setTemperatureHourValue:(float)value_ {
	[self setTemperatureHour:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveTemperatureHourValue {
	NSNumber *result = [self primitiveTemperatureHour];
	return [result floatValue];
}

- (void)setPrimitiveTemperatureHourValue:(float)value_ {
	[self setPrimitiveTemperatureHour:[NSNumber numberWithFloat:value_]];
}





@dynamic date;






@dynamic keg;

	



@end
