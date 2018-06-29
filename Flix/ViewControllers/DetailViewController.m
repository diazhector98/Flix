//
//  DetailViewController.m
//  Flix
//
//  Created by Hector Diaz on 6/27/18.
//  Copyright © 2018 Hector Diaz. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TrailerViewController.h"


@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //Images
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
    
    //Labels
    
    self.nameLabel.text = self.movie[@"title"];
    self.bigTitleLabel.text = self.movie[@"title"];
    
    self.synopsisLabel.text = self.movie[@"overview"];
    
//    [self.nameLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
    
//    Date
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc ] init];
    formatter.dateFormat = @"yyyy-MM-dd";

    NSString *rawDateString = [NSString stringWithFormat:@"%@", self.movie[@"release_date"]];
    
    NSDate *date = [formatter dateFromString:rawDateString];
    
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    NSString *finalDateString = [dateFormatter stringFromDate:date];
    
    self.dateLabel.text = finalDateString;
    
    //Popularity
    
    double vote_average = [self.movie[@"vote_average"] doubleValue];
    
    self.averageLabel.text = [NSString stringWithFormat:@"%.1f", vote_average];
    
    
    if(vote_average <= 5){
        
        self.averageLabel.textColor = UIColor.redColor;
        
    } else if (vote_average < 8){
        
        self.averageLabel.textColor = [UIColor colorWithRed:0.96 green:0.80 blue:0.26 alpha:1.0];
        
    } else {
        
        self.averageLabel.textColor = UIColor.greenColor;
        
    }
    
    [self.synopsisLabel sizeToFit];
    
    CGFloat maxHeight = self.synopsisLabel.frame.origin.y + self.synopsisLabel.frame.size.height + 30;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, maxHeight);
    
    NSLog(@"%@", self.movie[@"vote_average"]);
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    TrailerViewController *trailerViewController = [segue destinationViewController];
    
    trailerViewController.movie = self.movie;
    
    
}


@end
