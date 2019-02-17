import 'package:flutter/material.dart';
import 'package:flutter_notkeeper/models/note.dart';
import 'package:intl/intl.dart';
import 'package:flutter_notkeeper/helper/database_helper.dart';

class NoteDetails extends StatefulWidget {
  String title;
  final  Note note;

  NoteDetails(this.note,this.title);
  @override
  _NoteDetailsState createState() => _NoteDetailsState(note,title);
}

class _NoteDetailsState extends State<NoteDetails> {
  String title;
  final  Note note;
  static var _priorities = ['High','Low'];
  DatabaseHelper helper = new DatabaseHelper();
  var formKey = GlobalKey<FormState>();
  var scaffoldkey = GlobalKey<ScaffoldState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  _NoteDetailsState(this.note,this.title);

  // Convert the String priority in the form of integer before saving it to Database
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  // Convert int priority to String priority and display it to user in DropDown
  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];  // 'High'
        break;
      case 2:
        priority = _priorities[1];  // 'Low'
        break;
    }
    return priority;
  }

  void _delete() async{

    int result;

    result = await helper.deleteNote(note.id);

    if(result != 0){
      Navigator.pop(context,true);
    }

  }

  // Update the title of Note object
  void updateTitle(){
    note.title = titleController.text.trim();;
    setState(() {
      titleController.text = " ";
    });
  }

  // Update the description of Note object
  void updateDescription() {
    note.description = descriptionController.text.trim();
    setState(() {
      descriptionController.text =" ";
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }


  void _save() async{
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;

    if(note.id == null){
     result = await helper.insertNote(note);
    }else{
     result = await helper.updateNote(note);
    }

    if(result !=0){
      Navigator.pop(context,true);
    }else{

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



  @override
  Widget build(BuildContext context) {

    if(titleController.text.isEmpty ){
      titleController.text = note.title;
    }
    if(descriptionController.text.isEmpty ){
      descriptionController.text = note.description;
    }

    return Scaffold(
      key: scaffoldkey,
      appBar: new AppBar(
        title: Text(title),
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){Navigator.pop(context,true);}),


      ),
      body: Form(
        key: formKey,
        child: Padding(
            padding: EdgeInsets.only(top: 15.0,right: 10.0,left: 10.0),
             child: ListView(
               children: <Widget>[
             ListTile(
               title:   Row(
                 children: <Widget>[
                   Expanded(
                     flex: 2,
                     child: Text("Select Priority : ",textAlign: TextAlign.right,textScaleFactor:1.2,style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold),),
                   ),
                   Container(width: 8,),
                   Expanded(
                     flex: 1,
                     child: DropdownButtonHideUnderline(child: DropdownButton(
                         items: _priorities.map((String item){
                           return DropdownMenuItem<String>(
                             child: Text(item),
                             value: item,
                           );
                         }).toList(),
                         value: getPriorityAsString(note.priority),
                         onChanged: (value){
                           setState(() {
                             debugPrint('$value');
                             updatePriorityAsInt(value);
                           });
                         }),
                     ),
                   )

                 ],
               ),
             ),
               
                 Padding(
                   padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                   child: new TextFormField(
                     controller: titleController,
                     validator: (String value){
                       if(value.isEmpty || value.trim().length == 0 ){
                         return "Please enter title";
                       }else{
                         updateTitle();
                       }
                     },
                     decoration: InputDecoration(
                       labelText: 'Title',
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(10.0)
                       ),
                     ),
                   ),
                 ),
                 Padding(
                   padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
                   child: new TextFormField(
                     controller: descriptionController,
                     validator: (String value){
                       if(value.isEmpty || value.trim().length == 0 ){
                         return "Please enter description";
                       }else{
                         updateDescription();
                       }
                     },
                     decoration: InputDecoration(
                       labelText: 'Description',
                       border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(10.0)
                       ),
                     ),
                   ),
                 ),

           Padding(
             padding: const EdgeInsets.only(top: 15.0,bottom: 15.0),
             child:Row(
               children: <Widget>[
                 Expanded(
                   child: RaisedButton(
                     color: Colors.red,
                     shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(style: BorderStyle.none)),
                     child: Text("Save"),
                     elevation: 5.0,
                     onPressed: (){
                       setState(() {
                         debugPrint("Save Button Pressed");
                         if(formKey.currentState.validate()){
                           _save();
                           _showSnackbar("Successfully note updated.");
                           FocusScope.of(context).requestFocus(new FocusNode()); //Keyboard Hide
                         }
                       });
                     },
                   ),
                 ),
                 Container(width: note.id != null ? 5 :0,),

                 Expanded(
                   flex:  note.id != null ? 1 :0,
                   child:  note.id != null ? RaisedButton(
                     color: Colors.red,
                     shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(style: BorderStyle.none)),
                         child: Text("Delete"),
                         elevation: 5.0,
                         onPressed: (){
                           setState(() {
                             debugPrint("Delete Button Pressed");
                             _delete();
                           });
                         },
                       ): Container(width: 5,)  ,
                 ),
               ],
             ),
           )
               ],
             ),
        ),
      ),

    );
  }
}
