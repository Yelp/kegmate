// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KBRating.m instead.

#import "_KBRating.h"

@implementation KBRatingID
@end

@implementation _KBRating

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"KBRating" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"KBRating";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"KBRating" inManagedObjectContext:moc_];
}

- (KBRatingID*)objectID {
	return (KBRatingID*)[super objectID];
}




@dynamic beer;

	

@dynamic user;

	



@end
