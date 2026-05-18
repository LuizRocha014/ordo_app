import 'package:componentes_lr/componentes_lr.dart'
    show CepInputFormatter, cpfMask, phoneMask;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/ordo_colors.dart';
import '../../../../core/theme/ordo_radius.dart';
import '../../../../core/theme/ordo_spacing.dart';
import '../../../../core/theme/ordo_typography.dart';
import '../../../../shared/widgets/ordo_button.dart';
import '../../../../shared/widgets/ordo_field.dart';
import '../../../../shared/widgets/ordo_icon.dart';
import '../../../../shared/widgets/top_bar.dart';
import '../../../service_order/domain/entities/address.dart';
import '../controllers/clients_controller.dart';

class CadastroClientePage extends StatefulWidget {
  const CadastroClientePage({super.key});

  @override
  State<CadastroClientePage> createState() => _CadastroClientePageState();
}

class _CadastroClientePageState extends State<CadastroClientePage> {
  final _controller = Get.find<ClientsController>();

  final _nameCtl = TextEditingController();
  final _phoneCtl = TextEditingController();
  final _emailCtl = TextEditingController();
  final _cpfCtl = TextEditingController();
  final _cepCtl = TextEditingController();
  final _streetCtl = TextEditingController();
  final _numberCtl = TextEditingController();
  final _complementCtl = TextEditingController();
  final _neighborhoodCtl = TextEditingController();
  final _cityCtl = TextEditingController();
  final _stateCtl = TextEditingController();
  final _notesCtl = TextEditingController();

  String _lastCepLooked = '';

  @override
  void initState() {
    super.initState();
    _cepCtl.addListener(_onCepChanged);
  }

  @override
  void dispose() {
    _cepCtl.removeListener(_onCepChanged);
    _nameCtl.dispose();
    _phoneCtl.dispose();
    _emailCtl.dispose();
    _cpfCtl.dispose();
    _cepCtl.dispose();
    _streetCtl.dispose();
    _numberCtl.dispose();
    _complementCtl.dispose();
    _neighborhoodCtl.dispose();
    _cityCtl.dispose();
    _stateCtl.dispose();
    _notesCtl.dispose();
    super.dispose();
  }

  void _onCepChanged() {
    final digits = _cepCtl.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 8 && digits != _lastCepLooked) {
      _lastCepLooked = digits;
      _runCepLookup(digits);
    }
  }

  Future<void> _runCepLookup(String cep) async {
    final result = await _controller.lookupCep(cep);
    if (!mounted) return;
    if (result == null) {
      Get.snackbar(
        'CEP não encontrado',
        _controller.error.value ?? 'Verifique e tente de novo.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    _streetCtl.text = result.street;
    _neighborhoodCtl.text = result.neighborhood;
    _cityCtl.text = result.city;
    _stateCtl.text = result.state;
  }

  String? _validate() {
    if (_nameCtl.text.trim().isEmpty) return 'Informe o nome.';
    if (_phoneCtl.text.replaceAll(RegExp(r'\D'), '').length < 10) {
      return 'Telefone inválido.';
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(_emailCtl.text.trim())) {
      return 'Email inválido.';
    }
    if (_cpfCtl.text.replaceAll(RegExp(r'\D'), '').length != 11) {
      return 'CPF precisa ter 11 dígitos.';
    }
    if (_cepCtl.text.replaceAll(RegExp(r'\D'), '').length != 8) {
      return 'CEP precisa ter 8 dígitos.';
    }
    if (_streetCtl.text.trim().isEmpty) return 'Informe a rua.';
    if (_numberCtl.text.trim().isEmpty) return 'Informe o número.';
    if (_neighborhoodCtl.text.trim().isEmpty) return 'Informe o bairro.';
    if (_cityCtl.text.trim().isEmpty) return 'Informe a cidade.';
    if (_stateCtl.text.trim().length != 2) return 'UF inválida (2 letras).';
    return null;
  }

  Future<void> _submit() async {
    final err = _validate();
    if (err != null) {
      Get.snackbar(
        'Confira os dados',
        err,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final address = Address(
      zip: _cepCtl.text.replaceAll(RegExp(r'\D'), ''),
      street: _streetCtl.text.trim(),
      number: _numberCtl.text.trim(),
      complement: _complementCtl.text.trim().isEmpty
          ? null
          : _complementCtl.text.trim(),
      neighborhood: _neighborhoodCtl.text.trim(),
      city: _cityCtl.text.trim(),
      state: _stateCtl.text.trim().toUpperCase(),
    );

    final ok = await _controller.create(
      name: _nameCtl.text,
      phone: _phoneCtl.text,
      email: _emailCtl.text,
      cpf: _cpfCtl.text,
      address: address,
      notes: _notesCtl.text.trim().isEmpty ? null : _notesCtl.text,
    );

    if (!mounted) return;
    if (ok) {
      final created = _controller.lastCreated.value;
      if (created != null) {
        Get.offNamed(AppRoutes.clienteDetail, arguments: created.id);
      } else {
        Get.back();
      }
    } else {
      Get.snackbar(
        'Não consegui salvar',
        _controller.error.value ?? 'Tente novamente.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OrdoColors.bg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(76),
        child: OrdoTopBar(
          title: 'Novo cliente',
          subtitle: 'cadastro completo',
          leading: OrdoIconButton(
            ghost: true,
            onTap: Get.back,
            child: const OrdoIcon(OrdoIconName.chevronLeft, size: 22),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          OrdoSpacing.screenPadding,
          0,
          OrdoSpacing.screenPadding,
          OrdoSpacing.s6,
        ),
        children: [
          const _Banner(),
          const SizedBox(height: OrdoSpacing.s5),
          const _SectionLabel(text: 'DADOS DO CLIENTE'),
          const SizedBox(height: OrdoSpacing.s3),
          OrdoField(
            controller: _nameCtl,
            label: 'Nome',
            placeholder: 'Marcos Lima',
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: OrdoSpacing.s3),
          OrdoField(
            controller: _phoneCtl,
            label: 'Telefone',
            placeholder: '(11) 98213-4456',
            mono: true,
            keyboardType: TextInputType.phone,
            inputFormatters: [phoneMask],
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: OrdoSpacing.s3),
          OrdoField(
            controller: _emailCtl,
            label: 'Email',
            placeholder: 'marcos@email.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: OrdoSpacing.s3),
          OrdoField(
            controller: _cpfCtl,
            label: 'CPF',
            placeholder: '000.000.000-00',
            mono: true,
            keyboardType: TextInputType.number,
            inputFormatters: [cpfMask],
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: OrdoSpacing.s5),
          const _SectionLabel(text: 'ENDEREÇO'),
          const SizedBox(height: OrdoSpacing.s3),
          OrdoField(
            controller: _cepCtl,
            label: 'CEP',
            placeholder: '00000-000',
            mono: true,
            keyboardType: TextInputType.number,
            inputFormatters: [CepInputFormatter()],
            textInputAction: TextInputAction.next,
          ),
          Obx(() => _controller.cepLoading.value
              ? Padding(
                  padding: const EdgeInsets.only(top: 8, left: 4),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: OrdoColors.ink,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Consultando CEP…',
                        style: OrdoTypography.body(
                          size: 11,
                          color: OrdoColors.fg3,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink()),
          const SizedBox(height: OrdoSpacing.s3),
          OrdoField(
            controller: _streetCtl,
            label: 'Rua / logradouro',
            placeholder: 'Av. Brasil',
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: OrdoSpacing.s3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: OrdoField(
                  controller: _numberCtl,
                  label: 'Número',
                  placeholder: '123',
                  mono: true,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 5,
                child: OrdoField(
                  controller: _complementCtl,
                  label: 'Complemento (opcional)',
                  placeholder: 'Apt 42, bloco B',
                  textInputAction: TextInputAction.next,
                ),
              ),
            ],
          ),
          const SizedBox(height: OrdoSpacing.s3),
          OrdoField(
            controller: _neighborhoodCtl,
            label: 'Bairro',
            placeholder: 'Centro',
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: OrdoSpacing.s3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: OrdoField(
                  controller: _cityCtl,
                  label: 'Cidade',
                  placeholder: 'São Paulo',
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: OrdoField(
                  controller: _stateCtl,
                  label: 'UF',
                  placeholder: 'SP',
                  mono: true,
                  maxLength: 2,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(2),
                    _UppercaseFormatter(),
                  ],
                  textInputAction: TextInputAction.next,
                ),
              ),
            ],
          ),
          const SizedBox(height: OrdoSpacing.s5),
          const _SectionLabel(text: 'OBSERVAÇÕES (opcional)'),
          const SizedBox(height: OrdoSpacing.s3),
          OrdoField(
            controller: _notesCtl,
            label: 'Anotações sobre o cliente',
            placeholder: 'Preferências de contato, restrições, etc.',
            multiline: true,
          ),
          const SizedBox(height: OrdoSpacing.s6),
          Row(
            children: [
              Expanded(
                child: OrdoButton(
                  label: 'Cancelar',
                  variant: OrdoButtonVariant.secondary,
                  full: true,
                  onPressed: Get.back,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Obx(() => OrdoButton(
                      label: 'Salvar',
                      variant: OrdoButtonVariant.accent,
                      full: true,
                      loading: _controller.saving.value,
                      onPressed:
                          _controller.saving.value ? null : _submit,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UppercaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: OrdoColors.ink,
        borderRadius: BorderRadius.circular(OrdoRadius.md),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: OrdoColors.lime,
              borderRadius: BorderRadius.circular(9),
            ),
            alignment: Alignment.center,
            child: const OrdoIcon(
              OrdoIconName.users,
              size: 20,
              color: OrdoColors.ink,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Cadastre o cliente uma vez. Próximas OS já vinculam '
              'automaticamente ao histórico dele.',
              style: OrdoTypography.body(size: 13, color: OrdoColors.bone),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: OrdoTypography.body(
        size: 10,
        weight: FontWeight.w600,
        color: OrdoColors.fg3,
        letterSpacing: 0.8,
      ),
    );
  }
}
