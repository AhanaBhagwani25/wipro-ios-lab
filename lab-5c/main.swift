import Foundation

struct CourseDetail {
    let id: Int
    let title: String
}

enum FetchError: Error {
    case notFound(Int)
}

func fetchCourseDetail(id: Int, failingID: Int? = nil) async throws -> CourseDetail {
    try await Task.sleep(nanoseconds: 1_000_000_000)
    if id == failingID {
        throw FetchError.notFound(id)
    }
    return CourseDetail(id: id, title: "Course \(id)")
}

func fetchSequentially(ids: [Int]) async throws -> [CourseDetail] {
    var results: [CourseDetail] = []
    for id in ids {
        let detail = try await fetchCourseDetail(id: id)
        results.append(detail)
    }
    return results
}

func fetchConcurrently(ids: [Int], failingID: Int? = nil) async throws -> [CourseDetail] {
    try await withThrowingTaskGroup(of: CourseDetail.self) { group in
        for id in ids {
            group.addTask {
                try await fetchCourseDetail(id: id, failingID: failingID)
            }
        }

        var results: [CourseDetail] = []
        for try await detail in group {
            results.append(detail)
        }
        return results.sorted { $0.id < $1.id }
    }
}

func fetchPartialResults(ids: [Int], failingID: Int? = nil) async -> (found: [CourseDetail], failedIDs: [Int]) {
    await withTaskGroup(of: (Int, CourseDetail?).self) { group in
        for id in ids {
            group.addTask {
                let detail = try? await fetchCourseDetail(id: id, failingID: failingID)
                return (id, detail)
            }
        }

        var found: [CourseDetail] = []
        var failedIDs: [Int] = []
        for await (id, detail) in group {
            if let detail = detail {
                found.append(detail)
            } else {
                failedIDs.append(id)
            }
        }
        return (found.sorted { $0.id < $1.id }, failedIDs)
    }
}

func fetchInBatches(ids: [Int], batchSize: Int) async throws -> [CourseDetail] {
    var all: [CourseDetail] = []
    var startIndex = 0

    while startIndex < ids.count {
        let endIndex = min(startIndex + batchSize, ids.count)
        let batch = Array(ids[startIndex..<endIndex])
        let batchResult = try await fetchConcurrently(ids: batch)
        all.append(contentsOf: batchResult)
        startIndex = endIndex
    }
    return all
}

func secondsSince(_ start: Date) -> String {
    return String(format: "%.1f", Date().timeIntervalSince(start))
}

let courseIDs = [1, 2, 3, 4, 5]

print("--- Sequential ---")
var startTime = Date()
let sequentialResults = try await fetchSequentially(ids: courseIDs)
print("Got \(sequentialResults.count) courses in \(secondsSince(startTime)) seconds")

print("\n--- Concurrent (task group) ---")
startTime = Date()
let concurrentResults = try await fetchConcurrently(ids: courseIDs)
print("Got \(concurrentResults.count) courses in \(secondsSince(startTime)) seconds")
for course in concurrentResults {
    print(course.title)
}

print("\n--- One child fails: whole operation fails ---")
do {
    let results = try await fetchConcurrently(ids: courseIDs, failingID: 4)
    print("Got \(results.count) courses")
} catch {
    print("Whole operation failed: \(error)")
}

print("\n--- One child fails: return partial results ---")
let partial = await fetchPartialResults(ids: courseIDs, failingID: 4)
print("Found: \(partial.found.map { $0.title })")
print("Failed IDs: \(partial.failedIDs)")

print("\n--- Cancellation ---")
let longTask = Task {
    try await fetchConcurrently(ids: courseIDs)
}
try await Task.sleep(nanoseconds: 300_000_000)
longTask.cancel()
do {
    _ = try await longTask.value
    print("Finished normally")
} catch {
    print("Task was cancelled: \(error)")
}

print("\n--- Batches of 3 (10 courses) ---")
startTime = Date()
let batchResults = try await fetchInBatches(ids: Array(1...10), batchSize: 3)
print("Got \(batchResults.count) courses in \(secondsSince(startTime)) seconds")
