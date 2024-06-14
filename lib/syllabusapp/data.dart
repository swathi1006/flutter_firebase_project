// data.dart
class Elective{
  final String elective;

  Elective(this.elective);
}
class Subject {
  final String name;
  final int? i;
  //final String details;
  final List<Elective>? electives;

  Subject(this.name, {this.i,this.electives,});
}

class Semester {
  final String name;
  final List<Subject> subjects;
  final String subcname;

  Semester(this.name, this.subjects,{required this.subcname});
}

class Branch {
  final String name;
  final List<Semester> semesters;
  final String? docname;

  Branch(this.name, this.semesters, { this.docname});
}

class Course {
  final String name;
  final List<Branch> branches;

  Course(this.name, this.branches);
}

List<Course> courses = [
  Course('B.Tech', [
    Branch('Branch 1', [
      Semester('Semester 1', [
        Subject('Subject 1', i: 0),
        Subject('Subject 2', i: 1),
        // Add more subjects
      ],subcname: "sem1"),
      Semester('Semester 2', [
        Subject('Subject 1',i: 0 ),
        Subject('Subject 2', i:1 ),
        Subject('Subject 3',electives:[Elective("abcde"),
          Elective("elective 2")]),
        // Add more subjects
      ],subcname: "sem2"),
      // Add more semesters
    ], docname: 'ece'),
    Branch('Branch 2', [
      Semester('Semester 1', [
        Subject('Subject 1', i: 0),
        Subject('Subject 2', i: 1),
        // Add more subjects
      ],subcname: "sem1"),
      // Add semesters and subjects
    ], docname: 'eee'),
    Branch('Branch 3', [ // Add semesters and subjects
    ]),
  ]),

  Course('B.Arch', [
    Branch('Branch 1', [
      // Add semesters and subjects
    ]),
    Branch('Branch 2', [
      // Add semesters and subjects
    ]),
    Branch('Branch 3', [
      // Add semesters and subjects
    ]),
    Branch('Branch 4', [
      // Add semesters and subjects
    ]),
  ]),

  Course('B.Des', [
    Branch('Branch 1', [
      // Add semesters and subjects
    ]),
    Branch('Branch 2', [
      // Add semesters and subjects
    ]),
    Branch('Branch 3', [
      // Add semesters and subjects
    ]),
    Branch('Branch 4', [
      // Add semesters and subjects
    ]),
    Branch('Branch 5', [
      // Add semesters and subjects
    ]),
  ]),
];
