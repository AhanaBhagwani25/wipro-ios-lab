import Foundation

struct Student {
    let name: String
    let marks: Int
}

let students = [
    Student(name: "Riya", marks: 85),
    Student(name: "Aman", marks: 90),
    Student(name: "Karan", marks: 70)
]

let byMarks = students.sorted(by: { (a: Student, b: Student) -> Bool in
    return a.marks > b.marks
})
print("Sorted by marks:", byMarks.map { $0.name })

func loadStudentData(completion: (String) -> Void) {
    print("Loading data...")

    let result = "Data loaded for \(students.count) students"
    completion(result)
}

let sortedShort = students.sorted { $0.marks > $1.marks }

let sortedExplicit = students.sorted { first, second in
    return first.marks > second.marks
}
print("Shorthand:", sortedShort.map { $0.name })
print("Explicit :", sortedExplicit.map { $0.name })

loadStudentData { message in
    print("Completion called ->", message)
}

func makeCounter() -> () -> Int {
    var count = 0
    return {
        count += 1
        return count
    }
}

let counterA = makeCounter()
let counterB = makeCounter()
print(counterA(), counterA(), counterA())
print(counterB())

class DownloadManager {
    var name = "Downloader"
    var onFinish: (() -> Void)?

    func setup() {

        onFinish = { [weak self] in
            print("Finished \(self?.name ?? "unknown")")
        }
    }

    deinit {
        print("DownloadManager is removed from memory")
    }
}

do {
    let manager = DownloadManager()
    manager.setup()
    manager.onFinish?()
}

func retry(times: Int, operation: () -> Bool) -> Bool {
    var attempt = 1
    while attempt <= times {
        print("Attempt \(attempt)")
        if operation() {
            print("Success!")
            return true
        }
        attempt += 1
    }
    print("Failed after \(times) attempts")
    return false
}

var tries = 0
let done = retry(times: 5) {
    tries += 1
    return tries == 3
}
print("Retry result:", done)
