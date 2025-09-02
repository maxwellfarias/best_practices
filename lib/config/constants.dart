abstract final class Urls {
  static const String getTasks = '$urlBase/rest/v1/todos?select=*';
  static const String createTask = '$urlBase/rest/v1/todos';
  static const String deleteTask = '$urlBase/rest/v1/todos?id=eq.{id}';
  static const String updateTask = '$urlBase/rest/v1/todos?id=eq.{id}';
  static String deleteTaskUrl(String id) => deleteTask.replaceFirst('{id}', id);
  static String updateTaskUrl(String id) => updateTask.replaceFirst('{id}', id);
}

const urlBase = 'https://dqsbpsifdyujbbvbzjdq.supabase.co';
