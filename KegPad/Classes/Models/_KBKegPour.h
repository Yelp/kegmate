// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KBKegPour.h instead.

#import <CoreData/CoreData.h>


@class KBKeg;
@class KBUser;

@interface KBKegPourID : NSManagedObjectID {}
@end

@interface _KBKegPour : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (KBKegPourID*)objectID;



@property (nonatomic, retain) NSNumber *amountHour;

@property float amountHourValue;
- (float)amountHourValue;
- (void)setAmountHourValue:(float)value_;

//- (BOOL)validateAmountHour:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *amountUserHour;

@property float amountUserHourValue;
- (float)amountUserHourValue;
- (void)setAmountUserHourValue:(float)value_;

//- (BOOL)validateAmountUserHour:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *amount;

@property float amountValue;
- (float)amountValue;
- (void)setAmountValue:(float)value_;

//- (BOOL)validateAmount:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSDate *date;

//- (BOOL)validateDate:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) KBKeg* keg;
//- (BOOL)validateKeg:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) KBUser* user;
//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;



@end

@interface _KBKegPour (CoreDataGeneratedAccessors)

@end
