// import '../../model/investment_summary.dart';
// import '../../model/tax_summary.dart';
//
// InvestmentModel getInvestmentDetails(
//     {required double investedAmount, required double returnsPercentage}) {
//   double totalReturns = investedAmount * (returnsPercentage / 100);
//   double currentAmount = investedAmount + totalReturns;
//   print('Current Amount: $currentAmount');
//   print('Invested Amount: $investedAmount');
//   print('Total Returns: $totalReturns');
//   print('Returns Percentage: $returnsPercentage');
//
//   return InvestmentModel(
//     currentAmount: currentAmount.toStringAsFixed(2),
//     investedAmount: investedAmount.toStringAsFixed(2),
//     totalReturns: totalReturns.toStringAsFixed(2),
//     returnsPercentage: returnsPercentage.toStringAsFixed(2),
//   );
// }
//
//
// TaxModel getTaxDetails(
//     {required double taxableAmount, required double taxPercentage}) {
//   double totalTax = taxableAmount * (taxPercentage / 100);
//   double netAmountAfterTax = taxableAmount - totalTax;
//   return TaxModel(
//       netAmountAfterTax: netAmountAfterTax.toStringAsFixed(2),
//       taxableAmount: taxableAmount.toStringAsFixed(2),
//   totalTax: totalTax.toStringAsFixed(2),
//   taxPercentage: taxPercentage.toString(),
//   );
//   }