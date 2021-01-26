import '../helper/DBHelper.dart';

import '../model/user.dart';

class UserServices {
  void saveUser(String name, int age) {
    DBHelper.insert(
        'users', {'id': DateTime.now().toString(), 'name': name, 'age': age});
  }

  Future<List<User>> fetchUsers() async {
    final usersList = await DBHelper.getData('users');
    return usersList
        .map((item) =>
            User(id: item['id'], name: item['name'], age: item['age']))
        .toList();
  }

  void deleteUser(String id) {
    DBHelper.deleteData('users', id);
  }

  void updateUser(String id, String name, int age) {
    DBHelper.updateData('users', id,
        {'id': DateTime.now().toString(), 'name': name, 'age': age});
  }
}
