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
@property (nonatomic, strong) UIView *subMenusView;

@property (nonatomic, strong) UILabel *menuLabel;
@property (nonatomic, strong) UILabel *menuLabelBack;
@property (nonatomic, strong) NSArray *subMenus;
@property (nonatomic, assign) BOOL isFrontsideShown;
@end


@implementation RGFlipMenuView {
    BOOL isSubMenu;
}

#define kRGAnimationDuration 0.4f

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
        
        isSubMenu = theSubMenuFlag;
        self.subMenus = theSubMenus;
        self.isFrontsideShown = YES;
        self.actionBlock = theActionBlock;
        
        self.menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [RGFlipMenuView mainMenuWidth], [RGFlipMenuView mainMenuHeight])];
        [self.menuLabel setText:theMenuText];
        [self.menuLabel setFont:[UIFont preferredFontForTextStyle:isSubMenu ? UIFontTextStyleSubheadline : UIFontTextStyleHeadline]];
        [self.menuLabel setTextAlignment:NSTextAlignmentCenter];
        [self.menuLabel setTextColor:[UIColor darkGrayColor]];
        [self.menuLabel setNumberOfLines:3];

        self.mainMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [RGFlipMenuView mainMenuWidth], [RGFlipMenuView mainMenuHeight])];
        self.mainMenuView.center = self.middlePoint;
        [self.mainMenuView setBackgroundColor:kRGMainMenuColor];
        [self.mainMenuView addSubview:self.menuLabel];
        [self addSubview:self.mainMenuView];
        
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
            [self.subMenusView setHidden:YES];
            self.subMenusView.layer.transform = CATransform3DMakeScale(0.2, 0.2, 1);
            [self addSubview:self.subMenusView];
            
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
            self.mainMenuView.frame = CGRectMake(0, 0, [RGFlipMenuView subMenuWidth], [RGFlipMenuView subMenuHeight]);
            self.menuLabel.frame = self.mainMenuView.frame;
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

- (void)didTapMenu {
    
    self.actionBlock();
    
    if (!isSubMenu) {
        
        BOOL isLandscape = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);

        // move the main menu over; duration twice the 90º rotations
        [UIView animateWithDuration:kRGAnimationDuration*2 delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            if (!self.isFrontsideShown)
                [self.mainMenuView setCenter:self.middlePoint];
            
            else {
                if (isLandscape)
                    [self.mainMenuView setCenter:CGPointMake(self.mainMenuView.center.x - [RGFlipMenuView mainMenuOffset], self.mainMenuView.center.y)];
                else
                    [self.mainMenuView setCenter:CGPointMake(self.mainMenuView.center.x, self.mainMenuView.center.y - [RGFlipMenuView mainMenuOffset])];
            }
            
        } completion:^(BOOL finished) {

        }];
        
        
        if (self.isFrontsideShown)
            [self.subMenusView setHidden:NO];

        // rotate main menu
        [UIView animateWithDuration:kRGAnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            // rotate 90º; axis depends on device orientation
//            [self.mainMenuView.layer setAnchorPoint:CGPointMake(0, 0.5)];
            [self.mainMenuView.layer setTransform:CATransform3DConcat(CATransform3DMakeScale(0.8f, 0.8f, 1.0f), CATransform3DMakeRotation(M_PI_2, isLandscape ? 0.f : 1.f, isLandscape ? 1.f : 0.f, 0.f))];

        } completion:^(BOOL finished) {
            
            // then rotate 90º again, but also show sub menus
            [self toggleStatus];
            
            [UIView animateWithDuration:kRGAnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseOut  animations:^{

                // finish rotation of main menu
                [self.mainMenuView.layer setTransform:CATransform3DConcat(CATransform3DMakeScale(0.7f, 0.7f, 1.0f), CATransform3DMakeRotation(self.isFrontsideShown ? 0 : M_PI, isLandscape ? 0. : 1., isLandscape ? 1. : 0., 0.))];
                // for the back menu label: set rotation to 180
                [self.menuLabelBack.layer setTransform:CATransform3DMakeRotation(M_PI, isLandscape ? 0. : 1., isLandscape ? 1. : 0., 0.)];
    

                if (!self.isFrontsideShown) {
                    
                    // step 1: pop out submenus
                    self.subMenusView.layer.transform = CATransform3DIdentity;
                    NSUInteger subMenuIndex = 0;
                    for (RGFlipMenuView *subMenuView in self.subMenus) {
                        if (isLandscape)
                            [subMenuView setCenter:CGPointMake(subMenuView.center.x + subMenuIndex*[RGFlipMenuView subMenuOffset] - [RGFlipMenuView subMenuAllOffset], self.subMenusView.middleY)];
                        else
                            [subMenuView setCenter:CGPointMake(self.subMenusView.middleX, subMenuView.center.y + subMenuIndex*[RGFlipMenuView subMenuOffset] - [RGFlipMenuView subMenuAllOffset])];
                        
                        subMenuIndex++;
                    }
                    
                } else {
                    
                    // step 2: move back submenus
                    [self.mainMenuView.layer setTransform:CATransform3DIdentity];
                    self.subMenusView.layer.transform = CATransform3DMakeScale(0.2, 0.2, 1);
                    
                    for (RGFlipMenuView *subMenuView in self.subMenus) {
                        NSAssert([subMenuView isKindOfClass:[RGFlipMenuView class]], @"inconsistent");
                        subMenuView.center = self.middlePoint;
                    }
                    
                }

            } completion:^(BOOL finished) {
                if (self.isFrontsideShown)
                    [self.subMenusView setHidden:YES];
            }];
            
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
        return 30;
}

+ (CGFloat)subMenuOffset {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 150;
    else
        return 100;
}

+ (CGFloat)mainMenuWidth {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 180;
    else
        return 120;
}

+ (CGFloat)mainMenuHeight {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 180;
    else
        return 120;
}

+ (CGFloat)subMenuWidth {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 140;
    else
        return 90;
}

+ (CGFloat)subMenuHeight {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 140;
    else
        return 90;
}


+ (CGFloat)mainMenuOffset {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 250;
    else
        return 150;
}


@end
