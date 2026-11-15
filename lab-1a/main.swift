

import Foundation

//Task 1: Student Details

let studentName = "Ahana"
let rollNumber = 101

let subject1 = 85
let subject2 = 78
let subject3 = 90
let subject4 = 65
let subject5 = 80

let attendance = 85.0

// Calculate total marks
var totalMarks = 0

totalMarks += subject1
totalMarks += subject2
totalMarks += subject3
totalMarks += subject4
totalMarks += subject5

// Calculate average and percentage
let average = Double(totalMarks) / 5
let percentage = (Double(totalMarks) / 500) * 100

// Check pass or fail
var isPass = true

if subject1 < 40 || subject2 < 40 ||
   subject3 < 40 || subject4 < 40 ||
   subject5 < 40 || attendance < 75 {
    isPass = false
}

print("Name: \(studentName)")
print("Roll Number: \(rollNumber)")
print("Total Marks: \(totalMarks)")
print("Average: \(average)")
print("Percentage: \(percentage)%")
print("Attendance: \(attendance)%")

if isPass {
    print("Result: Pass")
} else {
    print("Result: Fail")
}


//Task 2: Operators


let a = 20
let b = 10

print("Addition:", a + b)
print("Subtraction:", a - b)
print("Multiplication:", a * b)
print("Division:", a / b)
print("Remainder:", a % b)


// Comparison Operators


print(a == b)
print(a != b)
print(a > b)
print(a < b)
print(a >= b)
print(a <= b)


// Logical Operators


let age = 20
let hasID = true

print(age >= 18 && hasID)
print(age >= 18 || hasID)
print(!hasID)


// Compound Assignment Operators


var marks = 50

marks += 10
print("After += :", marks)

marks -= 5
print("After -= :", marks)

marks *= 2
print("After *= :", marks)

marks /= 2
print("After /= :", marks)


// Nil Coalescing Operator


var studentCity: String? = nil

let city = studentCity ?? "Unknown"

print("City:", city)


//Task 3: Grade Calculation


var grade = ""

if isPass {
    switch average {
    case 90...100:
        grade = "A"
    case 80..<90:
        grade = "B"
    case 70..<80:
        grade = "C"
    case 60..<70:
        grade = "D"
    case 40..<60:
        grade = "E"
    default:
        grade = "F"
    }
} else {
    grade = "F"
}

print("Student Name: \(studentName)")
print("Total Marks: \(totalMarks)/500")
print("Average: \(String(format: "%.2f", average))")
print("Grade: \(grade)")


func checkResult(marks: Int, attendance: Double) {

    print("\nMarks: \(marks), Attendance: \(attendance)%")

    if marks >= 0 && marks <= 100 {
        print("Marks are valid")
    } else {
        print("Invalid marks")
    }

    if attendance >= 0 && attendance <= 100 {
        print("Attendance is valid")
    } else {
        print("Invalid attendance")
    }

    if marks >= 0 && marks <= 100 &&
       attendance >= 0 && attendance <= 100 {

        if marks < 40 || attendance < 75 {
            print("Result: Fail")
        } else {
            print("Result: Pass")
        }
    }
}


// Test Case 1
checkResult(marks: 0, attendance: 75)

// Test Case 2
checkResult(marks: 100, attendance: 100)

// Test Case 3
checkResult(marks: 39, attendance: 85)

// Test Case 4
checkResult(marks: 40, attendance: 75)

// Test Case 5
checkResult(marks: 85, attendance: 74)

// Test Case 6
checkResult(marks: 101, attendance: 80)

// Test Case 7
checkResult(marks: -5, attendance: 80)

// Test Case 8
checkResult(marks: 80, attendance: 105)


//Task 5: Reusable Grade Function

func calculateGrade(average: Double) -> String {

    if average >= 90 {
        return "A"
    } else if average >= 80 {
        return "B"
    } else if average >= 70 {
        return "C"
    } else if average >= 60 {
        return "D"
    } else if average >= 40 {
        return "E"
    } else {
        return "F"
    }
}


let finalGrade = calculateGrade(average: average)

print("Average Marks: \(average)")
print("Final Grade: \(finalGrade)")
