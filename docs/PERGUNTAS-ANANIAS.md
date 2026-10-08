# Perguntas para o Sr. Ananias

> Roteiro para levantar os requisitos reais do app de piscicultura.
> Enviar por WhatsApp — ele pode responder por áudio, do jeito que for mais fácil.
> Marque `[x]` conforme for obtendo as respostas e anote-as abaixo de cada pergunta.
>
> ⚠️ **Contexto (07/10/2026):** o Sr. Ananias **não registra nada hoje** — a planilha foi só um
> exemplo de como ele imagina o app. Perguntas sobre "como o senhor anota/faz" não têm resposta
> pronta. Regra: **decidimos nós** (com pesquisa e padrões configuráveis no app) e perguntamos a
> ele só o que depende da estrutura física dele.
>
> ⚠️ **Atualização (áudio de 07/10/2026):** ele quer **participar de perto** e propôs uma
> **reunião (domingo, 11/10)**. A Mensagem 2 **não será enviada**: as perguntas e as decisões
> "deduzidas por nós" viram **pauta da reunião** para ele confirmar.

---

## Mensagem pronta para enviar

Sr. Ananias, pra eu montar esse app do jeito certo, me ajuda respondendo essas perguntinhas
(pode ser por áudio mesmo, do jeito que for mais fácil pro senhor):

### Sobre a sua rotina hoje
- [x] **1.** Hoje o senhor anota esses dados como? No caderno, na cabeça, numa planilha?
  - _Resposta (30/09/2026):_ Ainda **não anota**. Pensou em fazer em planilha, mas concluiu que
    **planilha só armazena o dado** — para **gerar informação** ficaria trabalhoso/custoso. Por
    isso pensou no **aplicativo com banco de dados**. Vai montar uma **planilha de exemplo** de
    como armazenar os dados e enviar.
  - _✅ Planilha recebida_ (`docs/Pla_Peixe (3).xlsx`, com o áudio de 03/10) e consolidada em
    `NOTAS-TECNICAS.md` §11. Respondeu, total ou parcialmente, as perguntas 3–7, 12–14 e 17, e
    gerou as perguntas novas 19–28 (no fim deste arquivo).
- [ ] **2.** Quem vai mexer no app no dia a dia — só o senhor, ou tem mais alguém ajudando na criação?
  - _Resposta:_

### Sobre os peixes e os tanques
- [x] **3.** Que peixe o senhor cria (tilápia, tambaqui, outro)? É um tipo só ou vários?
  - _Resposta (planilha, 07/10/2026):_ **Tilápia** em todos os povoamentos. Também cadastrou lambari e pintado.
- [x] **4.** Quantos tanques o senhor tem hoje, e mais ou menos qual o tamanho deles?
  - _Resposta (planilha, 07/10/2026):_ **4 tanques** de 100 m² × 1 m de altura (100 m³), **suspensos**, de
    **geomembrana**.
- [ ] **5.** O senhor chega a ter mais de um "lote" no mesmo tanque ao longo do ano (povoa, colhe,
  povoa de novo)?
  - _Resposta (planilha, 07/10/2026):_ **Sim.** Repovoa o mesmo tanque depois da despesca, de forma escalonada (um
    tanque por mês), com 3.000–4.000 alevinos de ~2 g.

### Sobre os parâmetros da água (o coração da coisa)
- [ ] **6.** Quais medidas o senhor tira da água? (ex.: oxigênio, temperatura, pH, amônia...) Cita
  todas que vierem à cabeça.
  - _Resposta (planilha, 07/10/2026):_ pH, KH (alcalinidade), GH (dureza), amônia (NH₃), nitrito (NO₂), nitrato
    (NO₃), oxigênio dissolvido, transparência (cm), sólidos (ml) e temperatura da água. Também
    quer clima (temperatura ambiente, umidade, vento, pressão, chuva e estação), **puxado
    automaticamente da internet**.
- [ ] **7.** Com que frequência mede cada uma — todo dia, toda semana?
  - _Resposta parcial (planilha):_ a leitura de exemplo é às **6h15**, mas a planilha não diz a
    frequência de cada parâmetro.
- [ ] **8.** Como o senhor mede? Tem aparelho/sonda, kit de teste, ou é no olho mesmo?
  - _Resposta:_
- [ ] **9.** Pra cada medida dessas, o senhor sabe qual é o valor "bom" e a partir de qual valor já é
  problema? _(pergunta mais importante — alimenta os alertas do app)_
  - [x] _Decidido por nós (07/10/2026):_ faixas ideal/atenção/crítico pesquisadas com fontes
    (Embrapa, SRAC, Kubitza) em **`FAIXAS-IDEAIS-TILAPIA.md`**. Entram como **padrão editável**
    no app; não dependem de validação dele.

### Sobre o que fazer quando dá ruim
- [ ] **10.** Quando alguma medida sai do normal, o que o senhor faz? (troca água, liga aerador,
  para de dar ração...)
  - _Resposta:_
- [ ] **11.** Já perdeu peixe por causa de algum desses parâmetros? Qual foi?
  - _Resposta:_

### Sobre ração e crescimento
- [x] **12.** O senhor controla a ração que dá? Anota quanto gasta?
  - _Resposta (planilha, 07/10/2026):_ **Sim.** Quer registrar o arraçoamento diário (marca, vezes por dia, kg),
    as compras (ração e insumos, com valor) e o **estoque com alerta** verde/amarelo/vermelho.
- [x] **13.** Costuma pesar os peixes de vez em quando pra ver se estão crescendo?
  - _Resposta (planilha, 07/10/2026):_ **Sim**, por amostra (ex.: 100 peixes, cerca de 30 dias após o povoamento).
    Quer comparar com o **peso esperado** de uma tabela de crescimento da tilápia.

### O que o senhor quer VER no app
- [ ] **14.** No fim das contas, o senhor gostaria de ver o quê? Um resumo do dia, um gráfico
  mostrando a evolução, um alerta no celular quando algo está errado, um relatório de custo?
  - _Resposta parcial (áudio de 03/10/2026):_ quer **relatórios** que transformem os dados em
    informação, com **gráficos de barra e de linha**. Parte dos dados deve ser **gerada pelo
    app** (cálculos e clima automático).
- [ ] **15.** O senhor falou que testou uns apps que já existem — o que faltou neles? O que te
  incomodou? _(ouro: é onde mora a oportunidade de fazer melhor)_
  - _Resposta:_

### Sobre o uso na prática
- [ ] **16.** Lá nos tanques pega internet no celular, ou é lugar sem sinal?
  - _Resposta:_

### Sobre a propriedade (cadastro e localização)
- [ ] **17.** Além do nome, o que faria sentido guardar da propriedade? (município/UF, endereço ou
  ponto de referência, área total, de onde vem a água — açude/rio/poço/nascente, telefone de contato)
  - _Resposta parcial (planilha, 07/10/2026):_ precisa da **latitude** (-15.74) para buscar o clima. O restante
    segue em aberto.
- [ ] **18.** O senhor lida com alguma documentação da criação — outorga de uso da água, licença
  ambiental, registro de aquicultor (RGP)? Valeria o app guardar isso?
  - _Resposta:_
  - _(contexto: define se a entity Propriedade ganha campos de documentação na Fase 2 —
    ver `NOTAS-TECNICAS.md` §10)_

### Dúvidas que surgiram da planilha (07/10/2026)
- [ ] **19.** As medições da água são feitas **em cada tanque** ou uma só para todos? (A planilha
  não tem coluna de tanque na medição.)
  - [x] _Deduzido por nós (07/10/2026), a planilha tem valores fictícios:_ **por tanque**, ligada ao ciclo ativo.
- [ ] **20.** Na lista de parâmetros, "T_Agua" está como "temperatura do ambiente (internet)" e
  "T_Ambi" como "temperatura da água". Estão trocados? A temperatura da água o senhor mede com
  termômetro?
  - [x] _Deduzido por nós (07/10/2026), a planilha tem valores fictícios:_ **erro de digitação**. Na aba `Medicao`, `T_Agua` é medida (25 °C) e `T_Ambi` vem
    da internet (27 °C).
- [ ] **21.** Na despesca de exemplo saíram 100 peixes de um lote de 3.000. O senhor costuma
  **tirar aos poucos** (várias despescas no mesmo lote) ou tira tudo de uma vez? Quando considera
  que o lote terminou?
  - [x] _Decidido por nós (07/10/2026), ele não registra nada hoje:_ o app aceita **várias despescas por ciclo**; a marcada como **final** encerra o
    ciclo. Cobre os dois jeitos.
- [ ] **22.** No arraçoamento, a quantidade (kg) é **por trato** ou o **total do dia**? E o alerta
  verde/amarelo/vermelho é do **estoque de ração**? A partir de quanto muda de cor?
  - [x] _Deduzido por nós (07/10/2026), a planilha tem valores fictícios:_ `Quant(kg)` é **por trato** e o total do dia = vezes × quant (calculado). O alerta é
    do **estoque**, com limites **configuráveis** no app.
- [ ] **23.** Em Compras, o "Valor" é o **total** da compra ou o preço **por saco**? O estoque
  deve ser controlado por marca/tipo de ração?
  - [x] _Deduzido por nós (07/10/2026), a planilha tem valores fictícios:_ gravar **quantidade + valor total** (unitário calculado). Estoque **por item**
    (tipo + marca + especificação).
- [ ] **24.** No povoamento, "marca" é o **fornecedor/linhagem do alevino**? E "vacina" é só
  sim/não, ou importa qual vacina e quando?
  - [x] _Deduzido por nós (07/10/2026), a planilha tem valores fictícios:_ marca = **fornecedor/linhagem do alevino**; vacina = **sim/não**.
- [ ] **25.** O senhor já tem os **PDFs** da tabela de ração e da tabela de crescimento da
  tilápia? Se tiver, manda pra mim (de qual fabricante/fonte?).
  - [x] _Decidido por nós (07/10/2026), ele não registra nada hoje:_ **nós pesquisamos** as tabelas de crescimento e de arraçoamento da tilápia (Embrapa,
    fabricantes de ração).
- [ ] **26.** O senhor anota os **peixes que morrem**? (A planilha não tem mortalidade, mas ela é
  importante para calcular biomassa e conversão alimentar.)
  - [x] _Decidido por nós (07/10/2026), ele não registra nada hoje:_ **mortalidade entra no app** como registro opcional por ciclo.
- [ ] **27.** O que o senhor quer registrar dos **equipamentos** (soprador, aerador...): em qual
  tanque estão, manutenção, horas ligados?
  - [x] _Decidido por nós (07/10/2026), ele não registra nada hoje:_ **backlog**, depois do MVP.
- [ ] **28.** Na biometria, o que significam a **"nota"** (Bom/Excelente/Ruim) e o **"fato"**
  (Rotina/Biometria/Outro)?
  - [x] _Deduzido por nós (07/10/2026), a planilha tem valores fictícios:_ **nota** = avaliação do lote (o app pode sugerir comparando média × esperado);
    **fato** = motivo da pesagem.
- [ ] **29.** O senhor cria no sistema de **bioflocos**? (Tanque suspenso de geomembrana,
  medição de sólidos, KH alto e compra de bicarbonato/probiótico sugerem que sim. Muda as faixas
  de alcalinidade, sólidos e transparência.) Vai na **Mensagem 2**.
  - _Resposta:_

---

## Mensagem 2 — o que só ele sabe (revisada em 07/10/2026)

> Formatada para colar no WhatsApp (`*negrito*`). Substitui as versões anteriores: como ele não
> registra nada hoje, todo o resto (perguntas 9 e 19–28) foi decidido por nós. Ficam só as
> perguntas sobre a estrutura física dele: **29** (bioflocos) e **8** (como mede a água).

```
Sr. Ananias, recebi a planilha e o áudio, muito obrigado! Já deu pra entender o que o senhor quer, e eu já comecei a montar. 🐟

Só duas coisas que dependem de como é aí na chácara:

1. Os tanques são no sistema de *bioflocos* (água marrom, sem trocar água) ou no sistema comum, com troca de água?
2. O senhor já tem algum *kit ou aparelho pra medir a água* (pH, amônia, oxigênio)? Se tiver, me manda uma foto dele.

O resto eu resolvo por aqui. Os valores bons e ruins de cada medida eu pesquisei pra tilápia (Embrapa), e no app o senhor vai poder ajustar se quiser.
```

| Nº na mensagem | Pergunta no roteiro |
| --- | --- |
| 1 | 29 |
| 2 | 8 (+ unidade do kit, ver `FAIXAS-IDEAIS-TILAPIA.md`) |

---

## Observações para o Kayo
- **Pergunta 9** é a mais importante: as faixas ideais ("bom" x "problema") alimentam os alertas.
  Se ele não souber de cabeça, dá pra levantar por pesquisa de domínio (por espécie, com fontes) e
  confirmar depois.
- **Pergunta 15** revela a oportunidade competitiva (o que os concorrentes fazem mal).
- Quando ele responder por áudio, é só salvar o arquivo na pasta e transcrever com
  `transcrever.py` (ver `CONTEXTO.md`).
