//
//  StudentViewController.m
//  CoreDataLearnByCode
//
//  Created by lance on 13-12-31.
//  Copyright (c) 2013年 Lance. All rights reserved.
//

#import "StudentViewController.h"
#import "Student.h"
@interface StudentViewController ()

@end
#define EntityName @"Student"
@implementation StudentViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initwithProfession:(Profession *)profession
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.profession = profession;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.profession.name;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addProfession)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark BarButton action
- (void)addProfession
{
    UIAlertView *inputAlert = [[UIAlertView alloc] initWithTitle:@"add" message:@"add a new Student" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    inputAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [inputAlert show];
    [inputAlert release];
}

#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // entity
        NSEntityDescription *professionDescription = [NSEntityDescription entityForName:EntityName inManagedObjectContext:self.profession.managedObjectContext];
        // object
        Student *newStudent = (Student *)[[NSManagedObject alloc] initWithEntity:professionDescription insertIntoManagedObjectContext:self.profession.managedObjectContext];
        newStudent.name = [alertView textFieldAtIndex:0].text;
        NSError *error = nil;
        [self.profession addStudentsObject:newStudent];
        if (![self.profession.managedObjectContext save:&error]) {
            NSLog(@"save Student error :%@", error);
        }
        [self.tableView reloadData];
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
    return [self.profession.students count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    Student *student = (Student *)[self.profession.students.allObjects objectAtIndex:indexPath.row];
    cell.textLabel.text = student.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",student.sno];
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
        NSManagedObject *deleted = [self.profession.students.allObjects objectAtIndex:indexPath.row];
        [self.profession.managedObjectContext deleteObject:deleted];
        NSError *error = nil;
        if (![self.profession.managedObjectContext save:&error]) {
            NSLog(@"delete object failed :%@", error);
        }
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
