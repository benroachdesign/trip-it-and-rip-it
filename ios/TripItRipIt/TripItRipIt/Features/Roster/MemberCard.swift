import Foundation

struct MemberCard {
    let catchphrase: String
    let signatureShot: String
    let mostLikelyTo: String
    let drinkOfChoice: String
    let walkUpSong: String
    let bagLiability: String
}

extension Member {
    var card: MemberCard? {
        guard let nick = nickname else { return nil }
        return Member.cardByNickname[nick]
    }

    static let cardByNickname: [String: MemberCard] = [
        "Roach": MemberCard(
            catchphrase: "Fuck",
            signatureShot: "Wedge matrix",
            mostLikelyTo: "Completely collapse under pressure",
            drinkOfChoice: "Doesn't discriminate",
            walkUpSong: "Franklin's Tower — Grateful Dead",
            bagLiability: "Driver, Woods, Hybrids, Irons, etc."
        ),
        "Strub": MemberCard(
            catchphrase: "We'll build on that",
            signatureShot: "Hitting tee shot backwards",
            mostLikelyTo: "Drive the van back from the course",
            drinkOfChoice: "Athletic Brewing",
            walkUpSong: "A podcast about real estate",
            bagLiability: "See signature shot"
        ),
        "Mader": MemberCard(
            catchphrase: "G",
            signatureShot: "Snap hook",
            mostLikelyTo: "Lose an entire box of balls on the front 9",
            drinkOfChoice: "Modelo",
            walkUpSong: "Poppin' Them Thangs — G-Unit",
            bagLiability: "Just… all of it"
        ),
        "Braden": MemberCard(
            catchphrase: "Turn this shit up",
            signatureShot: "Grandpa swing",
            mostLikelyTo: "Bum a cigarette",
            drinkOfChoice: "Hazy IPA",
            walkUpSong: "Free Fallin' — Tom Petty",
            bagLiability: "Forgetting a club on the previous hole"
        ),
        "Webb": MemberCard(
            catchphrase: "Yo",
            signatureShot: "Standing super close to the ball and somehow pounding it",
            mostLikelyTo: "Miss an eagle putt",
            drinkOfChoice: "The heaviest IPA imaginable",
            walkUpSong: "Levels — Avicii",
            bagLiability: "SpongeBob ice cream on his grips"
        ),
        "Tommer": MemberCard(
            catchphrase: "I'm so horny",
            signatureShot: "Extremely steep swing at 150% power",
            mostLikelyTo: "Wear neon head to toe",
            drinkOfChoice: "All of them",
            walkUpSong: "Swag Surf — Lil Wayne",
            bagLiability: "Hiding his poop shorts in the bag"
        ),
        "Lutz": MemberCard(
            catchphrase: "Can I hit your vape?",
            signatureShot: "Draining a long putt",
            mostLikelyTo: "Get the yips",
            drinkOfChoice: "Aperol Spritz",
            walkUpSong: "Free Willy theme song",
            bagLiability: "The bag running out"
        ),
        "Derek": MemberCard(
            catchphrase: "LET'S GO PUPS",
            signatureShot: "Big ol' slice",
            mostLikelyTo: "Lose money gambling",
            drinkOfChoice: "Transfusion",
            walkUpSong: "Into the Mystic — Van Morrison",
            bagLiability: "Weighed down with airplane shots"
        ),
        "Bliz": MemberCard(
            catchphrase: "Let's go",
            signatureShot: "Nice natural draw (so annoying)",
            mostLikelyTo: "Keep his shirt tucked in all round",
            drinkOfChoice: "Domestic light beer",
            walkUpSong: "Pride of Cucamonga — Grateful Dead",
            bagLiability: "Wedges"
        ),
        "Kyle": MemberCard(
            catchphrase: "I'm playing as a 4 at Bandon",
            signatureShot: "Hitting bombs",
            mostLikelyTo: "Actually be a solid golfer",
            drinkOfChoice: "23 beers",
            walkUpSong: "Batter Up — Nelly",
            bagLiability: "Accidentally brought a pickleball bag"
        ),
        "Mike": MemberCard(
            catchphrase: "My back hurts",
            signatureShot: "Iron off the tee box",
            mostLikelyTo: "Complain",
            drinkOfChoice: "Whatever",
            walkUpSong: "My Neck, My Back — Khia",
            bagLiability: "IDK, he's not coming back anyway"
        )
    ]
}
