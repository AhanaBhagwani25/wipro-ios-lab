
import Foundation


var courses = ["Swift", "Python", "Java", "C++"]

print("All Courses:", courses)

courses.append("JavaScript")
print("After Adding:", courses)

courses.remove(at: 2)
print("After Removing:", courses)

courses.sort()
print("Sorted Courses:", courses)

let filteredCourses = courses.filter { $0.count > 4 }
print("Courses with more than 4 letters:", filteredCourses)

if courses.contains("Swift") {
    print("Swift course is available")
} else {
    print("Swift course is not available")
}



var studentIDs: Set<Int> = [101, 102, 103, 101, 104]

print("Student IDs:", studentIDs)

print("Total Unique Students:", studentIDs.count)

studentIDs.insert(105)
print("After Adding:", studentIDs)

studentIDs.remove(102)
print("After Removing:", studentIDs)

if studentIDs.contains(103) {
    print("Student ID 103 is present")
} else {
    print("Student ID 103 is not present")
}



var studentMarks = [
    "Ahana": 85,
    "Riya": 90,
    "Aman": 75,
    "Rahul": 65,
    "Priya": 95
]

for (name, marks) in studentMarks {
    print("\(name): \(marks)")
}

studentMarks["Karan"] = 80

print("\nAfter Adding Student:")
print(studentMarks)

studentMarks["Aman"] = 82

print("\nAfter Updating Marks:")
print(studentMarks)

if let marks = studentMarks["Ahana"] {
    print("Ahana's Marks:", marks)
} else {
    print("Student not found")
}

studentMarks.removeValue(forKey: "Rahul")

print("\nAfter Removing Student:")
print(studentMarks)

var topperName = ""
var highestMarks = 0

for (name, marks) in studentMarks {
    if marks > highestMarks {
        highestMarks = marks
        topperName = name
    }
}

print("\nTopper Name:", topperName)
print("Highest Marks:", highestMarks)

print("\nStudents Scoring Below 80:")

for (name, marks) in studentMarks {
    if marks < 80 {
        print(name, marks)
    }
}



enum TaskPriority {
    case low
    case medium
    case high
}

let priority = TaskPriority.high

switch priority {

case .low:
    print("Task Priority: Low")

case .medium:
    print("Task Priority: Medium")

case .high:
    print("Task Priority: High")
}


enum OrderStatus {
    case placed
    case shipped
    case delivered
    case cancelled
}

let order = OrderStatus.shipped

switch order {

case .placed:
    print("Your order has been placed")

case .shipped:
    print("Your order has been shipped")

case .delivered:
    print("Your order has been delivered")

case .cancelled:
    print("Your order has been cancelled")
}



print("Total Courses:", courses.count)
print("Total Unique Students:", studentIDs.count)
print("Total Students:", studentMarks.count)
print("Topper:", topperName)
print("Topper Marks:", highestMarks)

print("\nProgram Completed Successfully!")
