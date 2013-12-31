//
//  ProfessionViewController.h
//  CoreDataLearnByCode
//
//  Created by lance on 13-12-31.
//  Copyright (c) 2013年 Lance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfessionViewController : UITableViewController <UIAlertViewDelegate>
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
- (id)initwithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
@end
