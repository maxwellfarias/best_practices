# Workflow de Conversão React → Flutter

Este guia detalha o processo passo-a-passo para converter componentes React para Flutter usando os templates criados.

## 🚀 Visão Geral do Processo

1. **Análise do Componente React** - Entender estrutura e funcionalidades
2. **Preparação dos Modelos** - Converter interfaces TypeScript 
3. **Criação do Widget Base** - Escolher template apropriado
4. **Implementação da UI** - Replicar layout e estilos
5. **Migração da Lógica** - Converter hooks e estados
6. **Testes e Refinamento** - Validar fidelidade visual

## 📋 Pré-requisitos

- Componente React original funcional
- Design system Flutter configurado (CustomTextTheme, NewAppColorTheme)
- Templates do projeto disponíveis em `templates/flutter_templates/`

## 🔍 Fase 1: Análise do Componente React

### 1.1 Inventário de Funcionalidades
```checklist
[ ] Identificar props do componente
[ ] Mapear hooks utilizados (useState, useEffect, etc.)
[ ] Listar eventos e callbacks
[ ] Documentar estados do componente
[ ] Identificar dependências externas
[ ] Mapear responsividade e breakpoints
```

### 1.2 Análise de Estilos
```checklist
[ ] Listar classes Tailwind utilizadas
[ ] Identificar componentes do design system
[ ] Mapear cores customizadas
[ ] Documentar animações e transições
[ ] Identificar layouts responsivos
[ ] Listar ícones utilizados
```

### 1.3 Análise de Dados
```checklist
[ ] Identificar interfaces TypeScript
[ ] Mapear tipos de dados
[ ] Documentar estruturas de estado
[ ] Listar dados mock/exemplo
[ ] Identificar validações
[ ] Mapear transformações de dados
```

## 🏗️ Fase 2: Preparação dos Modelos

### 2.1 Conversão de Interfaces TypeScript

Usar template: `data_models_template.dart`

**Mapeamento TypeScript → Dart:**
```typescript
// TypeScript
interface User {
  id: string;
  name: string;
  email?: string;
  status: 'active' | 'inactive';
  createdAt: Date;
}

type UserStatus = 'active' | 'inactive';
```

```dart
// Dart
enum UserStatus {
  active('active', 'Ativo'),
  inactive('inactive', 'Inativo');
  
  const UserStatus(this.value, this.label);
  final String value;
  final String label;
}

class User {
  final String id;
  final String name;
  final String? email;
  final UserStatus status;
  final DateTime createdAt;
  
  const User({
    required this.id,
    required this.name,
    this.email,
    required this.status,
    required this.createdAt,
  });
  
  // fromJson, toJson, copyWith, etc.
}
```

### 2.2 Checklist de Modelos
```checklist
[ ] Converter todas as interfaces para classes Dart
[ ] Criar enums para union types
[ ] Implementar constructors com validação
[ ] Adicionar métodos fromJson/toJson se necessário
[ ] Implementar copyWith para imutabilidade
[ ] Criar dados mock idênticos ao React
[ ] Adicionar extensões para UI (cores, ícones)
[ ] Documentar relacionamentos entre modelos
```

## 🎨 Fase 3: Criação do Widget Base

### 3.1 Escolha do Template

| Tipo de Componente | Template Recomendado |
|-------------------|---------------------|
| Página completa com estado | `stateful_widget_template.dart` |
| Widget simples sem estado | `simple_widget_template.dart` |
| Formulários com validação | `form_widget_template.dart` |
| Cards/itens de lista | `simple_widget_template.dart` |

### 3.2 Customização do Template

1. **Renomear classe e arquivo**
```dart
// De: ExamplePage
// Para: UserProfilePage
class UserProfilePage extends StatefulWidget {
```

2. **Substituir placeholders**
```dart
// [DESCRIPTION] → "Tela de perfil do usuário"
// [COMPONENT_NAME] → "UserProfile"
```

3. **Configurar imports**
```dart
import '../models/user_models.dart';
import '../widgets/user_avatar.dart';
```

## 🎯 Fase 4: Implementação da UI

### 4.1 Mapeamento de Estilos Tailwind

**Classes Tailwind → Flutter:**

| Tailwind | Flutter CustomTextTheme |
|----------|------------------------|
| `text-xl font-bold` | `customTextTheme.textXlBold` |
| `text-sm text-gray-500` | `customTextTheme.textSm.copyWith(color: mutedForeground)` |
| `bg-white border` | `Card(color: card)` |

**Layout responsivo:**
```dart
LayoutBuilder(
  builder: (context, constraints) {
    // Tailwind: sm:flex-col md:flex-row lg:grid-cols-3
    if (constraints.maxWidth < 640) {
      return _buildMobileLayout();
    } else if (constraints.maxWidth < 1024) {
      return _buildTabletLayout();
    } else {
      return _buildDesktopLayout();
    }
  },
)
```

### 4.2 Checklist de UI
```checklist
[ ] Replicar estrutura de layout (Container, Row, Column)
[ ] Implementar responsividade com LayoutBuilder
[ ] Mapear todas as classes Tailwind
[ ] Adicionar elevação e sombras
[ ] Implementar gradientes se necessário
[ ] Configurar border radius e paddings
[ ] Adicionar hover effects com InkWell
[ ] Testar em diferentes tamanhos de tela
```

## ⚡ Fase 5: Migração da Lógica

### 5.1 Conversão de Hooks React

**useState → variáveis de estado:**
```dart
// React
const [loading, setLoading] = useState(false);
const [data, setData] = useState([]);

// Flutter
bool _loading = false;
List<User> _data = [];

void _setLoading(bool value) {
  setState(() {
    _loading = value;
  });
}
```

**useEffect → lifecycle methods:**
```dart
// React
useEffect(() => {
  fetchData();
}, []);

// Flutter
@override
void initState() {
  super.initState();
  _fetchData();
}
```

**useCallback → métodos da classe:**
```dart
// React
const handleSubmit = useCallback(() => {
  // lógica
}, [dependency]);

// Flutter
void _handleSubmit() {
  // lógica
}
```

### 5.2 Checklist de Lógica
```checklist
[ ] Converter todos os useState para variáveis de estado
[ ] Migrar useEffect para initState/didChangeDependencies
[ ] Implementar callbacks como métodos da classe
[ ] Adicionar controllers para TextFields
[ ] Configurar FocusNodes para navegação
[ ] Implementar dispose para cleanup
[ ] Adicionar validações de formulário
[ ] Manter lógica de negócio idêntica
```

## 🧪 Fase 6: Testes e Refinamento

### 6.1 Validação Visual
```checklist
[ ] Comparar lado a lado com versão React
[ ] Testar em breakpoints mobile (< 640px)
[ ] Testar em breakpoints tablet (640-1024px)
[ ] Testar em breakpoints desktop (> 1024px)
[ ] Validar cores do tema
[ ] Verificar tipografia
[ ] Testar estados de hover
[ ] Validar animações
```

### 6.2 Validação Funcional
```checklist
[ ] Testar todos os eventos de tap/click
[ ] Validar formulários e inputs
[ ] Testar estados de loading
[ ] Verificar navegação entre telas
[ ] Testar modais e dialogs
[ ] Validar dados mock
[ ] Testar cenários de erro
[ ] Verificar performance
```

### 6.3 Checklist de Qualidade
```checklist
[ ] Código sem warnings do analyzer
[ ] Widgets const onde apropriado
[ ] Dispose implementado corretamente
[ ] Comentários em código complexo
[ ] Nomes de variáveis consistentes
[ ] Estrutura de pastas organizada
[ ] Imports organizados
[ ] Performance otimizada
```

## 📚 Recursos de Referência

### Templates Disponíveis
- `stateful_widget_template.dart` - Páginas com estado
- `simple_widget_template.dart` - Widgets simples
- `form_widget_template.dart` - Formulários
- `data_models_template.dart` - Modelos de dados

### Documentação
- `react_to_flutter_guide.md` - Guia técnico completo
- `conversion_prompt_template.md` - Template para solicitações

### Mapeamentos Rápidos
- Breakpoints: mobile < 640px, tablet 640-1024px, desktop > 1024px
- Cores: usar NewAppColorTheme
- Tipografia: usar CustomTextTheme
- Layouts: LayoutBuilder para responsividade

## 🔄 Exemplo Prático Completo

### Componente React Original:
```tsx
interface User {
  id: string;
  name: string;
  email: string;
  status: 'active' | 'inactive';
}

const UserCard: React.FC<{ user: User; onClick: () => void }> = ({ user, onClick }) => {
  return (
    <div 
      className="bg-white p-4 rounded-lg shadow-md hover:shadow-lg cursor-pointer"
      onClick={onClick}
    >
      <h3 className="text-lg font-semibold text-gray-900">{user.name}</h3>
      <p className="text-sm text-gray-500">{user.email}</p>
      <span className={`inline-block px-2 py-1 rounded text-xs ${
        user.status === 'active' ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'
      }`}>
        {user.status}
      </span>
    </div>
  );
};
```

### Versão Flutter Convertida:
```dart
// user_models.dart
enum UserStatus {
  active('active', 'Ativo'),
  inactive('inactive', 'Inativo');
  
  const UserStatus(this.value, this.label);
  final String value;
  final String label;
}

class User {
  final String id;
  final String name;
  final String email;
  final UserStatus status;
  
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
  });
}

// user_card.dart
class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback? onTap;
  
  const UserCard({
    super.key,
    required this.user,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: context.customColorTheme.card,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: context.customTextTheme.textLgSemibold.copyWith(
                  color: context.customColorTheme.foreground,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.email,
                style: context.customTextTheme.textSm.copyWith(
                  color: context.customColorTheme.mutedForeground,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: user.status == UserStatus.active 
                    ? Colors.green.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  user.status.label,
                  style: context.customTextTheme.textXs.copyWith(
                    color: user.status == UserStatus.active 
                      ? Colors.green.shade800
                      : Colors.grey.shade800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

Este workflow garante conversões consistentes e de alta qualidade, mantendo fidelidade visual e funcional com os componentes React originais.