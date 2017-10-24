//
//  ViewController.m
//  GitHub Repos
//
//  Created by Andrew on 2017-10-23.
//  Copyright © 2017 Andrew. All rights reserved.
//

#import "ViewController.h"
@import SafariServices;

@interface ViewController ()

@property (strong, nonatomic) NSArray<NSDictionary *> *repos;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.prefersLargeTitles = YES;
    

    

    NSURL *url = [NSURL URLWithString:@"https://api.github.com/users/ashpland/repos"]; // 1
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
        NSArray *repos = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError]; // 2
        
        if (jsonError) { // 3
            // Handle the error
            NSLog(@"jsonError: %@", jsonError.localizedDescription);
            return;
        }
        
        self.repos = repos;
        
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
        
//
//
//        // If we reach this point, we have successfully retrieved the JSON from the API
//        for (NSDictionary *repo in repos) { // 4
//
//            NSString *repoName = repo[@"name"];
//            NSLog(@"repo: %@", repoName);
//        }
        
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
    
    cell.textLabel.text = [self.repos[indexPath.row] objectForKey:@"name"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self showWebSiteForRepo:indexPath.row];
}

- (void)showWebSiteForRepo:(NSInteger)repoIndex {
    NSURL *url = [NSURL URLWithString:[self.repos[repoIndex] objectForKey:@"html_url"]];
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
//    [self showViewController:safariVC sender:nil];
    [self presentViewController:safariVC animated:YES completion:nil];
}



@end
