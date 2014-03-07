//
//  RGFlipSubMenuView.h
//  RGFlipMenu
//
//  Created by RolandG on 05/03/2014.
//  Copyright (c) 2014 mapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RGFlipMenu.h"
#import "RGFlipMenuView.h"


@interface RGFlipSubMenuView : UIView

- (id)initWithFrame:(CGRect)frame text:(NSString *)theMenuText actionBlock:(RGFlipMenuActionBlock)theActionBlock delegate:(id<RGFlipMenuDelegate>)theDelegate;

@end
