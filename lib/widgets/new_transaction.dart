import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addNewTransaction;

  NewTransaction(this.addNewTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _title = TextEditingController();
  final _amount = TextEditingController();
  DateTime? _selectedDate;

  void _submitData() {
    // if(_title.text.isEmpty || _amount.text.isEmpty || _selectedDate == null) return;

    final enteredTitle = _title.text;
    final enteredAmount = double.parse(_amount.text);

    if (enteredTitle.isEmpty || enteredAmount < 0 || _selectedDate == null) {
      return;
    }

    widget.addNewTransaction(enteredTitle, enteredAmount, _selectedDate);
    Navigator.of(context).pop();
  }

  void _displayDatePicker(){
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime.now()
    ).then((value)  {
      if (value == null) return;
      setState(() {
        _selectedDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: _title,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: _amount,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                          _selectedDate == null ?
                          'No Date selected' :
                          'Transaction date: ${DateFormat.yMd().format(_selectedDate!)}'
                      ),
                    ),
                    FlatButton(onPressed: _displayDatePicker,
                        textColor: Theme.of(context).primaryColor,
                        child: Text('Select date', style: TextStyle(fontWeight: FontWeight.bold),)),
                  ],
                ),
              ),
              RaisedButton(
                onPressed: () => _submitData(),
                child: Text('Add Transaction'),
                textColor: Theme.of(context).textTheme.button!.color,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
