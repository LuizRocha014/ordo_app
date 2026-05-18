import 'package:componentes_lr/componentes_lr.dart' show phoneMask;
import 'package:flutter/material.dart';
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
  final _notesCtl = TextEditingController();

  @override
  void dispose() {
    _nameCtl.dispose();
    _phoneCtl.dispose();
    _notesCtl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = await _controller.create(
      name: _nameCtl.text,
      phone: _phoneCtl.text,
      notes: _notesCtl.text.trim().isEmpty ? null : _notesCtl.text,
    );
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
          subtitle: 'cadastro rápido',
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
