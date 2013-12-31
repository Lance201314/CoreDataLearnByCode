//
//  Profession.h
//  CoreDataLearnByCode
//
//  Created by lance on 13-12-31.
//  Copyright (c) 2013年 Lance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Student;

@interface Profession : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * cid;
@property (nonatomic, retain) NSSet *students;
@end

@interface Profession (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(Student *)value;
- (void)removeStudentsObject:(Student *)value;
- (void)addStudents:(NSSet *)values;
- (void)removeStudents:(NSSet *)values;

@end
