import 'package:dartz/dartz.dart';
import 'package:expensetx/features/home/data/models/expensemodels.dart';
import 'package:expensetx/general/failures/failures.dart';

abstract class IExpenseFacade {
  
  /// Uploads an expense to Firestore.
  Future<Either<MainFailures, String>> uploadExpense({required ExpenseModel expenseModel});

  // / Fetches all expenses from Firestore.


  Future<Either<MainFailures, List<ExpenseModel>>> fetchExpenses();



  
}
