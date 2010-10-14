// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KBPourIndex.m instead.

#import "_KBPourIndex.h"

@implementation KBPourIndexID
@end

@implementation _KBPourIndex

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"KBPourIndex" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"KBPourIndex";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"KBPourIndex" inManagedObjectContext:moc_];
}

- (KBPourIndexID*)objectID {
	return (KBPourIndexID*)[super objectID];
}




@dynamic volumePoured;



- (float)volumePouredValue {
	NSNumber *result = [self volumePoured];
	return result ? [result floatValue] : 0;
}

- (void)setVolumePouredValue:(float)value_ {
	[self setVolumePoured:[NSNumber numberWithFloat:value_]];
}






@dynamic timeType;



- (int)timeTypeValue {
	NSNumber *result = [self timeType];
	return result ? [result intValue] : 0;
}

- (void)setTimeTypeValue:(int)value_ {
	[self setTimeType:[NSNumber numberWithInt:value_]];
}






@dynamic timeIndex;



- (int)timeIndexValue {
	NSNumber *result = [self timeIndex];
	return result ? [result intValue] : 0;
}

- (void)setTimeIndexValue:(int)value_ {
	[self setTimeIndex:[NSNumber numberWithInt:value_]];
}






@dynamic pourCount;



- (int)pourCountValue {
	NSNumber *result = [self pourCount];
	return result ? [result intValue] : 0;
}

- (void)setPourCountValue:(int)value_ {
	[self setPourCount:[NSNumber numberWithInt:value_]];
}






@dynamic keg;

	

@dynamic user;

	



@end
