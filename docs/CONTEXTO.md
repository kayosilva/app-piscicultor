# Projeto: App de Controle de Criação de Peixes (Piscicultura)

> Documento de contexto — resumo da ideia, origem e modelo de negócio.
> Última atualização: 2026-10-07

## Origem

Ideia trazida pelo **Sr. Ananias** por áudio de WhatsApp em 2026-09-29 (transcrição em
`transcricao-audio-ananias.txt`).

Ele quer um app para **controle de criação de peixe** (piscicultura) na chácara dele. Pontos que
ele levantou no áudio:

- Na criação de peixe é preciso **medir vários parâmetros da água o tempo todo** — senão o peixe
  morre ou não cresce.
- São **uns 10 a 15 dados** que precisam ser coletados (diária, semanal ou mensalmente) e
  **armazenados** para criar um **histórico**.
- Precisa de **banco de dados** para armazenar e depois **trabalhar os dados para gerar informação**.
- Ele acha que **não é tão complexo**. Já programou em dBase IV e C há uns 30 anos.
- Já **testou apps concorrentes** (inclusive de locação) e achou que estão **"fracos"** — dá pra
  melhorar.

Em **2026-10-03** ele mandou a **planilha-exemplo** (`Pla_Peixe (3).xlsx`) e um segundo áudio
(`transcricao-audio-ananias-2026-10-03.txt`). Recados do áudio: a planilha mostra os dados a
armazenar; a maioria será digitada, mas **parte deve ser gerada pelo próprio app**; e ele quer
**relatórios com gráficos de barra e de linha**. A análise da planilha está em
`NOTAS-TECNICAS.md` §11.

## Modelo de negócio (visão do Sr. Ananias)

1. **Fase 1** — usar o app na própria chácara/criação dele.
2. **Fase 2** — quando estiver "redondinho", **disponibilizar para locação** (SaaS / assinatura) —
   "um dinheirinho que ia entrar todo mês".
3. Quer **um parceiro técnico** (desenvolvedor) para fazer junto: ele entra com o conhecimento do
   domínio (o que medir, armazenar, recuperar, que informação gerar) e o parceiro desenvolve.

## Situação do Kayo (desenvolvedor)

- Achou o projeto interessante e de **complexidade baixa/média**.
- Está **enferrujado** em criação de apps — última vez há ~3 anos, no Gran, com **Flutter**.
- Quer pensar bem no **o que dá pra fazer** e **como fazer** antes de começar.

## Próximos passos definidos

1. [x] Transcrever o áudio.
2. [x] Levantar visão inicial (parâmetros, o que fazer com os dados, modelagem, MVP, tecnologia)
   → ver `NOTAS-TECNICAS.md`.
3. [~] **Enviar perguntas ao Sr. Ananias** para levantar requisitos reais
   → ver `PERGUNTAS-ANANIAS.md`. (pergunta 1 respondida em 30/09/2026; planilha recebida e
   consolidada em 07/10/2026, respondendo total ou parcialmente as perguntas 3–7, 12–14 e 17)
   - **Importante:** ele **não registra nada hoje**; a planilha é só ilustrativa. Requisitos são
     decididos por nós, com padrões configuráveis no app.
   - **Pendente:** enviar a **Mensagem 2** (só bioflocos e kit de medição).
4. [~] Consolidar respostas → modelagem de dados definitiva + escopo do MVP.
   - Modelo-alvo e nova ordem do MVP propostos em `NOTAS-TECNICAS.md` §3, §5 e §11 (2026-10-07).
     Os pontos que dependem das perguntas 21, 25–27 estão marcados com `?`.
5. [x] Pesquisa de domínio: **faixas ideais da tilápia**, com fontes (2026-10-07) →
   `FAIXAS-IDEAIS-TILAPIA.md`. Entram como padrão editável no app. Falta só saber se o sistema
   é de **bioflocos** (pergunta 29, na Mensagem 2).
   - [ ] Pesquisar também a **tabela de crescimento** e a **tabela de arraçoamento** da tilápia
     (substituem as abas vazias `Tab_Cresci` e `Tab_Racao` da planilha).
6. [x] Esqueleto do projeto Flutter criado em **`~/dev/piscicultor`** (2026-09-30) — GetX,
   estrutura feature-first, tema, build validada no emulador. Ambiente reinstalado
   (ver `NOTAS-TECNICAS.md` §8).
7. [x] **Camada de dados + CRUD de Tanques** (2026-09-30) — modelagem `Propriedade → Tanque → Ciclo`
   em SQLite (UUID + soft-delete + seed da propriedade padrão), repositórios, e dashboard/lista de
   tanques com criar/editar/excluir. Validado rodando no emulador (criar tanque persiste e aparece
   na lista). Detalhes da modelagem em `NOTAS-TECNICAS.md` §3.
8. [x] **CRUD de Ciclos** (2026-09-30) — módulo `ciclos` (controller, binding, lista e formulário).
   Tocar num tanque abre seus ciclos; criar/editar/encerrar (despesca, com data)/excluir. Regra de
   negócio: **só um ciclo ativo por tanque** (é preciso encerrar antes de povoar de novo). Também
   entrou a **localização pt-BR** (`flutter_localizations`) para os date pickers.
9. [x] **Painel (dashboard)** (2026-09-30) — nova tela inicial (`/dashboard`) consolidando os tanques
   com seus ciclos ativos: KPIs no topo (tanques, em cultivo, peixes em cultivo) + um cartão por
   tanque (espécie · nº peixes · dias, ou "ocioso"). Tocar num tanque abre seus ciclos e o painel
   recarrega ao voltar. Módulo `dashboard`. Validado no emulador com dados semeados.
10. [x] **Identidade visual** (2026-09-30) — logo/marca (peixe branco sobre ondas, no teal da marca),
    **ícone do launcher** adaptativo e **splash** nativo (Android 12+ e anteriores), além do badge no
    header do menu. Fonte editável em `art/*.svg`; PNGs em `assets/branding/`. Ver `NOTAS-TECNICAS.md` §9.
11. [x] **Edição da propriedade** (2026-09-30) — tela acessível pelo menu (`/propriedade`) para
    editar os dados da propriedade cadastrada (nome e localização). No MVP é só edição da propriedade
    padrão — sem lista nem "nova propriedade" (o CRUD completo entra na Fase 2, multi-tenant). O nome
    editado reflete na hora no título do painel e no **header do menu** (via serviço global reativo
    `PropriedadeAtualService`). Módulo `propriedade`.
12. [x] **Planilha do Ananias consolidada** (2026-10-07) — análise aba por aba, modelo-alvo,
    inconsistências e perguntas novas. Ver `NOTAS-TECNICAS.md` §11.
13. [x] **Repositório git** criado (2026-10-07) — privado em `github.com/kayosilva/app-piscicultor`,
    remoto via alias SSH `github-pessoal` (chave pessoal) e autor com o e-mail pessoal.
14. [ ] **Ajustes em Tanque e Ciclo** vindos da planilha (altura, material, tipo "suspenso", peso
    inicial, vacina, fornecedor do alevino) → bump de `_version` + migração.
15. [ ] **Medição de água** (catálogo de parâmetros + leituras em formato longo) + faixas de
    referência para tilápia (pesquisa) + alertas + gráfico de linha.

## Projeto de código

- **Local:** `/home/gran-001081/dev/piscicultor`. Os docs de planejamento ficam em `docs/`.
- **Repositório:** `git@github.com:kayosilva/app-piscicultor.git` (privado). Neste repo o remoto usa
  `git@github-pessoal:...`, porque o `github.com` do `~/.ssh/config` aponta para a chave do trabalho.
- **Stack:** Flutter + GetX + (SQLite/Hive/Dio/fl_chart/dotenv já como dependências).
- `applicationId`: `br.com.piscicultor` (provisório — trocar pelo domínio real depois).
- Rodar: `cd ~/dev/piscicultor && flutter run -d emulator-5554` (com o emulador `piscicultura` aberto).
- **Estrutura atual do código:**
  - `lib/app/shared/data/database/app_database.dart` — abre o SQLite, cria o schema, faz o seed.
  - `lib/app/shared/data/models/` — `propriedade.dart`, `tanque.dart`, `ciclo.dart`.
  - `lib/app/shared/data/repositories/` — um repositório por entidade.
  - `lib/app/modules/dashboard/` — controller, binding e página do Painel (tela inicial).
  - `lib/app/modules/tanques/` — controller, binding, lista e formulário.
  - `lib/app/modules/ciclos/` — controller, binding, lista e formulário (por tanque).
  - `lib/app/modules/propriedade/` — controller, binding e página de edição da propriedade.
  - `lib/app/shared/services/propriedade_atual_service.dart` — propriedade atual reativa e permanente
    (nome exibido no header do menu); carregada no `main`.
  - Rota inicial agora é `/dashboard` (Painel); `/tanques` continua para gestão/CRUD. Navegação
    pelo drawer: Painel · Tanques · Propriedade · Configurações.
- Próximo no código: **ajustes em Tanque e Ciclo** (passo 14) e, em seguida, a **Medição de água**
  (passo 15). Ordem completa do MVP em `NOTAS-TECNICAS.md` §5.

## Arquivos deste projeto

- `CONTEXTO.md` — este arquivo (visão geral e negócio).
- `NOTAS-TECNICAS.md` — parâmetros, uso dos dados, modelagem, tecnologia, MVP.
- `PERGUNTAS-ANANIAS.md` — roteiro de perguntas para a conversa com o Sr. Ananias.
- `FAIXAS-IDEAIS-TILAPIA.md` — faixas ideal/atenção/crítico dos parâmetros da água, com fontes.
- `transcricao-audio-ananias.txt` — transcrição do áudio original (2026-09-29).
- `Pla_Peixe (3).xlsx` — planilha-exemplo do Ananias (2026-10-03).
- `WhatsApp Ptt 2026-10-03 at 14.50.22.ogg` + `transcricao-audio-ananias-2026-10-03.txt` — áudio
  que acompanhou a planilha e sua transcrição.
- **Fora do repo** (`~/Documentos/IdeiaSistema/`): o áudio original de 29/09 e o `transcrever.py`
  (faster-whisper), com o venv `.venv-whisper`. Para transcrever um áudio novo:
  `~/Documentos/IdeiaSistema/.venv-whisper/bin/python ~/Documentos/IdeiaSistema/transcrever.py "<arquivo.ogg>"`.
