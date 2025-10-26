import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mini_social_application/models/expense_model.dart';
import 'package:mini_social_application/screens/home/edit_expense_screen.dart';
import '../utils/utils.dart';

class ExpanseTile extends StatelessWidget {
  final Expense expense;
  const ExpanseTile({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseDatabase.instance.ref('users/$userId/expenses');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(expense.title),
        subtitle: Text(
          '${expense.category} • ${expense.date.toLocal().toString().split(' ')[0]}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Rs. ${expense.amount.toStringAsFixed(0)}'),
            const SizedBox(width: 8),
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text('Edit'), Icon(Icons.edit)],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text('Delete'), Icon(Icons.delete)],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  // implement edit functi
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>EditExpenseScreen(expense: expense ,)));
                } else if (value == 'delete') {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Expense'),
                      content: const Text(
                        'Are you sure you want to delete this expense?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            try {
                              await ref.child(expense.id).remove();
                              Utils().toastMessage(
                                  "Expense deleted successfully");
                              Navigator.pop(context);
                            } catch (error) {
                              Utils().toastMessage(
                                  "Error deleting expense: $error");
                            }
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
