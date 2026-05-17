import 'package:flutter/material.dart';

/// Mapeamento de ícones Lucide → IconData mais próximo do Material.
///
/// O design system Ordo é especificado em Lucide (linha 1.75px). Como
/// não temos os SVGs Lucide embutidos, usamos o Material como
/// substituto visual fiel — ele segue a mesma geometria 24px e linha
/// fina. Quando quiser fidelidade pixel-perfect, swap por `lucide_icons`
/// (pacote pub.dev) sem mudar a interface.
enum OrdoIconName {
  car,
  bike,
  smartphone,
  laptop,
  monitor,
  washingMachine,
  wrench,
  bell,
  search,
  chevronRight,
  chevronLeft,
  plus,
  check,
  checkCircle,
  edit,
  phone,
  messageCircle,
  more,
  home,
  fileText,
  users,
  settings,
  alertTriangle,
  camera,
  image,
}

class OrdoIcon extends StatelessWidget {
  final OrdoIconName name;
  final double size;
  final Color? color;

  const OrdoIcon(
    this.name, {
    super.key,
    this.size = 20,
    this.color,
  });

  IconData get _data {
    switch (name) {
      case OrdoIconName.car:
        return Icons.directions_car_outlined;
      case OrdoIconName.bike:
        return Icons.two_wheeler_outlined;
      case OrdoIconName.smartphone:
        return Icons.smartphone_outlined;
      case OrdoIconName.laptop:
        return Icons.laptop_outlined;
      case OrdoIconName.monitor:
        return Icons.desktop_windows_outlined;
      case OrdoIconName.washingMachine:
        return Icons.local_laundry_service_outlined;
      case OrdoIconName.wrench:
        return Icons.build_outlined;
      case OrdoIconName.bell:
        return Icons.notifications_outlined;
      case OrdoIconName.search:
        return Icons.search_outlined;
      case OrdoIconName.chevronRight:
        return Icons.chevron_right;
      case OrdoIconName.chevronLeft:
        return Icons.chevron_left;
      case OrdoIconName.plus:
        return Icons.add;
      case OrdoIconName.check:
        return Icons.check;
      case OrdoIconName.checkCircle:
        return Icons.check_circle_outline;
      case OrdoIconName.edit:
        return Icons.edit_outlined;
      case OrdoIconName.phone:
        return Icons.phone_outlined;
      case OrdoIconName.messageCircle:
        return Icons.chat_outlined;
      case OrdoIconName.more:
        return Icons.more_horiz;
      case OrdoIconName.home:
        return Icons.home_outlined;
      case OrdoIconName.fileText:
        return Icons.description_outlined;
      case OrdoIconName.users:
        return Icons.people_outline;
      case OrdoIconName.settings:
        return Icons.settings_outlined;
      case OrdoIconName.alertTriangle:
        return Icons.warning_amber_outlined;
      case OrdoIconName.camera:
        return Icons.photo_camera_outlined;
      case OrdoIconName.image:
        return Icons.image_outlined;
    }
  }

  /// Resolve o nome canônico do design system Ordo (carro / celular...)
  /// para o ícone correspondente.
  static OrdoIconName forShop(String shopId) {
    switch (shopId) {
      case 'carro':
        return OrdoIconName.car;
      case 'moto':
        return OrdoIconName.bike;
      case 'celular':
        return OrdoIconName.smartphone;
      case 'notebook':
        return OrdoIconName.laptop;
      case 'desktop':
        return OrdoIconName.monitor;
      case 'eletrodomestico':
        return OrdoIconName.washingMachine;
      default:
        return OrdoIconName.wrench;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Icon(_data, size: size, color: color);
  }
}
