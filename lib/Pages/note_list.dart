import 'package:flutter/material.dart';
import 'package:flutter_notkeeper/Pages/note_details.dart';
import 'package:flutter_notkeeper/helper/database_helper.dart';
import 'package:flutter_notkeeper/models/note.dart';


class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  int count =0;
  DatabaseHelper databaseHelper =new DatabaseHelper();
  List<Note> noteList;
  var scaffoldkey = GlobalKey<ScaffoldState>();

  Color getPriorityColor(int pos){
    switch(pos){
      case 1 : return Colors.green;
      break;
      default: return Colors.red;
      break;
    }
  }

  Icon getPriorityIcon(int pos){
    switch(pos){
      case 1 : return Icon(Icons.arrow_upward,color: Colors.white,);
      break;
      case 2 : return Icon(Icons.arrow_downward,color: Colors.white,);
      break;
      default: return Icon(Icons.arrow_downward,color: Colors.white,);
      break;
    }
  }

  void delete(Note note) async{
     int result = await databaseHelper.deleteNote(note.id);
     if(result != 0){
       _showSnackbar("Successfully Deleted");
       updateListView();
     }

  }

  void _showSnackbar(String text){

    final key =scaffoldkey.currentState;
    key.showSnackBar(
        new SnackBar(
          content: new Text(text),
          duration: new Duration(seconds: 2),
          action: SnackBarAction(
              label: "UNDO",
              onPressed: (){}),
        )
    );

  }



  void _showAlertDialouge(BuildContext context,Note note){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(

            shape: RoundedRectangleBorder(

                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                side: BorderSide(style: BorderStyle.none)),
            content: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)),gradient: LinearGradient(
                  // Add one stop for each color. Stops should increase from 0 to 1
                  colors: [Colors.white,Colors.white])),
              height: 200.0,
              child: Container(
                child: new Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top:15),
                      child: Icon(
                        Icons.warning,
                        color: Colors.red,
                        size: 60,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    new Text("Are you sure ?",
                        style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.black,
                           )),
                    new Divider(),
                   Container(

                     child:  new Row(
                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                       children: <Widget>[
                         new RaisedButton(onPressed: (){delete(note);
                         Navigator.of(context).pop();},child: Text("Yes"),
                           color: Colors.redAccent,shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),),

                         new RaisedButton(
                           onPressed: (){Navigator.of(context).pop();},
                           child: Text("Close"),
                         color: Colors.blueGrey,shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),),
                       ],
                     ),
                   )
                  ],
                ),
              ),
            ),
            contentPadding: EdgeInsets.only(top: 0),
          );
        });
  }


  void updateListView(){
    
    Future<List<Note>> noteListFuture = databaseHelper.getNotelist();
    noteListFuture.then((noteList) {
      setState(() {
        this.noteList = noteList;
        this.count = noteList.length;
      });
    });
  }




  @override
  Widget build(BuildContext context) {

    if(noteList == null){
      noteList = new List<Note>();
      updateListView();
    }
    return Scaffold(
      key: scaffoldkey,
      appBar: new AppBar(
        title: new Text('Note Keeper'),
      ),
      body: getNoteListView(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: ()=> navigateToDetails(Note("","",2),"Add Note"),
        backgroundColor: Colors.red,
        tooltip: 'Add Note',
        child: Icon(Icons.add,color: Colors.white,),),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(height: 50,)
          ],
        ),
          color:  Theme.of(context).primaryColor,
          shape: CircularNotchedRectangle()
      ),
    );

  }


  ListView getNoteListView(){
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context,int ind){
          return Card(
            color: Colors.transparent,
            elevation: 2.0,
            child: ListTile(
              title: new Text(this.noteList[ind].title),
              subtitle: new Text(this.noteList[ind].date),
              trailing: GestureDetector(
                child: new Icon(Icons.delete),
                onTap: (){_showAlertDialouge(context,this.noteList[ind]);},
              ),
              leading: CircleAvatar(
                child: getPriorityIcon(this.noteList[ind].priority),
                backgroundColor: getPriorityColor(this.noteList[ind].priority),
              ),
              onTap: (){
                navigateToDetails(this.noteList[ind],'Edit Note');
              },
            ),
          );
        });
  }

  void navigateToDetails(Note note, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetails(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }
}
