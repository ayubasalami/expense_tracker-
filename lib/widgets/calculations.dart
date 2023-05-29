class Calculations {
  static int totalBalance = 0;
  static int totalIncome = 0;
  static int totalExpense = 0;
  static String companyName = '';

  static getTotalBalance(Map entireData) {
    totalBalance = 0;
    totalIncome = 0;
    totalExpense = 0;

    entireData.forEach((key, value) async {
      if (value['type'] == 'Income') {
        totalBalance += int.tryParse(value['amount']) ?? 0;
        totalIncome += int.tryParse(value['amount']) ?? 0;
      } else {
        totalBalance -= int.tryParse(value['amount']) ?? 0;
        totalExpense += int.tryParse(value['amount']) ?? 0;
      }
    });
  }

  static getUserData(Map userData) {
    companyName = '';
    userData.forEach((key, value) {
      companyName = value['companyName'];
    });
  }
}
