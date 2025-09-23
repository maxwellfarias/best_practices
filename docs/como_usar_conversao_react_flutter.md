# 📚 Tutorial: Como Usar o Prompt de Conversão React → Flutter

## 🎯 Objetivo
Este tutorial ensina como usar o template de prompt para converter componentes React do projeto `/lovable` para Flutter, seguindo a arquitetura completa estabelecida no projeto.

## 📋 Pré-requisitos

### ✅ Arquivos Necessários
Antes de iniciar, certifique-se de ter acesso aos seguintes arquivos:

```
📁 Projeto Base
├── lovable/src/pages/{sua_pagina}.tsx     # Componente React a ser convertido
├── lib/templates/conversion_guides/
│   └── conversion_prompt_template.md      # Template do prompt
├── lib/exceptions/app_exception.dart      # Sistema de exceções
├── lib/utils/result.dart                  # Wrapper Result<T>
├── lib/utils/command.dart                 # Command pattern
└── lib/ui/core/themes/                    # Temas e estilos
```

### 🧠 Conhecimentos Necessários
- Básico de React (para entender o componente origem)
- Básico de Flutter (widgets, estado, layout)
- Padrões do projeto (Repository, ViewModel, Command)

## 🚀 Passo a Passo

### 📝 **PASSO 1: Analisar o Componente React**

Primeiro, analise o componente React que será convertido:

```tsx
// Exemplo: lovable/src/pages/medical-dashboard.tsx
import React from 'react';
import { Card, CardHeader, CardTitle } from '@/components/ui/card';

const MedicalDashboard = () => {
  const [patients, setPatients] = useState([]);
  
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-4">
      {patients.map(patient => (
        <Card key={patient.id}>
          <CardHeader>
            <CardTitle>{patient.name}</CardTitle>
          </CardHeader>
        </Card>
      ))}
    </div>
  );
};
```

**📊 Identifique:**
- ✅ **Dados**: Quais informações são exibidas? (ex: patients)
- ✅ **Layout**: Como está organizado? (grid responsivo)
- ✅ **Funcionalidades**: O que o usuário pode fazer? (ver, criar, editar)
- ✅ **Estados**: Loading, erro, lista vazia?
- ✅ **Componentes Importados**: Verificar TODOS os imports de @/components/ui/*
- ✅ **Estilos**: Classes Tailwind e variáveis CSS utilizadas

---

### � **PASSO 2.5: Analisar Estilos e Componentes**

Antes de definir a arquitetura, analise cuidadosamente os estilos e componentes:

#### **📝 Mapeamento de Tipografia**
```tsx
// React Tailwind → Flutter CustomTextTheme
text-4xl font-bold     → context.customTextTheme.text4XlBold
text-xl font-semibold  → context.customTextTheme.textXlSemibold
text-base font-medium  → context.customTextTheme.textBaseMedium
text-sm                → context.customTextTheme.textSm
```

#### **🎨 Mapeamento de Cores**
```tsx
// React CSS Variables → Flutter NewAppColorTheme  
--primary              → context.customColorTheme.primary
--background           → context.customColorTheme.background
--card                 → context.customColorTheme.card
--muted-foreground     → context.customColorTheme.mutedForeground
```

#### **📐 Mapeamento de Espaçamentos**
```tsx
// Tailwind → Flutter EdgeInsets
p-4                    → EdgeInsets.all(16)
px-6                   → EdgeInsets.symmetric(horizontal: 24)
py-2                   → EdgeInsets.symmetric(vertical: 8)
pt-4 pb-2              → EdgeInsets.only(top: 16, bottom: 8)
```

#### **🧩 Componentes Importados**
```tsx
// Sempre verificar TODOS os imports:
import { Button } from "@/components/ui/button";           → ElevatedButton/OutlinedButton
import { Card, CardContent } from "@/components/ui/card";  → Card widget
import { Dialog } from "@/components/ui/dialog";           → showDialog()
import { Form } from "@/components/ui/form";               → Form widget
import { Select } from "@/components/ui/select";           → DropdownButtonFormField
```

**⚠️ ATENÇÃO**: Não ignore os componentes importados! Eles são essenciais para a renderização completa.

Com base na análise, defina os nomes para a arquitetura:

```yaml
# Exemplo para Medical Dashboard
NOME_COMPONENTE: "MedicalDashboard"
NOME_MODELO: "Patient"          # Singular, PascalCase
NOME_TELA: "medical_dashboard"  # snake_case  
NOME_PAGINA: "medical-dashboard" # kebab-case (nome do arquivo React)
```

**📁 Estrutura que será criada:**
```
lib/
├── domain/models/
│   └── patient_model.dart                    # 1. Domain Model
├── utils/mocks/
│   └── patient_mock.dart                     # 2. Mock Data
├── data/repositories/patient/
│   ├── patient_repository.dart               # 3. Repository Interface
│   └── patient_repository_impl.dart          # 4. Repository Implementation
└── ui/medical_dashboard/
    ├── viewmodel/
    │   └── medical_dashboard_viewmodel.dart   # 5. ViewModel
    └── widget/
        └── medical_dashboard_screen.dart      # 6. UI Screen
```

---

### 🏗️ **PASSO 3: Definir a Arquitetura**

Abra o arquivo `lib/templates/conversion_guides/conversion_prompt_template.md` e localize a seção **"PROMPT FINAL PARA USO"**.

**🔄 Substitua as variáveis:**

```markdown
# ANTES (template):
Converta o componente React {NOME_COMPONENTE} para Flutter...
- **Domain Model Path**: /lib/domain/models/{NOME_MODELO}_model.dart
- **Tela Nome**: {NOME_TELA}
- **Componente React**: lovable/src/pages/{NOME_PAGINA}.tsx

# DEPOIS (preenchido):
Converta o componente React MedicalDashboard para Flutter...
- **Domain Model Path**: /lib/domain/models/patient_model.dart
- **Tela Nome**: medical_dashboard  
- **Componente React**: lovable/src/pages/medical-dashboard.tsx
```

---

### 📝 **PASSO 4: Preparar o Prompt**

#### 5.1 Abrir o Modo Agente
1. Pressione `Ctrl+Shift+P` (ou `Cmd+Shift+P` no Mac)
2. Digite: `GitHub Copilot: Open Chat`
3. Ou use o atalho: `Ctrl+Alt+I`

#### 5.2 Anexar Arquivos Necessários
No chat do Copilot, anexe os seguintes arquivos:

```
@lovable/src/pages/medical-dashboard.tsx
@lib/templates/conversion_guides/conversion_prompt_template.md
@lib/exceptions/app_exception.dart
@lib/utils/result.dart
@lib/utils/command.dart
@lib/ui/core/themes/theme.dart
@lib/ui/core/extensions/build_context_extension.dart
```

#### 5.3 Colar o Prompt Preenchido
Cole o prompt com as variáveis substituídas:

```
Converta o componente React MedicalDashboard para Flutter seguindo a arquitetura completa estabelecida no projeto.

**INFORMAÇÕES OBRIGATÓRIAS:**
- **Domain Model Path**: /lib/domain/models/patient_model.dart
- **Tela Nome**: medical_dashboard
- **Componente React**: lovable/src/pages/medical-dashboard.tsx

**ARQUITETURA COMPLETA (6 ARQUIVOS):**
1. Domain Model (/lib/domain/models/patient_model.dart)
2. Mock Data (/lib/utils/mocks/patient_mock.dart)  
3. Repository Interface (/lib/data/repositories/patient/patient_repository.dart)
4. Repository Implementation (/lib/data/repositories/patient/patient_repository_impl.dart)
5. ViewModel (/lib/ui/medical_dashboard/viewmodel/medical_dashboard_viewmodel.dart)
6. UI Screen (/lib/ui/medical_dashboard/widget/medical_dashboard_screen.dart)

**PADRÕES OBRIGATÓRIOS:**
- Domain Model: fromJson, toJson, copyWith, toString
- Mock: CRUD completo com Future.delayed(2s)
- Repository: 5 métodos com Result<T>
- ViewModel: Command pattern com notifyListeners
- UI: ListenableBuilder + Command listeners + responsividade

**FUNCIONALIDADES:**
- Layout responsivo (mobile/tablet/desktop)
- CRUD completo funcionando
- Estados loading/error/empty/success
- Feedback visual com SnackBars
- Formulários com validação
- Conversão fiel de estilos usando CustomTextTheme e NewAppColorTheme
- Todos os componentes importados devem ser considerados na conversão

**IMPORTANTE**: Analisar TODOS os imports do arquivo React, incluindo componentes de @/components/ui/*, pois estes são essenciais para a renderização completa da página.

Implemente seguindo exatamente o template de conversão anexado.
```

---

### 🤖 **PASSO 5: Usar o Prompt no GitHub Copilot**

#### 5.1 Abrir o Modo Agente
```dart
// ✅ Verificar se tem:
- Constructor com required/optional
- factory fromJson(dynamic json)
- Map<String, dynamic> toJson()
- copyWith({...})
- toString() override
```

#### 🔍 **5.2 Mock Data** (`patient_mock.dart`)
```dart
// ✅ Verificar se tem:
- Lista privada estática
- getMockPatients() com Future.delayed
- addPatient, getPatientById, updatePatient, deletePatient
- clearAllPatients, resetToInitialState
- 6-8 itens mock realistas
```

#### 🔍 **5.3 Repository Interface** (`patient_repository.dart`)
```dart
// ✅ Verificar se tem os 5 métodos:
- Future<Result<List<PatientModel>>> getAllPatients({required String databaseId})
- Future<Result<PatientModel>> getPatientBy({required String databaseId, required String patientId})
- Future<Result<PatientModel>> createPatient({required String databaseId, required PatientModel patient})
- Future<Result<PatientModel>> updatePatient({required String databaseId, required PatientModel patient})
- Future<Result<dynamic>> deletePatient({required String databaseId, required String patientId})
```

#### 🔍 **5.4 Repository Implementation** (`patient_repository_impl.dart`)
```dart
// ✅ Verificar se:
- Implementa a interface
- Todos os métodos delegam para PatientMock
- Usa Result.ok() e Result.error()
```

#### 🔍 **5.5 ViewModel** (`medical_dashboard_viewmodel.dart`)
```dart
// ✅ Verificar se tem:
- Constructor com repository injection
- 5 Commands: getAllPatients, getPatientBy, createPatient, updatePatient, deletePatient
- Lista privada _patients e getter público patients
- Métodos privados com notifyListeners()
- extends ChangeNotifier
```

#### 🔍 **5.6 UI Screen** (`medical_dashboard_screen.dart`)
```dart
// ✅ Verificar se tem:
- initState com 3 listeners (create, update, delete) + execute getAll
- dispose com removeListener
- _onResult com SnackBar para feedback
- ListenableBuilder com Listenable.merge
- Estados: loading (CupertinoActivityIndicator), error, empty, success
- Layout responsivo com LayoutBuilder
- FloatingActionButton para criar
- Métodos CRUD funcionais
```

---

### ✅ **PASSO 6: Validar o Resultado**

O Copilot irá gerar os 6 arquivos. Valide cada um:

#### 🔍 **6.1 Domain Model** (`patient_model.dart`)
```dart
// ✅ Verificar se tem:
- Constructor com required/optional
- factory fromJson(dynamic json)
- Map<String, dynamic> toJson()
- copyWith({...})
- toString() override
```

#### 🔍 **6.2 Mock Data** (`patient_mock.dart`)
```dart
// ✅ Verificar se tem:
- Lista privada estática
- getMockPatients() com Future.delayed
- addPatient, getPatientById, updatePatient, deletePatient
- clearAllPatients, resetToInitialState
- 6-8 itens mock realistas
```

#### 🔍 **6.3 Repository Interface** (`patient_repository.dart`)
```dart
// ✅ Verificar se tem os 5 métodos:
- Future<Result<List<PatientModel>>> getAllPatients({required String databaseId})
- Future<Result<PatientModel>> getPatientBy({required String databaseId, required String patientId})
- Future<Result<PatientModel>> createPatient({required String databaseId, required PatientModel patient})
- Future<Result<PatientModel>> updatePatient({required String databaseId, required PatientModel patient})
- Future<Result<dynamic>> deletePatient({required String databaseId, required String patientId})
```

#### 🔍 **6.4 Repository Implementation** (`patient_repository_impl.dart`)
```dart
// ✅ Verificar se:
- Implementa a interface
- Todos os métodos delegam para PatientMock
- Usa Result.ok() e Result.error()
```

#### 🔍 **6.5 ViewModel** (`medical_dashboard_viewmodel.dart`)
```dart
// ✅ Verificar se tem:
- Constructor com repository injection
- 5 Commands: getAllPatients, getPatientBy, createPatient, updatePatient, deletePatient
- Lista privada _patients e getter público patients
- Métodos privados com notifyListeners()
- extends ChangeNotifier
```

#### 🔍 **6.6 UI Screen** (`medical_dashboard_screen.dart`)
```dart
// ✅ Verificar se tem:
- initState com 3 listeners (create, update, delete) + execute getAll
- dispose com removeListener
- _onResult com SnackBar para feedback
- ListenableBuilder com Listenable.merge
- Estados: loading (CupertinoActivityIndicator), error, empty, success
- Layout responsivo com LayoutBuilder
- FloatingActionButton para criar
- Métodos CRUD funcionais
- Uso correto de CustomTextTheme e NewAppColorTheme
- Conversão fiel dos componentes React importados
```

---

#### 7.1 Compilar o Código
```bash
flutter pub get
flutter analyze
```

#### 7.2 Integrar na Navegação
Adicione a tela ao sistema de rotas do projeto:

```dart
// Em router.dart ou routes.dart
'/medical-dashboard': (context) => MedicalDashboardScreen(
  viewModel: MedicalDashboardViewModel(
    patientRepository: PatientRepositoryImpl(),
  ),
),
```

#### 7.3 Testar Funcionalidades
- ✅ Carregamento inicial (loading 2s)
- ✅ Lista de pacientes exibida
- ✅ Responsividade (mobile/tablet/desktop)
- ✅ Criar novo paciente
- ✅ Editar paciente existente
- ✅ Deletar paciente
- ✅ Feedback visual (SnackBars)
- ✅ Estados de erro
- ✅ Estilos fiéis ao React (tipografia, cores, espaçamentos)
- ✅ Todos os componentes funcionando

---

## 🎯 Casos de Uso Comuns

### 📊 **Dashboard com Cards**
```yaml
Componente: Dashboard
Modelo: Metric (id, title, value, trend, category)
Funcionalidades: Visualizar métricas, filtrar por categoria
Layout: Grid responsivo com cards
```

### 📝 **Lista de Formulários**
```yaml
Componente: FormList  
Modelo: Form (id, name, status, createdAt, fields)
Funcionalidades: CRUD completo, buscar, filtrar por status
Layout: Lista + modal de edição
```

### 👥 **Gerenciamento de Usuários**
```yaml
Componente: UserManagement
Modelo: User (id, name, email, role, isActive)
Funcionalidades: CRUD, ativar/desativar, filtrar por role
Layout: Tabela responsiva + dialogs
```

---

## ⚠️ Problemas Comuns e Soluções

### 🐛 **Problema 1: Copilot não gera todos os arquivos**
**Solução**: Seja mais específico no prompt:
```
"Crie EXATAMENTE 6 arquivos separados seguindo a estrutura anexada"
```

### 🐛 **Problema 2: Domain Model sem métodos obrigatórios**
**Solução**: Enfatize no prompt:
```
"OBRIGATÓRIO: fromJson, toJson, copyWith, toString implementados"
```

### 🐛 **Problema 3: Mock sem Future.delayed**
**Solução**: Seja específico:
```
"Mock deve ter Future.delayed(Duration(seconds: 2)) para simular rede"
```

### 🐛 **Problema 4: ViewModel sem Command pattern**
**Solução**: Anexe o arquivo command.dart e enfatize:
```
"Usar Command0 e Command1 conforme arquivo command.dart anexado"
```

### 🐛 **Problema 5: UI sem responsividade**
**Solução**: Detalhe os breakpoints:
```
"LayoutBuilder obrigatório: mobile < 640px, tablet 640-1024px, desktop > 1024px"
```

### 🐛 **Problema 6: Estilos não fiéis ao React**
**Solução**: Enfatize o uso dos temas customizados:
```
"OBRIGATÓRIO: Usar CustomTextTheme e NewAppColorTheme conforme tabelas de mapeamento"
```

### 🐛 **Problema 7: Componentes React não considerados**
**Solução**: Destaque a importância dos imports:
```
"Analisar TODOS os imports de @/components/ui/* e converter cada um para Flutter"
```

### 🐛 **Problema 8: Espaçamentos incorretos**
**Solução**: Forneça a tabela de conversão:
```
"Usar tabela de conversão Tailwind → EdgeInsets: p-4 = EdgeInsets.all(16)"
```

---

## 📚 Recursos Adicionais

### 🔗 **Links Úteis**
- [Documentação Flutter](https://flutter.dev/docs)
- [Command Pattern no Flutter](https://flutter.dev/docs/development/data-and-backend/state-mgmt)
- [Repository Pattern](https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple)

### 📖 **Arquivos de Referência**
- `lib/templates/conversion_guides/react_to_flutter_guide.md` - Guia detalhado
- `lib/utils/command.dart` - Implementação do Command pattern
- `lib/utils/result.dart` - Wrapper para resultados
- `lib/exceptions/app_exception.dart` - Sistema de exceções

### 🎓 **Próximos Passos**
1. Praticar com componentes simples primeiro
2. Entender bem o Command pattern
3. Dominar o ListenableBuilder
4. Implementar testes unitários
5. Otimizar performance

---

## ✅ Checklist Final

### 📋 **Antes de Usar o Prompt**
- [ ] Analisei o componente React
- [ ] Defini nomes da arquitetura (modelo, tela, etc.)
- [ ] Preparei o prompt com variáveis substituídas
- [ ] Anexei todos os arquivos necessários

### 📋 **Após Receber o Resultado**
- [ ] Validei os 6 arquivos gerados
- [ ] Compilei sem erros
- [ ] Testei todas as funcionalidades
- [ ] Verifiquei fidelidade visual (tipografia, cores, espaçamentos)
- [ ] Confirmei que todos os componentes React foram convertidos
- [ ] Testei responsividade em diferentes breakpoints
- [ ] Integrei na navegação do app
- [ ] Documentei mudanças (se necessário)

---

🎉 **Parabéns!** Agora você sabe como usar o prompt de conversão para criar uma arquitetura Flutter completa e funcional a partir de componentes React!
