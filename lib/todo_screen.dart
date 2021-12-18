import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'database/todo_database.dart';
import 'model/todo_model.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({Key? key}) : super(key: key);

  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _occupationController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  final DatabaseProvider _databaseProvider = DatabaseProvider.db;
  bool updateData=false;
  bool deleteData=false;
  TodoModel? todo;
  TodoModel? item;
  TodoModel todos=TodoModel();
  List<TodoModel> updateName=[];
  int updateindex=0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              setState(() {
                updateData=false;
                deleteData=false;
              });
              _openFiledFormToDo();
            },
          ),
          backgroundColor: Colors.white,
          bottomNavigationBar: _bottomNavigationBar(),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              "To Do",
              style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          body: _getBody(),
        ));
  }

  Widget _getBody() {
    return SingleChildScrollView(
        child: FutureBuilder(
       future: DatabaseProvider.db.getAllToDo(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return  ListView.separated(
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
               item = snapshot.data![index];
              return Container(
                margin: EdgeInsets.only(left: 20.0,right: 20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(width: 1.0,color: Colors.black)
                ),
                padding: EdgeInsets.only(top: 8.0,bottom: 8.0,left: 20.0,right: 20.0),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   _getShowData(),
                    _getMoreIcon(index)
                  ],
                ),
              );
            }, separatorBuilder: (BuildContext context, int index) {
              return Padding(padding: EdgeInsets.only(top: 20.0));
          },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    ));
  }

  _bottomNavigationBar() {
    return BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.white,
        notchMargin: 8.0,
        child: Container(
          height: 50.0,
        ));
  }

  _openFiledFormToDo() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Form(
                key: _formKey,
                child: Wrap(
                  children: [
                    Container(
                      child: Column(
                        children: <Widget>[
                        _textFieldWidget(
                              hintText: "First Name",
                              controller: _firstNameController),
                          deleteData?Container(): Padding(padding: EdgeInsets.only(top: 10.0)),
                           deleteData? Container():_textFieldWidget(
                             hintText: "Last Name",
                             controller: _lastNameController),
                           deleteData?Container(): Padding(padding: EdgeInsets.only(top: 10.0)),
                           deleteData? Container():_textFieldWidget(
                             hintText: "Occupation",
                             controller: _occupationController),
                          deleteData?Container(): Padding(padding: EdgeInsets.only(top: 10.0)),
                           deleteData?Container(): _textFieldWidget(
                             textInputType: TextInputType.number,
                             hintText: "Age",
                             controller: _ageController)
                        ],
                      ),
                    ),
                    _submitButton()
                  ],
                )),
          );
        });
  }

  _textFieldWidget(
      {required hintText, required TextEditingController controller,TextInputType? textInputType}) {
    return Container(
      child: TextField(
        keyboardType: textInputType,
        controller: controller,
        autofocus: false,
        style: TextStyle(fontSize: 15.0, color: Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '$hintText',
          filled: true,
          fillColor: Colors.grey.withOpacity(0.3),
          contentPadding:
              const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Widget _submitButton() {
    print(deleteData);
    print(updateData);
    print(todos.first_name);
    return GestureDetector(
      onTap: ()async{
        // Deleting data from database
        if(deleteData==true){
        _databaseProvider.deleteToDo(_firstNameController.text);
        setState(() {});
        Navigator.pop(context);
        }


        // updating data from database
        else if(updateData==true ){
            todos=TodoModel(first_name: _firstNameController.text);
            final updated=_databaseProvider.updateToDo(todos);
            todos.last_name = _lastNameController.text;
            todos.occupation=_occupationController.text;
            todos.age=int.parse(_ageController.text);
            setState(() {});
            Navigator.pop(context);

        }



        //inserting data into database
        else if(todo==null) {
          todos = TodoModel(
             first_name: _firstNameController.text,
             last_name: _lastNameController.text,
             age: int.parse(_ageController.text,),
              occupation: _occupationController.text
         );
         _databaseProvider.createTodo(todos).then((value) =>
         {
           _firstNameController.clear(),
           _lastNameController.clear(),
           _ageController.clear(),
           _occupationController.clear()
         });
         setState(() {});
         Navigator.pop(context);
       }
      },
      child: Container(
        height: 36.0,
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 20.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0), color: Colors.green),
        child: Text(
          "Data Submit",
          style: TextStyle(
              fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  _getShowData() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("First Name: "+item!.first_name!),
          Text("Last Name: "+item!.last_name!),
          Text("Occupation: "+item!.occupation!),
          Text("Age: "+item!.age.toString())
        ],
      ),
    );
  }

 Widget _getMoreIcon(int index) {
    return GestureDetector(
      onTapDown: (details){
        _openAdditionOption(details, index);
      },
      child: Container(
        child: Icon(Icons.more_vert,size: 20.0,),
      ),
    );
 }

  void _openAdditionOption(TapDownDetails details, int index) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        details.globalPosition.dy + 20,
        details.globalPosition.dx,
        details.globalPosition.dy + 20,
      ),
      items: [
        PopupMenuItem<String>(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                child: Column(
                  children: <Widget>[
                    _reportButton(title: "Update",function: _openUpdateContent,),
                    Divider(thickness: 1.0,color: Colors.black,),
                    _reportButton(title: "Delete",function: _deleteData,)
                  ],
                )
              );
            },
          ),
        ),
      ],
    );
  }
  _reportButton({required String title,required Function function,}) {
    return GestureDetector(
      onTap: () {
       function();
      },
      child: Text(title,),
    );
  }


// For update List based on name
  _openUpdateContent() {
   setState(() {
     updateData=true;
   });
   Navigator.pop(context);
 //  _firstNameController.text= todo!.first_name!;
   _openFiledFormToDo();
  }


  // Delete item from list based on name
  _deleteData() {
    setState(() {
      deleteData=true;
    });
    Navigator.pop(context);
    _openFiledFormToDo();
  }
}
