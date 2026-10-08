# CLAUDE.md — Piscicultor

Instruções para o Claude Code trabalhar neste repositório. Complementa o
`CLAUDE.md` global do usuário (regras de PR/code review valem e não se repetem aqui).
Responder sempre em **português (pt-br)**.

## O que é

App Flutter de **controle de criação de peixes** (piscicultura). MVP em construção.
Ver `README.md` para visão e estado atual.

**Planejamento e requisitos ficam em [`docs/`](docs/)** (fonte da verdade do planejamento):
- `docs/CONTEXTO.md` — ideia, negócio (Fase 1: uso próprio → Fase 2: SaaS), próximos passos.
- `docs/NOTAS-TECNICAS.md` — parâmetros, modelagem, decisões de arquitetura, ambiente.
- `docs/PERGUNTAS-ANANIAS.md` — requisitos ainda em aberto com o produtor.
- `docs/FAIXAS-IDEAIS-TILAPIA.md` — faixas dos parâmetros da água (base dos alertas), com fontes.
- `docs/REUNIAO-*.md` — pautas e anotações das reuniões com o produtor.
- `docs/Pla_Peixe (3).xlsx` — planilha-exemplo do produtor (análise em `NOTAS-TECNICAS.md` §11).
- `docs/transcricao-audio-ananias*.txt` — transcrições dos áudios do produtor.
  O de **2026-10-07** é importante: ele quer desenhar o app junto. Abordagem: entregar **em
  módulos** sobre o alicerce (Propriedade → Tanque → Ciclo); o fluxo de cada módulo de negócio é
  combinado com ele antes de construir, e ajustado depois que ele usar.

Ao mudar modelagem/escopo/progresso, **atualize também esses docs**, não só o código.
(Origem: foram copiados de `~/Documentos/IdeiaSistema`; a cópia versionada no repo é a
oficial.)

## Stack e arquitetura

- **Flutter + GetX** (estado, DI, rotas). Alvo inicial: Android.
- **SQLite (`sqflite`)** para dados estruturados; **Hive** para preferências/cache.
- **Feature-first** com camada de dados compartilhada em `lib/app/shared/data/`
  (`database/`, `models/`, `repositories/`).
- Módulos em `lib/app/modules/<feature>/` — cada um com
  `*_controller.dart`, `*_binding.dart` e as páginas.
- Rotas centralizadas: nomes em `app/routes/app_routes.dart`, mapa em `app_pages.dart`.

### Padrão GetX (seguir o que já existe)

- Serviços globais (banco, settings) via `Get.putAsync(..., permanent: true)` no `main`.
- Controllers e repositórios por feature via `Get.lazyPut` no `Binding` da rota.
- Repositório recebe o `Database` pronto: `Get.find<AppDatabase>().db`.
- UI reativa com `.obs` + `Obx`. Página é `GetView<Controller>`; formulário com
  estado local de campos pode ser `StatefulWidget` usando `Get.find<Controller>()`.

## Modelagem de dados (regras firmes)

- Hierarquia: **`Propriedade → Tanque → Ciclo → (leituras/biometria/ração/...)`**.
- **`tanque ≠ ciclo`**: tanque é estrutura física reutilizável; ciclo é um povoamento
  com começo e fim. **O histórico pendura no ciclo, não no tanque.** Não misturar.
- Toda tabela: **PK = UUID (TEXT)** (nunca auto-incremento — evita colisão no sync
  futuro) + `created_at`, `updated_at`, `deleted_at`.
- **Soft-delete sempre**: marcar `deleted_at`, nunca `DELETE` de verdade. Queries de
  leitura filtram `deleted_at IS NULL`.
- Enums gravam `.name` no banco e expõem `.label` para a UI (ver `TipoTanque`,
  `StatusCiclo`).
- Regras de persistência (gerar UUID, carimbar timestamps) ficam no **repositório**;
  o controller só lida com o modelo.
- Mudou o schema? Suba a `_version` do `AppDatabase` e trate a migração (ou, em dev,
  desinstale o app para recriar). Não quebre dados existentes silenciosamente.

## Comandos

```bash
flutter pub get
flutter run -d emulator-5554     # AVD "piscicultura" precisa estar aberto
flutter analyze                  # rodar antes de dar por pronto
flutter test
```

Para validar visualmente no emulador: `adb -s emulator-5554 exec-out screencap -p > /tmp/shot.png`.

## Convenções

- Comentários e identificadores de domínio em **português**; termos técnicos/idioms
  de código no original.
- Comentar o **porquê** (decisão, regra de domínio), não o óbvio — seguir a densidade
  dos arquivos existentes.
- Evitar dependências pesadas/pagas: gráficos com **`fl_chart`** (não Syncfusion, que
  é licença paga e o plano é SaaS).
- Sempre rodar `flutter analyze` e deixar sem issues antes de concluir uma tarefa.
