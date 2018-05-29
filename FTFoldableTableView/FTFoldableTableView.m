//
//  FTFoldableTableView.m
//  Demo
//
//  Created by liufengting on 2018/5/29.
//  Copyright © 2018年 liufengting. All rights reserved.
//

#import "FTFoldableTableView.h"

@interface FTFoldableTableView ()

@property (nonatomic, strong) NSMutableArray<NSNumber *> *statusArray;

@end

@implementation FTFoldableTableView

#pragma mark - Initial Methods

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupDelegateAndDataSource];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDelegateAndDataSource];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupDelegateAndDataSource];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setupDelegateAndDataSource];
    }
    return self;
}

#pragma mark - Setup Methods

- (void)setupDelegateAndDataSource {
    self.delegate = self;
    self.dataSource = self;
    if (self.style == UITableViewStylePlain) {
        self.tableFooterView = [[UIView alloc] init];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onChangeStatusBarOrientationNotification:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (NSMutableArray *)statusArray {
    if (!_statusArray) {
        _statusArray = [NSMutableArray array];
    }
    if (_statusArray.count) {
        if (_statusArray.count > self.numberOfSections) {
            [_statusArray removeObjectsInRange:NSMakeRange(self.numberOfSections - 1, _statusArray.count - self.numberOfSections)];
        }else if (_statusArray.count < self.numberOfSections) {
            for (NSInteger i = self.numberOfSections - _statusArray.count; i < self.numberOfSections; i++) {
                [_statusArray addObject:[NSNumber numberWithInteger:FTSectionStateFold]];
            }
        }
    }else{
        for (NSInteger i = 0; i < self.numberOfSections; i++) {
            [_statusArray addObject:[NSNumber numberWithInteger:FTSectionStateFold]];
        }
    }
    return _statusArray;
}

- (void)onChangeStatusBarOrientationNotification:(NSNotification *)notification {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadData];
    });
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.foldingDataSource && [self.foldingDataSource respondsToSelector:@selector(numberOfSectionsInFoldableTableView:)]) {
        return [self.foldingDataSource numberOfSectionsInFoldableTableView:self];
    }else{
        return self.numberOfSections;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (((NSNumber *)self.statusArray[section]).integerValue == FTSectionStateExpand) {
        if (self.foldingDataSource && [self.foldingDataSource respondsToSelector:@selector(foldableTableView:numberOfRowsInSection:)]) {
            return [self.foldingDataSource foldableTableView:self numberOfRowsInSection:section];
        }
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.foldingDelegate && [self.foldingDelegate respondsToSelector:@selector(foldableTableView:heightForHeaderInSection:)]) {
        return [self.foldingDelegate foldableTableView:self heightForHeaderInSection:section];
    }else{
        return self.sectionHeaderHeight;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.foldingDelegate && [self.foldingDelegate respondsToSelector:@selector(foldableTableView:heightForRowAtIndexPath:)]) {
        return [self.foldingDelegate foldableTableView:self heightForRowAtIndexPath:indexPath];
    }else{
        return self.rowHeight;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.style == UITableViewStylePlain) {
        return 0.f;
    }else{
        return 0.01f;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.foldingDelegate && [self.foldingDelegate respondsToSelector:@selector(foldableTableView:viewForHeaderInSection:)]) {
        FTFoldableSectionHeader *header =  [self.foldingDelegate foldableTableView:self viewForHeaderInSection:section];
        [header setupWithSection:section tapDelegate:self];
        return header;
    }else{
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.foldingDataSource && [self.foldingDataSource respondsToSelector:@selector(foldableTableView:cellForRowAtIndexPath:)]) {
        return [self.foldingDataSource foldableTableView:self cellForRowAtIndexPath:indexPath];
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultCellIndentifier"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.foldingDelegate && [self.foldingDelegate respondsToSelector:@selector(foldableTableView:didSelectRowAtIndexPath:)]) {
        return [self.foldingDelegate foldableTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - FTFoldableSectionHeaderDelegate

- (void)foldableSectionHeader:(FTFoldableSectionHeader *)sectionHeader didTapAtIndex:(NSInteger)index {
    [self changeFoldStateForSection:index];
}

#pragma mark - change fold state for section

- (void)changeFoldStateForSection:(NSInteger)section {
    BOOL currentIsOpen = ((NSNumber *)self.statusArray[section]).boolValue;
    
    if (self.foldingDelegate && [self.foldingDelegate respondsToSelector:@selector(foldableTableView:willChangeToSectionState:section:)]) {
        [self.foldingDelegate foldableTableView:self
                       willChangeToSectionState:(currentIsOpen == YES) ? FTSectionStateFold : FTSectionStateExpand
                                        section:section];
    }
    
    [self.statusArray replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:!currentIsOpen]];
    
    NSInteger numberOfRow = [self.foldingDataSource foldableTableView:self numberOfRowsInSection:section];
    NSMutableArray *rowArray = [NSMutableArray array];
    if (numberOfRow) {
        for (NSInteger i = 0; i < numberOfRow; i++) {
            [rowArray addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        }
    }
    if (rowArray.count) {
        if (currentIsOpen) {
            [self deleteRowsAtIndexPaths:[NSArray arrayWithArray:rowArray] withRowAnimation:UITableViewRowAnimationTop];
        }else{
            [self insertRowsAtIndexPaths:[NSArray arrayWithArray:rowArray] withRowAnimation:UITableViewRowAnimationTop];
        }
    }
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(foldableTableView:didChangeToSectionState:section:)]) {
        [_foldingDelegate foldableTableView:self
                    didChangeToSectionState:(currentIsOpen == YES) ? FTSectionStateFold : FTSectionStateExpand
                                    section:section];
    }
}

#pragma mark - public methods

- (FTSectionState)foldStateForSection:(NSInteger)section {
    if (section <= self.statusArray.count - 1) {
        return ((NSNumber *)self.statusArray[section]).integerValue;
    }
    return FTSectionStateFold;
}

- (void)expandSection:(NSInteger)section {
    if ([self foldStateForSection:section] == FTSectionStateFold) {
        [self changeFoldStateForSection:section];
    }
}

- (void)foldSection:(NSInteger)section {
    if ([self foldStateForSection:section] == FTSectionStateExpand) {
        [self changeFoldStateForSection:section];
    }
}

- (void)expandAllSections {
    [self.statusArray enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.integerValue == FTSectionStateFold) {
            [self changeFoldStateForSection:idx];
        }
    }];
}

- (void)foldAllSections {
    [self.statusArray enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.boolValue == FTSectionStateExpand) {
            [self changeFoldStateForSection:idx];
        }
    }];
}

@end

@interface FTFoldableSectionHeader ()

@property (nonatomic, weak) id<FTFoldableSectionHeaderDelegate> tapDelegate;
@property (nonatomic, assign) FTSectionState sectionState;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation FTFoldableSectionHeader

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addGestureRecognizer:self.tapGesture];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addGestureRecognizer:self.tapGesture];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addGestureRecognizer:self.tapGesture];
    }
    return self;
}

- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapped:)];
    }
    return _tapGesture;
}

- (void)onTapped:(UITapGestureRecognizer *)gesture
{
    if (self.tapDelegate && [self.tapDelegate respondsToSelector:@selector(foldableSectionHeader:didTapAtIndex:)]) {
        self.sectionState = [NSNumber numberWithInteger:(![NSNumber numberWithInteger:self.sectionState].boolValue)].integerValue;
        [_tapDelegate foldableSectionHeader:self didTapAtIndex:self.tag];
    }
}

- (void)setupWithSection:(NSInteger)section tapDelegate:(id<FTFoldableSectionHeaderDelegate>)tapDelegate {
    self.tag = section;
    self.tapDelegate = tapDelegate;
}


@end

