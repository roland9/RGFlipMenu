//
//  RGFlipMenuView.m
//  RGFlipMenuView
//
//  Created by RolandG on 17/11/2013.
//  Copyright (c) 2013 FM. All rights reserved.
//

#import "RGFlipMenuView.h"
#import <FrameAccessor.h>


@interface RGFlipMenuView ()
@property (copy) void (^actionBlock) (void);
@property (nonatomic, strong) UIView *mainMenuView;
@property (nonatomic, strong) UIView *mainMenuWrapperView;
@property (nonatomic, strong) UIView *subMenusView;

@property (nonatomic, strong) UILabel *menuLabel;
@property (nonatomic, strong) UILabel *menuLabelBack;
@property (nonatomic, strong) NSArray *subMenus;
@property (nonatomic, assign) BOOL isFrontsideShown;
@end


@implementation RGFlipMenuView {
    BOOL isSubMenu;
}

#define kRGMainMenuColor    [UIColor yellowColor]
#define kRGSubMenuColor     [UIColor greenColor]

////////////////////////////////////////////////////////////////////
# pragma mark - Public methods

-(void)popToRoot {
    NSAssert(!isSubMenu, @"switch to root only allowed for main/root menu, not the sub menus");
    if (!self.isFrontsideShown) {
        [self didTapMenu];
    }
}


- (void)changeText:(NSString *)theText {
    self.menuLabel.text = theText;
}


- (NSString *)menuText {
    return self.menuLabel.text;
}


////////////////////////////////////////////////////////////////////
# pragma mark - public initializers and factories

+ (id)subMenuWithText:(NSString *)theMenuText actionBlock:(void (^)(void))theActionBlock {
    NSAssert(theMenuText, @"menuText is mandatory");
    NSAssert(theActionBlock, @"actionBlock block is mandatory");
    
    RGFlipMenuView *menu = [[RGFlipMenuView alloc] initWithFrame:CGRectMake(0, 0, [self subMenuWidth], [self subMenuHeight]) text:theMenuText actionBlock:theActionBlock subMenus:NULL isSubMenu:YES];
    return menu;
}


- (id)initWithFrame:(CGRect)theFrame text:(NSString *)menuText actionBlock:(void (^)(void))theActionBlock subMenus:(NSArray *)theSubMenus {
    self = [self initWithFrame:theFrame text:menuText actionBlock:theActionBlock subMenus:theSubMenus isSubMenu:NO];
    return self;
}


////////////////////////////////////////////////////////////////////
# pragma mark - designated initializer

- (id)initWithFrame:(CGRect)theFrame text:(NSString *)theMenuText actionBlock:(void (^)(void))theActionBlock subMenus:(NSArray *)theSubMenus isSubMenu:(BOOL)theSubMenuFlag {
    self = [super initWithFrame:theFrame];
    if (self) {
        
//        self.backgroundColor = [UIColor lightGrayColor];
        
        isSubMenu = theSubMenuFlag;
        self.subMenus = theSubMenus;
        self.isFrontsideShown = YES;
        self.actionBlock = theActionBlock;

        if (isSubMenu) {
            self.menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [RGFlipMenuView subMenuWidth], [RGFlipMenuView subMenuHeight])];
            self.mainMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [RGFlipMenuView subMenuWidth], [RGFlipMenuView subMenuHeight])];
        } else {
            self.menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [RGFlipMenuView mainMenuWidth], [RGFlipMenuView mainMenuHeight])];
            self.mainMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [RGFlipMenuView mainMenuWidth], [RGFlipMenuView mainMenuHeight])];
        }
        
        
        [self.menuLabel setText:theMenuText];
        [self.menuLabel setFont:[UIFont preferredFontForTextStyle:isSubMenu ? UIFontTextStyleSubheadline : UIFontTextStyleHeadline]];
        [self.menuLabel setTextAlignment:NSTextAlignmentCenter];
        [self.menuLabel setTextColor:[UIColor darkGrayColor]];
        [self.menuLabel setNumberOfLines:3];

        // the mainMenuWrapperView is required so that the main Menu move animation is consistent
        self.mainMenuWrapperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [RGFlipMenuView mainMenuWidth], [RGFlipMenuView mainMenuHeight])];
        self.mainMenuWrapperView.center = self.middlePoint;
        [self addSubview:self.mainMenuWrapperView];


        self.mainMenuView.center = self.mainMenuWrapperView.middlePoint;
        [self.mainMenuView setBackgroundColor:kRGMainMenuColor];
        [self.mainMenuView addSubview:self.menuLabel];
        [self.mainMenuWrapperView addSubview:self.mainMenuView];
        
        // for main menu: create backside view & submenu view with the menu items
        if (!isSubMenu) {
            self.menuLabelBack = [[UILabel alloc] initWithFrame:self.menuLabel.frame];
            [self.menuLabelBack setText:@"Back"];
            [self.menuLabelBack setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
            [self.menuLabelBack setTextAlignment:NSTextAlignmentCenter];
            [self.menuLabelBack setTextColor:[UIColor darkGrayColor]];
            [self.menuLabelBack setNumberOfLines:3];
            [self.menuLabelBack setHidden:YES];
            [self.mainMenuView addSubview:self.menuLabelBack];

            self.subMenusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
//            [self.subMenusView setBackgroundColor:[UIColor orangeColor]];
            
            [self.subMenusView setHidden:YES];
            self.subMenusView.layer.transform = CATransform3DMakeScale(0.2, 0.2, 1);
            [self insertSubview:self.subMenusView belowSubview:self.mainMenuWrapperView];
            
            NSUInteger subMenuIndex = 0;
            for (RGFlipMenuView *subMenuView in theSubMenus) {
                NSAssert([subMenuView isKindOfClass:[RGFlipMenuView class]], @"expected instance RGMenuView class in backsideMenu array");
                
                [subMenuView setFrame:CGRectMake(0, 0, [RGFlipMenuView subMenuWidth], [RGFlipMenuView subMenuHeight])];
                subMenuView.center = self.middlePoint;
                [self.subMenusView addSubview:subMenuView];
                subMenuIndex ++;
            }
            
        } else {
            // inception: we are the submenu
            [self.mainMenuView setBackgroundColor:kRGSubMenuColor];
        }
        
        [self setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapMenu)];
        [self.mainMenuView addGestureRecognizer:tap];

        [self bringSubviewToFront:self.mainMenuView];
    }
    return self;
}


////////////////////////////////////////////////////////////////////
# pragma mark - Private

#define kRGAnimationDuration 0.4f


- (void)didTapMenu {
    
    self.actionBlock();
    
    if (!isSubMenu) {
        
        BOOL isLandscape = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);

        // move the main menu ...
        [UIView animateWithDuration:kRGAnimationDuration animations:^{
            if (self.isFrontsideShown) {
                [self toggleStatus];
                if (isLandscape)
                    [self.mainMenuWrapperView setCenter:CGPointMake(self.mainMenuWrapperView.center.x - [RGFlipMenuView mainMenuOffset], self.mainMenuWrapperView.center.y)];
                else
                    [self.mainMenuWrapperView setCenter:CGPointMake(self.mainMenuWrapperView.center.x, self.mainMenuWrapperView.center.y - [RGFlipMenuView mainMenuOffset]) ];
                
                // make the main menu a bit smaller
                [self.mainMenuView.layer setTransform:CATransform3DMakeScale(0.8, 0.8, 1)];
                
            } else {
                [self toggleStatus];
                [self.mainMenuWrapperView setCenter:self.middlePoint];
            }

        } completion:^(BOOL finished) {

        }];
        
        // ... and flip
        [UIView transitionWithView:self.mainMenuView
                          duration:kRGAnimationDuration
                           options:(isLandscape ?
                                    (self.isFrontsideShown ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight) :
                                    (self.isFrontsideShown ? UIViewAnimationOptionTransitionFlipFromBottom : UIViewAnimationOptionTransitionFlipFromTop)
                                    ) | UIViewAnimationOptionAllowAnimatedContent
                        animations:^{
                        } completion:NULL];
        
        
        // will be hidden again in completion block (so we see the animation)
        if (!self.isFrontsideShown)
            [self.subMenusView setHidden:NO];

        
        [UIView animateWithDuration:kRGAnimationDuration animations:^{
            
            // at this point in time, we have already toggled the frontside flag
            if (!self.isFrontsideShown) {
                
                // open menu: pop out submenus
                self.subMenusView.layer.transform = CATransform3DIdentity;
                NSUInteger subMenuIndex = 0;
                for (RGFlipMenuView *subMenuView in self.subMenus) {
                    if (isLandscape)
                        [subMenuView setCenter:CGPointMake(subMenuView.center.x + subMenuIndex*[RGFlipMenuView subMenuOffset] - [RGFlipMenuView subMenuAllOffset], self.subMenusView.middleY)];
                    else
                        [subMenuView setCenter:CGPointMake(subMenuView.superview.centerX, subMenuView.superview.centerY + subMenuIndex*[RGFlipMenuView subMenuOffset] - [RGFlipMenuView subMenuAllOffset])];
                    
                    subMenuIndex++;
                }
                
            } else {
                
                // close menu: move back submenus
                self.subMenusView.layer.transform = CATransform3DMakeScale(0.2, 0.2, 1);
                
                for (RGFlipMenuView *subMenuView in self.subMenus) {
                    NSAssert([subMenuView isKindOfClass:[RGFlipMenuView class]], @"inconsistent");
                    subMenuView.center = self.middlePoint;
                }
                
                // restore the original size of the main menu
                [self.mainMenuView.layer setTransform:CATransform3DIdentity];
                
            }
        } completion:^(BOOL finished) {
            if (self.isFrontsideShown) {
                [self.subMenusView setHidden:YES];
            }
        }];
        

    }
}


- (void)toggleStatus {
    self.isFrontsideShown = !self.isFrontsideShown;
    [self.menuLabel setHidden:!self.isFrontsideShown];
    [self.menuLabelBack setHidden:self.isFrontsideShown];
}


+ (CGFloat)subMenuAllOffset {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 50;
    else
        return 60;
}

+ (CGFloat)subMenuOffset {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 180;
    else
        return 120;
}

+ (CGFloat)mainMenuWidth {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 180;
    else
        return 120;
}

+ (CGFloat)mainMenuHeight {
    return [RGFlipMenuView mainMenuWidth];
}

+ (CGFloat)subMenuWidth {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 160;
    else
        return 110;
}

+ (CGFloat)subMenuHeight {
    return [RGFlipMenuView subMenuWidth];
}


+ (CGFloat)mainMenuOffset {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 250;
    else
        return 180;
}


@end
