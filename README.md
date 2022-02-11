# YagomCareer-5



# 숫자야구게임 (Number Base ball)

#순서도


## 프로젝트 기간 ( 2022.02.08 ~ 2022.02.11 )

## 요구사항
- 컴퓨터는 중복되지 않은 임의의 수 3개를 생성한다.
    - 임의의 수 3개는 게임 도중 변경되지 않는다.
    - 새로운 게임이 시작되면 임의의 수 3개는 변경된다.
- 게임이 끝날 때 까지 사용자에게 **중복된 수 없이** 3개의 정수를 입력받는다.
- 사용자는 9번의 기회 안에 3 스트라이크를 얻어내면 승리합니다.
    - 9번의 기회 안에 3 스트라이크를 얻어내지 못하면 컴퓨터가 승리합니다.

## 함수기능
- `playGame()` : 게임시작하는 함수
- `selectMenu()` : 메뉴 출력하는 함수
- `receiveUserInputNumbers()` : 사용자 숫자 입력받는 함수
- `generateRandomNumbers()` : 범위와 수를 지정하여 랜덤 숫자를 생성하는 함수
- `calculateStrikeCount()` : 스트라이크를 계산하는 함수
- `calculateBallCount()` : 볼을 계산하는 함수
- `calculateStrikeBallWith()` : 스트라이크와 볼을 계산하는 함수
- `saveConvertedNumbers()` : 사용자 입력 숫자를 저장하는 함수
- `resetStrikeBallCount()` : 스트라이크와 볼 수를 초기
- `isNumber()` : 숫자인지 검증하는 함수
- `isHaveInRange()` : 범위안에 있는 숫자인지 검증하는 함수
- `isHaveDuplicationNumbers()` : 중복된 숫자가 없는지 검증하는 함수
- `isHaveVerifiedNumbers()` : 숫자인지와 중복여부 및 범위안에 있는 숫자인지를 Bool로 반환하는 함수
- `printPlayingGameMessage()` : 매 판마다 게임안내메세지 및 판정결과를 출력하는 함수
- `judgeGameResult()` : 사용자 또는 컴퓨터 승리를 판정하는 함수

## 어려웠던점

- 함수를 분리하는 것이 가장 어려웠다. 그 기준을 어떻게 정해야하는지 고민이다. 예를들면 `calculateStrikeBallWith()` 함수내에 스트라이크 계산과 볼을 계산하고 스트라이크 전역변수에 값을 할당하는 기능이존재한다.
  스트라이크와 볼을 같이 계산하는게 자연스러울 것같다는 생각이들지만 분리하는게 더 가독성이 좋으려나 ? 헷갈린다. 개인적으로 코딩할때 나오는 단점이 코드를 줄여야한다는 강박이있다. 하지만 피드백을 받은 것중 하나가 코드를 억지로 줄이려고 땡겨서 코드를 작성하는것은 오히려 가독성을 해친다는것이었다. 기능이 단순한게 좋으니 많이 분리할 수 있도록 해보자.

[리펙토링 전]
```Swift
func calculateStrikeBallWith(_ userNumbers: Array<Int>, and computerNumbers: Array<Int>) -> (strikeResult: Int, ballResult: Int) {
    let strikePoint = 1
    var (strikeCount, ballCount) = (Int.zero, Int.zero)
    for index in userNumbers.indices {
        strikeCount += userNumbers[index] == computerNumbers[index] ? strikePoint : .zero
    }
    ballCount = (Set(computerNumbers).intersection(userNumbers).count - strikeCount)
    strikeCounting += strikeCount
    return (strikeCount, ballCount)
}
```
[리펙토링 후]
```Swift
func calculateStrikeCount(_ userNumbers: Array<Int>, and computerNumbers: Array<Int>) {
    let strikePoint = 1
    for index in userNumbers.indices {
        strikeCount += userNumbers[index] == computerNumbers[index] ? strikePoint : .zero
    }
}

func resetStrikeBallCount() {
    strikeCount = .zero
    ballCount = .zero
}

func calculateBallCount(_ userNumbers: Array<Int>, and computerNumbers: Array<Int>) {
    ballCount = (Set(computerNumbers).intersection(userNumbers).count - strikeCount)
}

func calculateStrikeBallWith(_ userNumbers: Array<Int>, and computerNumbers: Array<Int>) {
    calculateStrikeCount(userNumbers, and: computerNumbers)
    calculateBallCount(userNumbers, and: computerNumbers)
    strikeCounting += strikeCount
}
```

[리펙토링 전]
```Swift
func playGame() {
    let onePoint = 1
    
    while remainingChangeCount > .zero {
        if isHaveVerifiedNumbers(receiveUserInputNumbers()) {
            let (strikeResult, ballResult) = calculateStrikeBallWith(userInputNumbers, and: computerNumbers)
            remainingChangeCount -= onePoint
            printPlayingGameMessage(userNumbers: userInputNumbers, ballCount: ballResult, strikeCount: strikeResult)
            if strikeCounting == endGameCount { break }
        } else {
            receiveUserInputNumbers()
        }
    }
    judgeGameResult()
}
```
[리펙토링 후]



## 문제해결
- 함수의 기능을 분리하지 않으니 가독성이 해치는걸 몸소 느꼈다. 왜냐하먄 실행도중 예상치 못한 출력메세지가 나왔는데 확인하고 에러를 찾는게 스스로 안될 정도로 복잡했떤 코드였다. 이럴때 로직을 더 월활하게 기능분리를 했으면 분명히 로직을 찾는데는 수월했을 것이다. 전역변수로 검증된 숫자를 append 메서드를 사용하여 저장하는 방식을 택했는데 1회 경기 이후 2회때부터 계속 에러가 나기시작했다. 이유는 값 초기화를 잘못했기때문이었따.
1회가 끝나고 다음 2회경기때 저장할 숫자를 전역변수에 저장하는데 = 으로 초기화하는데 아니라 append로 값을 넣었기때문에 인덱스가 6개 즉, 숫자가 계속 누적이 됬던것이었다. 문제점은 메서드기능을 잘 이해하고 사용하는점과 오류가 발생했을때 빠르게 파악하려면 함수의 기능을 최대한 분리하자.

## 깨닳은점
- 나의 기준에서는 갖잖은 기능이라도 하나의 기능만하게 함수를 분리하자. 왜냐하면 나는 코드 수를 줄이려는 안좋은 습관이있다. 이걸 이겨내려면 오로지 하나의 기능만은 추구하자. 그래야 덜 욕먹는 코드가 생성될 것
- 요구사항 조건 중에 숫자검증하는 함수가 있었는데 조건이 숫자인지, 숫자가 범위안에있는지, 중복된 숫자가없는지를 체크해야했었다. 이런 경우들을 체크할때는 Bool로 하게되면 굉장히 수월하다는것을 배웠다.
  하나의 조건이상인 되는걸 검증해야할때는 Bool로 진행하고 false가나오면 에러로직을 수정하는 방향으로 가면 좋은것같다.
- 나의 코드에 국한되어있지말고 다른 캠퍼들이 어떻게 코드를 작성했는지 시간을 내서라도 확인하자. 분명히 배울점이 많았다. 고차함수나, 가독성있는코드, 네이밍 등 좋은 아이디어를 떠올리게 해주기도하는 영양분이었다.
  막막하거나 답답하게 코드가 짜지지않을때에는 캠퍼들의 코드를 확인해보거나 조언을 구해보자.

## 구현시 사용한 메서드 및 타입
- compactMap, filter
- Set, intersection
- ClosedRange
- Array
- indices
- readLine
- switch
- while
- guard
- Bool
- replacingOccurrences, trimmingCharacters, component


## 공부한 키워드
- Set
- Optional Type
- Hard Coding
- git restore
