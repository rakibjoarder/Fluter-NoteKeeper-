class Note{

  int    _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  Note(this._title,this._date,this._priority,[this._description]);
  Note.withId(this._id,this._title,this._date,this._priority,[this._description]);

  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get date => _date;
  int    get priority => _priority;

  set title(String newTitle){
    if(newTitle.length <= 255){
      this._title = newTitle;
    }
  }

  set description(String des){
    if(des.length <= 255){
      this._description = des;
    }
  }
  set date(String date){
    if(date.length <= 255){
      this._date = date;
    }
  }
  set priority(int priority){
    if(priority == 0 || priority == 1){
      this._priority = priority;
    }
  }

  Map<String,dynamic> toMap(){
    var map = new Map<String,dynamic>();

    if(_id != null){ map["id"] = _id;}
    map["title"]      = _title;
    map["description"]= _description;
    map["date"]       = _date;
    map["priority"]   = _priority;

    return map;
  }

  Note.fromMapObj(Map<String,dynamic> map){
    this._id          = map["id"];
    this._title       = map["title"];
    this._date        = map["date"];
    this._priority    = map["priority"];
    this._description = map["description"];
  }

}