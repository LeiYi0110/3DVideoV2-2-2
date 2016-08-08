//
//  ViewController.m
//  3DVideoV2
//
//  Created by Lei on 5/3/16.
//  Copyright © 2016 Lei. All rights reserved.
//

#import "ViewController.h"
#import "VideoCell.h"
//#import "PlayerViewController.h"
#import "LocalVideoViewController.h"
#import "VideoSearchViewController.h"
#import "VideoResource.h"

#import "APLViewController.h"

#import "CheckImage2ViewController.h"

#import "VideoOnlineCollectionViewCell.h"

#import "UIImageView+WebCache.h"


@interface ViewController ()

@end

@implementation ViewController
@synthesize searchTextField;
static NSString * const CellReuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.api = [[ServerSideAPI alloc] init];
    [self.api setDelegate:self];
    [self.api getVideoList];
    
    //[self.collectionView registerClass:[VideoOnlineCollectionViewCell class] forCellWithReuseIdentifier:CellReuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"VideoOnlineCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CellReuseIdentifier];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    self.dataSource = [[NSMutableArray alloc] init];
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusAuthorized:
                
                
                break;
            case PHAuthorizationStatusRestricted:
                
                
                
                break;
            case PHAuthorizationStatusDenied:
                
                
                
                break;
            default:
                break;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)didReceivedDicData:(NSDictionary *)receivedData apiKey:(APIKey)apiKey
{
    int status = [[receivedData valueForKey:@"Status"] intValue];
    if (status == 1) {
        if (apiKey == APIKeyVideoList) {
            self.dataSource = [receivedData valueForKey:@"Data"];
            [self.collectionView reloadData];
        }
        else if (apiKey == APIKeySetCheckNum)
        {
            [self removeHUD];
            [[NSUserDefaults standardUserDefaults] setObject:self.checkNum  forKey:@"checkNum"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self performSegueWithIdentifier:@"showPlayer" sender:self];
        }
        
    }
    else
    {
        if (apiKey == APIKeySetCheckNum)
        {
            [self showConpleteHUDWithText:@"序列号无效"];
        }
    }
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.collectionView.frame = self.view.bounds;
    [self initTextField];
    [self initNavgationBarRightButtons];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource count];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //UICollectionViewCell *cell = [[UICollectionViewCell alloc] init];
    VideoOnlineCollectionViewCell *cell = (VideoOnlineCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    /*
     cell.frame = CGRectMake(indexPath.item%3*self.view.bounds.size.width/3, indexPath.item/3*self.view.bounds.size.width/3, self.view.bounds.size.width/3, self.view.bounds.size.width/3);
     */
    
    /*
    cell.descImage = [UIImage imageNamed:@"a.jpeg"];
    cell.videoName = @"OK";
     */
    
    VideoResource *videoResource = [[VideoResource alloc] initWithDic:[self.dataSource objectAtIndex:indexPath.item]];
    videoResource.image = [UIImage imageNamed:@"a.jpeg"];
    cell.videoName.text = videoResource.name;
    [cell.videoImageView sd_setImageWithURL:videoResource.imageURL];
    //cell.videoSource = videoResource;
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //return CGSizeMake(self.view.bounds.size.width/2 - 8, self.view.bounds.size.width/2);
    return CGSizeMake(self.collectionView.bounds.size.width/2 - 8, self.collectionView.bounds.size.width/2);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(8, 2, 0, 2);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 3.0f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"0");
    }
    else//OK
    {
        NSLog(@"1");
        [self showHUD];
        self.checkNum = [alertView textFieldAtIndex:0].text;
        [self.api setCheckNum:self.checkNum];
        
    }
}
- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    
    
    /*
    NSString *checkNum = [[NSUserDefaults standardUserDefaults] valueForKey:@"checkNum"];
    if (checkNum == nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入序列号" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [alertView show];
        return;
    }
     */
     
    
    
    
    [self performSegueWithIdentifier:@"showPlayer" sender:self];
    /*
    VideoResource *videoResource = [[VideoResource alloc] initWithDic:[self.dataSource objectAtIndex:indexPath.item]];
    PlayerViewController *playerViewController = [[PlayerViewController alloc] initWithURL:videoResource.url];
    //[self.navigationController pushViewController:playerViewController animated:YES];
    [self presentViewController:playerViewController animated:NO completion:nil];
     */
    
}

-(void)initTextField
{
    
    
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    //searchTextField.placeholder = @"请输入股票代码";
    
    UIImage *searchIcon = [UIImage imageNamed:@"searchLeftView"];
    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:searchIcon];
    UIView *searchIconBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 33, searchIcon.size.height)];
    
    leftImageView.frame = CGRectMake(10, 0, searchIcon.size.width, searchIcon.size.height);
    
    [searchIconBackgroundView addSubview:leftImageView];
    
    
    
    //leftImageView.frame = CGRectMake(50, 50, 100, 100);
    
    //[self.view addSubview:leftImageView];
    
    [self.searchTextField setLeftView:searchIconBackgroundView];
    [self.searchTextField setLeftViewMode:UITextFieldViewModeAlways];
    //[searchTextField setRightView:leftImageView];
    searchTextField.textColor = [UIColor blackColor];
    searchTextField.font = [UIFont fontWithName:@"ArialMT" size:13];
    [searchTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [searchTextField setBackground:[UIImage imageNamed:@"searchBackground"]];
    //searchTextField.backgroundColor = [UIColor colorWithRed:0.2 green:0.9 blue:0.5 alpha:0.3];
    //searchTextField.layer.borderWidth = 1;
    //searchTextField.layer.borderColor = [[UIColor blackColor] CGColor];
    //searchTextField.tintColor = [UIColor whiteColor];
    
    UIColor *color = [UIColor grayColor];//[[StyleConfig sharedSingleton] getScrollTableRowFontColor];//[UIColor whiteColor];
    searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入电影名称" attributes:@{NSForegroundColorAttributeName: color}];
    
    
    self.navigationItem.titleView = searchTextField;
    
    //[searchTextField setKeyboardType:UIKeyboardTypeDefault];
    //[searchTextField becomeFirstResponder];
    
    //[self.view addSubview:searchTextField];
    
    //[api getStockCodeAndNameWithNum:3000];
    
    [searchTextField setDelegate:self];
    
    self.title = @"首页";
    
    
    
    
}
-(void)initNavgationBarRightButtons
{
    UIBarButtonItem *barButtonItemVideo = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"localVideo"] style:UIBarButtonItemStyleDone target:self action:@selector(localVideoButtonPress:)];
    UIBarButtonItem *barButtonItemCheck = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"checkButton"] style:UIBarButtonItemStyleDone target:self action:@selector(showCheckImage:)];
    
    
    
    
    self.navigationItem.rightBarButtonItems = @[barButtonItemVideo,barButtonItemCheck];
    [barButtonItemVideo setTintColor:[UIColor colorWithRed:86.0f/255 green:90.0f/255 blue:92.0f/255 alpha:1.0f]];
    [barButtonItemCheck setTintColor:[UIColor colorWithRed:86.0f/255 green:90.0f/255 blue:92.0f/255 alpha:1.0f]];
    
    
}
-(void)showCheckImage:(id)sender
{
    CheckImage2ViewController *checkImageViewController = [[CheckImage2ViewController alloc] init];
    [self presentViewController:checkImageViewController animated:NO completion:nil];
}
-(void)localVideoButtonPress:(id)sender
{
    //LocalVideoViewController *localVideoController = [[LocalVideoViewController alloc] init];
    //[self.navigationController pushViewController:localVideoController animated:YES];
    [self performSegueWithIdentifier:@"showLocalVideo" sender:self];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    /*
    VideoSearchViewController *videoSearchViewController = [[VideoSearchViewController alloc] init];
  
    UINavigationController *searchNav = [[UINavigationController alloc] initWithRootViewController:videoSearchViewController];
    [self presentViewController:searchNav animated:YES completion:nil];
     */
    [self performSegueWithIdentifier:@"showSearchView" sender:self];
    return NO;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"segue");
    //[self.navigationController supportedInterfaceOrientations] = UIInterfaceOrientationMaskLandscape;
    //self.navigationController.supportedInterfaceOrientations =
    
    
    if ([[segue identifier] isEqualToString:@"showPlayer"]) {
        
        VideoResource *videoResource = [[VideoResource alloc] initWithDic:[self.dataSource objectAtIndex:self.selectedIndexPath.item]];
    
        APLViewController *aplViewController = (APLViewController *)[segue destinationViewController];
        aplViewController.videoURL = videoResource.url;
        aplViewController.isOnline = YES;
        //aplViewController.videoTitleLabel.text = videoResource.name;
        aplViewController.videoTitle = videoResource.name;
       

    }
    
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
    //return UIInterfaceOrientationMaskLandscape;
}

-(void)showHUD
{
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    //HUD = [[MBProgressHUD alloc] initWithView:self.navigationController != nil ? self.navigationController.view:self.view];
    [self.view addSubview:HUD];
    [HUD show:YES];
}
-(void)showConpleteHUDWithText:(NSString *)text
{
    [self removeHUD];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]] ;
    
    
    HUD.customView = imageView;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = text;
    [self.view addSubview:HUD];
    [HUD show:YES];
    
    [self performSelector:@selector(removeHUD) withObject:nil afterDelay:0.8];
}

-(void)removeHUD
{
    if (HUD != nil) {
        [HUD hide:YES];
        [HUD removeFromSuperview];
        HUD = nil;
    }
    
}
@end
