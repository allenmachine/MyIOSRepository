//
//  ViewController.h
//  ZHanmburgerSlider
//
//  Created by Allen Lee I on 12/16/14.
//  Copyright (c) 2014 Allen Lee I. All rights reserved.
//

#import <UIKit/UIKit.h>

enum ZHamburgerMode
{
    SLIDETOP,
    SLIDEBOTTOM
};

@interface ZHamburgerSliderViewController : UIViewController

-(void)configureViewWithSlideMode:(enum ZHamburgerMode)mode menuView:(id)menuViewController moduleView:(id)moduleViewController;

-(void)moveSliderToLeft;
-(void)moveSliderToRight;

@end

