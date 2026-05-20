import Foundation

struct CourseContent {
    let signatureHoles: [SignatureHole]
    let thingsToKnow: [String]
    let scorecard: Scorecard?
}

struct SignatureHole: Identifiable, Hashable {
    let id = UUID()
    let number: Int
    let title: String?
    let note: String
}

struct Scorecard: Hashable {
    let holes: Int
    let par: Int
    let totalYardage: Int
    let tee: String
}

extension Course {
    var content: CourseContent? {
        Course.contentByCourseName[name]
    }

    static let contentByCourseName: [String: CourseContent] = [
        "Pacific Dunes": CourseContent(
            signatureHoles: [
                SignatureHole(number: 11, title: nil,
                              note: "Par 3 with the green perched at the cliff edge above the Pacific. Almost always into the wind. The shot of the round."),
                SignatureHole(number: 13, title: nil,
                              note: "Par 4 along the cliff, dogleg left. Drive has to thread past hidden bunkering. Camera-ready off the tee."),
                SignatureHole(number: 4, title: nil,
                              note: "Three different fairways depending on the wind. Doak's clearest lesson in 'pick a line, commit to it.'")
            ],
            thingsToKnow: [
                "Tom Doak's masterpiece. Routinely top-10 in the United States.",
                "Minimalist — most hazards are invisible from the tee. Caddies essential.",
                "Wind dictates everything. Club selection swings wildly during a single round.",
                "Walking only. Firm and fast turf year-round."
            ],
            scorecard: Scorecard(holes: 18, par: 71, totalYardage: 6633, tee: "Pacific")
        ),

        "Bandon Dunes": CourseContent(
            signatureHoles: [
                SignatureHole(number: 4, title: nil,
                              note: "First true cliffside hole. Long par 4 with the ocean on the right the entire way."),
                SignatureHole(number: 16, title: nil,
                              note: "Par 4 with the Pacific behind the green. The 'oh wow' moment for first-time visitors."),
                SignatureHole(number: 5, title: nil,
                              note: "Par 4 with a blind tee shot over the dunes. Trust the marker.")
            ],
            thingsToKnow: [
                "The original course that started the resort in 1999. David McLay Kidd's debut at Bandon.",
                "Walks more like classic links than the others — most exposed to wind.",
                "Best played in the morning before the afternoon wind picks up.",
                "Closing stretch (16-17-18) is the most photographed sequence at the resort."
            ],
            scorecard: Scorecard(holes: 18, par: 72, totalYardage: 6732, tee: "Bandon")
        ),

        "Old Macdonald": CourseContent(
            signatureHoles: [
                SignatureHole(number: 3, title: "Sahara",
                              note: "Long par 5 with massive sand-fronted approach. Lay up smart — the third shot is the easier one."),
                SignatureHole(number: 8, title: "Biarritz",
                              note: "Long par 3 with the famous swale running through the green. Putt from anywhere."),
                SignatureHole(number: 14, title: "Maiden",
                              note: "Drivable par 4 to a punchbowl green. Tempts you every time.")
            ],
            thingsToKnow: [
                "A tribute course — every hole references one of C.B. Macdonald's 'ideal' template designs.",
                "Huge fairways but the greens are wickedly contoured. Three-putts are common.",
                "Most exposed of all the Bandon courses — the wind has nowhere to hide.",
                "Often the 'fun' round — high scoring opportunities AND high disaster potential."
            ],
            scorecard: Scorecard(holes: 18, par: 71, totalYardage: 6944, tee: "Macdonald")
        ),

        "Sheep Ranch": CourseContent(
            signatureHoles: [
                SignatureHole(number: 3, title: nil,
                              note: "Par 4 along the cliff edge. The opening look that sets the tone for the cliffside back nine."),
                SignatureHole(number: 16, title: nil,
                              note: "Par 3 with the Pacific behind the green. Most-photographed hole at Bandon, period."),
                SignatureHole(number: 13, title: nil,
                              note: "Par 4 with a green that sits on a peninsula. Wind plays havoc with club choice.")
            ],
            thingsToKnow: [
                "Newest of the full-length courses (opened 2020). Coore & Crenshaw's seaside layout on the former Macauley ranch.",
                "Nine cliffside holes — more ocean frontage than any other course at Bandon.",
                "Zero bunkers. Hazards are dunes, native grasses, and the cliffs themselves.",
                "Most exposed to weather of any course here — bring an extra layer."
            ],
            scorecard: Scorecard(holes: 18, par: 72, totalYardage: 6800, tee: "Sheep")
        ),

        "Bandon Trails": CourseContent(
            signatureHoles: [
                SignatureHole(number: 5, title: nil,
                              note: "Reachable par 4 cutting through the forest. Risk-reward tee shot — go for it or lay up."),
                SignatureHole(number: 14, title: nil,
                              note: "Par 3 with a green tucked into the dunes. Tough wind read."),
                SignatureHole(number: 17, title: nil,
                              note: "Par 4 climbing back toward the dunes. The course's last big elevation change.")
            ],
            thingsToKnow: [
                "The only course at the resort that's not coastal — it starts and ends in dunes but routes through coastal forest.",
                "Biggest elevation changes at Bandon. Walk is more strenuous than the others.",
                "Wind is muted in the trees — often the lowest-scoring round of the trip.",
                "A welcome change of scenery in the middle of a multi-day stay."
            ],
            scorecard: Scorecard(holes: 18, par: 71, totalYardage: 6788, tee: "Trails")
        ),

        "Bandon Preserve": CourseContent(
            signatureHoles: [
                SignatureHole(number: 5, title: nil,
                              note: "Downhill par 3 with the ocean spread out behind the green. The shot you came for."),
                SignatureHole(number: 13, title: nil,
                              note: "Closing hole with expansive views back across the property.")
            ],
            thingsToKnow: [
                "13-hole par 3 course. Every hole has a view of the Pacific.",
                "Proceeds support the Wild Rivers Coast Alliance (coastal conservation).",
                "Walks in about 2 hours. Perfect arrival-day warmup or before-dinner round.",
                "Walking only, push carts allowed. Best played at sunset."
            ],
            scorecard: Scorecard(holes: 13, par: 39, totalYardage: 1490, tee: "Preserve")
        ),

        "Shorty's": CourseContent(
            signatureHoles: [
                SignatureHole(number: 9, title: nil,
                              note: "Punchbowl green that funnels everything toward the middle. Good way to end a loop."),
                SignatureHole(number: 19, title: "The Shorty",
                              note: "The bonus 19th hole. Settles every tied match.")
            ],
            thingsToKnow: [
                "19-hole par 3 course — the 19th breaks ties.",
                "More casual vibe than the Preserve. Beer in hand is encouraged.",
                "Walks in about an hour. Great between dinner and bedtime.",
                "Walking only. Push carts allowed."
            ],
            scorecard: Scorecard(holes: 19, par: 54, totalYardage: 1875, tee: "Shorty")
        ),

        "Sand Hollow Resort — Championship Course": CourseContent(
            signatureHoles: [
                SignatureHole(number: 11, title: nil,
                              note: "Par 3 across a canyon to a clifftop green. The shot you remember from Sand Hollow."),
                SignatureHole(number: 14, title: nil,
                              note: "Par 4 hugging the edge of the red rock cliff. Wide bailout left, certain doom right."),
                SignatureHole(number: 15, title: nil,
                              note: "Short par 3 over the box canyon. Wedge in your hands, vertigo in your stomach.")
            ],
            thingsToKnow: [
                "John Fought's red-rock masterpiece in southern Utah. Routinely on Golfweek's top-100 public list.",
                "Cliff carries on the front side of the back nine — bring extra balls.",
                "Weather turns fast out here. In 2025 the group got chased off the course mid-round by a thunderstorm; a course worker eventually came out and pulled the plug.",
                "Heads up around the clubhouse: an old man came tearing up the stairs in a cart and nearly took Roach out."
            ],
            scorecard: Scorecard(holes: 18, par: 72, totalYardage: 7197, tee: "Black")
        ),

        "Green Spring": CourseContent(
            signatureHoles: [
                SignatureHole(number: 6, title: nil,
                              note: "Par 5 with the tee perched above a desert wash. Carry it, then it's a wedge to scoring distance."),
                SignatureHole(number: 12, title: nil,
                              note: "Downhill par 4 with the green tucked into the canyon below.")
            ],
            thingsToKnow: [
                "The local favorite — Washington City's value play, often the warmup round of a St. George trip.",
                "Real canyon shots without the resort price tag.",
                "Walks well; cart not required.",
                "Doesn't try to be a bucket-list course — and it's better for it."
            ],
            scorecard: Scorecard(holes: 18, par: 71, totalYardage: 6027, tee: "Blue")
        ),

        "Wolf Creek Golf Club": CourseContent(
            signatureHoles: [
                SignatureHole(number: 7, title: nil,
                              note: "Par 3 with a 100+ foot elevation drop. You can see the green from the tee, but the math feels impossible."),
                SignatureHole(number: 12, title: nil,
                              note: "Par 4 with a fairway that wraps a ravine. Cut the corner or play safe — there's no in-between."),
                SignatureHole(number: 17, title: nil,
                              note: "Uphill par 4, blind approach. Most-photographed hole on the property.")
            ],
            thingsToKnow: [
                "Sits in Mesquite NV, about 45 minutes from St. George. The group's verdict from 2025: stole the show — felt like playing inside a video game.",
                "Cart path only, always. Don't even think about it.",
                "Elevation changes are unlike anything else in the region. Bring your full bag and trust nothing on yardage.",
                "Greg Norman's Grille on-site for the turn lunch."
            ],
            scorecard: Scorecard(holes: 18, par: 72, totalYardage: 6939, tee: "Wolf")
        ),

        "Coral Canyon": CourseContent(
            signatureHoles: [
                SignatureHole(number: 7, title: nil,
                              note: "Par 3 over a desert wash with the Pine Valley Mountains stacked behind the green."),
                SignatureHole(number: 13, title: nil,
                              note: "Par 4 dogleg with a long-iron approach to a perched green."),
                SignatureHole(number: 18, title: nil,
                              note: "Reachable par 5 finishing in front of the clubhouse.")
            ],
            thingsToKnow: [
                "Keith Foster design built around natural arroyos and red rock formations. Views toward Zion on a clear day.",
                "The group teed off in 2025 with a rainbow stretched across the mountains right after the morning rain cleared.",
                "Less canyon carry than Sand Hollow, more scenic ribbon-of-fairway through the desert.",
                "Plays cooler than the resort courses — usually 5-8° below St. George proper because of elevation."
            ],
            scorecard: Scorecard(holes: 18, par: 72, totalYardage: 6592, tee: "Black")
        ),

        "Black Desert Resort": CourseContent(
            signatureHoles: [
                SignatureHole(number: 9, title: nil,
                              note: "Par 4 finishing in front of the clubhouse with the basalt fields spread out behind the green."),
                SignatureHole(number: 17, title: nil,
                              note: "Par 3 over a lava field. Beautiful when you stick it; disaster when you don't."),
                SignatureHole(number: 14, title: nil,
                              note: "Dogleg par 5 carved through volcanic rock — the most distinctive hole on the course.")
            ],
            thingsToKnow: [
                "Tom Weiskopf's last design (2023). Built on a black lava flow in Ivins, UT.",
                "Now home to the Black Desert Championship on the PGA Tour. The group played here in 2025 weeks before the event — par-3 tees were closed to protect the tournament setup, so we hit off mats.",
                "Greens were as fast as anything the group has played.",
                "Lutz hit some absurd recoveries off the lava — a few of his shots from this round are still talked about.",
                "All-you-can-eat-and-drink during the round is included. Worth the green fee on its own.",
                "Skip the post-round 20th Hole restaurant — service collapsed when our group rolled in."
            ],
            scorecard: Scorecard(holes: 18, par: 71, totalYardage: 7371, tee: "Tournament")
        )
    ]
}
