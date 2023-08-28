class User{
  final String? uid;
  User({this.uid});
}

class UserData{
  final String? uid;
  final String? name;
  final List<Map>? accounts;
  final List<Map>? incomes;
  final List<Map>? expenses;
  final List<Map>? subscriptions;
  final List<Map>? budgets;
  final List<Map>? payDues;
  final List<Map>? collectDues;


  UserData({this.uid,this.name,this.accounts,this.incomes,this.expenses,this.subscriptions,this.budgets,this.payDues,this.collectDues});

}

class UserAccount{
  final String? accUid;
  UserAccount(this.accUid);
}
class AccountData{
  final String? accUid; 
  final String? account_name;
  final int? account_money;
  AccountData({this.accUid,this.account_name,this.account_money});
}