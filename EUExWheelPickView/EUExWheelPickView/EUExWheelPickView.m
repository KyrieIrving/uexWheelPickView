//
//  EUExWheelPickView.m
//  EUExWheelPickView
//
//  Created by 杨广 on 16/4/20.
//  Copyright © 2016年 杨广. All rights reserved.
//

#import "EUExWheelPickView.h"
#import "EUtility.h"
#import "JSON.h"
@implementation EUExWheelPickView{
     BOOL currentOpenStaus;
     BOOL notThird;
     BOOL isShow;
}
- (id)initWithBrwView:(EBrowserView *)eInBrwView{
    if (self = [ super initWithBrwView:eInBrwView]) {
       
    }
    return self;
}
- (NSMutableArray*)first{
    if (!_first) {
        _first = [NSMutableArray array];
    }
    return _first;
}
- (NSMutableDictionary*)citysDic{
    if (!_citysDic) {
        _citysDic = [NSMutableDictionary dictionary];
    }
    return _citysDic;
}
- (NSMutableDictionary*)areasDic{
    if (!_areasDic) {
        _areasDic = [NSMutableDictionary dictionary];
    }
    return _areasDic;
}
- (NSArray*)second{
    if (!_second) {
        _second = [self.citysDic valueForKey:self.first[[self.selectArr[0]intValue]]];
    }
    return _second;
}
- (NSArray*)thrid{
    if (!_thrid) {
        _thrid = [self.areasDic valueForKey:self.second[[self.selectArr[1]intValue]]];
        
    }
    return _thrid;
}
-(void)open:(NSMutableArray*)inArguments{
    if (inArguments.count < 1) {
        return;
    }
    if (currentOpenStaus == YES) {
        return;
    }
    id info=[inArguments[0] JSONValue];
    self.selectArr = [info objectForKey:@"select"];
    float x = [[info objectForKey:@"x"] floatValue]?:0;
    float hei = 0.4 *[EUtility screenHeight];
    float y = [[info objectForKey:@"y"] floatValue]?:[EUtility screenHeight] -hei ;
    float width = [[info objectForKey:@"width"] floatValue]?:[EUtility screenWidth];
    float height = [[info objectForKey:@"height"] floatValue]?:hei;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(x, y, width, height)];
    view.backgroundColor = [EUtility ColorFromString:@"#FCFCFC"];
    UIButton *btn = [UIButton buttonWithType:0];
    btn.frame = CGRectMake(width-50, 10, 50, 20);
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[EUtility ColorFromString:@"#1874CD"]forState:UIControlStateNormal];
     UIButton *btn2 = [UIButton buttonWithType:0];
    btn2.frame = CGRectMake(0, 10, 50, 20);
    [btn2 setTitle:@"取消" forState:UIControlStateNormal];
    [btn2 setTitleColor:[EUtility ColorFromString:@"#1874CD"]forState:UIControlStateNormal];
    self.btn1 = [UIButton buttonWithType:0];
    self.btn1.frame = CGRectMake(0, 0, [EUtility screenWidth], [EUtility screenHeight]);
    self.btn1.backgroundColor = [UIColor clearColor];
    
    notThird = YES;
    currentOpenStaus = YES;
    [view addSubview:btn2];
    [view addSubview:btn];
   
    NSString *path = [info objectForKey:@"src"];
    NSString * jsonFilePath = [EUtility getAbsPath:meBrwView path:path];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonFilePath];
    NSError *error = nil;
    NSArray *rootArr = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    for (int i = 0; i < rootArr.count; i++) {
        NSString *provinceName = rootArr[i][@"name"];
        [self.first addObject:provinceName];
        NSArray *citys = rootArr[i][@"sub"];
        NSMutableArray *second = [NSMutableArray array];
        for (NSDictionary *dic in citys) {
            [second addObject:dic[@"name"]];
        }
       self.citysDic[provinceName] = second;
    }
    
    for (NSDictionary *dic in rootArr) {
        NSArray *citys = dic[@"sub"];
        NSArray *areas = [NSArray array];
        for (NSDictionary *dic in citys) {
            NSString *city = dic[@"name"];
            areas = dic[@"sub"];
            if (areas == nil) {
                areas = @[@""];
            }else{
                isShow = YES;
            }
            self.areasDic[city] = areas;
        }
        if (isShow) {
            notThird = NO;
        }
    }
    
    self.selectProvince = self.first[[self.selectArr[0]intValue]];
    self.selectCity = self.second[[self.selectArr[1]intValue]];
    self.pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, width, height-40)];
    self.pickView.backgroundColor = [UIColor whiteColor];
    self.pickView.showsSelectionIndicator = YES;
    self.pickView.contentMode = UIViewContentModeScaleAspectFill;
    self.pickView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.pickView.dataSource = self;
    self.pickView.delegate = self;
    [self.pickView selectRow:[self.selectArr[0]intValue] inComponent:0 animated:YES];
    [self.pickView selectRow:[self.selectArr[1]intValue] inComponent:1 animated:YES];
    if (self.first.count <= [self.selectArr[0]intValue]) {
        [self.selectArr replaceObjectAtIndex:0 withObject:@(0)];
    }
    
    if (self.second.count <= [self.selectArr[1]intValue]) {
        [self.selectArr replaceObjectAtIndex:1 withObject:@(0)];
    }
    if (self.selectArr.count == 3) {
        if (self.thrid.count <= [self.selectArr[2]intValue]) {
            [self.selectArr replaceObjectAtIndex:2 withObject:@(0)];
        }
        self.selectArea = self.thrid[[self.selectArr[2]intValue]];
        
        if (!notThird) {
            [self.pickView selectRow:[self.selectArr[2]intValue] inComponent:2 animated:YES];
        }
        
    }
    [view addSubview:self.pickView];
    [self.btn1 addSubview:view];
    [btn addTarget:self action:@selector(choose) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn1 addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];

    [[UIApplication sharedApplication].keyWindow addSubview:self.btn1];

    
    

}
-(void)close:(NSMutableArray*)inArguments{
    currentOpenStaus = NO;
    self.first = nil;
    self.second = nil;
    self.thrid = nil;
    [self.citysDic removeAllObjects];
    [self.areasDic removeAllObjects];
    self.citysDic = nil;
    self.areasDic = nil;
    self.selectArea = nil;
    [self.btn1 removeFromSuperview];
     //self.pickView = nil;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (notThird) {
        return 2;
    }else{
        return 3;
    }
    
    
    
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) {
        return self.first.count;
    }else if(component==1){
        return self.second.count;
    }else{
        return self.thrid.count;
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component==0) {
        return self.first[row];
    }else if(component==1){
        return self.second[row];
    }else{
        if (!notThird) {
            return self.thrid[row];
        }
        return nil;
        
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [pickerView reloadAllComponents];
    
    if (component == 0) {
        NSString *selectedProvinceName = self.first[row];
        self.selectProvince = selectedProvinceName;
        self.second = [self.citysDic valueForKey:selectedProvinceName];
        self.selectCity = self.second[0];
        self.thrid = [self.areasDic valueForKey:self.selectCity];
        self.selectArea = self.thrid[0];
        [pickerView reloadAllComponents];
       [pickerView selectRow:0 inComponent:1 animated:YES];
        if (!notThird) {
            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
       
    }
    if (component == 1) {
        NSString *selectedCityName = self.second[row];
        self.thrid = [self.areasDic valueForKey:selectedCityName];
        if (self.selectProvince == nil) {
            self.selectProvince = self.first[[self.selectArr[0]intValue]];
        }
        self.selectCity = selectedCityName;
        self.selectArea = self.thrid[0];
        [pickerView reloadAllComponents];
        if (!notThird) {
             [pickerView selectRow:0 inComponent:2 animated:YES];
        }
       
    }
    if (!notThird) {
        if (component == 2) {
            if (self.selectProvince == nil) {
                self.selectProvince = self.first[[self.selectArr[0]intValue]];
            }
            if (self.selectCity == nil) {
                self.selectCity = self.second[[self.selectArr[1]intValue]];
            }
            self.selectArea = self.thrid[row];
        }

    }
    

}
-(void)choose{
    
     NSArray *fir = self.first;
    NSArray *sec = [self.citysDic objectForKey:self.selectProvince];
    NSArray *thr = [self.areasDic objectForKey:self.selectCity];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *dataArr = [NSArray array];
    NSArray *indexArr = [NSArray array];
    if ([self.selectArea isEqualToString:@""] || self.selectArea == nil) {
        dataArr = @[self.selectProvince,self.selectCity];
        indexArr = @[@([fir indexOfObject:self.selectProvince]),@([sec indexOfObject:self.selectCity])];
    }else{
        dataArr = @[self.selectProvince,self.selectCity,self.selectArea];
        indexArr = @[@([fir indexOfObject:self.selectProvince]),@([sec indexOfObject:self.selectCity]),@([thr indexOfObject:self.selectArea])];
    }
    dic[@"data"] = dataArr;
    dic[@"index"] = indexArr;
    NSString *results = [dic JSONFragment];
    NSString *jsString = [NSString stringWithFormat:@"if(uexWheelPickView.onConfirmClick){uexWheelPickView.onConfirmClick('%@');}",results];
    [EUtility brwView:self.meBrwView evaluateScript:jsString];
    [self close:nil];
}
@end
