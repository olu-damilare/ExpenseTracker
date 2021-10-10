import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/widgets/chart.dart';
import 'package:expense_tracker/widgets/new_transaction.dart';
import 'package:expense_tracker/widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //   [
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown
  //   ]
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense tracker',
      home: HomePage(),
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.amber,
          errorColor: Colors.red,
          fontFamily: 'Cabin',
          textTheme: ThemeData.light().textTheme.copyWith(
              title: GoogleFonts.abhayaLibre(fontSize: 16, fontWeight: FontWeight.bold),
          button: TextStyle(color: Colors.white),
      ),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                  title: GoogleFonts.abhayaLibre(fontSize: 20)))),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransactions = [
    // Transaction('t1', 'New Shoes', 12500, DateTime.now()),
    // Transaction('t2', 'New Laptop', 125000, DateTime.now())
  ];

  bool _showChart = false;

  @override
  void initState(){
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state){
    print(state);
  }

  @override
  dispose(){
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();

  }

  List<Transaction> get _recentTransaction {
    return _userTransactions.where((txn) {
      return txn.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  void _addNewTransaction(String title, double amount, chosenDate) {
    final txn = Transaction(
      DateTime.now().toString(),
      title,
      amount,
      chosenDate,
    );

    setState(() {
      _userTransactions.add(txn);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(_addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void deleteTransaction(String id){
    print(id);
    
    setState(() {
      _userTransactions.removeWhere((element) =>  element.id == id);
    });
  }

  List<Widget> _buildLandscapeContent(MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget){
    return [Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Show chart'),
        Switch(value: _showChart,
          onChanged: (val) {
            setState(() {
              _showChart = val;
            });
          },)
      ],
    ), _showChart
    ? Container(
    height: (mediaQuery.size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top) * 0.7,
    child: Chart(_recentTransaction))
    :
    txListWidget] ;
  }

  List<Widget> _buildPortraitContent(MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget){
    return [Container(
        height: (mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top) * 0.3,
        child: Chart(_recentTransaction)),
     txListWidget];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = AppBar(
    title: Text(
    'Expense Tracking App',
    ),
    actions: <Widget>[
    IconButton(
    icon: Icon(Icons.add),
    onPressed: () {
    _startAddNewTransaction(context);
    },
    )
    ],
    );
    final txListWidget = Container(
        height: (MediaQuery.of(context).size.height - appBar.preferredSize.height  - MediaQuery.of(context).padding.top) * 0.6,
        child: TransactionList(_userTransactions, deleteTransaction));


    return Scaffold(
      appBar: appBar,
		body: SingleChildScrollView(
			child: Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: <Widget>[
			  if (isLandscape)...  _buildLandscapeContent(mediaQuery, appBar, txListWidget),
        if(!isLandscape) ... _buildPortraitContent(mediaQuery, appBar, txListWidget),
      ],
			),
		),
		floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
		floatingActionButton: FloatingActionButton(
			onPressed: () {
			_startAddNewTransaction(context);
			},
			child: Icon(Icons.add),
		),
    );
  }
}
