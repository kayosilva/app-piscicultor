# Notas Técnicas — App de Piscicultura

> Levantamento inicial (superficial, a confirmar com o Sr. Ananias e/ou pesquisa de domínio).
> Última atualização: 2026-10-07 (planilha do Ananias consolidada — ver §11)

## 1. Parâmetros de uma criação de peixes

Dividem-se em dois grupos — o app precisa dos dois.

### A) Qualidade da água (medição frequente)
- **Oxigênio dissolvido (OD)** — o mais crítico. Mata peixe da noite pro dia. Medido geralmente de
  manhã cedo.
- **Temperatura** — afeta metabolismo e o próprio OD.
- **pH**
- **Amônia (NH₃)** — tóxica; sobe com excesso de ração/fezes.
- **Nitrito (NO₂)** e **Nitrato (NO₃)** — ciclo do nitrogênio.
- **Alcalinidade** e **dureza**.
- **Transparência** — medida com disco de Secchi; indica quantidade de algas.
- Eventuais: CO₂, condutividade, salinidade.

### B) Zootécnicos / manejo (retorno financeiro)
- **Biometria**: peso médio e comprimento (pesagem de amostra).
- **Densidade de estocagem** (peixes/m³).
- **Ração fornecida** por dia.
- **Conversão alimentar (TCA)** = kg ração ÷ kg peixe ganho. Indicador-chave de custo.
- **Mortalidade**.
- **Biomassa total** = nº de peixes × peso médio.

> ⚠️ As **faixas ideais** (valor "bom" x "problema") variam por espécie. É o que alimenta os
> alertas. Confirmar com o Ananias (pergunta 9) ou levantar em pesquisa de domínio com fontes.
> A planilha (§11) confirmou a lista de parâmetros, mas **não trouxe as faixas** (coluna "Valor"
> vazia). Faixas pesquisadas, com fontes, em **`FAIXAS-IDEAIS-TILAPIA.md`** (2026-10-07),
> aguardando validação do Ananias.

## 2. O que fazer com os dados (onde está o valor)

1. **Alertas / faixas ideais** — avisar na hora quando um parâmetro sai da faixa saudável.
   É o argumento de venda mais forte (evita perder tanque inteiro).
2. **Gráficos de tendência** — ver o parâmetro evoluindo ao longo do tempo.
3. **Curva de crescimento** — peso médio × tempo vs. curva esperada da espécie.
4. **Cálculo de arraçoamento** — quanto de ração dar hoje com base na biomassa (ração ≈ 70% do custo).
5. **Previsão de despesca** — estimativa de dias até o peso de abate.
6. **Relatório de ciclo e custo/lucro** por tanque.

## 3. Modelagem de dados

Peça-chave: **tanque ≠ ciclo**.
- **Tanque** = estrutura física (existe sempre, reusável).
- **Ciclo/lote** = um povoamento específico (ex.: 5.000 alevinos de tilápia em março). Ao despescar
  e povoar de novo, é **outro ciclo** no mesmo tanque.
- Todo o histórico pendura no **ciclo**, não no tanque.

**Implementado hoje** (schema **v2**, 2026-10-07):

```
Propriedade (nome, localizacao)
 └─ Tanque (nome, tipo: escavado / tanque-rede / suspenso / alvenaria / outro; volume_m3,
 │          area_m2, altura_m, material?, sistema_cultivo: convencional / bioflocos)
     └─ Ciclo (especie, data_povoamento, qtd_inicial, peso_inicial_g?, origem_alevinos
               [= fornecedor/linhagem], vacinado, status, data_despesca)
```

- **v1 → v2** só com `ALTER TABLE ... ADD COLUMN` (nulos ou com default): dados antigos ficam
  intactos. Migração validada no emulador sobre um banco v1 com dados reais.
- No formulário do tanque, o **volume é sugerido** como área × altura e continua editável
  (tanque circular, talude etc.).
- Números decimais nos formulários usam o helper `shared/utils/decimal_input.dart` (aceita
  vírgula ou ponto; exibe com vírgula).

**Modelo-alvo** (revisado em 2026-10-07 a partir da planilha do Ananias — detalhes e lacunas em
§11; decidido por nós, já que o Ananias não registra nada hoje — ver `PERGUNTAS-ANANIAS.md`):

```
Propriedade (+ latitude/longitude — necessárias p/ o clima automático)
 ├─ Tanque (+ altura_m, material; tipo ganha "suspenso"; volume = área × altura)
 │   └─ Ciclo = "Povoamento" na planilha
 │       (especie, data_povoamento, qtd_inicial, + peso_inicial_g, + fornecedor/marca do alevino,
 │        + vacinado, status, data_encerramento)
 │       ├─ Medicao (data/hora) ── MedicaoValor (parametro, valor)      por tanque (via ciclo)
 │       ├─ Biometria (data, amostra, peso total, média, esperado*, nota, motivo, observação)
 │       ├─ Arracoamento (data/hora do trato, ração, kg; total do dia*)  → baixa no estoque
 │       ├─ Despesca (data, qtd, peso total, média*, cliente, final?)    várias por ciclo
 │       └─ Mortalidade (data, qtd, causa)                              opcional
 ├─ ClimaDiario (data, temp. ambiente, umidade, vento, pressão, chuva, estação) — *automático*
 ├─ Insumo / Compra (tipo, marca, especificação, embalagem, qtd, valor) → Estoque
 └─ Pessoa (nome, tipo: cliente/fornecedor, celular, CPF/CNPJ)

Catálogos: Especie · Marca · Parametro (sigla, nome, unidade, faixas por espécie) · Equipamento
Referência (pesquisa): TabelaCrescimento (dias × peso esperado) · TabelaArracoamento (peso × % ração)
* = calculado pelo app
```

> Decisões de implementação (2026-09-30, validadas com o Kayo):
> - **Nome `Propriedade`** (em vez de "Estabelecimento") — mais palatável no diálogo com o Sr. Ananias.
> - **PK = UUID (TEXT)** em todas as tabelas, não auto-incremento — evita colisão de IDs no futuro
>   sync local→nuvem (SaaS).
> - **`created_at` / `updated_at` / `deleted_at`** em todas as tabelas. Soft-delete: nunca apagar de
>   fato, só marcar `deleted_at` (exigência do padrão de sincronização do app-gco).
> - **Seed de uma propriedade padrão** na criação do banco. No MVP o Sr. Ananias tem só uma, então o
>   app abre direto no **Painel** e há uma **tela de edição** da propriedade (nome/localização),
>   acessível pelo menu — sem lista nem "nova propriedade". O CRUD completo (criar/excluir várias)
>   entra na Fase 2 (multi-tenant); a tabela já nasce pronta para isso.
> - As tabelas `propriedade`, `tanque` e `ciclo` já estão **implementadas** (SQLite via `sqflite`);
>   `leitura_agua`/`biometria`/etc. entram nas próximas etapas.

## 4. Tecnologia

- **Flutter** — boa escolha (Kayo já conhece; multiplataforma; roda no celular na beira do tanque).
- **⚠️ Precisa funcionar OFFLINE** — na chácara pode não ter sinal. Gravar local
  (**SQLite** via `drift` ou `sqflite`) e **sincronizar** quando houver conexão. Confirmar sinal
  no local (pergunta 16).
- **Nuvem / multi-tenant** — como a Fase 2 é locar para outros, cada cliente vê só os próprios dados.
  Opções:
  - **Firebase/Firestore** — sync offline nativo, MVP rápido.
  - **Supabase (Postgres)** — mais estruturado para dados relacionais; melhor a longo prazo.
- **Estratégia**: começar **100% local** (só o Ananias usar) e plugar a nuvem só quando virar SaaS.
  Entrega valor rápido sem pagar infra à toa.

## 5. Sugestão de MVP

**Fase 1 (fazer ele já usar):**
- Cadastro de tanques e ciclos.
- Registro rápido de leituras de água (formulário simples, offline).
- Faixas ideais + alerta visual quando sai da faixa.
- 1 gráfico de tendência por parâmetro.

**Depois:** biometria/curva de crescimento → arraçoamento → relatório de custo →
sync/nuvem → multi-tenant.

**Revisão de ordem (2026-10-07, após a planilha):** o Ananias quer, além do registro, **telas de
relatório com gráficos de barra e de linha** (áudio de 03/10). A ordem sugerida passa a ser:

1. **Ajustes baratos no que já existe** — Tanque (`altura_m`, `material`, tipo "suspenso") e Ciclo
   (`peso_inicial_g`, `vacinado`, fornecedor do alevino). Bump de `_version` + migração.
2. **Medição de água** (catálogo de parâmetros + leituras) com faixas de referência para tilápia
   levantadas em pesquisa e confirmadas com ele depois → alerta visual + gráfico de linha.
3. **Biometria** + curva de crescimento esperada (depende da `Tab_Cresci`).
4. **Despesca** como evento próprio (com cliente) — e cadastro de **Pessoas**.
5. **Arraçoamento + Compras/Estoque** (com alerta de estoque) — depende da `Tab_Racao`.
6. **Clima automático** pela data + coordenada da propriedade.
7. **Relatórios** consolidando tudo (TCA, biomassa, custo por ciclo).

## 6. Decisão de arquitetura (definida em 2026-09-30)

Kayo é dev fullstack (PHP, Node, JS, Angular, React, Vue, Ionic), mas gostou muito de **Flutter**
e tem o projeto **`app-gco`** (`/home/gran-001081/dev/app-gco`) como referência viva. Decisão:

- **UI:** Flutter. Alvo inicial: **Android** (celular físico + emulador).
- **Estado / DI / rotas:** **GetX** (já domina via app-gco; simples, sem cerimônia).
- **Persistência local:** **SQLite** (dados estruturados: tanque→ciclo→leitura) + **Hive**
  (config/cache e fila de sync).
- **HTTP:** **Dio** com poucos interceptors (auth, retry, network).
- **Offline-first:** replicar o padrão **`SynchronizationClient`** do app-gco (fila em Hive + retry).
- **Gráficos:** **`fl_chart`** (grátis). ⚠️ Evitar **Syncfusion** — licença paga p/ uso comercial,
  e o plano é SaaS.
- **Erros:** `Either<Failure,T>` (dartz) — opcional no MVP.
- **Backend (Fase 2):** **próprio** (Node ou PHP + Postgres/MySQL — Kayo domina). Supabase
  possível como atalho inicial. Isolar acesso a dados atrás de repositório p/ não prender à infra.

## 7. Padrões reaproveitáveis do app-gco (referência)

App corporativo grande (30+ módulos) — **adotar apenas o essencial, em versão simplificada**.

- **FVM / Flutter 3.38.10 / Dart ^3.10.0** — só necessário se for abrir/rodar o app-gco.
- **Feature-first + clean arch** (application / domain / infra) — versão enxuta (~5 módulos, não 30).
- **Convenção de nomes:** `feature.page.dart`, `feature.controller.dart`, `feature.binding.dart`...
- ⭐ **`SynchronizationClient`** — fila offline em Hive + retry (até 5x) + `NetworkCheckerService`.
  Padrão-ouro p/ o offline do piscicultura. Arquivo:
  `app-gco/lib/app/shared/synchronization/synchronization-client/synchronization.client.dart`
- **Dio interceptors** (auth, retry, network) — `app-gco/lib/app/shared/dio/client.dio.dart`.
- **flutter_dotenv** p/ ambientes (dev/stg/prod).
- **OVERKILL p/ piscicultura (não copiar):** Firebase completo, social auth, ACL, 38 services,
  certificate pinning, Chromecast, in-app purchase, Syncfusion.

## 8. Ambiente de desenvolvimento

- **Reinstalado e funcional em 2026-09-30** (máquina havia sido formatada). Componentes:
  - **Flutter 3.47.5 stable + Dart 3.13.4** em `~/development/flutter` (PATH no `.bashrc`).
  - **Android SDK** em `~/Android/Sdk` (`ANDROID_HOME` + PATH no `.bashrc`): platform-tools,
    emulator, cmdline-tools, Platform android-37, Build-Tools 36, licenças aceitas.
  - **Android Studio** instalado (via snap) — editor + SDK Manager.
  - **Java OpenJDK 17** (já existia).
  - **AVD `piscicultura`**: Pixel 6, Android 16 ("Baklava"), imagem
    `system-images;android-36;google_apis;x86_64`, acelerada por **KVM**. Sobe com:
    `emulator -avd piscicultura` (ou pela GUI do Android Studio).
- **Avisos não-bloqueantes do `flutter doctor`:**
  - Linux toolchain (clang/cmake/ninja/gtk) ausente — só p/ build desktop Linux; ignorável.
  - `Multiple adb binaries` — há um `adb` do sistema em `/usr/lib/android-sdk/`; PATH prioriza o
    do SDK. P/ remover: `sudo apt remove android-sdk-platform-tools` (opcional).
- Testar em: **emulador** (primário — mais prático/rápido) e **celular físico via USB**
  (validação pontual: performance real, sensores, câmera — falta config udev + depuração USB).

## 9. Identidade visual (logo, ícone, splash)

- **Marca:** peixe branco estilizado sobre duas ondas, no teal da marca
  (`AppColors.seed = #00796B`, fundo do badge em degradê `#00897B → #00695C`).
- **Fonte editável (versionada):** `art/mark.svg` (marca isolada, branca, fundo transparente — vira o
  *foreground* do ícone adaptativo e o splash) e `art/icon.svg` (badge completo com fundo teal).
  Desenhados à mão em SVG; rasterizados com **Inkscape**.
- **PNGs gerados** (entram no app): `assets/branding/icon.png` (1024, badge) e
  `assets/branding/icon_foreground.png` (1024, marca branca). Declarados em `pubspec.yaml`.
- **Geração dos assets de plataforma** (ícone do launcher + splash), configurada no `pubspec.yaml`
  nos blocos `flutter_launcher_icons` e `flutter_native_splash`:
  ```bash
  # 1) reexportar os PNGs se a arte mudou:
  inkscape art/icon.svg  --export-type=png --export-filename=assets/branding/icon.png            -w 1024 -h 1024
  inkscape art/mark.svg  --export-type=png --export-filename=assets/branding/icon_foreground.png -w 1024 -h 1024
  # 2) regerar ícone e splash:
  dart run flutter_launcher_icons
  dart run flutter_native_splash:create
  ```
- **Splash:** fundo teal (`#00796B`; escuro `#00332C`) com a marca branca centralizada — consistente
  em Android 12+ e anteriores. **Ícone do launcher:** adaptativo (fundo teal + marca branca).
- O **header do menu** (`app_drawer.dart`) usa `assets/branding/icon.png` como logo e mostra o nome da
  propriedade atual (via `PropriedadeAtualService`).

## 10. Backlog — enriquecer a entity Propriedade (GPS, mapa, campos)

> Ideia levantada em 2026-09-30 (a confirmar com o Ananias — ver `PERGUNTAS-ANANIAS.md` 17–18).
> Hoje a `propriedade` tem só `nome` + `localizacao` (texto livre). Abaixo, para onde pode crescer.

### Campos candidatos (incrementais; novos campos entram nullable + bump de `_version`)
- **Localização:** `endereco`, `municipio`, `uf`, `cep`, `ponto_referencia` (texto);
  `latitude`, `longitude`, `precisao_m` (do GPS); `area_total_ha` (≠ área de tanque).
- **Contato/produtor** (relevante no multi-tenant): `responsavel`, `telefone`, `email`.
- **Piscicultura:** `fonte_agua` (açude/rio/poço/nascente). Documentação do setor (Fase 2):
  **outorga de uso da água**, **licença ambiental**, **registro de aquicultor (RGP)**.
- **Mídia** (futuro): `foto` da propriedade.

### GPS ≠ mapa (pegadas diferentes)
- **Capturar coordenada** (`geolocator`): devolve lat/long + precisão; **funciona offline** (chip de
  GPS, não precisa de internet — casa com o offline-first); grátis, sem chave. Exige permissão
  `ACCESS_FINE_LOCATION` + prompt em runtime. É o grosso do valor ("onde fica a propriedade").
- **Renderizar mapa** — é a parte que custa/depende de rede:
  - `google_maps_flutter`: **chave de API + cobrança** (Google Maps Platform) e tiles online. ❌ vai
    contra "evitar pagas" (§6) e não renderiza sem sinal.
  - `flutter_map` (OpenStreetMap): **grátis, sem chave**, tiles abertos; ainda precisa de internet
    (ou cache de tiles) pra desenhar. ✅ opção preferida se embutir mapa.
  - Mais barato ainda: **não embutir mapa**, só botão "abrir no mapa" via URI `geo:lat,long` (chama
    o app de mapas do celular). Zero custo/dependência.

### Faseamento sugerido
- **Fase A (barata, offline):** adicionar `latitude`/`longitude` + botão "capturar GPS" (`geolocator`),
  exibir coordenada + botão "abrir no mapa" (`geo:`). Sem chave, sem custo, funciona sem sinal.
- **Fase B (rica):** mapa embutido (`flutter_map`/OSM) pra ver/ajustar o pino, exibido quando online;
  opcionalmente cache de tiles da região.

### Atenção
- GPS é **dado sensível**: no SaaS, pedir consentimento e permitir editar/remover a localização.
- Metade dos campos acima depende das respostas 17–18 do Ananias — não cravar schema antes disso.

## 11. Planilha do Ananias (`docs/Pla_Peixe (3).xlsx`) — análise

> Recebida junto com o áudio de 2026-10-03 (transcrição em
> `transcricao-audio-ananias-2026-10-03.txt`) e consolidada em 2026-10-07.
> No áudio ele diz: (1) esses são os dados a armazenar; (2) **a maioria será digitada, parte gerada
> pelo próprio app**; (3) quer **relatórios/telas que transformem os dados em informação, com
> gráficos de barra e de linha**.

### Contexto real da criação (dados de exemplo da planilha)
- **4 tanques** iguais: 100 m², 1 m de altura (100 m³), **suspensos**, de **geomembrana**.
- Espécies cadastradas: **tilápia** (a única usada nos povoamentos), lambari, pintado.
- Povoamentos de **3.000–4.000 alevinos** de ~2 g, **escalonados a cada 30 dias** (um tanque por
  mês) — cada tanque é repovoado depois da despesca. Confirma o modelo **tanque ≠ ciclo**.
- Latitude **-15.74** (região do DF/entorno).

### Mapeamento aba → entidade

| Aba | Vira | Observações |
| --- | --- | --- |
| `Indicadores` | — | Só um índice (Tanque, Peixe, Parametros); parece rascunho. |
| `Tanques` | `tanque` | Novos: `altura`, `material`; `m3 = m2 × altura` (calculado); tipo "Suspenso" não existe no nosso enum. |
| `Peixes` | catálogo `especie` | Hoje `ciclo.especie` é texto livre. |
| `Povoamento` | `ciclo` | Novos: `peso(g)` inicial, `marca` (do alevino? valor "Genérico"), `vacina` (Sim/Não). |
| `Biometria` | `biometria` (no ciclo) | `idade` = data − povoamento; `media = peso total ÷ amostra`; `esperado` vem da `Tab_Cresci`; `nota` (Bom/Excelente/Ruim); `fato` (Rotina/Biometria/Outro); observação. |
| `Despesca` | `despesca` (no ciclo) | `idade` e `media` calculados; **`cliente`** → `pessoa`. Exemplo: 100 peixes de um lote de 3.000 → indica **despesca parcial**. |
| `Arracoamento` | `arracoamento` (no ciclo) | Marca da ração, vezes/dia, kg; consumo acumulado; **estoque** e **alerta verde/amarelo/vermelho** (de estoque). |
| `Compras` | `compra` / estoque | Tipos: Ração, BioRemediador, Probiótico, Bicarbonato. Ração tem granulometria (mm) e **PB** (proteína bruta, %). |
| `Marcas` | catálogo `marca` | TilaMax, Jkw, Acqua, Guabi (marcas de ração). |
| `Pessoas` | `pessoa` | Cliente/Fornecedor, celular, CPF/CNPJ. |
| `Paramentros` | catálogo `parametro` | Ver lista abaixo. Coluna "Valor" (faixa) **vazia**. |
| `Medicao` / `Med` | `medicao` + `medicao_valor` | Duas versões do mesmo dado: `Medicao` em colunas (1 linha por leitura) e `Med` em linhas (1 linha por parâmetro). Não têm coluna de tanque, mas a medição é **por tanque** (decidido). |
| `Equipamentos` | catálogo `equipamento` | Soprador, aerador, difusor, comedouro, bomba. **Backlog** (pós-MVP). |
| `Tab_Racao` | referência | Vazia: "quantidade de ração de 1 g até 1 kg — dados na internet em PDF". |
| `Tab_Cresci` | referência | Vazia: "escala de desenvolvimento em dias e peso da tilápia de 1 g a 1.000 g — PDF na internet". |

### Parâmetros da água (aba `Paramentros`)
- **Medidos (digitados):** pH, KH (alcalinidade), GH (dureza), NH₃ (amônia), NO₂ (nitrito),
  NO₃ (nitrato), OD (oxigênio dissolvido), turbidez/transparência (cm — disco de Secchi),
  sólidos (ml — provavelmente cone Imhoff), temperatura da água.
- **Automáticos (internet, pela data + latitude):** temperatura ambiente, umidade, vento, pressão,
  chuva (mm/dia), estação do ano.
- Leitura de exemplo às **6h15** — bate com a prática de medir OD de manhã cedo.

### Decisões de modelagem propostas
- **Medição em formato longo** (`medicao` + `medicao_valor` → `parametro`), como na aba `Med`:
  adicionar um parâmetro novo é só um registro no catálogo, sem migração de schema — importante
  para o SaaS (cada produtor mede coisas diferentes). As faixas ficam no catálogo, por espécie.
- **Clima separado da medição** (`clima_diario` por propriedade + data): é um dado do local, não do
  tanque, e não deve ser duplicado em cada leitura.
- **Clima automático × offline-first:** gravar a medição na hora e **completar o clima quando houver
  internet**. Candidata: API **Open-Meteo** (sem chave, tem histórico) — ⚠️ o plano gratuito é só
  para uso **não comercial**; na Fase 2 (SaaS) precisa de plano pago ou outra fonte. Exige
  `latitude`/`longitude` na propriedade (já previsto no §10 — vira prioridade).
- **Estação do ano** é calculada pela data + hemisfério; não precisa de API.
- **Faixas com 3 níveis** (ideal / atenção / crítico = verde / amarelo / vermelho), com mínimo e
  máximo por nível, **editáveis** pelo produtor. Valores iniciais em `FAIXAS-IDEAIS-TILAPIA.md`.
- **Amônia:** o produtor digita a **amônia total** (é o que o kit mede) e o app **calcula a NH₃
  tóxica** com o pH e a temperatura da mesma leitura (fórmula de Emerson; ver o doc de faixas).
- **Unidade no catálogo de parâmetros:** nitrito/nitrato podem vir como íon ou como N
  (N-NO₃ × 4,43 = NO₃⁻); guardar a unidade do kit.
- **Despesca como entidade própria** (várias por ciclo), não só a `data_despesca` do ciclo. O ciclo
  encerra na despesca final. ⚠️ Muda a regra atual de "encerrar = despescar".
- **Tabelas de referência** (`Tab_Cresci`, `Tab_Racao`) entram como dados semeados, a partir de
  fontes públicas citadas (Embrapa, fabricantes de ração). São elas que geram o "esperado" da
  biometria e a sugestão de ração do dia — a "inteligência do sistema" que ele mencionou.

### Inconsistências nos dados de exemplo → decisões nossas
Os valores da planilha são **fictícios**, então contas que não batem não são requisito. Onde o
dado de exemplo deixava dúvida, decidimos (2026-10-07):

- **Medição é por tanque**, ligada ao ciclo ativo (a planilha só omitiu a coluna).
- **T_Agua × T_Ambi:** as descrições em `Paramentros` estão trocadas por erro de digitação.
  Temperatura da água é medida; temperatura ambiente vem da internet.
- **Arraçoamento:** ~~`Quant(kg)` é por trato e o total do dia = vezes × quant~~ — **corrigido pelo
  áudio de 2026-10-07**: cada **trato é um registro próprio** (hora + kg, as quantidades variam ao
  longo do dia) e o app **soma o total diário**. O consumo acumulado e o estoque são calculados a
  partir das compras, nunca digitados (o "8.000 kg" é fictício). O alerta verde/amarelo/vermelho é
  do **estoque**, com limites **configuráveis**.
- **Compras:** gravar quantidade + **valor total**; o preço unitário é calculado. Estoque por item
  (tipo + marca + especificação).
- **Povoamento:** "marca" = fornecedor/linhagem do alevino; "vacina" = sim/não.
- **Biometria:** "nota" = avaliação do lote (o app pode sugerir pela média × esperado); "fato" =
  motivo da pesagem.

> ⚠️ **Áudio de 2026-10-07 (mais recente):** a planilha era a v1.0; ele já está fazendo a **v2.0** e
> quer **alinhar numa reunião** (proposta: 11/10) antes de implementarmos regras de negócio. As
> decisões abaixo são **propostas para levar à reunião**, não definitivas.

**Atualização (2026-10-07):** o Ananias **não registra nada hoje** — a planilha é só ilustrativa.
Por isso também decidimos: despesca **várias por ciclo** (a final encerra o ciclo); **mortalidade**
entra como registro opcional; **equipamentos** vão para o backlog; as **tabelas de crescimento e
de ração** e as **faixas ideais** (`FAIXAS-IDEAIS-TILAPIA.md`) vêm de pesquisa nossa e ficam
editáveis no app. Para ele só vão duas perguntas: bioflocos e kit de medição (Mensagem 2).
