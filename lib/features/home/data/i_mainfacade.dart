import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:expensetx/features/home/data/models/expensemodels.dart';
import 'package:expensetx/general/failures/failures.dart';

abstract class IExpenseFacade {
  
  /// Uploads an expense to Firestore.
  Future<Either<MainFailures, String>> uploadExpense({required ExpenseModel expenseModel}){
    throw UnimplementedError('uploadExpense() not implemented');

  }

  // / Fetches all expenses from Firestore.


  Future<Either<MainFailures, List<ExpenseModel>>> fetchExpenses(DocumentSnapshot<Object?>? lastDocument){
    throw UnimplementedError('fetchExpense() not implemented');
  }



  
}
