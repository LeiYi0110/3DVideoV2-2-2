//
//  ViewController.h
//  3DVideoV2
//
//  Created by Lei on 5/3/16.
//  Copyright © 2016 Lei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerSideAPI.h"
#import "MBProgressHUD.h"

@interface ViewController : UIViewController<ServerSideAPIDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,UIAlertViewDelegate>
{
    MBProgressHUD *HUD;

}

@property (strong, nonatomic) NSString *a;

@property (strong, nonatomic) ServerSideAPI *api;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) UITextField *searchTextField;

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@property (strong, nonnull) NSString *checkNum;

@end

