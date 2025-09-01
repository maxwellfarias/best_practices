abstract final class Routes {
  static const String getTasks = '$urlBase/rest/v1/todos?select=*';
  static const String createTask = '/taskDetails';
  static const String deleteTask = '/createTask';
  static const String updateTask = '/editTask';
}

const urlBase = 'https://dqsbpsifdyujbbvbzjdq.supabase.co';
