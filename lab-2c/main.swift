import Foundation

protocol Displayable {
    var displayText: String { get }
}

struct Student: Displayable {
    let name: String
    let marks: Int

    var displayText: String {
        return "Student: \(name), Marks: \(marks)"
    }
}

struct Course: Displayable {
    let title: String
    let credits: Int

    var displayText: String {
        return "Course: \(title) (\(credits) credits)"
    }
}

extension String {

    var isBlank: Bool {
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

extension Int {
    var isEven: Bool {
        return self % 2 == 0
    }
}

struct Stack<T> {
    private var items: [T] = []

    var isEmpty: Bool {
        return items.isEmpty
    }

    var count: Int {
        return items.count
    }

    mutating func push(_ item: T) {
        items.append(item)
    }

    mutating func pop() -> T? {
        return items.popLast()
    }

    func peek() -> T? {
        return items.last
    }
}

func largest<T: Comparable>(in items: [T]) -> T? {
    guard var biggest = items.first else {
        return nil
    }
    for item in items {
        if item > biggest {
            biggest = item
        }
    }
    return biggest
}

protocol Summarizable {
    func summary() -> String
}

extension Stack: Summarizable {
    func summary() -> String {
        if isEmpty {
            return "Stack is empty"
        }
        return "Stack has \(count) items, top = \(peek()!)"
    }
}

let s1 = Student(name: "Riya", marks: 88)
let c1 = Course(title: "Swift Basics", credits: 4)
assert(s1.displayText == "Student: Riya, Marks: 88")
assert(c1.displayText == "Course: Swift Basics (4 credits)")

assert("   ".isBlank == true)
assert("hello".isBlank == false)
assert(10.isEven == true)
assert(7.isEven == false)

var intStack = Stack<Int>()
assert(intStack.isEmpty)
assert(intStack.pop() == nil)
intStack.push(10)
intStack.push(20)
assert(intStack.peek() == 20)
assert(intStack.pop() == 20)
assert(intStack.count == 1)

var stringStack = Stack<String>()
stringStack.push("a")
stringStack.push("b")
assert(stringStack.peek() == "b")

assert(largest(in: [3, 8, 2]) == 8)
assert(largest(in: ["apple", "mango", "banana"]) == "mango")
assert(largest(in: [Int]()) == nil)

print(s1.displayText)
print(c1.displayText)
print(intStack.summary())
print(stringStack.summary())
print("All assertions passed!")
