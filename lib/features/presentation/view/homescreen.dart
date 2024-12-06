import 'package:expensetx/features/presentation/provider/state_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StateProvider>(context, listen: false).fetchExpenses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final stateProvider = Provider.of<StateProvider>(context);
    final expenses = stateProvider.expenses;
    final isLoading = stateProvider.isLoading;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text(
          "Expenses",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 19, 147, 25),
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading && expenses.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : expenses.isEmpty
              ? const Center(
                  child: Text(
                    "No expenses yet!",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                )
              : NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollEndNotification &&
                        scrollNotification.metrics.pixels ==
                            scrollNotification.metrics.maxScrollExtent) {
                      // Trigger fetch of more expenses when scroll reaches bottom
                      if (!isLoading && stateProvider.hasMore) {
                        Provider.of<StateProvider>(context, listen: false)
                            .fetchExpenses();
                      }
                    }
                    return false;
                  },
                  child: ListView.builder(
                    itemCount: expenses.length + (isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == expenses.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final expense = expenses[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(
                          title: Text(
                            expense.item,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 6, 37, 59),
                            ),
                          ),
                          subtitle: Text(
                            "₹${expense.price.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: expense.type == 'Dr'
                                  ? Colors.redAccent
                                  : Colors.green,
                            ),
                          ),
                          trailing: Text(
                            expense.type,
                            style: TextStyle(
                              color: expense.type == "Dr"
                                  ? Colors.red
                                  : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddExpenseDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context) {
    String selectedType = "Dr";
    final itemController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(
          child: Text(
            "Add Expense",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 72, 168, 8),
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: itemController,
              decoration: const InputDecoration(
                labelText: "Item Name",
              ),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: selectedType,
              items: ["Dr", "Cr"]
                  .map(
                    (type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (itemController.text.isNotEmpty &&
                  priceController.text.isNotEmpty) {
                final item = itemController.text;
                final price = double.parse(priceController.text);
                Provider.of<StateProvider>(context, listen: false)
                    .addExpense(item, price, selectedType);
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
