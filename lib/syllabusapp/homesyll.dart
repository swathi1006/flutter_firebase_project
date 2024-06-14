import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'data.dart';

class CoursesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Courses')),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(courses[index].name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BranchScreen(courses[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class BranchScreen extends StatelessWidget {
  final Course course;

  BranchScreen(this.course);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(course.name)),
      body: ListView.builder(
        itemCount: course.branches.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(course.branches[index].name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SemestersScreen(course.branches[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SemestersScreen extends StatelessWidget {
  final Branch branch;

  SemestersScreen(this.branch);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(branch.name)),
      body: ListView.builder(
        itemCount: branch.semesters.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(branch.semesters[index].name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubjectsScreen(branch.semesters[index],branch.docname!),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SubjectsScreen extends StatelessWidget {
  final Semester semester;
  final String docname;

  // final Subject subject;

  SubjectsScreen(this.semester, this.docname,);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(semester.name)),
      body: ListView.builder(
        itemCount: semester.subjects.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(semester.subjects[index].name),
            onTap: () {
              if (semester.subjects[index].electives != null && semester.subjects[index].electives!.isNotEmpty){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ElectivesScreen(semester.subjects[index].electives!),
                  ),
                );
              }else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubjectDetailScreen(semester.subjects[index],semester.subjects[index].i!,semester.subcname,docname),
                  ),
                );
              }

            },
          );
        },
      ),
    );
  }
}

class ElectivesScreen extends StatelessWidget {
  final List<Elective> electives;

  ElectivesScreen(this.electives);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Electives')),
      body: ListView.builder(
        itemCount: electives.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(electives[index].elective),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ElectiveDetailScreen(electives[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


class SubjectDetailScreen extends StatefulWidget {
  final int i;
  final Subject subject;
  final String subcname;
  final String docname;

  SubjectDetailScreen(this.subject, this.i, this.subcname, this.docname,);

  @override
  State<SubjectDetailScreen> createState() => _SubjectDetailScreenState();
}

class _SubjectDetailScreenState extends State<SubjectDetailScreen> {


  //late CollectionReference _syllabusCollection;
  late CollectionReference _subCollectionReference;

  @override
  void initState() {
   // _syllabusCollection = FirebaseFirestore.instance.collection("sem1");
    CollectionReference mainCollection = FirebaseFirestore.instance.collection("btech");
    DocumentReference documentReference = mainCollection.doc(widget.docname); // Replace with your document ID
    _subCollectionReference = documentReference.collection(widget.subcname); //
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.subject.name)),
      body: StreamBuilder<QuerySnapshot>(
          stream: readsyllabus(),
          builder: (context, AsyncSnapshot snapshot){
            if(snapshot.hasError){
              return Center(child: Text("Error : ${snapshot.error}"));
            }
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            }
           // final dsyllabus = snapshot.data!.docs;
            final dsyllabus = snapshot.data!.docs;

            final syll = dsyllabus[widget.subject.i];
            final module1 = syll['module1'];
            final m1syll = syll['m1syll'];
            final module2 = syll['module2'];
            final m2syll = syll['m2syll'];

            return Padding(
                padding: const EdgeInsets.all(28.0),
                child:
                Column(
                  children: [
                    Text(module1,style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 20,),
                    Text(m1syll),
                    SizedBox(height: 30,),
                    Text(module2,style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 20,),
                    Text(m2syll),
                  ],
                )

            );
          }),
    );
  }

  Stream<QuerySnapshot> readsyllabus(){
   // return _syllabusCollection.snapshots();
    return _subCollectionReference.snapshots();
  }
}

class ElectiveDetailScreen extends StatelessWidget {
  final Elective elective;

  ElectiveDetailScreen(this.elective);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(elective.elective)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Details of ${elective.elective}'),
      ),
    );
  }
}
