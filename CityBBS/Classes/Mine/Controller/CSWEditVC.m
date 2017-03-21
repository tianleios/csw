//
//  CSWEditVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/17.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWEditVC.h"

@interface CSWEditVC ()

@property (nonatomic, strong) TLTextField *contentTf;
@end

@implementation CSWEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(hasDone)];
    
    if (!self.editModel) {
        NSLog(@"数据模型？？？？");
        return;
    }
    
    if (self.type == CSWUserEditTypeEmail) {
        
        self.contentTf = [[TLTextField alloc] initWithframe:CGRectMake(0, 10, SCREEN_WIDTH, 45) leftTitle:@"邮箱" titleWidth:80 placeholder:@"请输入您的邮箱"];
        self.contentTf.keyboardType = UIKeyboardTypeEmailAddress;
        [self.view addSubview:self.contentTf];
        
    } else {
    
        self.contentTf = [[TLTextField alloc] initWithframe:CGRectMake(0, 10, SCREEN_WIDTH, 45) leftTitle:@"昵称" titleWidth:80 placeholder:@"请填写昵称"];
        [self.view addSubview:self.contentTf];
    }

    [self.contentTf becomeFirstResponder];
    
}

- (void)hasDone {

    if (self.type == CSWUserEditTypeEmail) {

        
    } else {
        
        
    }
    self.editModel.content = self.contentTf.text;

    if (self.done) {
        self.done();
    }
    [self.navigationController popViewControllerAnimated:YES];
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
