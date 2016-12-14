//
//  EUExWheelPickView.h
//  EUExWheelPickView
//
//  Created by 杨广 on 16/4/20.
//  Copyright © 2016年 杨广. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AppCanKit/AppCanKit.h>
@interface EUExWheelPickView :EUExBase<UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,strong)UIPickerView *pickView;
@property(nonatomic,strong)NSMutableArray *first;
@property(nonatomic,strong)NSMutableDictionary *citysDic;
@property(nonatomic,strong)NSMutableDictionary *areasDic;
@property(nonatomic,strong)NSMutableArray *selectArr;
@property(nonatomic,strong)NSArray *second;
@property(nonatomic,strong)NSArray *thrid;
@property(nonatomic,strong)NSString *selectProvince;
@property(nonatomic,strong)NSString *selectCity;
@property(nonatomic,strong)NSString *selectArea;
@property(nonatomic,strong)UIToolbar *toolBar;
@property(nonatomic,strong)UIButton *btn1;
@end
