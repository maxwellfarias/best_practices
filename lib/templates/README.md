# Sistema de Templates para Conversão React → Flutter

Este diretório contém um sistema completo de templates e guias para converter componentes React para Flutter com alta fidelidade visual e funcional.

## 📁 Estrutura dos Templates

```
templates/
├── conversion_guides/          # Documentação e guias
│   ├── react_to_flutter_guide.md     # Guia técnico completo
│   ├── conversion_prompt_template.md  # Template para prompts
│   └── conversion_workflow.md         # Workflow passo-a-passo
└── flutter_templates/         # Templates de código
    ├── stateful_widget_template.dart  # Páginas com estado
    ├── simple_widget_template.dart    # Widgets simples
    ├── form_widget_template.dart      # Formulários
    └── data_models_template.dart      # Modelos de dados
```

## 🚀 Como Usar

### 1. Para Conversões Manuais
1. Leia o `conversion_workflow.md` para entender o processo
2. Escolha o template apropriado em `flutter_templates/`
3. Siga o guia técnico em `react_to_flutter_guide.md`
4. Use os checklists para validação

### 2. Para Solicitações de IA
1. Use o template em `conversion_prompt_template.md`
2. Substitua os placeholders pelos dados do seu componente
3. Faça a solicitação para o assistente de IA
4. Valide o resultado usando os checklists

## 📋 Templates Disponíveis

### 🧩 Templates de Código Flutter

#### `stateful_widget_template.dart`
**Para:** Páginas completas, componentes com estado complexo
**Inclui:**
- Layout responsivo (mobile/tablet/desktop)
- Gerenciamento de estado
- Modais e dialogs
- Header com ações
- Sidebar/conteúdo lateral

**Exemplo de uso:**
- Dashboards
- Páginas de perfil
- Telas com formulários complexos
- Componentes com múltiplos estados

#### `simple_widget_template.dart`
**Para:** Widgets simples, cards, componentes de lista
**Inclui:**
- Layout responsivo básico
- Props/parâmetros
- Estados de loading
- Hover effects
- Layouts compacto e normal

**Exemplo de uso:**
- Cards de dados
- Itens de lista
- Botões customizados
- Widgets de exibição

#### `form_widget_template.dart`
**Para:** Formulários com validação
**Inclui:**
- Validação em tempo real
- Controllers gerenciados
- Campos de texto, números, email
- Dropdowns e switches
- Layout responsivo para ações

**Exemplo de uso:**
- Formulários de cadastro
- Formulários de edição
- Filtros avançados
- Configurações

#### `data_models_template.dart`
**Para:** Modelos de dados e estruturas
**Inclui:**
- Classes imutáveis
- Enums com extensões
- Serialização JSON
- Dados mock organizados
- Relacionamentos entre modelos

**Exemplo de uso:**
- Modelos de API
- Estados de aplicação
- Estruturas de dados complexas
- Enums de status/tipos

### 📚 Guias de Conversão

#### `react_to_flutter_guide.md`
Guia técnico completo com mapeamentos detalhados:
- Tipografia e cores
- Componentes equivalentes
- Layouts responsivos
- Estados e hooks
- Eventos e callbacks

#### `conversion_prompt_template.md`
Template estruturado para solicitações de IA:
- Formato padronizado
- Exemplos de uso
- Critérios de validação
- Checklist de qualidade

#### `conversion_workflow.md`
Processo passo-a-passo completo:
- Análise do componente React
- Preparação dos modelos
- Implementação da UI
- Migração da lógica
- Testes e refinamento

## ⚙️ Configuração do Projeto

Este sistema de templates assume que seu projeto Flutter possui:

### Design System Configurado
```dart
// Extensões de tema disponíveis
context.customTextTheme.textLgBold
context.customColorTheme.primary
context.customColorTheme.card
```

### Estrutura de Pastas
```
lib/
├── ui/
│   ├── core/
│   │   └── extensions/
│   │       └── build_context_extension.dart
│   └── [feature]/
│       ├── widgets/
│       ├── models/
│       └── [feature]_page.dart
```

### Breakpoints Responsivos
- Mobile: < 640px
- Tablet: 640px - 1024px  
- Desktop: > 1024px

## 🎯 Exemplos de Uso

### Exemplo 1: Convertendo um Card React

**React Original:**
```tsx
const UserCard = ({ user, onClick }) => (
  <div className="bg-white p-4 rounded-lg shadow-md" onClick={onClick}>
    <h3 className="text-lg font-semibold">{user.name}</h3>
    <p className="text-sm text-gray-500">{user.email}</p>
  </div>
);
```

**Passos:**
1. Use `simple_widget_template.dart`
2. Migre props para parâmetros do construtor
3. Converta classes Tailwind para tema customizado
4. Implemente evento onClick como onTap

### Exemplo 2: Convertendo um Formulário

**React Original:**
```tsx
const UserForm = () => {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  
  const handleSubmit = (e) => {
    e.preventDefault();
    // validação e submit
  };
  
  return <form onSubmit={handleSubmit}>...</form>;
};
```

**Passos:**
1. Use `form_widget_template.dart`
2. Converta useState para controllers
3. Implemente validação com Form e validators
4. Configure navegação entre campos

### Exemplo 3: Convertendo uma Página Completa

**React Original:**
```tsx
const Dashboard = () => {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(false);
  
  useEffect(() => {
    fetchData();
  }, []);
  
  return <div className="container">...</div>;
};
```

**Passos:**
1. Use `stateful_widget_template.dart`
2. Converta useState para variáveis de estado
3. Migre useEffect para initState
4. Implemente layout responsivo

## 🔄 Processo de Melhoria

Este sistema de templates está em constante evolução. Para contribuir:

1. **Identifique padrões recorrentes** em conversões
2. **Documente soluções** para problemas específicos
3. **Atualize templates** com melhorias descobertas
4. **Compartilhe feedback** sobre usabilidade

## 📈 Métricas de Sucesso

Uma conversão bem-sucedida deve ter:
- ✅ **Fidelidade visual** 100% ao React original
- ✅ **Funcionalidade idêntica** em todos os cenários
- ✅ **Responsividade** mantida em todos breakpoints
- ✅ **Performance** otimizada para Flutter
- ✅ **Código limpo** seguindo boas práticas
- ✅ **Zero warnings** do analyzer Dart

## 🆘 Troubleshooting

### Problemas Comuns

**Erro de compilação com templates:**
- Substitua todos os placeholders [NOME] por valores reais
- Verifique imports necessários
- Remova código não utilizado

**Layout diferente do React:**
- Verifique mapeamento de classes Tailwind
- Confirme breakpoints responsivos
- Validar cores do tema customizado

**Estados não funcionando:**
- Certifique-se de usar setState()
- Implemente dispose corretamente
- Verifique inicialização no initState

**Performance ruim:**
- Adicione const em widgets estáticos
- Use LayoutBuilder apenas quando necessário
- Otimize rebuilds desnecessários

---

**Criado para o projeto Palliative Care - Sistema de conversão React → Flutter**
**Última atualização:** Dezembro 2024