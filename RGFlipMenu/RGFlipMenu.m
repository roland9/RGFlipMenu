//
//  RGFlipMenu.m
//  RGFlipMenu
//
//  Created by RolandG on 05/03/2014.
//  Copyright (c) 2014 mapps. All rights reserved.
//

#import "RGFlipMenu.h"
#import "RGFlipSubMenuView.h"


@interface RGFlipMenu()
@end


@implementation RGFlipMenu

- (void)changeMenuText:(NSString *)theMenuText {
    self.menuText = theMenuText;
    // better would be: tie the menuLabel in the menuView to the menuText in the model object - via KVO?
    [((RGFlipSubMenuView *)self.menuView) changeMenuText:theMenuText];
}


- (id)initWithText:(NSString *)theMenuText actionBlock:(RGFlipMenuActionBlock)theActionBlock subMenus:(NSArray *)theSubMenus {
    self = [super init];
    if (self) {
        _menuText = theMenuText;
        _actionBlock = theActionBlock;
        _subMenus = theSubMenus;
        _isMenuClosed = YES;
        _selectedSubMenuIndex = NSUIntegerMax;
    }
    return self;
}


- (id)initWithText:(NSString *)theMenuText actionBlock:(RGFlipMenuActionBlock)theActionBlock {
    return [self initWithText:theMenuText actionBlock:theActionBlock subMenus:NULL];
}

@end

