// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KBUser.h instead.

#import <CoreData/CoreData.h>


@class KBRating;
@class KBKegPour;

@interface KBUserID : NSManagedObjectID {}
@end

@interface _KBUser : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (KBUserID*)objectID;



@property (nonatomic, retain) NSNumber *volumePoured;

@property float volumePouredValue;
- (float)volumePouredValue;
- (void)setVolumePouredValue:(float)value_;

//- (BOOL)validateVolumePoured:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *lastName;

//- (BOOL)validateLastName:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *firstName;

//- (BOOL)validateFirstName:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *pourCount;

@property int pourCountValue;
- (int)pourCountValue;
- (void)setPourCountValue:(int)value_;

//- (BOOL)validatePourCount:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *isAdmin;

@property BOOL isAdminValue;
- (BOOL)isAdminValue;
- (void)setIsAdminValue:(BOOL)value_;

//- (BOOL)validateIsAdmin:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *tagId;

//- (BOOL)validateTagId:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSSet* ratings;
- (NSMutableSet*)ratingsSet;



@property (nonatomic, retain) NSSet* pours;
- (NSMutableSet*)poursSet;



@end

@interface _KBUser (CoreDataGeneratedAccessors)

- (void)addRatings:(NSSet*)value_;
- (void)removeRatings:(NSSet*)value_;
- (void)addRatingsObject:(KBRating*)value_;
- (void)removeRatingsObject:(KBRating*)value_;

- (void)addPours:(NSSet*)value_;
- (void)removePours:(NSSet*)value_;
- (void)addPoursObject:(KBKegPour*)value_;
- (void)removePoursObject:(KBKegPour*)value_;

@end
