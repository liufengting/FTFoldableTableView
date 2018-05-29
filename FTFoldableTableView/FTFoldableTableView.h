//
//  FTFoldableTableView.h
//  Demo
//
//  Created by liufengting on 2018/5/29.
//  Copyright © 2018年 liufengting. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FTSectionState) {
    FTSectionStateFold,
    FTSectionStateExpand,
};

@class FTFoldableTableView;
@class FTFoldableSectionHeader;

@protocol FTFoldableTableViewDataSource <NSObject>

- (NSInteger)numberOfSectionsInFoldableTableView:(FTFoldableTableView *)tableView;

- (NSInteger)foldableTableView:(FTFoldableTableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)foldableTableView:(FTFoldableTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol FTFoldableTableViewDelegate <NSObject>

- (CGFloat)foldableTableView:(FTFoldableTableView *)tableView heightForHeaderInSection:(NSInteger)section;

- (FTFoldableSectionHeader *)foldableTableView:(FTFoldableTableView *)tableView viewForHeaderInSection:(NSInteger)section;

@optional

- (CGFloat)foldableTableView:(FTFoldableTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)foldableTableView:(FTFoldableTableView *)tableView willChangeToSectionState:(FTSectionState)sectionState section:(NSInteger)section;

- (void)foldableTableView:(FTFoldableTableView *)tableView didChangeToSectionState:(FTSectionState)sectionState section:(NSInteger)section;

- (void)foldableTableView:(FTFoldableTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol FTFoldableSectionHeaderDelegate <NSObject>

- (void)foldableSectionHeader:(FTFoldableSectionHeader *)sectionHeader didTapAtIndex:(NSInteger)index;

@end

@interface FTFoldableTableView : UITableView <UITableViewDataSource, UITableViewDelegate, FTFoldableSectionHeaderDelegate>

@property (nonatomic, weak) IBOutlet id<FTFoldableTableViewDataSource> foldingDataSource;
@property (nonatomic, weak) IBOutlet id<FTFoldableTableViewDelegate> foldingDelegate;

- (FTSectionState)foldStateForSection:(NSInteger)section;

- (void)expandSection:(NSInteger)section;

- (void)foldSection:(NSInteger)section;

- (void)expandAllSections;

- (void)foldAllSections;

@end

@interface FTFoldableSectionHeader : UIView

- (void)setupWithSection:(NSInteger )section tapDelegate:(id<FTFoldableSectionHeaderDelegate>)tapDelegate;

@end
