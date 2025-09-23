import 'package:flutter/material.dart';

/// [DESCRIPTION]
/// Modelos de dados para [COMPONENT_NAME]
/// Migrados diretamente dos tipos TypeScript

// Exemplo de enum para status/tipos
enum ExampleStatus {
  active('active', 'Ativo'),
  inactive('inactive', 'Inativo'),
  pending('pending', 'Pendente'),
  error('error', 'Erro');

  const ExampleStatus(this.value, this.label);
  
  final String value;
  final String label;
  
  // Método para conversão de string
  static ExampleStatus fromString(String value) {
    return ExampleStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => ExampleStatus.inactive,
    );
  }
  
  // Extension para cores baseadas no status
  Color getColor(BuildContext context) {
    // TODO: Mapear cores do tema baseadas no status
    switch (this) {
      case ExampleStatus.active:
        return Colors.green;
      case ExampleStatus.inactive:
        return Colors.grey;
      case ExampleStatus.pending:
        return Colors.orange;
      case ExampleStatus.error:
        return Colors.red;
    }
  }
  
  // Extension para ícones baseados no status
  IconData getIcon() {
    switch (this) {
      case ExampleStatus.active:
        return Icons.check_circle;
      case ExampleStatus.inactive:
        return Icons.circle_outlined;
      case ExampleStatus.pending:
        return Icons.schedule;
      case ExampleStatus.error:
        return Icons.error;
    }
  }
}

// Modelo principal
class ExampleModel {
  final String id;
  final String title;
  final String? description;
  final ExampleStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? metadata;
  final List<String> tags;
  final double? value;
  final bool isActive;

  const ExampleModel({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.metadata,
    this.tags = const [],
    this.value,
    this.isActive = true,
  });

  // Factory constructor para JSON (APIs)
  factory ExampleModel.fromJson(Map<String, dynamic> json) {
    return ExampleModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      status: ExampleStatus.fromString(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
      tags: List<String>.from(json['tags'] ?? []),
      value: (json['value'] as num?)?.toDouble(),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  // Método para converter para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.value,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'metadata': metadata,
      'tags': tags,
      'value': value,
      'isActive': isActive,
    };
  }

  // Método copyWith para atualizações imutáveis
  ExampleModel copyWith({
    String? id,
    String? title,
    String? description,
    ExampleStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
    List<String>? tags,
    double? value,
    bool? isActive,
  }) {
    return ExampleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
      tags: tags ?? this.tags,
      value: value ?? this.value,
      isActive: isActive ?? this.isActive,
    );
  }

  // Operadores de igualdade
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExampleModel &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      description,
      status,
      createdAt,
      updatedAt,
      isActive,
    );
  }

  @override
  String toString() {
    return 'ExampleModel(id: $id, title: $title, status: $status, isActive: $isActive)';
  }

  // Getters computados úteis
  bool get isExpired {
    // TODO: Implementar lógica de expiração
    return false;
  }

  String get formattedDate {
    // TODO: Implementar formatação de data customizada
    return createdAt.toString();
  }

  String get displayValue {
    if (value == null) return 'N/A';
    // TODO: Implementar formatação de valor (moeda, porcentagem, etc.)
    return value!.toStringAsFixed(2);
  }
}

// Modelo secundário/relacionado
class ExampleItem {
  final String id;
  final String exampleModelId; // Foreign key
  final String name;
  final int quantity;
  final DateTime timestamp;

  const ExampleItem({
    required this.id,
    required this.exampleModelId,
    required this.name,
    required this.quantity,
    required this.timestamp,
  });

  factory ExampleItem.fromJson(Map<String, dynamic> json) {
    return ExampleItem(
      id: json['id'] as String,
      exampleModelId: json['exampleModelId'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exampleModelId': exampleModelId,
      'name': name,
      'quantity': quantity,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExampleItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Classe para dados mockados/de exemplo
class ExampleMockData {
  static final List<ExampleModel> examples = [
    ExampleModel(
      id: '1',
      title: 'Exemplo 1',
      description: 'Descrição do primeiro exemplo',
      status: ExampleStatus.active,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      tags: ['tag1', 'tag2'],
      value: 42.5,
    ),
    ExampleModel(
      id: '2',
      title: 'Exemplo 2',
      description: 'Descrição do segundo exemplo',
      status: ExampleStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      tags: ['tag2', 'tag3'],
      value: 128.0,
    ),
    ExampleModel(
      id: '3',
      title: 'Exemplo 3',
      status: ExampleStatus.inactive,
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      tags: ['tag1'],
      value: 99.99,
      isActive: false,
    ),
  ];

  static final List<ExampleItem> items = [
    ExampleItem(
      id: 'item1',
      exampleModelId: '1',
      name: 'Item A',
      quantity: 5,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    ExampleItem(
      id: 'item2',
      exampleModelId: '1',
      name: 'Item B',
      quantity: 3,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    ExampleItem(
      id: 'item3',
      exampleModelId: '2',
      name: 'Item C',
      quantity: 8,
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
  ];

  // Métodos utilitários para dados mock
  static ExampleModel? getExampleById(String id) {
    try {
      return examples.firstWhere((example) => example.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<ExampleItem> getItemsByExampleId(String exampleId) {
    return items.where((item) => item.exampleModelId == exampleId).toList();
  }

  static List<ExampleModel> getExamplesByStatus(ExampleStatus status) {
    return examples.where((example) => example.status == status).toList();
  }

  static List<ExampleModel> getActiveExamples() {
    return examples.where((example) => example.isActive).toList();
  }
}

/*
TEMPLATE DE MODELOS PARA CONVERSÃO REACT → FLUTTER

CARACTERÍSTICAS:
✓ Classes imutáveis com const constructors
✓ Factory constructors para JSON serialization
✓ Métodos copyWith para atualizações imutáveis
✓ Operadores == e hashCode implementados
✓ Enums com extensões para cores e ícones
✓ Dados mock organizados em classe separada
✓ Getters computados para valores derivados
✓ Relacionamentos entre modelos (foreign keys)

CONVERSÃO DE TYPESCRIPT:
interface User { } → class User { }
type Status = 'active' | 'inactive' → enum Status { active, inactive }
Pick<User, 'id' | 'name'> → criar classe separada ou usar parâmetros nomeados
Partial<User> → usar parâmetros opcionais no copyWith
user?.property → usar null-aware operators

CHECKLIST DE CONVERSÃO:
[ ] Identificar todas as interfaces/types do TypeScript
[ ] Converter union types para enums
[ ] Mapear propriedades opcionais para campos nullable
[ ] Implementar serialização JSON se necessário
[ ] Criar dados mock idênticos ao React
[ ] Adicionar validações nos constructors se necessário
[ ] Implementar extensões para UI (cores, ícones)
[ ] Organizar relacionamentos entre modelos
*/