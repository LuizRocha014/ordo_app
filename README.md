# Ordo

> **Sua oficina, sob controle.**
> App mobile-first de Ordens de Serviço para oficinas (carros, motos,
> celulares, notebooks, eletrodomésticos), com checklist por foto,
> status em tempo real e histórico de atualizações.

Construído em Flutter seguindo **Clean Architecture** estrita, com o
**Ordo Design System** (Bone + Ink + Lime, Space Grotesk + DM Sans +
JetBrains Mono).

---

## Stack

- **Flutter** 3.41+ · **Dart** 3.11
- **GetX** (`get`) para estado reativo (`.obs` / `Obx`) e navegação
- **get_it** para DI de datasources, repositórios e use cases
- **http** para chamadas externas, **Navigator 1.0** mantido via `onGenerateRoute`
- **intl** (pt_BR), **google_fonts** (Space Grotesk / DM Sans / JetBrains Mono)
- **componentes_lr** como pacote base (path dependency)

### Padrão DI híbrido por camada

- **`sl` (get_it)** registra datasources, repositórios e use cases —
  peças de domain/data que não conhecem GetX.
- **`Get.put` / `Get.lazyPut`** registra **controllers** (`GetxController`).
  Controllers recebem use cases injetados a partir do `sl()` na construção.
- Páginas obtêm controllers via `Get.find<T>()` e renderizam reativo
  com `Obx(() => ...)`.

---

## Arquitetura

```
lib/
├── main.dart                    bootstrap (initStorage, intl, DI, runApp)
├── app.dart                     MultiProvider + onGenerateRoute
├── core/
│   ├── di/injection.dart        container get_it
│   ├── errors/failures.dart     Failure sealed (Validation/NotFound/…)
│   ├── result/result.dart       Result<T> = Success | FailureResult
│   ├── routes/app_routes.dart
│   ├── usecases/usecase.dart    UseCase<T, Params>
│   └── theme/                   tokens Ordo (cores, tipografia,
│                                 spacing, raios, sombras, motion)
├── features/
│   ├── setup/                   primeiro launch — escolha do tipo
│   │   ├── domain/  entities, repositories, usecases
│   │   ├── data/    datasource SharedPreferences + repo impl
│   │   └── presentation/  splash, setup, SetupController (GetX)
│   └── service_order/           núcleo do app
│       ├── domain/  ServiceOrder, OsStatus, ChecklistItem,
│       │            TimelineEvent, Client + 6 usecases
│       ├── data/    models JSON-ready, datasource in-memory
│       │            com seed por categoria, repo impl
│       └── presentation/  Home / OsList / NovaOs / Checklist /
│                          OsDetail + 3 GetxControllers
└── shared/
    ├── utils/formatters.dart    BRL, datas PT-BR, relativeDay
    └── widgets/                 OrdoButton, OrdoField, OSCard,
                                  StatusChip, KpiCard, OrdoTopBar,
                                  OrdoBottomNav, OrdoIcon
```

**Regra de ouro da Clean Arch aqui:** domain não importa nada de data
nem de presentation; data depende só de domain; presentation depende
de domain (via use cases) e nunca de data direto.

---

## Funcionalidades

| Tela | O que faz |
|---|---|
| **Splash** | Decide entre Setup e Home conforme `SharedPreferences` |
| **Setup** | Escolha do tipo de oficina (carros / motos / celulares / notebooks / eletrodomésticos) |
| **Home** | Cumprimento + nome da oficina, 4 KPIs (Em andamento / Aguard. peça / Prontas / Faturado hoje), banner âmbar para OS sem atualização > 48h, OS recentes, FAB lime |
| **Lista de OS** | Filtros por status em pill, busca por título/cliente/número (case + acento insensitive) |
| **Nova OS** | Banner Ink+Lime, dados do cliente (com máscara de telefone), campos dinâmicos por categoria (placa, IMEI, serial…), problema multiline |
| **Checklist** | Barra de progresso, itens template gerados pelo tipo de oficina, toggle de marcação + foto |
| **Detalhe da OS** | Hero Ink com status + CTA "Alterar", card resumo cliente/valor com Ligar/WhatsApp, grade 4×N de fotos com gradientes Slate, timeline com bullets Lime para eventos accent, botão "Marcar como entregue" |

---

## Tokens do Design System Ordo

- **Cores**: Bone `#F6F4EE`, Ink `#0F1115`, Lime `#D6F24E` (1× por
  tela), escala Slate completa, status colors (soft+saturado).
- **Tipografia**: Space Grotesk (display), DM Sans (corpo),
  JetBrains Mono (números/OS/IMEI/placa).
- **Espaçamento**: escala 4pt (4 · 8 · 12 · 16 · 20 · 24 · 32 · 40 · 56 · 72).
- **Raios**: 4 (chips), 8 (inputs), 12 (botões/cards), 16 (modais),
  9999 (pill).
- **Sombras**: sm / md / lg / xl / fab.
- **Motion**: `cubic-bezier(0.2, 0, 0, 1)` em 120ms (micro) /
  200ms (base) / 320ms (slow).

---

## Dependência local — `componentes_lr`

O `pubspec.yaml` declara:

```yaml
componentes_lr:
  path: ../Flutter_X_Components_Flutter
```

Para clonar e rodar, o pacote precisa estar disponível em
`../Flutter_X_Components_Flutter` ao lado deste projeto. O app reusa
do pacote: `initStorage()`, `sharedPreferences`, `secureStorage`,
`phoneMask`, `diacritic` (transitivo) e todas as utilities/widgets
exportadas pelo barrel `package:componentes_lr/componentes_lr.dart`.

---

## Como rodar

```bash
flutter pub get
flutter run -d chrome    # ou outro device
```

Para validar:

```bash
flutter analyze          # esperado: No issues found
flutter build web        # ou apk/ios
```
