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




@dynamic volumeTotal;



- (float)volumeTotalValue {
	NSNumber *result = [self volumeTotal];
	return [result floatValue];
}

- (void)setVolumeTotalValue:(float)value_ {
	[self setVolumeTotal:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveVolumeTotalValue {
	NSNumber *result = [self primitiveVolumeTotal];
	return [result floatValue];
}

- (void)setPrimitiveVolumeTotalValue:(float)value_ {
	[self setPrimitiveVolumeTotal:[NSNumber numberWithFloat:value_]];
}





@dynamic id;






@dynamic volumePoured;



- (float)volumePouredValue {
	NSNumber *result = [self volumePoured];
	return [result floatValue];
}

- (void)setVolumePouredValue:(float)value_ {
	[self setVolumePoured:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveVolumePouredValue {
	NSNumber *result = [self primitiveVolumePoured];
	return [result floatValue];
}

- (void)setPrimitiveVolumePouredValue:(float)value_ {
	[self setPrimitiveVolumePoured:[NSNumber numberWithFloat:value_]];
}





@dynamic index;



- (int)indexValue {
	NSNumber *result = [self index];
	return [result intValue];
}

- (void)setIndexValue:(int)value_ {
	[self setIndex:[NSNumber numberWithInt:value_]];
}

- (int)primitiveIndexValue {
	NSNumber *result = [self primitiveIndex];
	return [result intValue];
}

- (void)setPrimitiveIndexValue:(int)value_ {
	[self setPrimitiveIndex:[NSNumber numberWithInt:value_]];
}





@dynamic volumeAdjusted;



- (float)volumeAdjustedValue {
	NSNumber *result = [self volumeAdjusted];
	return [result floatValue];
}

- (void)setVolumeAdjustedValue:(float)value_ {
	[self setVolumeAdjusted:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveVolumeAdjustedValue {
	NSNumber *result = [self primitiveVolumeAdjusted];
	return [result floatValue];
}

- (void)setPrimitiveVolumeAdjustedValue:(float)value_ {
	[self setPrimitiveVolumeAdjusted:[NSNumber numberWithFloat:value_]];
}





@dynamic dateCreated;






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
