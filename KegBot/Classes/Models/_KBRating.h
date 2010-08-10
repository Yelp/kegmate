// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KBRating.h instead.

#import <CoreData/CoreData.h>


@class KBBeer;
@class KBUser;

@interface KBRatingID : NSManagedObjectID {}
@end

@interface _KBRating : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (KBRatingID*)objectID;




@property (nonatomic, retain) KBBeer* beer;
//- (BOOL)validateBeer:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) KBUser* user;
//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;



@end

@interface _KBRating (CoreDataGeneratedAccessors)

@end
