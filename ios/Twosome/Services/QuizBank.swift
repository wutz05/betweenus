import Foundation

enum QuizBank {
    static let levels: [QuizLevel] = buildAllLevels()

    static func levelsFor(_ category: QuizCategory) -> [QuizLevel] {
        levels.filter { $0.category == category }
    }

    private static func buildAllLevels() -> [QuizLevel] {
        var all: [QuizLevel] = []
        all.append(contentsOf: funnyLevels())
        all.append(contentsOf: deepLevels())
        all.append(contentsOf: romanticLevels())
        all.append(contentsOf: spicyLevels())
        return all
    }

    private static func funnyLevels() -> [QuizLevel] {
        [
            QuizLevel(category: .funny, levelNumber: 1, title: "Ice Breakers", questions: [
                QuizQuestion(text: "What's the weirdest food combo your partner secretly loves?"),
                QuizQuestion(text: "If your partner were a cartoon character, who would they be?"),
                QuizQuestion(text: "What's the most embarrassing song on your partner's playlist?"),
                QuizQuestion(text: "What animal does your partner most resemble in the morning?"),
                QuizQuestion(text: "What would your partner's superhero name be?"),
            ]),
            QuizLevel(category: .funny, levelNumber: 2, title: "Silly Secrets", questions: [
                QuizQuestion(text: "What's the funniest auto-correct fail you've sent each other?"),
                QuizQuestion(text: "What's your partner's most dramatic overreaction?"),
                QuizQuestion(text: "If your partner had a catchphrase, what would it be?"),
                QuizQuestion(text: "What's the silliest argument you've ever had?"),
                QuizQuestion(text: "What talent does your partner think they have but really don't?"),
            ]),
            QuizLevel(category: .funny, levelNumber: 3, title: "Comedy Hour", questions: [
                QuizQuestion(text: "What movie perfectly describes your relationship?"),
                QuizQuestion(text: "What's the most ridiculous thing your partner has bought?"),
                QuizQuestion(text: "If your partner joined a reality show, which one?"),
                QuizQuestion(text: "What's the funniest habit your partner has?"),
                QuizQuestion(text: "What would your partner's wrestling entrance look like?"),
            ]),
            QuizLevel(category: .funny, levelNumber: 4, title: "LOL Moments", questions: [
                QuizQuestion(text: "What's the worst joke your partner tells on repeat?"),
                QuizQuestion(text: "What does your partner do that always cracks you up?"),
                QuizQuestion(text: "If your partner opened a restaurant, what disaster dish would they serve?"),
                QuizQuestion(text: "What's the most chaotic vacation you've had together?"),
                QuizQuestion(text: "What TikTok trend would your partner fail at hilariously?"),
            ]),
            QuizLevel(category: .funny, levelNumber: 5, title: "Prank Masters", questions: [
                QuizQuestion(text: "What's the best prank you could pull on your partner?"),
                QuizQuestion(text: "What would your partner do if they won the lottery?"),
                QuizQuestion(text: "What's the weirdest thing in your partner's search history?"),
                QuizQuestion(text: "If your partner starred in a commercial, what product?"),
                QuizQuestion(text: "What's a rule your partner would make if they were president?"),
            ]),
            QuizLevel(category: .funny, levelNumber: 6, title: "Laugh Attack", questions: [
                QuizQuestion(text: "What sitcom family are you two most like?"),
                QuizQuestion(text: "What Olympic sport would your partner hilariously fail at?"),
                QuizQuestion(text: "What's your partner's most irrational fear?"),
                QuizQuestion(text: "If your life together was a meme, which one?"),
                QuizQuestion(text: "What's the funniest thing that happened on a date?"),
            ]),
            QuizLevel(category: .funny, levelNumber: 7, title: "Comedy Legends", questions: [
                QuizQuestion(text: "What would the title of your partner's autobiography be?"),
                QuizQuestion(text: "If you two had a band, what would it be called?"),
                QuizQuestion(text: "What's the weirdest thing you've bonded over?"),
                QuizQuestion(text: "What would your partner order at a medieval feast?"),
                QuizQuestion(text: "What's the most unhinged text your partner has sent you?"),
            ]),
            QuizLevel(category: .funny, levelNumber: 8, title: "Ultimate Goofs", questions: [
                QuizQuestion(text: "Describe your relationship using only emojis — what would your partner pick?"),
                QuizQuestion(text: "What conspiracy theory would your partner most likely believe?"),
                QuizQuestion(text: "What's the most chaotic thing you've cooked together?"),
                QuizQuestion(text: "If your partner was a flavor of ice cream, which one?"),
                QuizQuestion(text: "What's the dumbest hill your partner is willing to die on?"),
            ]),
        ]
    }

    private static func deepLevels() -> [QuizLevel] {
        [
            QuizLevel(category: .deep, levelNumber: 1, title: "First Steps", questions: [
                QuizQuestion(text: "What's one thing you wish your partner understood better about you?"),
                QuizQuestion(text: "What moment made you realize this relationship was special?"),
                QuizQuestion(text: "What's your biggest fear about the future together?"),
                QuizQuestion(text: "What childhood experience shaped how you love?"),
                QuizQuestion(text: "When do you feel most vulnerable with your partner?"),
            ]),
            QuizLevel(category: .deep, levelNumber: 2, title: "Open Hearts", questions: [
                QuizQuestion(text: "What's something you've never told your partner?"),
                QuizQuestion(text: "What part of yourself have you discovered through this relationship?"),
                QuizQuestion(text: "How has your definition of love changed since being together?"),
                QuizQuestion(text: "What's the hardest thing you've forgiven in this relationship?"),
                QuizQuestion(text: "What does emotional safety mean to you?"),
            ]),
            QuizLevel(category: .deep, levelNumber: 3, title: "Soul Dive", questions: [
                QuizQuestion(text: "What's a belief you've changed because of your partner?"),
                QuizQuestion(text: "What do you think your partner's greatest inner struggle is?"),
                QuizQuestion(text: "When did you last cry in front of each other and why?"),
                QuizQuestion(text: "What does growing old together actually look like to you?"),
                QuizQuestion(text: "What's a wound from your past that still affects your relationship?"),
            ]),
            QuizLevel(category: .deep, levelNumber: 4, title: "Inner World", questions: [
                QuizQuestion(text: "What part of your identity feels most connected to this relationship?"),
                QuizQuestion(text: "What are you most afraid of losing?"),
                QuizQuestion(text: "What's the most important lesson this relationship has taught you?"),
                QuizQuestion(text: "How do you want to be remembered by your partner?"),
                QuizQuestion(text: "What topic do you avoid discussing and why?"),
            ]),
            QuizLevel(category: .deep, levelNumber: 5, title: "Uncharted", questions: [
                QuizQuestion(text: "What would you sacrifice for your partner's happiness?"),
                QuizQuestion(text: "What does true partnership mean to you?"),
                QuizQuestion(text: "When do you feel most disconnected and what triggers it?"),
                QuizQuestion(text: "What's the bravest thing you've done for this relationship?"),
                QuizQuestion(text: "If you could heal one thing between you, what would it be?"),
            ]),
            QuizLevel(category: .deep, levelNumber: 6, title: "Core Truth", questions: [
                QuizQuestion(text: "What does unconditional love mean to you practically?"),
                QuizQuestion(text: "How do you handle the parts of your partner you can't change?"),
                QuizQuestion(text: "What's the most important promise you've made to each other?"),
                QuizQuestion(text: "What does forgiveness really look like in your relationship?"),
                QuizQuestion(text: "What legacy do you want your love to leave behind?"),
            ]),
            QuizLevel(category: .deep, levelNumber: 7, title: "Depth Charge", questions: [
                QuizQuestion(text: "What's a dream you've given up and does your partner know?"),
                QuizQuestion(text: "How has grief or loss shaped your relationship?"),
                QuizQuestion(text: "What's the most painful honest truth you've shared?"),
                QuizQuestion(text: "What does commitment look like on your hardest days?"),
                QuizQuestion(text: "What question are you afraid to ask your partner?"),
            ]),
            QuizLevel(category: .deep, levelNumber: 8, title: "Infinite Deep", questions: [
                QuizQuestion(text: "What's the most transformative moment in your relationship?"),
                QuizQuestion(text: "If you could relive one conversation, which one?"),
                QuizQuestion(text: "What does your partner need most that they'd never ask for?"),
                QuizQuestion(text: "What's the deepest truth about love you've discovered together?"),
                QuizQuestion(text: "What do you want to tell your partner right now, unfiltered?"),
            ]),
        ]
    }

    private static func romanticLevels() -> [QuizLevel] {
        [
            QuizLevel(category: .romantic, levelNumber: 1, title: "Sweet Start", questions: [
                QuizQuestion(text: "What was your first impression of your partner?"),
                QuizQuestion(text: "What's the most romantic text you've ever received?"),
                QuizQuestion(text: "What song makes you think of your partner?"),
                QuizQuestion(text: "Describe your perfect date night in detail."),
                QuizQuestion(text: "What physical feature do you find most attractive about your partner?"),
            ]),
            QuizLevel(category: .romantic, levelNumber: 2, title: "Love Letters", questions: [
                QuizQuestion(text: "If you wrote a love letter right now, what would the first line be?"),
                QuizQuestion(text: "What's the most romantic surprise you've planned or received?"),
                QuizQuestion(text: "What moment made you fall in love?"),
                QuizQuestion(text: "What's your favorite way to show love?"),
                QuizQuestion(text: "What small gesture from your partner melts your heart every time?"),
            ]),
            QuizLevel(category: .romantic, levelNumber: 3, title: "Butterflies", questions: [
                QuizQuestion(text: "What still gives you butterflies about your partner?"),
                QuizQuestion(text: "What's the most beautiful place you've visited together?"),
                QuizQuestion(text: "What's a romantic movie scene you'd love to recreate?"),
                QuizQuestion(text: "When do you feel most in love?"),
                QuizQuestion(text: "What's your favorite memory of just the two of you?"),
            ]),
            QuizLevel(category: .romantic, levelNumber: 4, title: "Tender Touch", questions: [
                QuizQuestion(text: "What's the most meaningful gift you've given or received?"),
                QuizQuestion(text: "What does your ideal morning together look like?"),
                QuizQuestion(text: "What's a tradition you want to create together?"),
                QuizQuestion(text: "How do you know your partner loves you without them saying it?"),
                QuizQuestion(text: "What's the most romantic thing you've ever done spontaneously?"),
            ]),
            QuizLevel(category: .romantic, levelNumber: 5, title: "Eternal Flame", questions: [
                QuizQuestion(text: "Where would you renew your vows or promise to each other?"),
                QuizQuestion(text: "What's a love poem or quote that describes your relationship?"),
                QuizQuestion(text: "What does 'forever' look like with your partner?"),
                QuizQuestion(text: "What's the most romantic sunset or sunrise you've shared?"),
                QuizQuestion(text: "If you could freeze one moment together forever, which one?"),
            ]),
            QuizLevel(category: .romantic, levelNumber: 6, title: "Moonlit", questions: [
                QuizQuestion(text: "What scent reminds you of your partner?"),
                QuizQuestion(text: "What's the most intimate non-physical moment you've shared?"),
                QuizQuestion(text: "What's a dream honeymoon destination for you two?"),
                QuizQuestion(text: "What does your partner do that makes you feel truly seen?"),
                QuizQuestion(text: "What's the most romantic meal you've shared?"),
            ]),
            QuizLevel(category: .romantic, levelNumber: 7, title: "Soulbound", questions: [
                QuizQuestion(text: "What's a promise you want to make to your partner right now?"),
                QuizQuestion(text: "How has your partner made you believe in love?"),
                QuizQuestion(text: "What's the most beautiful thing about your love story?"),
                QuizQuestion(text: "What do you admire most about how your partner loves?"),
                QuizQuestion(text: "What's a romantic fantasy you haven't shared yet?"),
            ]),
            QuizLevel(category: .romantic, levelNumber: 8, title: "Timeless", questions: [
                QuizQuestion(text: "Write the final chapter of your love story — how does it end?"),
                QuizQuestion(text: "What's the one thing you never want your partner to doubt about your love?"),
                QuizQuestion(text: "If you could give your partner one feeling forever, what would it be?"),
                QuizQuestion(text: "What makes your love different from every other love story?"),
                QuizQuestion(text: "What would you whisper to your partner at the end of time?"),
            ]),
        ]
    }

    private static func spicyLevels() -> [QuizLevel] {
        [
            QuizLevel(category: .spicy, levelNumber: 1, title: "Warm Up", questions: [
                QuizQuestion(text: "What outfit does your partner wear that drives you wild?"),
                QuizQuestion(text: "What's the most attractive thing your partner does without realizing it?"),
                QuizQuestion(text: "Where's the most unexpected place you've kissed?"),
                QuizQuestion(text: "What's your partner's most irresistible feature?"),
                QuizQuestion(text: "What type of flirting works best on you?"),
            ]),
            QuizLevel(category: .spicy, levelNumber: 2, title: "Turning Up", questions: [
                QuizQuestion(text: "What's the boldest move your partner has ever made?"),
                QuizQuestion(text: "Describe your ideal romantic evening in three words."),
                QuizQuestion(text: "What's a compliment that always gets your heart racing?"),
                QuizQuestion(text: "What's the most spontaneous romantic thing you've done?"),
                QuizQuestion(text: "What's a secret turn-on you haven't shared?"),
            ]),
            QuizLevel(category: .spicy, levelNumber: 3, title: "Heat Wave", questions: [
                QuizQuestion(text: "What's a dare you'd give your partner right now?"),
                QuizQuestion(text: "What's the most memorable kiss you've shared?"),
                QuizQuestion(text: "What scenario from a movie would you love to recreate?"),
                QuizQuestion(text: "What's a fantasy vacation just for the two of you?"),
                QuizQuestion(text: "What song sets the mood perfectly for you two?"),
            ]),
            QuizLevel(category: .spicy, levelNumber: 4, title: "Red Hot", questions: [
                QuizQuestion(text: "What's the most daring thing on your couple bucket list?"),
                QuizQuestion(text: "What's something new you'd love to try together?"),
                QuizQuestion(text: "What's the most romantic city you'd love to explore together?"),
                QuizQuestion(text: "What role would you each play in a romance novel?"),
                QuizQuestion(text: "What's the spiciest text you've ever sent?"),
            ]),
            QuizLevel(category: .spicy, levelNumber: 5, title: "Inferno", questions: [
                QuizQuestion(text: "What's a hidden desire you want to share?"),
                QuizQuestion(text: "What's the most adventurous date you can imagine?"),
                QuizQuestion(text: "Truth or dare — what would you pick and why?"),
                QuizQuestion(text: "What's the boldest thing you'd do for love?"),
                QuizQuestion(text: "What makes your connection feel electric?"),
            ]),
            QuizLevel(category: .spicy, levelNumber: 6, title: "Wildfire", questions: [
                QuizQuestion(text: "What's a boundary you'd like to explore together?"),
                QuizQuestion(text: "What's the most passionate moment in your relationship?"),
                QuizQuestion(text: "If you could read your partner's mind for a day, what would you find?"),
                QuizQuestion(text: "What's a fantasy destination for a couple's getaway?"),
                QuizQuestion(text: "What's a challenge you'd give each other this week?"),
            ]),
            QuizLevel(category: .spicy, levelNumber: 7, title: "Volcanic", questions: [
                QuizQuestion(text: "What's the most thrilling surprise you could plan?"),
                QuizQuestion(text: "What keeps the spark alive for you?"),
                QuizQuestion(text: "What's the most daring thing you've done together?"),
                QuizQuestion(text: "What would a perfect 24 hours together look like?"),
                QuizQuestion(text: "What's an unspoken rule between you two?"),
            ]),
            QuizLevel(category: .spicy, levelNumber: 8, title: "Supernova", questions: [
                QuizQuestion(text: "If tonight was your last night on earth, how would you spend it?"),
                QuizQuestion(text: "What's the ultimate way to sweep your partner off their feet?"),
                QuizQuestion(text: "What's one thing that would make your connection even deeper?"),
                QuizQuestion(text: "What does passion mean to you in this relationship?"),
                QuizQuestion(text: "What's the single most unforgettable moment between you two?"),
            ]),
        ]
    }
}
