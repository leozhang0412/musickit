//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKImageStore.h"
#import "VMKMeasureView.h"
#import "VMKMeasureLayer.h"


@interface VMKMeasureView ()

@property(nonatomic, strong, readonly) VMKMeasureLayer* measureLayer;

@end


@implementation VMKMeasureView

+ (Class)layerClass {
    return [VMKMeasureLayer class];
}

- (VMKMeasureLayer*)measureLayer {
    return (VMKMeasureLayer*)self.layer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.clipsToBounds = NO;
    self.backgroundColor = [UIColor clearColor];
    return self;
}

- (instancetype)initWithMeasure:(const mxml::MeasureGeometry*)measureGeometry {
    self = [super initWithGeometry:measureGeometry];
    if (!self)
        return nil;

    self.measureLayer.measureGeometry = measureGeometry;
    return self;
}


#pragma mark -

- (const mxml::MeasureGeometry*)measureGeometry {
    return static_cast<const mxml::MeasureGeometry*>(self.measureLayer.measureGeometry);
}

- (void)setMeasureGeometry:(const mxml::MeasureGeometry *)measureGeometry {
    self.measureLayer.measureGeometry = measureGeometry;
}

@end
