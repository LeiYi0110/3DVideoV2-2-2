//
//  VideoSearchViewController.m
//  3DVideoV2
//
//  Created by Lei on 6/3/16.
//  Copyright © 2016 Lei. All rights reserved.
//

#import "VideoSearchViewController.h"
#import "APLViewController.h"

@interface VideoSearchViewController ()

@end

@implementation VideoSearchViewController
@synthesize searchTableView;
@synthesize searchTextField;
@synthesize searchResult;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //[self performSelectorInBackground:@selector(initTextField) withObject:nil];
    
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    [self initTextField];
    
    
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style: UIBarButtonItemStyleDone target:self action:@selector(cancelPress:)];
    self.navigationItem.rightBarButtonItems = @[cancelBarButton];//@[cancelBarButton];
    
    self.searchResult = [[NSMutableArray alloc] init];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[searchTextField becomeFirstResponder];
    //[self performSelectorInBackground:@selector(textFieldBecomeFirstResponder) withObject:nil];
    //[self performSelector:@selector(textFieldBecomeFirstResponder) withObject:nil afterDelay:0.001f];
    
    [self.searchTextField becomeFirstResponder];
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self performSelectorInBackground:@selector(textFieldBecomeFirstResponder) withObject:nil];
    //[searchTextField becomeFirstResponder];
    
    
    //[self.searchTextField becomeFirstResponder];  // <---- Only edit this line
    
    
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
-(void)initTextField
{
    
    
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 350, 30)];
    //searchTextField.placeholder = @"请输入股票代码";
    
    UIImage *searchIcon = [UIImage imageNamed:@"searchLeftView"];
    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:searchIcon];
    UIView *searchIconBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 33, searchIcon.size.height)];
    
    leftImageView.frame = CGRectMake(10, 0, searchIcon.size.width, searchIcon.size.height);
    
    [searchIconBackgroundView addSubview:leftImageView];
    
    self.searchTextField.leftView = searchIconBackgroundView;
    
    
    [self.searchTextField setLeftViewMode:UITextFieldViewModeAlways];
    //[searchTextField setRightView:leftImageView];
    searchTextField.textColor = [UIColor blackColor];
    searchTextField.font = [UIFont fontWithName:@"ArialMT" size:13];;
    [searchTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [searchTextField setBackground:[UIImage imageNamed:@"searchBackground"]];
    //searchTextField.tintColor = [UIColor whiteColor];
    
    UIColor *color = [UIColor grayColor];
    searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入视频名称" attributes:@{NSForegroundColorAttributeName: color}];
    
    
    self.navigationItem.titleView = searchTextField;
    
    [searchTextField setKeyboardType:UIKeyboardTypeAlphabet];
    //[searchTextField becomeFirstResponder];
    
    
    
    [searchTextField setDelegate:self];
    
    
    
    
    
    
    
}
-(void)textFieldBecomeFirstResponder
{
    [self.searchTextField becomeFirstResponder];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResult count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = ((NSDictionary *)[searchResult objectAtIndex:indexPath.row]).allKeys[0]; //[NSString stringWithFormat:@"%d",indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.selectedIndexPath = indexPath;
    
    [self performSegueWithIdentifier:@"showPlayer" sender:self];
    
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"segue");
    if ([[segue identifier] isEqualToString:@"showPlayer"]) {
        
        NSString *urlString = ((NSDictionary *)[searchResult objectAtIndex:self.selectedIndexPath.row]).allValues[0];
        //VideoResource *videoResource = [[VideoResource alloc] initWithDic:[self.dataSource objectAtIndex:self.selectedIndexPath.item]];
        
        APLViewController *aplViewController = (APLViewController *)[segue destinationViewController];
        aplViewController.videoURL = [NSURL URLWithString:urlString];
        aplViewController.isOnline = YES;
        
        NSString *title = ((NSDictionary *)[searchResult objectAtIndex:self.selectedIndexPath.row]).allKeys[0];
        aplViewController.videoTitle = title;
        
        
    }
    
}

-(void)cancelPress:(id)sender
{
    [self.searchTextField resignFirstResponder];
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)searchWithPreCode:(NSString *)preStockCode
{
    NSDictionary *stockCode = [[NSUserDefaults standardUserDefaults] valueForKey:@"videoData"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",preStockCode];
    
    
    
    NSArray *preCode = stockCode.allKeys;
    
    
    preCode = [preCode filteredArrayUsingPredicate:predicate];
    
    NSLog(@"preCode count is %d", [preCode count]);
    [searchResult removeAllObjects];
    for (NSString *code in preCode) {
        NSDictionary *item = [NSDictionary dictionaryWithObject:[stockCode valueForKey:code] forKey:code];
        [searchResult addObject:item];
    }
    
    NSLog(@"result is %@", searchResult);
    NSLog(@"preCode count is %d", [preCode count]);
    
    [self.searchTableView reloadData];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"all is %@ input is %@", textField.text, string);
    
    //[[NSUserDefaults standardUserDefaults] setObject:stockCode forKey:@"stockCode"];
    
    
    
    NSString *currentSearch = [NSString stringWithFormat:@"%@%@",textField.text,string];
    
    
    [self searchWithPreCode:currentSearch];
    
    
    return YES;
}
@end
