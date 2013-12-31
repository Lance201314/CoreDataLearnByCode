//
//  ProfessionViewController.m
//  CoreDataLearnByCode
//
//  Created by lance on 13-12-31.
//  Copyright (c) 2013年 Lance. All rights reserved.
//

#import "ProfessionViewController.h"
#import "Profession.h"
#import "StudentViewController.h"
@interface ProfessionViewController ()

@end

#define EntityName @"Profession"

@implementation ProfessionViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initwithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.managedObjectContext = managedObjectContext;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configData];
    self.title = @"Profession";
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addProfession)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // update fetch
    [self fetchProfessions];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_managedObjectContext release];
    [_fetchedResultsController release];
    [super dealloc];
}

#pragma mark BarButton action
- (void)addProfession
{
    UIAlertView *inputAlert = [[UIAlertView alloc] initWithTitle:@"add" message:@"add a new Profession" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    inputAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [inputAlert show];
    [inputAlert release];
}

#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // entity
        NSEntityDescription *professionDescription = [NSEntityDescription entityForName:EntityName inManagedObjectContext:self.managedObjectContext];
        // object
        Profession *newProfession = (Profession *)[[NSManagedObject alloc] initWithEntity:professionDescription insertIntoManagedObjectContext:self.managedObjectContext];
        newProfession.name = [alertView textFieldAtIndex:0].text;
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"save profession error :%@", error);
        }
        [self fetchProfessions];
        [self.tableView reloadData];
    }
}

#pragma mark config data
- (void)configData
{
    // fetchRequest to get objects
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:EntityName];
    // set fetchrequest property
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"cid" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    // set cache
    NSString *cacheName = [EntityName stringByAppendingString:@"Cache"];
    // init fetchedResultsController
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:cacheName];
}

// get objects from db
- (void)fetchProfessions
{
    NSError *error = nil;
    BOOL success = [self.fetchedResultsController performFetch:&error];
    if (!success) {
        NSLog(@"failed to fetch data:%@", error);
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.fetchedResultsController.fetchedObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    Profession *profession = (Profession *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = profession.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"(%d)", [profession.students count]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSManagedObject *deleted = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
        [self.managedObjectContext deleteObject:deleted];
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"delete error :%@", error);
            abort();
        }
        [self fetchProfessions];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StudentViewController *studentViewController = [[StudentViewController alloc] initwithProfession:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    [self.navigationController pushViewController:studentViewController animated:YES];
    [studentViewController release];
}

@end
