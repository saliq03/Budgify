import 'package:budgify/shared/view/widgets/reusable_app_bar.dart';
import 'package:flutter/material.dart';

class EmiAndLoans extends StatelessWidget {
  const EmiAndLoans({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: ReusableAppBar(text: "EMI & Loans",isCenterText: true,),
      body: Center(
        child: Text(
          'No EMI & Loans Found',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
