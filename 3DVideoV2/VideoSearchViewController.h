//
//  VideoSearchViewController.h
//  3DVideoV2
//
//  Created by Lei on 6/3/16.
//  Copyright © 2016 Lei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoSearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITableView *searchTableView;

@property (strong, nonatomic) UITextField *searchTextField;

@property (strong, nonatomic) NSMutableArray *searchResult;

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@end
