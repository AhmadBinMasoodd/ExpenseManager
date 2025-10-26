import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mini_social_application/models/expense_model.dart';
import 'package:mini_social_application/utils/utils.dart';
import 'package:mini_social_application/widgets/round_botton.dart';

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;
  const EditExpenseScreen({super.key, required this.expense});

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final formKey = GlobalKey<FormState>();
  final userId = FirebaseAuth.instance.currentUser!.uid;
  late TextEditingController titleController;
  late TextEditingController categoryController;
  late TextEditingController amountController;
  late TextEditingController dateController;

  bool loading = false;
  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.expense.title);
    categoryController = TextEditingController(text: widget.expense.category);
    amountController = TextEditingController(
      text: widget.expense.amount.toString(),
    );
    dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(widget.expense.date),
    );
  }

  void updateExpense() async {
    setState(() {
      loading = true;
    });
    double amount = double.parse(amountController.text);
    DateTime date = DateTime.parse(dateController.text);
    DatabaseReference ref = FirebaseDatabase.instance.ref(
      'users/$userId/expenses/${widget.expense.id}',
    );
    Map<String, dynamic> updatedData = {
      'title': titleController.text,
      'category': categoryController.text,
      'amount': amount,
      'date': date.toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };

    try {
      await ref.update(updatedData);
      setState(() {
        loading = false;
      });
      Utils().toastMessage("Expense updated successfully");
      Navigator.pop(context);
    } catch (error) {
      setState(() {
        loading = false;
      });
      Utils().toastMessage('Error updating expense: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Expense'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (v) => v!.isEmpty ? "Please enter a title" : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Category'),
                validator: (v) => v!.isEmpty ? "Please enter a category" : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Amount'),
                validator: (v) => v!.isEmpty ? "Please enter amount" : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'Select Date'),
                readOnly: true,
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    initialDate: widget.expense.date,
                  );
                  if (picked != null) {
                    dateController.text = DateFormat(
                      'yyyy-MM-dd',
                    ).format(picked);
                  }
                },
              ),
              SizedBox(height: 10),
              RoundBotton(
                title: "Update Expense",
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    updateExpense();
                  }
                },
                loading: loading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
