//
//  DetailViewController.m
//  Flix
//
//  Created by Hector Diaz on 6/27/18.
//  Copyright © 2018 Hector Diaz. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"


@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString *baseUrl = @"https://image.tmdb.org/t/p/w500";
    
    NSString *posterUrlString = self.movie[@"poster_path"];
    
    NSString *fullPosterUrlString = [baseUrl stringByAppendingString:posterUrlString];
    
    NSURL *posterUrl = [NSURL URLWithString:fullPosterUrlString];
    
    [self.movieImageView setImageWithURL:posterUrl];
    
    
    NSString *coverUrlString = self.movie[@"backdrop_path"];
    
    NSString *fullCoverUrlString = [baseUrl stringByAppendingString:coverUrlString];
    
    NSURL *coverUrl = [NSURL URLWithString:fullCoverUrlString];
    
    [self.movieImageView setImageWithURL:posterUrl];
    
    [self.coverImageView setImageWithURL:coverUrl];
    
    self.nameLabel.text = self.movie[@"title"];
    
    self.synopsisLabel.text = self.movie[@"overview"];
    
    [self.nameLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
    
    [UIView animateWithDuration:0.75 animations:^{
        
        self.movieImageView.frame = CGRectMake(self.movieImageView.frame.origin.x, self.movieImageView.frame.origin.y, 100 , 140);
    }];
    
    
    
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
