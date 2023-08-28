import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zense_project/user.dart';

class NewBudget extends StatefulWidget {
  const NewBudget({super.key});

  @override
  State<NewBudget> createState() => _NewBudgetState();
}

class _NewBudgetState extends State<NewBudget> {
  final _formkey = GlobalKey<FormState>();
  late Stream<QuerySnapshot> BudgetStream;
  
    
    int target=0;
    String? category;
    List<String> categories = ['Food/Drinks','Transportation','Medical','Recreation','Bills','Shopping','Housing','Vehicle','Misc.'];
    TextEditingController _date1 = TextEditingController();
    TextEditingController _date2 = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    DocumentReference _documentReference = FirebaseFirestore.instance.collection('profiles').doc(user.uid);
    CollectionReference _budgetsReference = _documentReference.collection('Budgets');
    return Form(
      key: _formkey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text('Add New Budget',style: TextStyle(fontSize: 20)),
            SizedBox(height: 20,),
            Dropdownforcategory(),
            SizedBox(height: 10,),
            Center(
                        child: SizedBox(
                          width: 500,
                          child: TextField(
                                            controller: _date1,
                                            decoration: InputDecoration(
                                  
                                  fillColor: Colors.white,
                                  filled: true,
                                  labelText: 'Select start date',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                                            onTap: () async{
                                              await Future.delayed(Duration(milliseconds: 100));
                                              FocusScope.of(context).unfocus();
                                              DateTime? pickeddate = await showDatePicker(context:  context 
                                              , initialDate: DateTime.now()
                                              , firstDate: DateTime(2000)
                                              , lastDate: DateTime.now());
                                              if (pickeddate!=null){
                          
                                  setState(() {
                                    _date1.text = DateFormat('yyyy-MM-dd').format(pickeddate);
                                  });

                                              }
                                            },
                                          ),
                        ),
                  
                      ),
                    SizedBox(height: 10,),

                    Center(
                        child: SizedBox(
                          width: 500,
                          child: TextField(
                                            controller: _date2,
                                            decoration: InputDecoration(
                                  
                                  fillColor: Colors.white,
                                  filled: true,
                                  labelText: 'Select end date',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                                            onTap: () async{
                                              await Future.delayed(Duration(milliseconds: 100));
                                              FocusScope.of(context).unfocus();
                                              DateTime? pickeddate = await showDatePicker(context:  context 
                                              , initialDate: DateTime.now()
                                              , firstDate: DateTime(2000)
                                              , lastDate: DateTime(2100));
                                              if (pickeddate!=null){
                          
                         
                                setState(() {
                                  _date2.text = DateFormat('yyyy-MM-dd').format(pickeddate);
                                });

                                              }
                                            },
                                          ),
                        ),
                  
                      ),
                      
                      SizedBox(height: 10,),
                      TextFormField(
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Enter limit";
                                  }
                                  int? parsedValue = int.tryParse(val);
                                  if (parsedValue == null || parsedValue <= 0) {
                                    return "Enter a valid amount (> Rs.0)";
                                  }
                                  return null;
                                },
                                onChanged: (val) {
                                  setState(() {
                                    target = int.tryParse(val) ?? 0;
                                  });
                                },
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: 'Limit(Rs.)',
                                labelText: 'Limit(Rs.)',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          SizedBox(height: 30,),

                          Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              'Add',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.lightGreen,
                              child: IconButton(
                                  color: Colors.black,
                                  onPressed: () async{

                                    if (_formkey.currentState!.validate()){

                                    List<String> dateParts = _date1.text.split("-");
                                    int year = int.parse(dateParts[0]);
                                    int month = int.parse(dateParts[1]);
                                    int day = int.parse(dateParts[2]);
                                    DateTime dateTime1 = DateTime(year, month, day);

                                    
                                    List<String> dateParts2 = _date2.text.split("-");
                                    int year2 = int.parse(dateParts2[0]);
                                    int month2 = int.parse(dateParts2[1]);
                                    int day2 = int.parse(dateParts2[2]);
                                    DateTime dateTime2 = DateTime(year2, month2, day2);

                                    if (dateTime1.isAfter(dateTime2)){
                                      DisplayAlertMessage();
                                    }
                                    else{
                                      Map<String,dynamic> toAdd = {'category':category,'start_date':_date1.text,'end_date':_date2.text,'target':target};
                                      _budgetsReference.add(toAdd);
                                      Navigator.of(context).pop();
                                    }
                                      
                                      
                                      

                                      // await DatabaseService(uid: user.uid).setAccountDetails(context,account_name,account_money);
                                      }
                                    
                                  },
                                  icon: const Icon(Icons.arrow_forward_rounded)),
                            )
                          ],
                        ),

          ],
          
        ),
      )
    );
  }
  Widget Dropdownforcategory(){
        
        return DropdownButtonFormField<String>(
          hint: Text('Select category'),
          items: categories.map((e){
            return DropdownMenuItem(
              value: e,
              child: Text(e),
            );
          }).toList(),
          onChanged: (val) => setState(() => category = val),
          value: category,
        );
  }
  void DisplayAlertMessage(){
         showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert!'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('End date cannot be after start date.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Exit'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}