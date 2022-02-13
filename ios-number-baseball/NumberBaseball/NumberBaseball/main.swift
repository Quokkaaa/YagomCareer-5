//  NumberBaseball - main.swift
//  Created by Roy and 쿼카 .
//  Copyright © yagom academy. All rights reserved.

import Foundation

var userInputNumbers: [Int] = []
let computerNumbers = generateRandomNumbers()
var remainingChangeCount: Int = 9
var strikeCountResult = 0
let endGameCount = 3
var (strikeCount, ballCount) = (Int.zero, Int.zero)

func playGame() {
    let chanceCount = 1
    
    while remainingChangeCount > .zero {
        guard isHaveVerifiedNumbers(receiveUserInputNumbers()) else {
            playGame()
            return
        }
        calculateStrikeBallWith(userInputNumbers, and: computerNumbers)
        remainingChangeCount -= chanceCount
        printPlayingGameMessage()
        resetStrikeBallCount()
        if strikeCountResult >= endGameCount { break }
    }
    judgeGameResult()
}

func printMenu() {
    print("1. 게임시작")
    print("2. 게임종료")
    print("원하는 기능을 선택해주세요 : ", terminator: "")
}

func selectMenu() {
    printMenu()
    let inputNumbers = readLine()?.replacingOccurrences(of: " ", with: "")
    
    switch inputNumbers {
    case "1":
        playGame()
        selectMenu()
    case "2":
        break
    default:
        print("입력이 잘못되었습니다.")
        selectMenu()
    }
}

func printInputGuidance() {
    print("숫자 3개를 띄어쓰기로 구분하여 입력해주세요.")
    print("중복 숫자는 허용하지 않습니다.")
    print("입력 : ", terminator: "")
}

func receiveUserInputNumbers() -> [String]? {
    printInputGuidance()
    let inputNumbers = readLine()?.components(separatedBy: " ")
    return inputNumbers
}

func generateRandomNumbers(range: ClosedRange<Int> = 1...9, numbersCount: Int = 3) -> Array<Int> {
    var randomNumbers: Set<Int> = []
    while randomNumbers.count < numbersCount {
        randomNumbers.insert(Int.random(in: range))
    }
    return Array(randomNumbers)
}

func calculateStrikeCount(_ userNumbers: Array<Int>, and computerNumbers: Array<Int>) {
    let strikePoint = 1
    for index in userNumbers.indices {
        strikeCount += userNumbers[index] == computerNumbers[index] ? strikePoint : .zero
    }
}

func calculateBallCount(_ userNumbers: Array<Int>, and computerNumbers: Array<Int>) {
    ballCount = (Set(computerNumbers).intersection(userNumbers).count - strikeCount)
}

func updateStrikeResult() {
    strikeCountResult += strikeCount
}

func calculateStrikeBallWith(_ userNumbers: Array<Int>, and computerNumbers: Array<Int>) {
    calculateStrikeCount(userNumbers, and: computerNumbers)
    calculateBallCount(userNumbers, and: computerNumbers)
    updateStrikeResult()
}

func resetStrikeBallCount() {
    strikeCount = .zero
    ballCount = .zero
}

func saveConvertedNumbers(_ numbers: [String]?) {
    if let verifyNumbers = numbers?.compactMap({ Int($0) }) {
        userInputNumbers = verifyNumbers
    }
}

func isNumber(_ numbers: [String]?) -> Bool {
    guard let verifiedNumbers = numbers?.compactMap({ Int($0) }),
          verifiedNumbers.count == 3 else {
              return false
          }
    saveConvertedNumbers(numbers)
    return true
}

func isHaveInRange(numbers: [Int], range: ClosedRange<Int> = 1...9) -> Bool {
    return numbers.filter { range.contains($0) }.count == 3
}

func isHaveDuplication(_ numbers: [Int]) -> Bool {
    return Set(numbers).count == 3
}

func isHaveVerifiedNumbers(_ numbers: [String]?) -> Bool {
    return isNumber(numbers) && isHaveInRange(numbers: userInputNumbers) && isHaveDuplication(userInputNumbers)
}

func printPlayingGameMessage() {
    let (strikeDescription, ballDescription) =  ("스트라이크," ,"볼")
    let remainingChanceDescription = "남은 기회 :"
    
    print("\(strikeCount) \(strikeDescription) \(ballCount) \(ballDescription) ")
    print("\(remainingChanceDescription) \(remainingChangeCount)")
}

func judgeGameResult() {
    let (userWin, computerWin) = ("사용자의 승리...!", "컴퓨터의 승리...!")
    print(remainingChangeCount == .zero ? computerWin : userWin)
}
selectMenu()
