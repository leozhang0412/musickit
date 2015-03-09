//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

#import "VMKAdHocScoreTestCase.h"
#import "VMKPartLayer.h"
#import "VMKTieLayer.h"

#include <mxml/dom/Tuplet.h>
#include <mxml/geometry/PartGeometry.h>
#include <mxml/geometry/ScrollScoreGeometry.h>
#include <mxml/geometry/factories/TieGeometryFactory.h>

using namespace mxml;


@interface VMKTupletLayerTests : VMKAdHocScoreTestCase

@end


@implementation VMKTupletLayerTests

- (void)testTuplet {
    auto builder = self.builder;
    auto time = dom::time_t{};

    {
        auto note = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, time++, 1);
        builder->setPitch(note, mxml::dom::Pitch::Step::E, 5);

        note->timeModification.reset(new dom::TimeModification{});
        note->timeModification->actualNotes = 3;
        note->timeModification->normalNotes = 2;

        auto tuplet = std::unique_ptr<dom::Tuplet>(new dom::Tuplet{});
        tuplet->type = dom::Tuplet::Type::Start;

        auto notations = std::unique_ptr<dom::Notations>(new dom::Notations{});
        notations->tuplets.push_back(std::move(tuplet));
        note->notations = std::move(notations);
    }
    {
        auto note = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, time++, 1);
        builder->setPitch(note, mxml::dom::Pitch::Step::B, 4);

        note->timeModification.reset(new dom::TimeModification{});
        note->timeModification->actualNotes = 3;
        note->timeModification->normalNotes = 2;
    }
    {
        auto note = builder->addNote(self.measure, mxml::dom::Note::Type::Quarter, time++, 1);
        builder->setPitch(note, mxml::dom::Pitch::Step::E, 4);

        note->timeModification.reset(new dom::TimeModification{});
        note->timeModification->actualNotes = 3;
        note->timeModification->normalNotes = 2;

        auto tuplet = std::unique_ptr<dom::Tuplet>(new dom::Tuplet{});
        tuplet->type = dom::Tuplet::Type::Stop;

        auto notations = std::unique_ptr<dom::Notations>(new dom::Notations{});
        notations->tuplets.push_back(std::move(tuplet));
        note->notations = std::move(notations);
    }

    auto score = builder->build();
    auto scoreGeometry = std::unique_ptr<mxml::ScrollScoreGeometry>(new mxml::ScrollScoreGeometry(*score, true));
    auto partGeometry = scoreGeometry->partGeometries().front();
    VMKPartLayer* layer = [[VMKPartLayer alloc] initWithPartGeometry:partGeometry];

    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

@end
