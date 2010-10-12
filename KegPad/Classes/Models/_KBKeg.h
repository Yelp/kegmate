// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KBKeg.h instead.

#import <CoreData/CoreData.h>


@class KBKegTemperature;
@class KBBeer;
@class KBKegPour;

@interface KBKegID : NSManagedObjectID {}
@end

@interface _KBKeg : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (KBKegID*)objectID;



@property (nonatomic, retain) NSNumber *volumePoured;

@property float volumePouredValue;
- (float)volumePouredValue;
- (void)setVolumePouredValue:(float)value_;

//- (BOOL)validateVolumePoured:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *id;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *index;

@property int indexValue;
- (int)indexValue;
- (void)setIndexValue:(int)value_;

//- (BOOL)validateIndex:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *volumeTotal;

@property float volumeTotalValue;
- (float)volumeTotalValue;
- (void)setVolumeTotalValue:(float)value_;

//- (BOOL)validateVolumeTotal:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *ratingCount;

@property int ratingCountValue;
- (int)ratingCountValue;
- (void)setRatingCountValue:(int)value_;

//- (BOOL)validateRatingCount:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *ratingTotal;

@property double ratingTotalValue;
- (double)ratingTotalValue;
- (void)setRatingTotalValue:(double)value_;

//- (BOOL)validateRatingTotal:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSDate *dateCreated;

//- (BOOL)validateDateCreated:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *volumeAdjusted;

@property float volumeAdjustedValue;
- (float)volumeAdjustedValue;
- (void)setVolumeAdjustedValue:(float)value_;

//- (BOOL)validateVolumeAdjusted:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSSet* temperatures;
- (NSMutableSet*)temperaturesSet;



@property (nonatomic, retain) KBBeer* beer;
//- (BOOL)validateBeer:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSSet* pours;
- (NSMutableSet*)poursSet;



@end

@interface _KBKeg (CoreDataGeneratedAccessors)

- (void)addTemperatures:(NSSet*)value_;
- (void)removeTemperatures:(NSSet*)value_;
- (void)addTemperaturesObject:(KBKegTemperature*)value_;
- (void)removeTemperaturesObject:(KBKegTemperature*)value_;

- (void)addPours:(NSSet*)value_;
- (void)removePours:(NSSet*)value_;
- (void)addPoursObject:(KBKegPour*)value_;
- (void)removePoursObject:(KBKegPour*)value_;

@end
