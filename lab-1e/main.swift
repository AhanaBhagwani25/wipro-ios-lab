import Foundation

struct Course {
    var courseName: String
    var duration: Int
}

var course1 = Course(courseName: "Swift", duration: 3)
var course2 = course1

course2.courseName = "iOS Development"
course2.duration = 6

print("Course 1:", course1.courseName)
print("Course 1 Duration:", course1.duration)
print("Course 2:", course2.courseName)
print("Course 2 Duration:", course2.duration)




class CourseManager {
    var courseName: String

    init(courseName: String) {
        self.courseName = courseName
    }
}

let manager1 = CourseManager(courseName: "Swift Programming")
let manager2 = manager1

manager2.courseName = "Advanced Swift"

print("Manager 1 Course:", manager1.courseName)
print("Manager 2 Course:", manager2.courseName)




struct Student {
    var name: String
}

class Teacher {
    var name: String

    init(name: String) {
        self.name = name
    }
}

var student1 = Student(name: "Ahana")
var student2 = student1

student2.name = "Riya"

print("Student 1:", student1.name)
print("Student 2:", student2.name)

let teacher1 = Teacher(name: "Neha")
let teacher2 = teacher1

teacher2.name = "Priya"

print("Teacher 1:", teacher1.name)
print("Teacher 2:", teacher2.name)




class Classroom {
    weak var teacher: Teacher?

    init() {
        print("Classroom created")
    }

    deinit {
        print("Classroom released from memory")
    }
}

class TeacherWithClassroom {
    var name: String
    var classroom: Classroom?

    init(name: String) {
        self.name = name
        print("Teacher created:", name)
    }

    deinit {
        print("Teacher released from memory:", name)
    }
}

var teacher: TeacherWithClassroom? = TeacherWithClassroom(name: "Anita")
var classroom: Classroom? = Classroom()

teacher?.classroom = classroom
classroom?.teacher = nil

teacher = nil
classroom = nil



class Department {
    var name: String
    var employees: [Employee] = []

    init(name: String) {
        self.name = name
        print("Department created:", name)
    }

    deinit {
        print("Department released from memory")
    }
}

class Employee {
    var name: String
    weak var department: Department?

    init(name: String) {
        self.name = name
        print("Employee created:", name)
    }

    deinit {
        print("Employee released from memory:", name)
    }
}

var department: Department? = Department(name: "IT")
var employee: Employee? = Employee(name: "Ahana")

department?.employees.append(employee!)
employee?.department = department

department = nil
employee = nil



class Person {
    var name: String

    init(name: String) {
        self.name = name
        print("Person created:", name)
    }

    func showMessage() -> () -> Void {
        return { [weak self] in
            guard let self = self else {
                print("Person no longer exists")
                return
            }

            print("Hello", self.name)
        }
    }

    deinit {
        print("Person released from memory")
    }
}

var person: Person? = Person(name: "Ahana")
var greeting = person?.showMessage()

greeting?()

person = nil

greeting?()
