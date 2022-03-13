import Foundation

struct HandGame {
    private var hasUserWin = false

    private enum kind {
        case rockPaperScissors, mukjipa
    }
    
    private enum Hand: CaseIterable, CustomStringConvertible {
        case rock, paper, scissors
        
        var description: String {
            switch self {
            case .scissors:
                return "가위"
            case .rock:
                return "바위"
            case .paper:
                return "보"
            }
        }
    }
    
    private enum NormalValue: CaseIterable {
        case one, two, three, zero
        
        var description: String {
            switch self {
            case .one:
                return "1"
            case .two:
                return "2"
            case .three:
                return "3"
            case .zero:
                return "0"
            }
        }
    }
    
    private enum Player: CustomStringConvertible {
        case userTurn, computerTurn
        
        var description: String {
            switch self {
            case .userTurn:
                return "사용자"
            case .computerTurn:
                return "컴퓨터"
            }
        }
    }
    
    private enum Guide: CustomStringConvertible {
        case rockPaperScissorsMessage, mukjipaMessage
        
        var description: String {
            switch self {
            case .rockPaperScissorsMessage:
                return "가위(1), 바위(2), 보(3)! <종료 : 0> : "
            case .mukjipaMessage:
                return "묵(1), 찌(2), 빠(3)! <종료 : 0> : "
            }
        }
    }
    
    private enum Result: CustomStringConvertible {
        case win, lose, draw, endGame, computerWin, userWin
        
        var description: String {
            switch self {
            case .win:
                return "이겼습니다!"
            case .lose:
                return "졌습니다!"
            case .draw:
                return "비겼습니다!"
            case .endGame:
                return "게임 종료"
            case .computerWin:
                return "컴퓨터의 승리!"
            case .userWin:
                return "사용자의 승리!"
            }
        }
    }
    
    private enum Error: CustomStringConvertible {
        case wrongInput
        
        var description: String {
            switch self {
            case .wrongInput:
                return "잘못된 입력입니다. 다시 시도해주세요."
            }
        }
    }

    mutating func play() {
        printInputGuidanceMessage(gameKind: .rockPaperScissors)
        
        let userHand = receiveUserInputHand()
        if isValueZero(to: userHand) {
            print(Result.endGame)
            return
        }
        if isWrongInputted(userHand) {
            print(Error.wrongInput)
            play()
            return
        }
        let verifiedUserHand = convertedUserHand(userHand, gameKind: .rockPaperScissors)
        let computerHand = generatedRandomHand()
        let userGameResult = judgeGameResult(userHand: verifiedUserHand, computerHand: computerHand)
        printGameResult(by: userGameResult)
        if isDraw(by: userGameResult) { play() }
        if userGameResult != .draw { playMukjipa(didUserWin: self.hasUserWin) }
    }
    
    private func printInputGuidanceMessage(gameKind: kind) {
        if gameKind == .rockPaperScissors {
            print(Guide.rockPaperScissorsMessage, terminator: "")
        } else if gameKind == .mukjipa {
            print(Guide.mukjipaMessage, terminator: "")
        }
    }
    
    private func receiveUserInputHand() -> String? {
        let inputtedHand = readLine()?.replacingOccurrences(of: " ", with: "")
        return inputtedHand
    }
    
    private func convertedUserHand(_ inputtedValue: String?, gameKind: kind) -> HandGame.Hand {
        switch inputtedValue {
        case NormalValue.one.description:
            if gameKind == .mukjipa { return .rock }
            return .scissors
        case NormalValue.two.description:
            if gameKind == .mukjipa { return .scissors }
            return .rock
        default:
            return .paper
        }
    }
    
    private func isValueZero(to userInputted: String?) -> Bool {
        if userInputted == NormalValue.zero.description {
            return true
        }
        return false
    }

    private func generatedRandomHand() -> HandGame.Hand {
        if let hand = Hand.allCases.randomElement() {
            return hand
        }
        return generatedRandomHand()
    }

    private mutating func judgeGameResult(userHand: HandGame.Hand, computerHand: HandGame.Hand) -> HandGame.Result {
        if userHand == computerHand {
            return .draw
        } else if (userHand, computerHand) == (.scissors, .paper) ||
                    (userHand, computerHand) == (.rock, .scissors) ||
                    (userHand, computerHand) == (.paper, .rock) {
            self.hasUserWin = true
            return .win
        } else {
            self.hasUserWin = false
            return .lose
        }
    }
    
    private mutating func playMukjipa(didUserWin: Bool) {
        printRockPaperScissorsWinnerTurn(by: didUserWin)
        printInputGuidanceMessage(gameKind: .mukjipa)

        let userHand = receiveUserInputHand()
        if isValueZero(to: userHand) {
            print(Result.endGame)
            return
        }
        if isWrongInputted(userHand) {
            print(Error.wrongInput)
            switchTurn(by: didUserWin)
            playMukjipa(didUserWin: self.hasUserWin)
            return
        }
        let verifiedUserHand = convertedUserHand(userHand, gameKind: .mukjipa)
        let computerHand = generatedRandomHand()
        let mukjipaGameResult = judgeGameResult(userHand: verifiedUserHand, computerHand: computerHand)
        if isDraw(by: mukjipaGameResult) {
            judgeMukjipaWinner(by: mukjipaGameResult)
            return
        } else {
            judgeMukjipaWinner(by: mukjipaGameResult)
            playMukjipa(didUserWin: self.hasUserWin)
        }
    }
    
    private func printRockPaperScissorsWinnerTurn(by hasUserWin: Bool) {
        if hasUserWin == true {
            print("[\(Player.userTurn) 턴] ", terminator: "")
        } else if hasUserWin == false {
            print("[\(Player.computerTurn) 턴] ", terminator: "")
        }
    }
    
    private func isWrongInputted(_ value: String?) -> Bool {
        let normalValues = NormalValue.allCases.description
        if let value = value, normalValues.contains(value) {
            return false
        }
        return true
    }
    
    private mutating func isDraw(by user: HandGame.Result) -> Bool {
        if user == .draw {
            return true
        }
        return false
    }
    
    private mutating func printGameResult(by user: HandGame.Result) {
        if user == .draw {
            print(Result.draw)
        } else if user == .win {
            print(Result.win)
        } else {
            print(Result.lose)
        }
    }
    
    private mutating func switchTurn(by hasUserWin: Bool) {
        if hasUserWin == true {
            self.hasUserWin = true
        } else {
            self.hasUserWin = false
        }
    }
    
    private func printMukjipaWinnerTurn(by hasUserWin: Bool) {
        if hasUserWin == true {
            print("\(Player.userTurn) 턴입니다")
        } else if hasUserWin == false {
            print("\(Player.computerTurn) 턴입니다")
        }
    }
    
    private func printMukjipaWinner(didUserWin: Bool) {
        if didUserWin {
            print(Result.userWin)
        } else {
            print(Result.computerWin)
        }
    }
    
    private mutating func judgeMukjipaWinner(by mukjipaGameResult: HandGame.Result) {
        if mukjipaGameResult == .draw {
            printMukjipaWinner(didUserWin: self.hasUserWin)
            print(Result.endGame)
        } else {
            printMukjipaWinnerTurn(by: self.hasUserWin)
        }
    }
}
