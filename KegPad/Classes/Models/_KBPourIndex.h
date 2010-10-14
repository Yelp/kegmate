// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KBPourIndex.h instead.

#import <CoreData/CoreData.h>


@class KBKeg;
@class KBUser;

@interface KBPourIndexID : NSManagedObjectID {}
@end

@interface _KBPourIndex : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (KBPourIndexID*)objectID;



@property (nonatomic, retain) NSNumber *volumePoured;

@property float volumePouredValue;
- (float)volumePouredValue;
- (void)setVolumePouredValue:(float)value_;

//- (BOOL)validateVolumePoured:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *timeType;

@property int timeTypeValue;
- (int)timeTypeValue;
- (void)setTimeTypeValue:(int)value_;

//- (BOOL)validateTimeType:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *timeIndex;

@property int timeIndexValue;
- (int)timeIndexValue;
- (void)setTimeIndexValue:(int)value_;

//- (BOOL)validateTimeIndex:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *pourCount;

@property int pourCountValue;
- (int)pourCountValue;
- (void)setPourCountValue:(int)value_;

//- (BOOL)validatePourCount:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) KBKeg* keg;
//- (BOOL)validateKeg:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) KBUser* user;
//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;



@end

@interface _KBPourIndex (CoreDataGeneratedAccessors)

@end
