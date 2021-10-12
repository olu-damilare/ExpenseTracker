import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';

import 'TransactionItem.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTxn;
  TransactionList(this.transactions, this.deleteTxn);
  

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
          ? LayoutBuilder(builder: (ctx, constraints){
           return Column(
               children: <Widget>[
                 Text(
                   'No transactions added yet',
                   style: Theme.of(context).textTheme.subtitle1,
                 ),
                 SizedBox(
                   height: 20,
                 ),
                 Container(
                   width: constraints.maxWidth * 0.5,
                   height: constraints.maxHeight * 0.6,
                   child: Image.network(
                       'https://images.unsplash.com/photo-1622428051717-dcd8412959de?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
                       fit: BoxFit.cover),
                 ),
               ],
             );
          })
          : ListView(
              children: transactions.map((txn) =>
                TransactionItem(
                  key: ValueKey(txn.id ),
                    transaction: txn,
                    deleteTxn: deleteTxn)
                ).toList(),


    );
  }
}

