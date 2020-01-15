//
//  SignWithApple.m
//  buyer
//
//  Created by Jonson on 2020/1/14.
//  Copyright © 2020 Jonson
//

#import "SignWithApple.h"
#import "SignWithAppleHelper.h"
#import "CoustomView.h"

@interface SignWithApple()
@property(nonatomic,copy)CoustomView  *imageView;

@end


@implementation SignWithApple

RCT_EXPORT_MODULE();
-(UIView *) view{
  
  _imageView = [[CoustomView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  return self.imageView;
}

RCT_EXPORT_VIEW_PROPERTY(imageUrl, NSString)
RCT_EXPORT_VIEW_PROPERTY(onClick, RCTBubblingEventBlock)



@end
