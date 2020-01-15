//
//  CoustomView.h
//  buyer
//
//  Created by Jonson on 2020/1/14.
//  Copyright © 2020 Jonson
//

#import <UIKit/UIKit.h>
#import <React/RCTViewManager.h>
NS_ASSUME_NONNULL_BEGIN

@interface CoustomView : UIImageView

@property(nonatomic,copy) NSString *imageUrl; //图片路径
@property (nonatomic, copy)RCTBubblingEventBlock onClick;//点击事件
@end

NS_ASSUME_NONNULL_END
