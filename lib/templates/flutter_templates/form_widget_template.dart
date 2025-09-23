import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mastering_tests/ui/core/extensions/build_context_extension.dart';

/// [DESCRIPTION]
/// Formulário com validação inspirado no React Hook Form
class ExampleFormWidget extends StatefulWidget {
  final VoidCallback? onSubmit;
  final VoidCallback? onCancel;
  final bool isLoading;
  final Map<String, dynamic>? initialValues;

  const ExampleFormWidget({
    super.key,
    this.onSubmit,
    this.onCancel,
    this.isLoading = false,
    this.initialValues,
  });

  @override
  State<ExampleFormWidget> createState() => _ExampleFormWidgetState();
}

class _ExampleFormWidgetState extends State<ExampleFormWidget> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers para cada campo
  final _textController = TextEditingController();
  final _numberController = TextEditingController();
  final _emailController = TextEditingController();
  
  // Focus nodes para navegação
  final _textFocus = FocusNode();
  final _numberFocus = FocusNode();
  final _emailFocus = FocusNode();
  
  // Estados do formulário
  bool _isValid = false;
  String? _selectedOption;
  bool _switchValue = false;
  
  // Opções para dropdowns/selects
  final List<String> _options = [
    'Opção 1',
    'Opção 2', 
    'Opção 3',
  ];

  @override
  void initState() {
    super.initState();
    _initializeForm();
    _setupValidation();
  }

  @override
  void dispose() {
    _textController.dispose();
    _numberController.dispose();
    _emailController.dispose();
    _textFocus.dispose();
    _numberFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  void _initializeForm() {
    if (widget.initialValues != null) {
      _textController.text = widget.initialValues!['text'] ?? '';
      _numberController.text = widget.initialValues!['number']?.toString() ?? '';
      _emailController.text = widget.initialValues!['email'] ?? '';
      _selectedOption = widget.initialValues!['option'];
      _switchValue = widget.initialValues!['switch'] ?? false;
    }
  }

  void _setupValidation() {
    // Listener para validação em tempo real
    void validateForm() {
      setState(() {
        _isValid = _formKey.currentState?.validate() ?? false;
      });
    }

    _textController.addListener(validateForm);
    _numberController.addListener(validateForm);
    _emailController.addListener(validateForm);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: context.customColorTheme.card,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.customColorTheme.card,
              context.customColorTheme.muted.withOpacity(0.2),
            ],
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildFormFields(context),
              const SizedBox(height: 24),
              _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Título do Formulário',
          style: context.customTextTheme.textXlBold.copyWith(
            color: context.customColorTheme.foreground,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Descrição do formulário e instruções',
          style: context.customTextTheme.textSm.copyWith(
            color: context.customColorTheme.mutedForeground,
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields(BuildContext context) {
    return Column(
      children: [
        // Campo de texto obrigatório
        _buildTextField(
          controller: _textController,
          focusNode: _textFocus,
          nextFocusNode: _numberFocus,
          label: 'Campo de Texto',
          hint: 'Digite um texto',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Este campo é obrigatório';
            }
            if (value.length < 3) {
              return 'Mínimo 3 caracteres';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Campo numérico
        _buildTextField(
          controller: _numberController,
          focusNode: _numberFocus,
          nextFocusNode: _emailFocus,
          label: 'Campo Numérico',
          hint: 'Digite um número',
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo é obrigatório';
            }
            final number = int.tryParse(value);
            if (number == null) {
              return 'Digite apenas números';
            }
            if (number <= 0) {
              return 'Deve ser maior que zero';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Campo de email
        _buildTextField(
          controller: _emailController,
          focusNode: _emailFocus,
          label: 'Email',
          hint: 'Digite seu email',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo é obrigatório';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Email inválido';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Dropdown
        _buildDropdown(context),
        const SizedBox(height: 16),
        
        // Switch
        _buildSwitch(context),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocusNode,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    TextInputAction? textInputAction,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.customTextTheme.textSmMedium.copyWith(
            color: context.customColorTheme.foreground,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          textInputAction: textInputAction ?? TextInputAction.next,
          validator: validator,
          onFieldSubmitted: (_) {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            }
          },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: context.customTextTheme.textSm.copyWith(
              color: context.customColorTheme.mutedForeground,
            ),
            filled: true,
            fillColor: context.customColorTheme.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.customColorTheme.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.customColorTheme.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.customColorTheme.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.customColorTheme.destructive),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Opção',
          style: context.customTextTheme.textSmMedium.copyWith(
            color: context.customColorTheme.foreground,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _selectedOption,
          decoration: InputDecoration(
            filled: true,
            fillColor: context.customColorTheme.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.customColorTheme.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.customColorTheme.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.customColorTheme.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          hint: Text(
            'Selecione uma opção',
            style: context.customTextTheme.textSm.copyWith(
              color: context.customColorTheme.mutedForeground,
            ),
          ),
          items: _options.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(
                option,
                style: context.customTextTheme.textSm.copyWith(
                  color: context.customColorTheme.foreground,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedOption = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Selecione uma opção';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSwitch(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Configuração Opcional',
                style: context.customTextTheme.textSmMedium.copyWith(
                  color: context.customColorTheme.foreground,
                ),
              ),
              Text(
                'Descrição da configuração',
                style: context.customTextTheme.textXs.copyWith(
                  color: context.customColorTheme.mutedForeground,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: _switchValue,
          onChanged: (value) {
            setState(() {
              _switchValue = value;
            });
          },
          activeColor: context.customColorTheme.primary,
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 400) {
          // Layout vertical em telas pequenas
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: _isValid && !widget.isLoading ? _handleSubmit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.customColorTheme.primary,
                  foregroundColor: context.customColorTheme.primaryForeground,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: widget.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Confirmar'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: widget.isLoading ? null : widget.onCancel,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: context.customColorTheme.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Cancelar'),
              ),
            ],
          );
        }
        
        // Layout horizontal em telas maiores
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: widget.isLoading ? null : widget.onCancel,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: context.customColorTheme.border),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Cancelar'),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _isValid && !widget.isLoading ? _handleSubmit : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.customColorTheme.primary,
                foregroundColor: context.customColorTheme.primaryForeground,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Coletar dados do formulário
      final formData = {
        'text': _textController.text.trim(),
        'number': int.tryParse(_numberController.text),
        'email': _emailController.text.trim(),
        'option': _selectedOption,
        'switch': _switchValue,
      };
      
      // TODO: Processar dados do formulário
      debugPrint('Form data: $formData');
      
      widget.onSubmit?.call();
    }
  }
}

/*
TEMPLATE DE FORMULÁRIO PARA CONVERSÃO REACT → FLUTTER

CARACTERÍSTICAS:
✓ Validação em tempo real
✓ Controllers e FocusNodes gerenciados
✓ Formatação de input (números, email)
✓ Layout responsivo para ações
✓ Estados de loading
✓ Integração com tema customizado
✓ Cleanup automático no dispose

TIPOS DE CAMPO INCLUÍDOS:
✓ TextFormField com validação
✓ Campo numérico com formatters
✓ Campo de email com regex
✓ DropdownButtonFormField
✓ Switch com descrição

CHECKLIST DE CONVERSÃO:
[ ] Identificar todos os campos do formulário React
[ ] Mapear validações do React Hook Form
[ ] Criar controllers para cada campo
[ ] Implementar validações personalizadas
[ ] Ajustar labels e hints conforme design
[ ] Configurar navegação entre campos (Tab)
[ ] Implementar submit handler
[ ] Adicionar feedback visual (loading, erros)
*/