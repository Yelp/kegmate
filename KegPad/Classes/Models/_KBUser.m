// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KBUser.m instead.

#import "_KBUser.h"

@implementation KBUserID
@end

@implementation _KBUser

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"KBUser" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"KBUser";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"KBUser" inManagedObjectContext:moc_];
}

- (KBUserID*)objectID {
	return (KBUserID*)[super objectID];
}




@dynamic volumePoured;



- (float)volumePouredValue {
	NSNumber *result = [self volumePoured];
	return result ? [result floatValue] : 0;
}

- (void)setVolumePouredValue:(float)value_ {
	[self setVolumePoured:[NSNumber numberWithFloat:value_]];
}






@dynamic lastName;






@dynamic firstName;






@dynamic pourCount;



- (int)pourCountValue {
	NSNumber *result = [self pourCount];
	return result ? [result intValue] : 0;
}

- (void)setPourCountValue:(int)value_ {
	[self setPourCount:[NSNumber numberWithInt:value_]];
}






@dynamic isAdmin;



- (BOOL)isAdminValue {
	NSNumber *result = [self isAdmin];
	return result ? [result boolValue] : 0;
}

- (void)setIsAdminValue:(BOOL)value_ {
	[self setIsAdmin:[NSNumber numberWithBool:value_]];
}






@dynamic tagId;






@dynamic ratings;

	
- (NSMutableSet*)ratingsSet {
	[self willAccessValueForKey:@"ratings"];
	NSMutableSet *result = [self mutableSetValueForKey:@"ratings"];
	[self didAccessValueForKey:@"ratings"];
	return result;
}
	

@dynamic pours;

	
- (NSMutableSet*)poursSet {
	[self willAccessValueForKey:@"pours"];
	NSMutableSet *result = [self mutableSetValueForKey:@"pours"];
	[self didAccessValueForKey:@"pours"];
	return result;
}
	



@end
