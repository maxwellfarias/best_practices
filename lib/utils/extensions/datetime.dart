extension DateTimeFormatting on DateTime {
  String toBrString() {
    // Formatar a data como "dd/MM/yyyy"
    const weekdays = ['Segunda-feira', 'Terça-feira', 'Quarta-feira', 'Quinta-feira', 'Sexta-feira', 'Sábado', 'Domingo'];
    const months = ['janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho', 'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro'];
    
    String weekday = weekdays[this.weekday - 1];
    String day = this.day.toString().padLeft(2, '0');
    String month = months[this.month - 1];
    String year = this.year.toString();
    
    return "$weekday, $day de $month de $year";
  }
}