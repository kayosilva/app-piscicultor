# Notas Técnicas — App de Piscicultura

> Levantamento inicial (superficial, a confirmar com o Sr. Ananias e/ou pesquisa de domínio).
> Última atualização: 2026-09-30

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

```
Propriedade  (a fazenda/chácara — topo da hierarquia)
 └─ Tanque (nome, tipo: escavado / tanque-rede / alvenaria / outro; volume_m3, area_m2)
     └─ Ciclo (espécie, data_povoamento, qtd_inicial, origem_alevinos, status, data_despesca)
         ├─ LeituraDeAgua (data/hora, OD, temp, pH, amônia, nitrito, ...)
         ├─ Biometria (data, peso médio, nº amostrado)
         ├─ Arraçoamento (data, kg de ração)
         └─ Mortalidade (data, qtd)
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
