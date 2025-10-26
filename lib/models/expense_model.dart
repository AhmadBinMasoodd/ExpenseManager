
class Expense{
  String id;
  String title;
  String category;
  double amount;
  DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.amount
  });

  Map<String,dynamic> toMap(){
    return{
      'id':id,
      'title':title,
      'category':category,
      'date':date.toIso8601String(),
      'amount':amount
    };
  }
  factory Expense.fromMap(Map<String,dynamic> map){
    return Expense(id: map['id'], title: map['title'], category: map['category'], date: map['date'], amount: map['amount']);
  }
}