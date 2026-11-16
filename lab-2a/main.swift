
import Foundation

func calculateMean(of numbers: [Double]) -> Double {
    if numbers.isEmpty {
        return 0
    }
    var sum = 0.0
    for n in numbers {
        sum += n
    }
    return sum / Double(numbers.count)
}

func findMaximum(in numbers: [Int]) -> Int? {
    if numbers.isEmpty {
        return nil
    }
    var biggest = numbers[0]
    for n in numbers {
        if n > biggest {
            biggest = n
        }
    }
    return biggest
}

func isValidEmail(_ email: String) -> Bool {
    let parts = email.split(separator: "@", omittingEmptySubsequences: false)

    if parts.count != 2 {
        return false
    }
    let name = parts[0]
    let domain = parts[1]
    if name.isEmpty || domain.isEmpty {
        return false
    }

    return domain.contains(".") && !domain.hasPrefix(".") && !domain.hasSuffix(".")
}

func formatDisplayName(first: String, last: String) -> String {
    let f = first.trimmingCharacters(in: .whitespaces).capitalized
    let l = last.trimmingCharacters(in: .whitespaces).capitalized
    return "\(f) \(l)"
}

func isPassing(mark: Int, passMark: Int = 40) -> Bool {
    return mark >= passMark
}

struct Transaction {
    let title: String
    let amount: Double
    let category: String
}

let transactions = [
    Transaction(title: "Salary", amount: 20000, category: "Income"),
    Transaction(title: "Groceries", amount: -1500, category: "Food"),
    Transaction(title: "Pizza", amount: -400, category: "Food"),
    Transaction(title: "Bus pass", amount: -800, category: "Travel"),
    Transaction(title: "Movie", amount: -350, category: "Fun")
]

let expenses = transactions.filter { $0.amount < 0 }

let expenseAmounts = expenses.map { -$0.amount }

let totalExpense = expenseAmounts.reduce(0, +)

func totalExpenseWithLoop(_ list: [Transaction]) -> Double {
    var total = 0.0
    for t in list {
        if t.amount < 0 {
            total += -t.amount
        }
    }
    return total
}

struct Student {
    let name: String
    let marks: Int
}

let students = [
    Student(name: "Riya", marks: 85),
    Student(name: "Aman", marks: 90),
    Student(name: "Neha", marks: 85),
    Student(name: "Karan", marks: 70)
]

let sortedStudents = students.sorted { first, second in
    if first.marks == second.marks {
        return first.name < second.name
    }
    return first.marks > second.marks
}

func spendingByCategory(_ list: [Transaction]) -> [String: Double] {
    let onlyExpenses = list.filter { $0.amount < 0 }
    var result: [String: Double] = [:]
    for t in onlyExpenses {
        result[t.category, default: 0] += -t.amount
    }
    return result
}

func spendingByCategoryReduce(_ list: [Transaction]) -> [String: Double] {
    return list
        .filter { $0.amount < 0 }
        .reduce(into: [String: Double]()) { dict, t in
            dict[t.category, default: 0] += -t.amount
        }
}

var testNumber = 1
func check(_ description: String, _ passed: Bool) {
    print("Test \(testNumber) | \(description) | \(passed ? "PASS" : "FAIL")")
    testNumber += 1
}

print("---- Lab 2A test table ----")
check("mean of [1,2,3,4] = 2.5", calculateMean(of: [1, 2, 3, 4]) == 2.5)
check("mean of empty array = 0", calculateMean(of: []) == 0)
check("max of [3,9,2] = 9", findMaximum(in: [3, 9, 2]) == 9)
check("max of empty array = nil", findMaximum(in: []) == nil)
check("email 'abc@gmail.com' valid", isValidEmail("abc@gmail.com"))
check("email 'abcgmail.com' invalid", !isValidEmail("abcgmail.com"))
check("email 'a@b' invalid (no dot)", !isValidEmail("a@b"))
check("display name 'riya' 'SHARMA' -> Riya Sharma", formatDisplayName(first: "riya", last: "SHARMA") == "Riya Sharma")
check("mark 40 is passing", isPassing(mark: 40))
check("mark 39 is not passing", !isPassing(mark: 39))
check("total expense = 3050", totalExpense == 3050)
check("loop and reduce give same total", totalExpenseWithLoop(transactions) == totalExpense)
check("sorted: first student is Aman", sortedStudents[0].name == "Aman")
check("sorted: tie handled (Neha before Riya)", sortedStudents[1].name == "Neha" && sortedStudents[2].name == "Riya")

print("\nSorted students:")
for s in sortedStudents {
    print("\(s.name) - \(s.marks)")
}

print("\nSpending by category:")
for (category, amount) in spendingByCategory(transactions).sorted(by: { $0.key < $1.key }) {
    print("\(category): \(amount)")
}
