// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KBKeg.m instead.

#import "_KBKeg.h"

@implementation KBKegID
@end

@implementation _KBKeg

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"KBKeg" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"KBKeg";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"KBKeg" inManagedObjectContext:moc_];
}

- (KBKegID*)objectID {
	return (KBKegID*)[super objectID];
}




@dynamic volumePoured;



- (float)volumePouredValue {
	NSNumber *result = [self volumePoured];
	return result ? [result floatValue] : 0;
}

- (void)setVolumePouredValue:(float)value_ {
	[self setVolumePoured:[NSNumber numberWithFloat:value_]];
}






@dynamic id;






@dynamic index;



- (int)indexValue {
	NSNumber *result = [self index];
	return result ? [result intValue] : 0;
}

- (void)setIndexValue:(int)value_ {
	[self setIndex:[NSNumber numberWithInt:value_]];
}






@dynamic volumeTotal;



- (float)volumeTotalValue {
	NSNumber *result = [self volumeTotal];
	return result ? [result floatValue] : 0;
}

- (void)setVolumeTotalValue:(float)value_ {
	[self setVolumeTotal:[NSNumber numberWithFloat:value_]];
}






@dynamic ratingCount;



- (int)ratingCountValue {
	NSNumber *result = [self ratingCount];
	return result ? [result intValue] : 0;
}

- (void)setRatingCountValue:(int)value_ {
	[self setRatingCount:[NSNumber numberWithInt:value_]];
}






@dynamic ratingTotal;



- (double)ratingTotalValue {
	NSNumber *result = [self ratingTotal];
	return result ? [result doubleValue] : 0;
}

- (void)setRatingTotalValue:(double)value_ {
	[self setRatingTotal:[NSNumber numberWithDouble:value_]];
}






@dynamic dateCreated;






@dynamic volumeAdjusted;



- (float)volumeAdjustedValue {
	NSNumber *result = [self volumeAdjusted];
	return result ? [result floatValue] : 0;
}

- (void)setVolumeAdjustedValue:(float)value_ {
	[self setVolumeAdjusted:[NSNumber numberWithFloat:value_]];
}






@dynamic temperatures;

	
- (NSMutableSet*)temperaturesSet {
	[self willAccessValueForKey:@"temperatures"];
	NSMutableSet *result = [self mutableSetValueForKey:@"temperatures"];
	[self didAccessValueForKey:@"temperatures"];
	return result;
}
	

@dynamic beer;

	

@dynamic pours;

	
- (NSMutableSet*)poursSet {
	[self willAccessValueForKey:@"pours"];
	NSMutableSet *result = [self mutableSetValueForKey:@"pours"];
	[self didAccessValueForKey:@"pours"];
	return result;
}
	



@end
