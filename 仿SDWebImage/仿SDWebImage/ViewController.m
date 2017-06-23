//
//  ViewController.m
//  仿SDWebImage
//
//  Created by caesar on 2017/6/23.
//  Copyright © 2017年 caesar. All rights reserved.
//
#import "NWDownloadImageOperation.h"
#import "ViewController.h"
#import "AFNetworking.h"
#import "YYModel.h"
#import "APPModel.h"
@interface ViewController ()
@property (nonatomic,strong) NSArray *appList;
@property (nonatomic,strong) NSOperationQueue *qq;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (nonatomic,strong) NSMutableDictionary *opCache;
@property (nonatomic,copy) NSString *lastUrl;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.qq = [NSOperationQueue new];
    
    self.opCache = [[NSMutableDictionary alloc]init];
    
    [self loadData];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    int random = arc4random_uniform((uint32_t)self.appList.count);
    
    APPModel *model = self.appList[random];
    
    //判断如果连续点击取消上一次点击下载的操作
    if (![model.icon isEqualToString:_lastUrl] && _lastUrl != nil) {
        NWDownloadImageOperation *lastOP = [self.opCache objectForKey:_lastUrl];
        [lastOP cancel];
        
        //删除操作
        [self.opCache removeObjectForKey:_lastUrl];
    }
    //为lastURL赋值
    _lastUrl = model.icon;
    
    NWDownloadImageOperation *op = [NWDownloadImageOperation downLoadOperationWithURLString:model.icon finishedBlock:^(UIImage *image) {
        
        self.iconImageView.image = image;
        
        //图片下载结束时,移除opCache中得op
        [self.opCache removeObjectForKey:model.icon];
    }];
    
    [self.opCache setObject:op forKey:model.icon];
    
    [self.qq addOperation:op];

}

//点击按钮切换图片
- (IBAction)clickExchangeButton:(id)sender {
    int random = arc4random_uniform((uint32_t)self.appList.count);
    
    APPModel *model = self.appList[random];
    
    //判断如果连续点击取消上一次点击下载的操作
    if (![model.icon isEqualToString:_lastUrl] && _lastUrl != nil) {
        NWDownloadImageOperation *lastOP = [self.opCache objectForKey:_lastUrl];
        [lastOP cancel];
        
        //删除操作
        [self.opCache removeObjectForKey:_lastUrl];
    }
    //为lastURL赋值
    _lastUrl = model.icon;
    
    NWDownloadImageOperation *op = [NWDownloadImageOperation downLoadOperationWithURLString:model.icon finishedBlock:^(UIImage *image) {
        
        self.iconImageView.image = image;
        
        //图片下载结束时,移除opCache中得op
        [self.opCache removeObjectForKey:model.icon];
    }];
    
    [self.opCache setObject:op forKey:model.icon];
    
    [self.qq addOperation:op];
}
//加载json数据到AppList
-(void)loadData{
    NSString *urlString = @"https://raw.githubusercontent.com/Nil-Wang/IOS/master/apps.json";
    
    [[AFHTTPSessionManager manager]GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSArray *dictArray = responseObject;
        
        self.appList = [NSArray yy_modelArrayWithClass:[APPModel class] json:dictArray];
        
        NSLog(@"%@",self.appList);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
