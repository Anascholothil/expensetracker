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

  //upload Exp
  Future<Either<MainFailures, String>> uploadExpense(
      {required ExpenseModel expenseModel}) async {
    try {
      final expenseRef = firestore.collection(FirebaseCollections.expenses);

      final id = expenseRef.doc().id;

      final expense = expenseModel.copyWith(id: id);

      await expenseRef.doc(id).set(expense.toMap());

      return right('Expense Added');
    } catch (e) {
      return left(MainFailures.serverFailer(errormsg: e.toString()));
    }
  }

//fetchExpense

 @override
  Future<Either<MainFailures, List<ExpenseModel>>> fetchExpenses(DocumentSnapshot? lastDocument) async {
    try {
      Query query = firestore.collection(FirebaseCollections.expenses).limit(10);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument); 
      }

      final querySnapshot = await query.get();

      final expenses = querySnapshot.docs.map((doc) {
        return ExpenseModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      return right(expenses);
    } catch (e) {
      return left(MainFailures.serverFailer(errormsg: e.toString()));
    }
  }

}
