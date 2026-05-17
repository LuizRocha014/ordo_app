/// Ciclo de vida da Ordem de Serviço Ordo.
///
/// 6 estados — cada um tem cor funcional + label oficial em PT-BR. Os
/// mapeamentos para cor vivem em `presentation/widgets/status_chip.dart`
/// para manter o domínio livre de dependências de UI.
enum OsStatus {
  aberta('aberta', 'Aberta'),
  andamento('andamento', 'Em andamento'),
  aguardando('aguardando', 'Aguardando peça'),
  pronta('pronta', 'Pronta'),
  entregue('entregue', 'Entregue'),
  cancelada('cancelada', 'Cancelada');

  const OsStatus(this.id, this.label);

  final String id;
  final String label;

  static OsStatus fromId(String id) =>
      OsStatus.values.firstWhere((s) => s.id == id, orElse: () => OsStatus.aberta);
}
