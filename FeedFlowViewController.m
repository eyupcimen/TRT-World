//
//  FeedFlowViewController.m
//  TRT World
//
//  Created by eyupcimen on 23/02/2017.
//  Copyright © 2017 eyupcimen. All rights reserved.
//

#import "FeedFlowViewController.h"
#import "TFHpple.h"
#import "HtmlObject.h"
#import "Contributor.h"
#import "FeedFlowCell.h"
#import <QuartzCore/QuartzCore.h>



#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <BlocksKit/UIView+BlocksKit.h>
#import <sys/utsname.h>
#import "SDWebImageManager.h"



@interface FeedFlowViewController ()

@end

@implementation FeedFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _htmlParserArrayTitle           = [[NSMutableArray alloc]init];
    _htmlParserArrayUrl             = [[NSMutableArray alloc]init];
    _htmlParserArraySubtitle        = [[NSMutableArray alloc]init];
    
    self.tableViewTrtWorld.delegate = self;
    self.tableViewTrtWorld.dataSource = self ;
    [self loadTutorials];
    
    [self.view addSubview:self.tableViewTrtWorld ];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadTutorials];
}

-(void)loadTutorials {
    
    NSURL *tutorialsUrl = [NSURL URLWithString:@"https://www.trtworld.com/turkey"];
    NSData *htmlData = [NSData dataWithContentsOfURL:tutorialsUrl];
    TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:htmlData];
    
    
    // NSString *tutorialsXpathQueryString = @"//div[@class='content-wrapper']/ul/li/a";
    NSString *tutorialsXpathQueryString = @"//div[@class='col-lg-4 col-md-4 col-sm-4 col-xs-12 align']/a/img";
    NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
    NSMutableArray *newTutorials = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement *element in tutorialsNodes) {
        HtmlObject *tutorial = [[HtmlObject alloc] init];
        [newTutorials addObject:tutorial];
        tutorial.url = [element objectForKey:@"src"];
    }

    
    
    NSString *tutorialsXpathQueryString2 = @"//div[@class='newsBox-bigTitle']";
    NSArray *tutorialsNodes2 = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString2];
    NSMutableArray *newTutorials2 = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement *element in tutorialsNodes2) {
        HtmlObject *tutorial = [[HtmlObject alloc] init];
        [newTutorials2 addObject:tutorial];
        tutorial.title = [[element firstChild] content];
        
    }
    
    
    
    
    NSString *tutorialsXpathQueryString3 = @"//div[@class='newsBox-description hidden-xs hidden-sm']";
    NSArray *tutorialsNodes3 = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString3];
    NSMutableArray *newTutorials3 = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement *element in tutorialsNodes3) {
        HtmlObject *tutorial = [[HtmlObject alloc] init];
        [newTutorials3 addObject:tutorial];
        tutorial.descriptionn = [[element firstChild] content];
    }
    
    
    
    
    _htmlParserArraySubtitle = newTutorials3 ;
    _htmlParserArrayTitle = newTutorials2 ;
    _htmlParserArrayUrl = newTutorials;
    [self.tableViewTrtWorld reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _htmlParserArrayUrl.count ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FeedFlowCell *cell = [self.tableViewTrtWorld dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    HtmlObject *title       = _htmlParserArrayTitle[indexPath.row];
    HtmlObject *imageUrl    = _htmlParserArrayUrl[indexPath.row];
    HtmlObject *subtitle    = _htmlParserArraySubtitle[indexPath.row];
    
    
    
    NSString *imageURL = [NSString stringWithFormat:@"http://www.trtworld.com%@" , imageUrl.url ];
    [cell.imageViewFeed sd_setImageWithURL:[NSURL URLWithString:imageURL ]  completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            cell.imageViewFeed.image = image;
        }
    }];
    
    
    cell.feedLabel.text =  [self stringByStrippingHTML:title.title];
    cell.descriptionLabel.text = [self stringByStrippingHTML :subtitle.descriptionn] ;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 436 ;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 430 ;
}



-(NSString *) stringByStrippingHTML:(NSString *)htmlString {
   
    NSScanner *myScanner;
    NSString *text = nil;
    myScanner = [NSScanner scannerWithString:htmlString];
    
    while (![myScanner isAtEnd]) {
        [myScanner scanUpToString:@"<" intoString:NULL] ;
        [myScanner scanUpToString:@">" intoString:&text] ;
        htmlString = [htmlString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    htmlString = [htmlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return htmlString;
}




@end
