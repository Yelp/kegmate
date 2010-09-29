// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KBBeer.h instead.

#import <CoreData/CoreData.h>


@class KBRating;
@class KBKeg;










@interface KBBeerID : NSManagedObjectID {}
@end

@interface _KBBeer : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (KBBeerID*)objectID;



@property (nonatomic, retain) NSString *type;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *id;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *info;

//- (BOOL)validateInfo:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *rating;

@property float ratingValue;
- (float)ratingValue;
- (void)setRatingValue:(float)value_;

//- (BOOL)validateRating:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *abv;

@property float abvValue;
- (float)abvValue;
- (void)setAbvValue:(float)value_;

//- (BOOL)validateAbv:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *country;

//- (BOOL)validateCountry:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *imageName;

//- (BOOL)validateImageName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSSet* ratings;
- (NSMutableSet*)ratingsSet;



@property (nonatomic, retain) NSSet* kegs;
- (NSMutableSet*)kegsSet;



@end

@interface _KBBeer (CoreDataGeneratedAccessors)

- (void)addRatings:(NSSet*)value_;
- (void)removeRatings:(NSSet*)value_;
- (void)addRatingsObject:(KBRating*)value_;
- (void)removeRatingsObject:(KBRating*)value_;

- (void)addKegs:(NSSet*)value_;
- (void)removeKegs:(NSSet*)value_;
- (void)addKegsObject:(KBKeg*)value_;
- (void)removeKegsObject:(KBKeg*)value_;

@end

@interface _KBBeer (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveType;
- (void)setPrimitiveType:(NSString*)value;


- (NSString*)primitiveId;
- (void)setPrimitiveId:(NSString*)value;


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;


- (NSString*)primitiveInfo;
- (void)setPrimitiveInfo:(NSString*)value;


- (NSNumber*)primitiveRating;
- (void)setPrimitiveRating:(NSNumber*)value;

- (float)primitiveRatingValue;
- (void)setPrimitiveRatingValue:(float)value_;


- (NSNumber*)primitiveAbv;
- (void)setPrimitiveAbv:(NSNumber*)value;

- (float)primitiveAbvValue;
- (void)setPrimitiveAbvValue:(float)value_;


- (NSString*)primitiveCountry;
- (void)setPrimitiveCountry:(NSString*)value;


- (NSString*)primitiveImageName;
- (void)setPrimitiveImageName:(NSString*)value;




- (NSMutableSet*)primitiveRatings;
- (void)setPrimitiveRatings:(NSMutableSet*)value;



- (NSMutableSet*)primitiveKegs;
- (void)setPrimitiveKegs:(NSMutableSet*)value;


@end
