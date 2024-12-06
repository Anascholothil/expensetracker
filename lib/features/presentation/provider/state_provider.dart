import 'package:expensetx/features/home/data/i_mainfacade.dart';
import 'package:expensetx/features/home/data/models/expensemodels.dart';
import 'package:flutter/material.dart';

class StateProvider with ChangeNotifier {
  final IExpenseFacade _expenseFacade;

  StateProvider({required IExpenseFacade expenseFacade})
      : _expenseFacade = expenseFacade;

//List private
  List<ExpenseModel> _expenses = [];

  //total price
  final double _netTotal = 0.0;

  //Loader
  bool _isLoading = false;
  String? _message;

//Model getting
  List<ExpenseModel> get expenses => _expenses;
  double get netTotal => _netTotal;
  bool get isLoading => _isLoading;
  String? get message => _message;

  //upload user expenses

  Future<void> addExpense(String item, double price, String type) async {
    _isLoading = true;
    _message = null;
    notifyListeners();

    final expense = ExpenseModel(
      id: '', // ID is generated in the implementation
      item: item,
      price: price,
      type: type,
    );

    final result = await _expenseFacade.uploadExpense(expenseModel: expense);
    result.fold(
      (failure) => _message = failure.errormsg,
      (successMessage) {
        _message = successMessage;
        fetchExpenses(); // Refresh the expense list
      },
    );

    _isLoading = false;
    notifyListeners();
  }

// Fetch all expenses
  Future<void> fetchExpenses() async {
    _isLoading = true;
    _message = null;
    notifyListeners();

    final result = await _expenseFacade.fetchExpenses();
    result.fold(
      (failure) {
        _message = failure.errormsg;
      },
      (expenses) {
        _expenses = expenses;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  // Future<void> deleteExpense(String expenseId, int index) async {
  //   // Call the facade to delete the expense from Firestore
  //   final result = await _expenseFacade.deleteExpense(expenseId);
  //   result.fold(
  //     (failure) {
  //       _message = failure.errormsg;
  //       notifyListeners();
  //     },
  //     (success) {
  //       _expenses.removeAt(index); // Remove the expense from the list
  //       notifyListeners();
  //     },
  //   );
  // }
}
