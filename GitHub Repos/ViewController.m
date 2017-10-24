//
//  ViewController.m
//  GitHub Repos
//
//  Created by Andrew on 2017-10-23.
//  Copyright © 2017 Andrew. All rights reserved.
//

#import "ViewController.h"
#import "Repo.h"
@import SafariServices;

@interface ViewController ()

@property (strong, nonatomic) NSArray<Repo *> *repos;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)getMostRecent:(UIBarButtonItem *)sender;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.repos = @[];
    
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    

    

    NSURL *url = [NSURL URLWithString:@"https://api.github.com/users/ashpland/repos?sort=updated"]; // 1
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url]; // 2
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration]; // 3
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration]; // 4
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest
                                                completionHandler:^(NSData * _Nullable data,
                                                                    NSURLResponse * _Nullable response,
                                                                    NSError * _Nullable error)
    {
        if (error) { // 1
            // Handle the error
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        NSError *jsonError = nil;
        NSArray *repoDicts = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError]; // 2
        
        if (jsonError) { // 3
            // Handle the error
            NSLog(@"jsonError: %@", jsonError.localizedDescription);
            return;
        }
        
        
        
        for (NSDictionary *currentRepo in repoDicts) {
            
            Repo *newRepo = [[Repo alloc] initWithName:[currentRepo objectForKey:@"name"]
                                                andURL:[NSURL URLWithString:[currentRepo objectForKey:@"html_url"]]];
            
            self.repos = [self.repos arrayByAddingObject:newRepo];
            
        }
        
        
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
        
    }]; // 5
    
    [dataTask resume]; // 6
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.repos)
        return self.repos.count;
    else
        return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"repoCell"];
    
    cell.textLabel.text = self.repos[indexPath.row].name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self showWebSiteForRepo:indexPath.row];
}

- (void)showWebSiteForRepo:(NSInteger)repoIndex {
    SFSafariViewController *safariVC = [[SFSafariViewController alloc]
                                        initWithURL:self.repos[repoIndex].url];
    [self presentViewController:safariVC animated:YES completion:nil];
}



- (IBAction)getMostRecent:(UIBarButtonItem *)sender {
    
    [UIPasteboard generalPasteboard].string = [self.repos[0].url absoluteString];

    
    UIAlertController *copyAlert = [UIAlertController alertControllerWithTitle:@"URL Copied" message:nil preferredStyle:UIAlertControllerStyleAlert];

    [self presentViewController:copyAlert animated:YES completion:nil];
    
    [self performSelector:@selector(dismissAlert:) withObject:copyAlert afterDelay:1.0];
    
}

-(void)dismissAlert:(UIAlertController *)alert
{
    [alert dismissViewControllerAnimated:YES completion:nil];
}





@end
