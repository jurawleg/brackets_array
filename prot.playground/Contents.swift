import Foundation

class ArrayParser {

    enum ArrayError: Error {
        case arrayIsGood
        case arrayIsEmpty
        case expressionIsOdd
        case badExpressionSyntax
        case firstBracketError
        case lastBracketError
        case openClosedDifference

        var description: String {
            switch self {
            case .arrayIsGood: return "Everything is good!"
            case .arrayIsEmpty: return "Array is empty, nothing to parse"
            case .expressionIsOdd: return "Amount of brackets is odd, check expression."
            case .badExpressionSyntax: return "Expression is broken."
            case .firstBracketError: return "First bracket is not opening."
            case .lastBracketError: return "Last bracket is not closing."
            case .openClosedDifference: return "Different amount of open and closed brackets."
            }
        }
    }

    var type: ArrayError
    
    var details: String?

    init(_ type: ArrayError, details: String? = nil) {
        self.type = type
        self.details = details
    }
}

func preCheckArray(array: [String]) -> ArrayParser? {

    if array.isEmpty {
        return ArrayParser(.arrayIsEmpty)
    }
    
    if array.first != "(" {
        return ArrayParser(.firstBracketError)
    }
    
    if array.last != ")" {
        return ArrayParser(.lastBracketError)
    }
    
    if array.count%2 != 0 {
        return ArrayParser(.expressionIsOdd)
    }
    
    var openBracketCounter: Int = 0
    var closeBracketCounter: Int = 0

    _ = array.map {
        $0 == "(" ? (openBracketCounter += 1) : (closeBracketCounter += 1)
    }

    if openBracketCounter != closeBracketCounter {
        return ArrayParser(.openClosedDifference)
    }

    return nil
}

enum ArrayCheckingResult {
    case success
    case failure(ArrayParser)
}

func anotherCheckMethod(array: [String]) -> ArrayParser {
    var brackets = 0

    for index in 0..<array.count {
        if array[index] == "(" {
            brackets += 1
        } else {
            if brackets != 0 {
                brackets -= 1
            } else {
                return ArrayParser(.badExpressionSyntax, details: "Unexpected bracket type at \(index) index")
            }
        }
    }

    if brackets == 0 {
        return ArrayParser(.arrayIsGood)
    }

    return ArrayParser(.badExpressionSyntax)
}

func checkArray(array: [String]) -> ArrayCheckingResult {

    if let error = preCheckArray(array: array) {
        return .failure(error)
    }

    let result = anotherCheckMethod(array: array)

    if result.type == .arrayIsGood {
        return .success
    } else {
        return .failure(result)
    }
}

// TEST
var badRow = ["(", ")", "(", ")", "(", "(", "(", "("]
var goodRow = ["(", "(", ")", ")",]
var pseudoGoodRow = ["(", ")", ")", "(", "(", ")"]
var emptyRow: [String] = []
var oddRow = ["(", ")", ")"]
var firstRow = [")", ")", ")"]
var lastRow = ["(", ")", "("]


var rows = [badRow, goodRow, pseudoGoodRow, emptyRow, oddRow, firstRow, lastRow]

for row in rows {
    switch checkArray(array: row) {
        case .success:
        print("Array is good!")

        case .failure(let error):
        var errorDescription = "Array is bad, reason - \(error.type.description)"
        if let details = error.details { errorDescription.append(", details - \(details)") }
        print(errorDescription)
    }

}
