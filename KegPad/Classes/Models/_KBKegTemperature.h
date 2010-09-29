// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KBKegTemperature.h instead.

#import <CoreData/CoreData.h>


@class KBKeg;





@interface KBKegTemperatureID : NSManagedObjectID {}
@end

@interface _KBKegTemperature : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (KBKegTemperatureID*)objectID;



@property (nonatomic, retain) NSNumber *temperature;

@property float temperatureValue;
- (float)temperatureValue;
- (void)setTemperatureValue:(float)value_;

//- (BOOL)validateTemperature:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *temperatureHour;

@property float temperatureHourValue;
- (float)temperatureHourValue;
- (void)setTemperatureHourValue:(float)value_;

//- (BOOL)validateTemperatureHour:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSDate *date;

//- (BOOL)validateDate:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) KBKeg* keg;
//- (BOOL)validateKeg:(id*)value_ error:(NSError**)error_;



@end

@interface _KBKegTemperature (CoreDataGeneratedAccessors)

@end

@interface _KBKegTemperature (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveTemperature;
- (void)setPrimitiveTemperature:(NSNumber*)value;

- (float)primitiveTemperatureValue;
- (void)setPrimitiveTemperatureValue:(float)value_;


- (NSNumber*)primitiveTemperatureHour;
- (void)setPrimitiveTemperatureHour:(NSNumber*)value;

- (float)primitiveTemperatureHourValue;
- (void)setPrimitiveTemperatureHourValue:(float)value_;


- (NSDate*)primitiveDate;
- (void)setPrimitiveDate:(NSDate*)value;




- (KBKeg*)primitiveKeg;
- (void)setPrimitiveKeg:(KBKeg*)value;


@end
