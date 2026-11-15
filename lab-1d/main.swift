import Foundation

let studentName: String? = "Ahana"
let studentAge: Int? = 20
let studentCity: String? = nil

if let name = studentName {
    print("Student Name:", name)
} else {
    print("Student name is not available")
}

if let age = studentAge {
    print("Student Age:", age)
} else {
    print("Student age is not available")
}

if let city = studentCity {
    print("Student City:", city)
} else {
    print("Student city is not available")
}



let cityName = studentCity ?? "Delhi"
print("City:", cityName)

let displayName = studentName ?? "Unknown"
print("Name:", displayName)



let studentMarks: [Int: Int] = [
    101: 85,
    102: 90,
    103: 75,
    104: 65
]

func getMarks(studentID: Int) -> Int? {
    return studentMarks[studentID]
}

if let marks = getMarks(studentID: 101) {
    print("Student ID: 101")
    print("Marks:", marks)
} else {
    print("Student not found")
}

if let marks = getMarks(studentID: 110) {
    print("Marks:", marks)
} else {
    print("Student ID 110 not found")
}



func showStudentMarks(studentID: Int) {

    guard let marks = getMarks(studentID: studentID) else {
        print("Student ID \(studentID) not found")
        return
    }

    print("Student ID:", studentID)
    print("Student Marks:", marks)
}

showStudentMarks(studentID: 102)
showStudentMarks(studentID: 999)



struct StudentProfile {

    var name: String
    var address: String?
    var phone: String?
}

let student = StudentProfile(
    name: "Ahana",
    address: nil,
    phone: "9876543210"
)

print("Student Name:", student.name)

if let address = student.address {
    print("Address:", address)
} else {
    print("Address is not available")
}

if let phone = student.phone {
    print("Phone:", phone)
} else {
    print("Phone is not available")
}

let addressLength = student.address?.count
print("Address Length:", addressLength ?? 0)


let name: String? = ""

if let studentName = name {

    if studentName.isEmpty {
        print("Name cannot be empty")
    } else {
        print("Student Name:", studentName)
    }

} else {
    print("Name is nil")
}


let testIDs = [101, 102, 103, 105, 110, 999]

for id in testIDs {

    if let marks = getMarks(studentID: id) {
        print("Student ID \(id): Marks = \(marks)")
    } else {
        print("Student ID \(id): Student not found")
    }
}


print("Student Name:", displayName)
print("Student City:", cityName)

if let marks = getMarks(studentID: 101) {
    print("Student Marks:", marks)
}

print("\nProgram Completed Successfully!")
