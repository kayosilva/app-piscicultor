# Piscicultor

App de **controle de criação de peixes** (piscicultura). Registra os parâmetros
da água e o manejo de cada tanque para gerar histórico, gráficos e alertas —
ajudando o produtor a não perder um tanque inteiro por um parâmetro fora da faixa.

> Ideia do **Sr. Ananias** (produtor). A documentação de planejamento, o contexto
> de negócio e o levantamento de requisitos ficam em [`docs/`](docs/):
> [`CONTEXTO.md`](docs/CONTEXTO.md) (visão e negócio),
> [`NOTAS-TECNICAS.md`](docs/NOTAS-TECNICAS.md) (parâmetros, modelagem, ambiente),
> [`PERGUNTAS-ANANIAS.md`](docs/PERGUNTAS-ANANIAS.md) (requisitos em aberto), a
> planilha-exemplo do produtor ([`Pla_Peixe (3).xlsx`](docs/), analisada no §11 das notas
> técnicas) e as transcrições dos áudios dele.

## Estado atual (MVP em construção)

- [x] Esqueleto Flutter + GetX, tema claro/escuro, navegação por drawer.
- [x] Camada de dados local (SQLite): `Propriedade → Tanque → Ciclo`.
- [x] **Painel** (tela inicial com KPIs e um cartão por tanque).
- [x] **CRUD de Tanques** e **CRUD de Ciclos** (um ciclo ativo por tanque; encerrar = despesca).
- [x] Edição da **Propriedade**, identidade visual (ícone e splash) e localização pt-BR.
- [x] Planilha do produtor analisada → modelo-alvo e ordem do MVP (`docs/NOTAS-TECNICAS.md` §5 e §11).
- [ ] Ajustes em Tanque e Ciclo vindos da planilha (altura, material, peso inicial, vacina...).
- [ ] Medição de água + faixas ideais + alertas + gráfico de linha.
- [ ] Biometria, despesca, arraçoamento/estoque, clima automático, relatórios e gráficos.
- [ ] Sync com nuvem / multi-tenant (Fase 2 — SaaS).

## Tecnologias

| Camada | Escolha | Por quê |
| --- | --- | --- |
| UI / SDK | **Flutter** (Android como alvo inicial) | Multiplataforma, roda no celular na beira do tanque; já é do domínio do time. |
| Estado / DI / Rotas | **GetX** (`get`) | Estado reativo, injeção de dependência e rotas com pouca cerimônia. |
| Banco local | **SQLite** (`sqflite` + `path` + `path_provider`) | Dados estruturados e relacionais (tanque → ciclo → leituras). |
| Preferências / cache | **Hive** (`hive`, `hive_flutter`) | Chave-valor rápido para tema e configs; futura fila de sync. |
| HTTP (Fase 2) | **Dio** (`dio`) | Cliente HTTP para quando plugar a nuvem. |
| Gráficos | **fl_chart** | Gratuito e suficiente. Evitamos Syncfusion (licença paga; o plano é SaaS). |
| Config de ambiente | **flutter_dotenv** | Separar dev/stg/prod. |
| Conectividade | **connectivity_plus** | Detectar online/offline (offline-first). |
| IDs | **uuid** | PK em UUID para evitar colisão no sync local→nuvem. |
| Utilidades | **intl** (datas/números), **dartz** (`Either` p/ erros) | Formatação e tratamento de falhas. |

Offline-first é um requisito: na chácara pode não haver sinal, então tudo grava
localmente primeiro e a sincronização com a nuvem entra só na Fase 2 (SaaS).

## Arquitetura

Feature-first, com uma **camada de dados compartilhada**. O fluxo é
`Página (GetView) → Controller (.obs) → Repository → AppDatabase (SQLite)`.

```
lib/
  main.dart                         # bootstrap: Hive, AppDatabase, GetMaterialApp
  app/
    routes/
      app_routes.dart               # nomes das rotas (sem strings soltas)
      app_pages.dart                # mapa rota → página + binding
    modules/                        # uma pasta por feature
      tanques/
        tanques_controller.dart     # estado + regras (carregar, salvar, excluir)
        tanques_binding.dart        # injeta repositórios e controller (lazy)
        tanques_list_page.dart      # dashboard + lista
        tanque_form_page.dart       # criar / editar
      settings/
    shared/
      data/
        database/app_database.dart  # abre o SQLite, cria o schema, faz o seed
        models/                     # propriedade · tanque · ciclo (fromMap/toMap)
        repositories/               # um por entidade (CRUD + soft-delete)
      services/settings_service.dart# preferências via Hive (GetxService)
      theme/                        # cores de marca + tema Material 3
      widgets/app_drawer.dart       # navegação principal
```

### Padrões (GetX)

- **Serviços globais** (banco, settings) sobem no `main` via
  `Get.putAsync(..., permanent: true)`.
- **Controllers e repositórios** por feature entram via `Get.lazyPut` no `Binding`
  da rota; o repositório recebe o `Database` já aberto (`Get.find<AppDatabase>().db`).
- **UI reativa** com `.obs` + `Obx`. Página é `GetView<Controller>`; formulários com
  estado local de campos podem ser `StatefulWidget` usando `Get.find<Controller>()`.
- Regras de persistência (gerar UUID, carimbar timestamps, soft-delete) ficam no
  **repositório** — o controller só lida com o modelo.

### Modelagem de dados

Regra central: **tanque ≠ ciclo**. O tanque é a estrutura física (reutilizável);
o **ciclo** é um povoamento específico (ex.: 5.000 alevinos de tilápia em março).
Ao despescar e povoar de novo, é um novo ciclo no mesmo tanque — e é no ciclo que
todo o histórico (leituras, biometria, ração) se pendura.

```
Propriedade → Tanque → Ciclo → (LeituraDeAgua, Biometria, Arraçoamento, Mortalidade)
```

Todas as tabelas usam **UUID (TEXT)** como PK e carregam
`created_at` / `updated_at` / `deleted_at` (soft-delete) — para viabilizar o sync
futuro. A tabela `propriedade` já existe pensando no multi-tenant; no MVP há uma
só, criada por seed, e o app abre direto nos Tanques.

## Pré-requisitos

- **Flutter 3.47.5** (canal stable) e **Dart 3.13.4** — constraint do projeto: `sdk: ^3.13.4`.
- **Android SDK** (platform-tools, emulator, cmdline-tools; Platform Android 36/37,
  Build-Tools 36) com `ANDROID_HOME` e as licenças aceitas.
- **JDK 17** (OpenJDK).
- Um **emulador ou dispositivo Android**. AVD de referência: `piscicultura`
  (Pixel 6, Android 16), acelerado por KVM.
- `applicationId`: `br.com.piscicultor` (provisório — trocar pelo domínio real depois).

> O ambiente de desenvolvimento (paths, versões, AVD) está documentado em detalhe em
> [`docs/NOTAS-TECNICAS.md`](docs/NOTAS-TECNICAS.md) (§8).

## Como rodar

```bash
flutter pub get

# subir o emulador (ou usar a GUI do Android Studio)
emulator -avd piscicultura
flutter run -d emulator-5554

flutter analyze                       # análise estática (deixar sem issues)
flutter test                          # testes
```

Para validar visualmente:
`adb -s emulator-5554 exec-out screencap -p > /tmp/shot.png`.

O banco local fica em `piscicultor.db` no diretório de documentos do app. Para
recriar do zero (ex.: mudou o schema em dev), desinstale o app do emulador ou apague
o arquivo.
