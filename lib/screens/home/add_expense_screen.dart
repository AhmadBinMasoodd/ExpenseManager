import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mini_social_application/utils/utils.dart';
import 'package:mini_social_application/widgets/round_botton.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final categoryController = TextEditingController();
  final dateController = TextEditingController();
  final formfield = GlobalKey<FormState>();
  final userid = FirebaseAuth.instance.currentUser!.uid;

  late DatabaseReference ref;
  bool loading=false;
  @override
  void initState() {
    super.initState();
    // Initialize the reference to Realtime Database
    ref = FirebaseDatabase.instance.ref('users/$userid/expenses');
  }

  void addExpense() {
    setState(() {
      loading=true;
    });
    if (titleController.text.isEmpty ||
        categoryController.text.isEmpty ||
        amountController.text.isEmpty ||
        dateController.text.isEmpty) {
      Utils().toastMessage("Please fill all fields");
      return;
    }

    double amount = double.tryParse(amountController.text) ?? 0;
    DateTime dateTime = DateTime.parse(dateController.text);

    Map<String, dynamic> expenseData = {
      'title': titleController.text,
      'category': categoryController.text,
      'amount': amount,
      'date': dateTime.toIso8601String(), // store as string
      'createdAt': DateTime.now().toIso8601String(),
    };

    ref.push().set(expenseData).then((_) {
      setState(() {
        loading=false;
      });
      Utils().toastMessage('Expense added successfully');
      // Optionally clear fields after adding
      titleController.clear();
      categoryController.clear();
      amountController.clear();
      dateController.clear();
    }).catchError((error) {
      setState(() {
        loading=false;
      });
      Utils().toastMessage('Error adding expense: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 2,
        centerTitle: true,
        title: const Text(
          'Add Expense',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
              key: formfield,
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.title),
                      hintText: 'Title',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                        BorderSide(color: Colors.deepPurple.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                        BorderSide(color: Colors.deepPurple.shade200),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: categoryController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.category),
                      hintText: 'Category',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                        BorderSide(color: Colors.deepPurple.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                        BorderSide(color: Colors.deepPurple.shade200),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.attach_money),
                      hintText: 'Amount',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                        BorderSide(color: Colors.deepPurple.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                        BorderSide(color: Colors.deepPurple.shade200),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: dateController,
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        initialDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          dateController.text =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                        });
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.calendar_month),
                      hintText: 'Tap to select date',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                        BorderSide(color: Colors.deepPurple.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                        BorderSide(color: Colors.deepPurple.shade200),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            RoundBotton(
              title: 'Add Expense',
              loading: loading,
              onTap: () {
                addExpense();
              },
            ),
          ],
        ),
      ),
    );
  }
}
