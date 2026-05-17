import '../../domain/entities/checklist_item.dart';
import '../../domain/entities/client.dart';
import '../../domain/entities/os_status.dart';
import '../../domain/entities/timeline_event.dart';
import '../models/service_order_model.dart';

/// Seed de dados de demonstração — uma amostra plausível por categoria.
///
/// É usado pelo `InMemoryServiceOrderDataSource` para que o app
/// inicialize com OS prontas e KPIs preenchidos, sem precisar abrir
/// nenhuma manualmente.
List<ServiceOrderModel> buildMockSeed(String shopTypeId) {
  final now = DateTime.now();
  DateTime daysAgo(int d, {int h = 9, int m = 42}) =>
      DateTime(now.year, now.month, now.day - d, h, m);

  String c(int n) => n.toString().padLeft(4, '0');

  switch (shopTypeId) {
    case 'carro':
      return [
        _osBase(
          id: c(1284),
          title: 'Civic LXR 2018 — barulho na suspensão',
          category: 'carro',
          client: const Client(id: 'cli-1', name: 'Marcos Lima', phone: '(11) 98213-4456'),
          problem: 'Cliente relata batidas ao passar em lombadas e curvas fechadas.',
          status: OsStatus.andamento,
          valueCents: 95000,
          openedAt: daysAgo(2),
          updatedAt: daysAgo(0, h: 14),
        ),
        _osBase(
          id: c(1283),
          title: 'Hilux 2020 — revisão 60.000km',
          category: 'carro',
          client: const Client(id: 'cli-2', name: 'Renata Souza', phone: '(11) 99127-0091'),
          problem: 'Revisão preventiva conforme manual.',
          status: OsStatus.aguardando,
          valueCents: 184000,
          openedAt: daysAgo(3),
          updatedAt: daysAgo(1, h: 10),
        ),
        _osBase(
          id: c(1281),
          title: 'Onix 2022 — luz de injeção acesa',
          category: 'carro',
          client: const Client(id: 'cli-3', name: 'Diego Almeida', phone: '(11) 97412-9988'),
          problem: 'Luz acende após 10min com o motor ligado.',
          status: OsStatus.pronta,
          valueCents: 42000,
          openedAt: daysAgo(4),
          updatedAt: daysAgo(0, h: 8),
        ),
        _osBase(
          id: c(1278),
          title: 'Gol 2014 — alinhamento e balanceamento',
          category: 'carro',
          client: const Client(id: 'cli-4', name: 'Patrícia Vargas', phone: '(11) 95577-1133'),
          problem: 'Pneus desgastando irregularmente.',
          status: OsStatus.entregue,
          valueCents: 18000,
          openedAt: daysAgo(8),
          updatedAt: daysAgo(6),
        ),
      ];
    case 'celular':
      return [
        _osBase(
          id: c(1284),
          title: 'iPhone 13 — tela trincada',
          category: 'celular',
          client: const Client(id: 'cli-1', name: 'Marcos Lima', phone: '(11) 98213-4456'),
          problem: 'Cliente deixou cair, tela quebrou no canto inferior direito. Toque parou de funcionar.',
          status: OsStatus.andamento,
          valueCents: 78000,
          openedAt: daysAgo(2),
          updatedAt: daysAgo(0, h: 14),
        ),
        _osBase(
          id: c(1283),
          title: 'Galaxy S23 — não carrega',
          category: 'celular',
          client: const Client(id: 'cli-2', name: 'Renata Souza', phone: '(11) 99127-0091'),
          problem: 'Cabo encaixa mas não carrega. Já trocou cabo e fonte sem sucesso.',
          status: OsStatus.aguardando,
          valueCents: 32000,
          openedAt: daysAgo(3),
          updatedAt: daysAgo(1),
        ),
        _osBase(
          id: c(1281),
          title: 'Moto G73 — bateria viciada',
          category: 'celular',
          client: const Client(id: 'cli-3', name: 'Diego Almeida', phone: '(11) 97412-9988'),
          problem: 'Descarrega em 4h em uso normal.',
          status: OsStatus.pronta,
          valueCents: 22000,
          openedAt: daysAgo(4),
          updatedAt: daysAgo(0, h: 8),
        ),
        _osBase(
          id: c(1278),
          title: 'iPhone 11 — molhou',
          category: 'celular',
          client: const Client(id: 'cli-4', name: 'Patrícia Vargas', phone: '(11) 95577-1133'),
          problem: 'Caiu na pia. Liga mas a câmera está embaçada.',
          status: OsStatus.entregue,
          valueCents: 18000,
          openedAt: daysAgo(8),
          updatedAt: daysAgo(6),
        ),
      ];
    case 'notebook':
      return [
        _osBase(
          id: c(1284),
          title: 'Dell Inspiron 15 — não liga',
          category: 'notebook',
          client: const Client(id: 'cli-1', name: 'Marcos Lima', phone: '(11) 98213-4456'),
          problem: 'Botão de power não responde, LED acende rapidamente e apaga.',
          status: OsStatus.andamento,
          valueCents: 65000,
          openedAt: daysAgo(2),
          updatedAt: daysAgo(0, h: 14),
        ),
        _osBase(
          id: c(1283),
          title: 'Macbook Air M1 — bateria fraca',
          category: 'notebook',
          client: const Client(id: 'cli-2', name: 'Renata Souza', phone: '(11) 99127-0091'),
          problem: 'Bateria dura 1h30 com brilho médio.',
          status: OsStatus.aguardando,
          valueCents: 89000,
          openedAt: daysAgo(3),
          updatedAt: daysAgo(1),
        ),
        _osBase(
          id: c(1281),
          title: 'Acer Aspire 5 — tela com listras',
          category: 'notebook',
          client: const Client(id: 'cli-3', name: 'Diego Almeida', phone: '(11) 97412-9988'),
          problem: 'Listras verticais coloridas aparecem após alguns minutos de uso.',
          status: OsStatus.pronta,
          valueCents: 124000,
          openedAt: daysAgo(4),
          updatedAt: daysAgo(0, h: 8),
        ),
      ];
    case 'eletrodomestico':
      return [
        _osBase(
          id: c(1284),
          title: 'Geladeira Brastemp — não gela',
          category: 'eletrodomestico',
          client: const Client(id: 'cli-1', name: 'Marcos Lima', phone: '(11) 98213-4456'),
          problem: 'Parou de gelar após queda de energia.',
          status: OsStatus.andamento,
          valueCents: 47000,
          openedAt: daysAgo(2),
          updatedAt: daysAgo(0, h: 14),
        ),
        _osBase(
          id: c(1283),
          title: 'Máquina de lavar Consul — vazando',
          category: 'eletrodomestico',
          client: const Client(id: 'cli-2', name: 'Renata Souza', phone: '(11) 99127-0091'),
          problem: 'Água escorrendo pela parte de trás durante a centrifugação.',
          status: OsStatus.aguardando,
          valueCents: 38000,
          openedAt: daysAgo(3),
          updatedAt: daysAgo(1),
        ),
      ];
    case 'moto':
      return [
        _osBase(
          id: c(1284),
          title: 'CB 500F — barulho na corrente',
          category: 'moto',
          client: const Client(id: 'cli-1', name: 'Marcos Lima', phone: '(11) 98213-4456'),
          problem: 'Barulho metálico aumenta em marchas baixas.',
          status: OsStatus.andamento,
          valueCents: 35000,
          openedAt: daysAgo(2),
          updatedAt: daysAgo(0, h: 14),
        ),
      ];
    default:
      return const [];
  }
}

ServiceOrderModel _osBase({
  required String id,
  required String title,
  required String category,
  required Client client,
  required String problem,
  required OsStatus status,
  required int valueCents,
  required DateTime openedAt,
  required DateTime updatedAt,
}) {
  return ServiceOrderModel(
    id: id,
    title: title,
    category: category,
    client: client,
    problem: problem,
    status: status,
    valueCents: valueCents,
    openedAt: openedAt,
    updatedAt: updatedAt,
    checklist: const [
      ChecklistItem(id: 'chk-1', label: 'Estado geral', done: true, photoCount: 2),
      ChecklistItem(id: 'chk-2', label: 'Acessórios', done: true, photoCount: 1),
      ChecklistItem(id: 'chk-3', label: 'Avarias visíveis', done: false),
    ],
    timeline: [
      TimelineEvent(
        id: 'ev-1',
        when: updatedAt,
        description: 'Status atualizado para ${status.label}.',
        author: 'Bruno (técnico)',
        accent: true,
      ),
      TimelineEvent(
        id: 'ev-2',
        when: openedAt,
        description: 'OS aberta com checklist de entrada.',
        author: 'Renata (atendente)',
      ),
    ],
    photoIds: const ['p1', 'p2', 'p3', 'p4', 'p5'],
  );
}
