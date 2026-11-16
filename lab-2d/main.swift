import Foundation

enum ValidationError: Error {
    case emptyName
    case invalidMark
    case invalidID
}

struct Student {
    let id: Int
    let name: String
    let mark: Int
}

func registerStudent(id: Int, name: String, mark: Int) throws -> Student {
    if name.trimmingCharacters(in: .whitespaces).isEmpty {
        throw ValidationError.emptyName
    }
    if mark < 0 || mark > 100 {
        throw ValidationError.invalidMark
    }
    if id <= 0 {
        throw ValidationError.invalidID
    }
    return Student(id: id, name: name, mark: mark)
}

func tryRegister(id: Int, name: String, mark: Int) {
    do {
        let student = try registerStudent(id: id, name: name, mark: mark)
        print("Success: \(student.name) registered with ID \(student.id)")
    } catch ValidationError.emptyName {
        print("Error: name cannot be empty")
    } catch ValidationError.invalidMark {
        print("Error: mark must be between 0 and 100")
    } catch ValidationError.invalidID {
        print("Error: ID must be a positive number")
    } catch {
        print("Unknown error: \(error)")
    }
}

func registerOptional(id: Int, name: String, mark: Int) -> Student? {
    return try? registerStudent(id: id, name: name, mark: mark)
}

func registerResult(id: Int, name: String, mark: Int) -> Result<Student, ValidationError> {
    if name.trimmingCharacters(in: .whitespaces).isEmpty {
        return .failure(.emptyName)
    }
    if mark < 0 || mark > 100 {
        return .failure(.invalidMark)
    }
    if id <= 0 {
        return .failure(.invalidID)
    }
    return .success(Student(id: id, name: name, mark: mark))
}

print("---- Test cases ----")
tryRegister(id: 1, name: "Riya", mark: 85)
tryRegister(id: 2, name: "", mark: 70)
tryRegister(id: 3, name: "Aman", mark: 150)
tryRegister(id: -4, name: "Neha", mark: 60)

print("\n---- Optional version ----")
if let s = registerOptional(id: 5, name: "Karan", mark: 90) {
    print("Optional worked:", s.name)
}
if registerOptional(id: 6, name: "", mark: 90) == nil {
    print("Optional returned nil (but we don't know the reason)")
}

print("\n---- Result version ----")
switch registerResult(id: 7, name: "Pooja", mark: -5) {
case .success(let student):
    print("Registered", student.name)
case .failure(let error):
    print("Result failed with:", error)
}

enum NetworkError: Error {
    case noInternet
    case serverDown
    case badData
}

func fakeNetworkCall(code: Int) -> Result<String, NetworkError> {
    switch code {
    case 200:
        return .success("Data received")
    case 0:
        return .failure(.noInternet)
    case 500:
        return .failure(.serverDown)
    default:
        return .failure(.badData)
    }
}

func friendlyMessage(for error: NetworkError) -> String {
    switch error {
    case .noInternet:
        return "No internet connection. Please check your Wi-Fi."
    case .serverDown:
        return "Server is not working right now. Try again later."
    case .badData:
        return "Something went wrong with the data."
    }
}

print("\n---- Network simulation ----")
for code in [200, 0, 500, 404] {
    switch fakeNetworkCall(code: code) {
    case .success(let message):
        print(message)
    case .failure(let error):
        print(friendlyMessage(for: error))
    }
}
