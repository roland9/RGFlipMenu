//
//  RGFlipMainMenuView.h
//  RGFlipMenu
//
//  Created by RolandG on 06/03/2014.
//  Copyright (c) 2014 mapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RGFlipMenuView.h"

@interface RGFlipMainMenuView : UIView

@property (nonatomic, strong) UIView *mainMenuWrapperView;
@property (nonatomic, strong) UIView *mainMenuView;
@property (nonatomic, strong) UILabel *menuLabel;
@property (nonatomic, strong) UILabel *menuLabelBack;
@property (nonatomic, strong) UIView *subMenusView;

- (id)initWithFrame:(CGRect)frame text:(NSString *)theMenuText subMenus:(NSArray *)theSubMenus delegate:(id<RGFlipMenuDelegate>)delegate;

@end
