//
//  RGFlipMainMenuView.m
//  RGFlipMenu
//
//  Created by RolandG on 06/03/2014.
//  Copyright (c) 2014 mapps. All rights reserved.
//

#import "RGFlipMainMenuView.h"
#import "RGFlipSubMenuView.h"
#import "RGFlipMenuView.h"
#import "RGFlipMenu.h"
#import <FrameAccessor.h>


CGRect subMenuRect(NSUInteger maxCount) {
    CGFloat factor = maxCount < 5 ? 1.f : 6.f/maxCount;
    CGFloat width = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 160*factor : 110*factor;
    return CGRectMake(0, 0, width, width);
}


@interface RGFlipMainMenuView ()

@property (nonatomic, weak) id<RGFlipMenuDelegate> delegate;

@end


@implementation RGFlipMainMenuView

- (id)initWithFrame:(CGRect)frame text:(NSString *)theMenuText subMenus:(NSArray *)theSubMenus delegate:(id)theDelegate {
    NSParameterAssert(theMenuText);
    NSParameterAssert(theSubMenus);
    NSParameterAssert(theDelegate);
    
    self = [super initWithFrame:frame];
    if (self) {
    
        _delegate = theDelegate;
        
        // the mainMenuWrapperView is required so that the main Menu move animation is consistent together with the flipping transition
        _mainMenuWrapperView = [[UIView alloc] initWithFrame:mainMenuRect()];
        _mainMenuWrapperView.backgroundColor = [UIColor greenColor];  // troubleshooting only
        [_mainMenuWrapperView setCenter:self.middlePoint];
        [self addSubview:_mainMenuWrapperView];

        _mainMenuView = [[UIView alloc] initWithFrame:mainMenuRect()];
        _mainMenuView.center = _mainMenuWrapperView.middlePoint;
        [_mainMenuView setBackgroundColor:kRGMainMenuColor];
        [_mainMenuView addSubview:_menuLabel];
        [_mainMenuWrapperView addSubview:_mainMenuView];
        
        _menuLabel = [[UILabel alloc] initWithFrame:frame];
        [_menuLabel setText:theMenuText];
        [_menuLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
        [_menuLabel setTextAlignment:NSTextAlignmentCenter];
        [_menuLabel setTextColor:[UIColor darkGrayColor]];
        [_menuLabel setNumberOfLines:3];
        [_mainMenuView addSubview:_menuLabel];

        // create backside view & submenu view with the menu items
        _menuLabelBack = [[UILabel alloc] initWithFrame:_menuLabel.frame];
        [_menuLabelBack setText:@"Back"];
        [_menuLabelBack setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
        [_menuLabelBack setTextAlignment:NSTextAlignmentCenter];
        [_menuLabelBack setTextColor:[UIColor darkGrayColor]];
        [_menuLabelBack setNumberOfLines:3];
        [_menuLabelBack setHidden:YES];
        [_mainMenuView addSubview:_menuLabelBack];
        
        _subMenusView = [[UIView alloc] initWithFrame:self.frame];
//            [_subMenusView setBackgroundColor:[UIColor orangeColor]];    // troubleshooting only
        [_subMenusView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        [self insertSubview:_subMenusView belowSubview:_mainMenuWrapperView];
        
        for (RGFlipMenu *subMenu in theSubMenus) {
            NSAssert([subMenu isKindOfClass:[RGFlipMenu class]], @"expected instance RGFlipMenu class in subMenu array");
            
            RGFlipSubMenuView *subMenuView = [[RGFlipSubMenuView alloc] initWithFrame:subMenuRect([theSubMenus count]) text:subMenu.menuText actionBlock:subMenu.actionBlock];
            [_subMenusView addSubview:subMenuView];
            subMenu.menuView = subMenuView;
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapMenu:)];
        [_mainMenuView addGestureRecognizer:tap];
        
        [self bringSubviewToFront:_mainMenuView];
    }
    return self;
}


- (void)didTapMenu:(id)sender {
    NSAssert([sender isKindOfClass:[UITapGestureRecognizer class]], @"inconsistent");
    
    [self.delegate didTapMenu:self];
}

@end
