//
//  StarredMoviesViewController.m
//  Flix
//
//  Created by Hector Diaz on 6/29/18.
//  Copyright © 2018 Hector Diaz. All rights reserved.
//

#import "StarredMoviesViewController.h"
#import "StarredCell.h"
#import "MovieCell.h"

@interface StarredMoviesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *movies;
@property (nonatomic, strong) NSMutableArray *movieTitles;

@end

@implementation StarredMoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self fetchStarredMovies];
    
    
}

-(void) fetchStarredMovies {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *movieIdArray = [defaults arrayForKey:@"movieId_array"];
    
    for(NSString *stringId in movieIdArray) {
        
        NSLog(@"%@", stringId);
        
        [self fetchMovie:stringId];
        
    }
    
    
}

-(void) fetchMovie:(NSString *) stringId {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@",@"https://api.themoviedb.org/3/movie/", stringId, @"?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies" message:@"Internet connection appears to be offline" preferredStyle: UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Try Again" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self fetchMovie:stringId];
                
            }];
            
            [alert addAction: cancelAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"%@", dataDictionary[@"title"]);
            [self.movies addObject:dataDictionary[@"title"]];
            
            [self.tableView reloadData];
        }
        
        
    }];
    [task resume];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    NSLog(@"Count: %@", self.movies);
    
    return self.movies.count;

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Cell loaded");

    StarredCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StarCell" forIndexPath: indexPath];
    
    cell.textLabel.text = @"Text";
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
