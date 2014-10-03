//
//  DMTabBar.m
//  DMTabBar - XCode like Segmented Control
//
//  Created by Daniele Margutti on 6/18/12.
//  Copyright (c) 2012 Daniele Margutti (http://www.danielemargutti.com - daniele.margutti@gmail.com).
//  All rights reserved.
//  Licensed under MIT License

#import "DMTabBar.h"
#import "MTExtensions.h"

// Default tabBar item width
#define kDMTabBarItemWidth 47.0f

@interface DMTabBar()
{
    DMTabBarEventsHandler _selectionHandler;
}

// Relayout button items
- (void)layoutSubviews;
// Remove all loaded button items
- (void)removeAllTabBarItems;
// Handle click on a single item (change selection, post event to the handler)
- (void)selectTabBarItem:(id)sender;

@end

@implementation DMTabBar

@synthesize selectedTabBarItem = _selectedTabBarItem;
@synthesize tabBarItems = _tabBarItems;

- (id)initWithFrame:(NSRect)frameRect
{
    if (self = [super initWithFrame:frameRect])
    {
        [self setDefaultColors];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setDefaultColors];
    }
    return self;
}

- (void)setDefaultColors
{
    self.drawTopShadow = (!RUNNING_ON_YOSEMITE_OR_HIGHER);
    self.drawGradient = (!RUNNING_ON_YOSEMITE_OR_HIGHER);
    if (RUNNING_ON_YOSEMITE_OR_HIGHER)
        self.backgroundColor = [NSColor colorWithDeviceWhite:0.96 alpha:1.0];

    self.drawUpperBorder = NO;
    self.drawLowerBorder = YES;
}

- (BOOL)isFlipped
{
    return YES;
}

- (void)dealloc
{
    [self removeAllTabBarItems];
}


#pragma mark -
#pragma mark Selection

- (void)handleTabBarItemSelection:(DMTabBarEventsHandler)newSelectionHandler
{
    _selectionHandler = newSelectionHandler;
}

- (void)selectTabBarItem:(id)sender
{
    __block NSUInteger itemIndex = NSNotFound;
    [self.tabBarItems enumerateObjectsUsingBlock:^(DMTabBarItem *tabBarItem, NSUInteger idx, BOOL *stop)
    {
        if (sender == tabBarItem.tabBarItemButton)
        {
            itemIndex = idx;
            *stop = YES;
        }
    }];
    if (itemIndex == NSNotFound) return;
    
    DMTabBarItem *tabBarItem = [self.tabBarItems objectAtIndex:itemIndex];
    _selectionHandler(DMTabBarItemSelectionType_WillSelect, tabBarItem, itemIndex);
    
    self.selectedTabBarItem = tabBarItem;
    _selectionHandler(DMTabBarItemSelectionType_DidSelect, tabBarItem, itemIndex);
}

- (DMTabBarItem *)selectedTabBarItem
{
    return _selectedTabBarItem;
}

- (void)setSelectedTabBarItem:(DMTabBarItem *)newSelectedTabBarItem
{
    if (![self.tabBarItems containsObject:newSelectedTabBarItem])
        return;
    
    NSUInteger selectedItemIndex = [self.tabBarItems indexOfObject:newSelectedTabBarItem];
    _selectedTabBarItem = newSelectedTabBarItem;
    
    __block NSUInteger buttonIndex = 0;
    [self.tabBarItems enumerateObjectsUsingBlock:^(DMTabBarItem *tabBarItem, NSUInteger idx, BOOL *stop)
    {
        tabBarItem.state = (buttonIndex == selectedItemIndex ? NSOnState : NSOffState);
        ++buttonIndex;
    }];
}

- (NSUInteger)selectedIndex
{
    return [self.tabBarItems indexOfObject:self.selectedTabBarItem];
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex
{
    if (newSelectedIndex != self.selectedIndex &&
        newSelectedIndex < [self.tabBarItems count])
    {
        self.selectedTabBarItem = [self.tabBarItems objectAtIndex:newSelectedIndex];
    }
}


#pragma mark -
#pragma mark Layout Subviews

- (void)resizeSubviewsWithOldSize:(NSSize)oldSize
{
    [super resizeSubviewsWithOldSize:oldSize];
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    // Centered layout:
    // NSUInteger buttonsNumber = [self.tabBarItems count];
    // CGFloat totalWidth = (buttonsNumber * kDMTabBarItemWidth);
    // __block CGFloat offset_x = floorf((NSWidth(self.bounds) - totalWidth) / 2.0f);
    
    // Left aligned layout:
    __block CGFloat offset_x = 2.0;
    
    [self.tabBarItems enumerateObjectsUsingBlock:^(DMTabBarItem *tabBarItem, NSUInteger idx, BOOL *stop)
    {
        tabBarItem.tabBarItemButton.frame = NSMakeRect(offset_x, NSMinY(self.bounds), kDMTabBarItemWidth, NSHeight(self.bounds));
        offset_x += kDMTabBarItemWidth;
    }];
}


#pragma mark -
#pragma mark Items

- (NSArray *)tabBarItems
{
    return _tabBarItems;
}

- (void)setTabBarItems:(NSArray *)newTabBarItems
{
    if (newTabBarItems != _tabBarItems)
    {
        [self removeAllTabBarItems];
        _tabBarItems = newTabBarItems;
        
        NSUInteger selectedItemIndex = [self.tabBarItems indexOfObject:self.selectedTabBarItem];
        NSUInteger itemIndex = 0;
        [self.tabBarItems enumerateObjectsUsingBlock:^(DMTabBarItem *tabBarItem, NSUInteger idx, BOOL *stop)
        {
            NSButton *itemButton = tabBarItem.tabBarItemButton;
            itemButton.frame = NSMakeRect(0.0f, 0.0f, kDMTabBarItemWidth, NSHeight(self.bounds));
            itemButton.state = (itemIndex == selectedItemIndex ? NSOnState : NSOffState);
            itemButton.action = @selector(selectTabBarItem:);
            itemButton.target = self;
            [self addSubview:itemButton];
        }];
        
        [self layoutSubviews];
        
        if (![self.tabBarItems containsObject:self.selectedTabBarItem])
            self.selectedTabBarItem = ([self.tabBarItems count] > 0 ? [self.tabBarItems objectAtIndex:0] : nil);
    }
}

- (void)removeAllTabBarItems
{
    [self.tabBarItems enumerateObjectsUsingBlock:^(DMTabBarItem *tabBarItem, NSUInteger idx, BOOL *stop)
     {
         [tabBarItem.tabBarItemButton removeFromSuperview];
     }];
    
    _tabBarItems = nil;
    _selectedTabBarItem = nil;
}



@end
