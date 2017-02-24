//
//  FeedFlowViewController.h
//  TRT World
//
//  Created by eyupcimen on 23/02/2017.
//  Copyright © 2017 eyupcimen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedFlowViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *htmlParserArrayUrl ;
@property (nonatomic,strong) NSMutableArray *htmlParserArrayTitle ;
@property (nonatomic,strong) NSMutableArray *htmlParserArraySubtitle ;


@property (weak, nonatomic) IBOutlet UITableView *tableViewTrtWorld;

@end
