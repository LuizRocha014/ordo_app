import 'package:componentes_lr/componentes_lr.dart' show phoneMask;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/ordo_colors.dart';
import '../../../../core/theme/ordo_radius.dart';
import '../../../../core/theme/ordo_spacing.dart';
import '../../../../core/theme/ordo_typography.dart';
import '../../../../shared/widgets/ordo_button.dart';
import '../../../../shared/widgets/ordo_field.dart';
import '../../../../shared/widgets/ordo_icon.dart';
import '../../../../shared/widgets/top_bar.dart';
import '../../../setup/presentation/providers/setup_provider.dart';
import '../providers/nova_os_provider.dart';

/// Campo dinâmico por categoria — `id` casa com `equipmentFields[id]`
/// no provider.
class _EquipmentField {
  final String id;
  final String label;
  final String placeholder;
  final bool mono;
  final TextInputType? keyboardType;

  const _EquipmentField({
    required this.id,
    required this.label,
    required this.placeholder,
    this.mono = false,
    this.keyboardType,
  });
}

List<_EquipmentField> _fieldsForShop(String? id) {
  switch (id) {
    case 'carro':
      return const [
        _EquipmentField(
          id: 'modelo',
          label: 'Modelo / ano',
          placeholder: 'Civic LXR 2018',
        ),
        _EquipmentField(
          id: 'placa',
          label: 'Placa',
          placeholder: 'BRA2E19',
          mono: true,
        ),
        _EquipmentField(
          id: 'km',
          label: 'Hodômetro',
          placeholder: '78.420 km',
          mono: true,
          keyboardType: TextInputType.number,
        ),
      ];
    case 'moto':
      return const [
        _EquipmentField(
          id: 'modelo',
          label: 'Modelo / ano',
          placeholder: 'CB 500F 2022',
        ),
        _EquipmentField(
          id: 'placa',
          label: 'Placa',
          placeholder: 'BRA1A23',
          mono: true,
        ),
      ];
    case 'celular':
      return const [
        _EquipmentField(
          id: 'modelo',
          label: 'Modelo',
          placeholder: 'iPhone 13 / Galaxy S23 ...',
        ),
        _EquipmentField(
          id: 'imei',
          label: 'IMEI',
          placeholder: '356938035643809',
          mono: true,
          keyboardType: TextInputType.number,
        ),
      ];
    case 'notebook':
      return const [
        _EquipmentField(
          id: 'modelo',
          label: 'Marca / modelo',
          placeholder: 'Dell Inspiron 15 3520',
        ),
        _EquipmentField(
          id: 'serial',
          label: 'Serial',
          placeholder: 'SN: ...',
          mono: true,
        ),
      ];
    case 'eletrodomestico':
      return const [
        _EquipmentField(
          id: 'modelo',
          label: 'Marca / modelo',
          placeholder: 'Brastemp BRH80 ...',
        ),
        _EquipmentField(
          id: 'serial',
          label: 'N° de série',
          placeholder: 'SN: ...',
          mono: true,
        ),
      ];
    default:
      return const [
        _EquipmentField(
          id: 'descricao',
          label: 'Equipamento',
          placeholder: 'Descreva o equipamento',
        ),
      ];
  }
}

class NovaOsPage extends StatefulWidget {
  const NovaOsPage({super.key});

  @override
  State<NovaOsPage> createState() => _NovaOsPageState();
}

class _NovaOsPageState extends State<NovaOsPage> {
  final _clientNameCtl = TextEditingController();
  final _clientPhoneCtl = TextEditingController();
  final _problemCtl = TextEditingController();
  final Map<String, TextEditingController> _equipCtls = {};
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final shop = context.read<SetupProvider>().current;
      if (shop != null) {
        context.read<NovaOsProvider>().loadTemplate(shop.id);
      }
    });
  }

  @override
  void dispose() {
    _clientNameCtl.dispose();
    _clientPhoneCtl.dispose();
    _problemCtl.dispose();
    for (final c in _equipCtls.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _ctlFor(String id) =>
      _equipCtls.putIfAbsent(id, () => TextEditingController());

  Future<void> _submit() async {
    final shop = context.read<SetupProvider>().current;
    if (shop == null) return;
    final provider = context.read<NovaOsProvider>();

    provider
      ..clientName = _clientNameCtl.text
      ..clientPhone = _clientPhoneCtl.text
      ..problem = _problemCtl.text
      ..equipmentFields = {
        for (final entry in _equipCtls.entries) entry.key: entry.value.text,
      };

    final ok = await provider.submit(shopTypeId: shop.id);
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pushReplacementNamed(
        AppRoutes.checklist,
        arguments: provider.created!.id,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Não consegui salvar.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<SetupProvider>().current;
    final provider = context.watch<NovaOsProvider>();
    final fields = _fieldsForShop(shop?.id);

    final productNoun = shop?.productNoun ?? 'serviço';
    final shopName = shop?.shopName ?? 'Ordo';

    return Scaffold(
      backgroundColor: OrdoColors.bg,
      appBar: OrdoTopBar(
        title: 'Nova OS de $productNoun',
        subtitle: shopName,
        leading: OrdoIconButton(
          ghost: true,
          onTap: () => Navigator.of(context).maybePop(),
          child: const OrdoIcon(OrdoIconName.chevronLeft, size: 22),
        ),
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            OrdoSpacing.screenPadding,
            0,
            OrdoSpacing.screenPadding,
            OrdoSpacing.s6,
          ),
          children: [
            _VerticalBanner(
              productNoun: productNoun,
              icon: OrdoIcon.forShop(shop?.id ?? ''),
            ),
            const SizedBox(height: OrdoSpacing.s5),
            const _SectionLabel(text: 'CLIENTE'),
            const SizedBox(height: OrdoSpacing.s3),
            OrdoField(
              controller: _clientNameCtl,
              label: 'Nome',
              placeholder: 'Marcos Lima',
            ),
            const SizedBox(height: OrdoSpacing.s3),
            OrdoField(
              controller: _clientPhoneCtl,
              label: 'Telefone',
              placeholder: '(11) 98213-4456',
              mono: true,
              keyboardType: TextInputType.phone,
              inputFormatters: [phoneMask],
            ),
            const SizedBox(height: OrdoSpacing.s5),
            _SectionLabel(text: 'DADOS DO ${productNoun.toUpperCase()}'),
            const SizedBox(height: OrdoSpacing.s3),
            for (final f in fields) ...[
              OrdoField(
                controller: _ctlFor(f.id),
                label: f.label,
                placeholder: f.placeholder,
                mono: f.mono,
                keyboardType: f.keyboardType,
              ),
              const SizedBox(height: OrdoSpacing.s3),
            ],
            const SizedBox(height: OrdoSpacing.s2),
            const _SectionLabel(text: 'PROBLEMA RELATADO'),
            const SizedBox(height: OrdoSpacing.s3),
            OrdoField(
              controller: _problemCtl,
              label: 'O que o cliente relatou?',
              placeholder: 'Descreva o problema do $productNoun...',
              multiline: true,
            ),
            const SizedBox(height: OrdoSpacing.s5),
            Row(
              children: [
                Expanded(
                  child: OrdoButton(
                    label: 'Cancelar',
                    variant: OrdoButtonVariant.secondary,
                    full: true,
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OrdoButton(
                    label: 'Continuar',
                    variant: OrdoButtonVariant.accent,
                    full: true,
                    loading: provider.saving,
                    onPressed: provider.saving ? null : _submit,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _VerticalBanner extends StatelessWidget {
  final String productNoun;
  final OrdoIconName icon;

  const _VerticalBanner({required this.productNoun, required this.icon});

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
            child: OrdoIcon(icon, size: 20, color: OrdoColors.ink),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: OrdoTypography.body(size: 13, color: OrdoColors.bone),
                children: [
                  const TextSpan(text: 'Esta OS é de '),
                  TextSpan(
                    text: productNoun,
                    style: OrdoTypography.body(
                      size: 13,
                      weight: FontWeight.w600,
                      color: OrdoColors.bone,
                    ),
                  ),
                  const TextSpan(
                    text:
                        '. O checklist correto será gerado ao continuar.',
                  ),
                ],
              ),
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
