//
//  StarredMoviesViewController.m
//  Flix
//
//  Created by Hector Diaz on 6/29/18.
//  Copyright © 2018 Hector Diaz. All rights reserved.
//

#import "StarredMoviesViewController.h"
#import "MovieCell.h"

@interface StarredMoviesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *movies;

@end

@implementation StarredMoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    
}

-(void) fetchStarredMovies {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *movieIdArray = [defaults arrayForKey:@"movieId_array"];
    
    NSLog(@"%@", movieIdArray);
    
    
    for(NSString *stringId in movieIdArray) {
        
        
    }
    
    
}

-(void) fetchMovie:(NSString *) stringId {
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 20;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StarCell" forIndexPath: indexPath];
    
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
