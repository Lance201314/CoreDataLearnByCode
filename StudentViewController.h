//
//  StudentViewController.h
//  CoreDataLearnByCode
//
//  Created by lance on 13-12-31.
//  Copyright (c) 2013年 Lance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Profession.h"
@interface StudentViewController : UITableViewController <UIAlertViewDelegate>

@property (nonatomic, retain) Profession *profession;
- (id)initwithProfession:(Profession *)profession;
@end
