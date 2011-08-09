// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KBKegTimeHost.h instead.

#import <CoreData/CoreData.h>



@interface KBKegTimeHostID : NSManagedObjectID {}
@end

@interface _KBKegTimeHost : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (KBKegTimeHostID*)objectID;



@property (nonatomic, retain) NSString *ipAddress;

//- (BOOL)validateIpAddress:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *port;

@property int portValue;
- (int)portValue;
- (void)setPortValue:(int)value_;

//- (BOOL)validatePort:(id*)value_ error:(NSError**)error_;




@end

@interface _KBKegTimeHost (CoreDataGeneratedAccessors)

@end
