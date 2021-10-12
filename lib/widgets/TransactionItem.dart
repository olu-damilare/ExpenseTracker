import 'dart:math';

import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.deleteTxn,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTxn;

  @override
  State<TransactionItem> createState() => _TransactionItemState();

 }

class _TransactionItemState extends State<TransactionItem> {
  Color? _bgColor;

  @override
  void initState(){
    const availableColours = [
      Colors.red, Colors.black, Colors.blue, Colors.purple
    ];
    _bgColor = availableColours[Random().nextInt(4)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(child: Text('\$${widget.transaction.amount}')),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        subtitle: Text(DateFormat.yMMMd().format(widget.transaction.date)),
        trailing: MediaQuery.of(context).size.width > 360
            ? FlatButton.icon(
          icon: Icon(Icons.delete),
          label: Text('Delete'),
          textColor: Colors.red,
          onPressed: widget.deleteTxn(widget.transaction.id),
        )
            : IconButton(icon: Icon(Icons.delete), color: Theme.of(context).errorColor, onPressed: () {widget.deleteTxn(widget.transaction.id); },),

      ),
    );
  }
}

