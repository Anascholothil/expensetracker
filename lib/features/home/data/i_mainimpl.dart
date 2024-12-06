import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:expensetx/features/home/data/i_mainfacade.dart';
import 'package:expensetx/features/home/data/models/expensemodels.dart';
import 'package:expensetx/general/failures/failures.dart';
import 'package:expensetx/general/utils/firebasecollection.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IExpenseFacade)
class IMainImpl implements IExpenseFacade {
  final FirebaseFirestore firestore;
  IMainImpl(this.firestore);

  @override
  Future<Either<MainFailures, String>> uploadExpense({required ExpenseModel expenseModel}) async {
    try {
      final expenseRef = firestore.collection(FirebaseCollections.expenses);

      // Generate a unique document ID
      final id = expenseRef.doc().id;

      // Create a new expense model with the generated ID
      final expense = expenseModel.copyWith(id: id);

      // Save the expense to Firestore
      await expenseRef.doc(id).set(expense.toMap());

      return right('Expense Added');
    } catch (e) {
      return left(MainFailures.serverFailer(errormsg: e.toString()));
    }
  }

  // // Fetch all expenses from Firestore
  // @override
  // Future<Either<MainFailures, List<ExpenseModel>>> fetchExpenses() async {
  //   try {
  //     final expenseRef = firestore.collection(FirebaseCollections.expenses);
  //     final snapshot = await expenseRef.get();
      
  //     final expenses = snapshot.docs.map((doc) {
  //       return ExpenseModel.fromMap(doc.data());
  //     }).toList();

  //     return right(expenses);
  //   } catch (e) {
  //     return left(MainFailures.serverFailer(errormsg: e.toString()));
  //   }
  // }

 @override
  Future<Either<MainFailures, List<ExpenseModel>>> fetchExpenses() async {
    try {
      // Fetch all documents from the expenses collection
      final expenseSnapshot = await firestore.collection(FirebaseCollections.expenses).get();

      // Convert Firestore documents to a list of ExpenseModel
      final expenses = expenseSnapshot.docs.map((doc) {
        return ExpenseModel.fromMap(doc.data()).copyWith(id: doc.id);
      }).toList();

      return right(expenses); // Return the list of expenses
    } catch (e) {
      return left(MainFailures.serverFailer(errormsg: e.toString())); // Handle errors
    }
  }

}
