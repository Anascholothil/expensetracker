import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensetx/features/home/data/i_mainfacade.dart';
import 'package:expensetx/features/home/data/models/expensemodels.dart';
import 'package:flutter/material.dart';

class StateProvider with ChangeNotifier {
  final IExpenseFacade _expenseFacade;

  StateProvider({required IExpenseFacade expenseFacade})
      : _expenseFacade = expenseFacade;

//List private
  final List<ExpenseModel> _expenses = [];

  //last document
    DocumentSnapshot? _lastDocument;


  //total price
  final double _netTotal = 0.0;

  //Loader
  bool isLoading = false;
  String? _message;


//has more data
  bool hasMore = true;

//Model getting
  List<ExpenseModel> get expenses => _expenses;
  double get netTotal => _netTotal;
  // bool get isLoading => _isLoading;
  String? get message => _message;

  //upload user expenses

  Future<void> addExpense(String item, double price, String type) async {
    isLoading = true;
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

    isLoading = false;
    notifyListeners();
  }

// Fetch all expenses
Future<void> fetchExpenses() async {
    if (isLoading) return;

    isLoading = true; 
    notifyListeners();

    try {
      final result = await _expenseFacade.fetchExpenses(_lastDocument);
      result.fold(
        (failure) {
          isLoading = false;
          notifyListeners();
        },
        (newExpenses) {
          if (newExpenses.isEmpty) {
            hasMore = false;
          } else {
            _expenses.addAll(newExpenses);
            _lastDocument = newExpenses.last.id as DocumentSnapshot<Object?>?;
          }
          isLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
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
