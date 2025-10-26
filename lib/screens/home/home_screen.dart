import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mini_social_application/screens/auth/login_screen.dart';
import 'package:mini_social_application/screens/home/add_expense_screen.dart';
import 'package:mini_social_application/utils/utils.dart';
import '../../models/expense_model.dart';
import '../../widgets/expanse_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  final userid = FirebaseAuth.instance.currentUser!.uid;
  late DatabaseReference ref;
  late Stream<DatabaseEvent> expenseStream;

  @override
  void initState() {
    super.initState();
    ref = FirebaseDatabase.instance.ref('users/$userid/expenses');
    expenseStream = ref.onValue;
  }

  List<Expense> parseExpenses(Map<dynamic, dynamic> data) {
    List<Expense> expenses = [];
    data.forEach((key, value) {
      expenses.add(Expense(
        id: key,
        title: value['title'] ?? '',
        category: value['category'] ?? '',
        date: DateTime.tryParse(value['date'] ?? '') ?? DateTime.now(),
        amount: double.tryParse(value['amount'].toString()) ?? 0,
      ));
    });
    return expenses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 2,
        centerTitle: true,
        title: const Text(
          'Home Screen',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
              });
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: expenseStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text('No Expense Yet'));
          } else {
            final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            final expenses = parseExpenses(data);
            return ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return ExpanseTile(expense: expense);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
