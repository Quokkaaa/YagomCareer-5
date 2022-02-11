//
//  NumberBaseball - main.swift
//  Created by Roy and 쿼카 .
//  Copyright © yagom academy. All rights reserved.
//

import Foundation

var userInputNumbers: [Int] = []
let computerNumbers = generateRandomNumbers()
var remainingChangeCount: Int = 9
var strikeCounting = 0
let endGameCount = 3
var (strikeCount, ballCount) = (Int.zero, Int.zero)

func playGame() {
    let onePoint = 1
    
    while remainingChangeCount > .zero {
        if isHaveVerifiedNumbers(receiveUserInputNumbers()) {
            calculateStrikeBallWith(userInputNumbers, and: computerNumbers)
            remainingChangeCount -= onePoint
            printPlayingGameMessage(userNumbers: userInputNumbers, ballCount: strikeCount, strikeCount: ballCount)
            resetStrikeBallCount()
            if strikeCounting == endGameCount { break }
        } else {
            receiveUserInputNumbers()
        }
    }
    judgeGameResult()
}

func selectMenu() {
    print("1. 게임시작")
    print("2. 게임종료")
    print("원하는 기능을 선택해주세요 : ", terminator: "")
    
    let inputNumbers: String? = readLine()
    
    switch inputNumbers {
    case "1":
        playGame()
    case "2":
        return
    default:
        print("입력이 잘못되었습니다.")
        selectMenu()
    }
}

@discardableResult func receiveUserInputNumbers() -> [String]? {
    print("숫자 3개를 띄어쓰기로 구분하여 입력해주세요.")
    print("중복 숫지는 허용하지 않습니다.")
    print("입력 : ", terminator: "")
    
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

func calculateStrikeBallWith(_ userNumbers: Array<Int>, and computerNumbers: Array<Int>) {
    calculateStrikeCount(userNumbers, and: computerNumbers)
    calculateBallCount(userNumbers, and: computerNumbers)
    strikeCounting += strikeCount
}

func resetStrikeBallCount() {
    strikeCount = .zero
    ballCount = .zero
}

func saveConvertedNumbers(_ numbers: [Int]) {
    userInputNumbers = numbers
}

func isNumber(_ numbers: [String]?) -> Bool {
    let verifyNumbers = numbers?.compactMap{ Int($0) }
    guard let verifiedNumber = verifyNumbers, verifiedNumber.count == 3 else {
        return false
    }
    saveConvertedNumbers(verifiedNumber)
    return true
}

func isHaveInRange(numbers: [Int], range: ClosedRange<Int> = 1...9) -> Bool {
    return numbers.filter { range.contains($0) }.count == 3
}

func isHaveVerifiedNumbers(_ numbers: [String]?) -> Bool {
    return isNumber(numbers) && isHaveInRange(numbers: userInputNumbers) && isHaveDuplicationNumbers(userInputNumbers)
}

func isHaveDuplicationNumbers(_ numbers: [Int]) -> Bool {
    return Set(numbers).count == 3
}

func printPlayingGameMessage(userNumbers: Array<Int> ,ballCount: Int ,strikeCount: Int) {
    let (strikeDescription, ballDescription) =  ("스트라이크," ,"볼")
    let (randomNumbersDescription, remainingChanceDescription) = ("임의의 수 : " ,"남은 기회 :")
    let squareBrakets: CharacterSet = ["[","]"]
    
    print("\(randomNumbersDescription) \(userNumbers.description.replacingOccurrences(of: ",", with: "").trimmingCharacters(in: squareBrakets))")
    print("\(strikeCount) \(strikeDescription) \(ballCount) \(ballDescription) ")
    print("\(remainingChanceDescription) \(remainingChangeCount)")
}

func judgeGameResult() {
    let (userWin, computerWin) = ("사용자의 승리...!", "컴퓨터의 승리...!")
    print(remainingChangeCount == .zero ? computerWin : userWin)
}
selectMenu()
