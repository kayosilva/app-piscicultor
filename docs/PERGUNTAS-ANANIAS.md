# Perguntas para o Sr. Ananias

> Roteiro para levantar os requisitos reais do app de piscicultura.
> Enviar por WhatsApp — ele pode responder por áudio, do jeito que for mais fácil.
> Marque `[x]` conforme for obtendo as respostas e anote-as abaixo de cada pergunta.

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
  - _⭐ Ação:_ aguardar a planilha-exemplo do Ananias — ela deve revelar os parâmetros (perguntas
    6–9) e a estrutura de dados que ele imagina. Ao receber, transcrever/importar e comparar com a
    modelagem de `NOTAS-TECNICAS.md`.
- [ ] **2.** Quem vai mexer no app no dia a dia — só o senhor, ou tem mais alguém ajudando na criação?
  - _Resposta:_

### Sobre os peixes e os tanques
- [ ] **3.** Que peixe o senhor cria (tilápia, tambaqui, outro)? É um tipo só ou vários?
  - _Resposta:_
- [ ] **4.** Quantos tanques o senhor tem hoje, e mais ou menos qual o tamanho deles?
  - _Resposta:_
- [ ] **5.** O senhor chega a ter mais de um "lote" no mesmo tanque ao longo do ano (povoa, colhe,
  povoa de novo)?
  - _Resposta:_

### Sobre os parâmetros da água (o coração da coisa)
- [ ] **6.** Quais medidas o senhor tira da água? (ex.: oxigênio, temperatura, pH, amônia...) Cita
  todas que vierem à cabeça.
  - _Resposta:_
- [ ] **7.** Com que frequência mede cada uma — todo dia, toda semana?
  - _Resposta:_
- [ ] **8.** Como o senhor mede? Tem aparelho/sonda, kit de teste, ou é no olho mesmo?
  - _Resposta:_
- [ ] **9.** Pra cada medida dessas, o senhor sabe qual é o valor "bom" e a partir de qual valor já é
  problema? _(pergunta mais importante — alimenta os alertas do app)_
  - _Resposta:_

### Sobre o que fazer quando dá ruim
- [ ] **10.** Quando alguma medida sai do normal, o que o senhor faz? (troca água, liga aerador,
  para de dar ração...)
  - _Resposta:_
- [ ] **11.** Já perdeu peixe por causa de algum desses parâmetros? Qual foi?
  - _Resposta:_

### Sobre ração e crescimento
- [ ] **12.** O senhor controla a ração que dá? Anota quanto gasta?
  - _Resposta:_
- [ ] **13.** Costuma pesar os peixes de vez em quando pra ver se estão crescendo?
  - _Resposta:_

### O que o senhor quer VER no app
- [ ] **14.** No fim das contas, o senhor gostaria de ver o quê? Um resumo do dia, um gráfico
  mostrando a evolução, um alerta no celular quando algo está errado, um relatório de custo?
  - _Resposta:_
- [ ] **15.** O senhor falou que testou uns apps que já existem — o que faltou neles? O que te
  incomodou? _(ouro: é onde mora a oportunidade de fazer melhor)_
  - _Resposta:_

### Sobre o uso na prática
- [ ] **16.** Lá nos tanques pega internet no celular, ou é lugar sem sinal?
  - _Resposta:_

### Sobre a propriedade (cadastro e localização)
- [ ] **17.** Além do nome, o que faria sentido guardar da propriedade? (município/UF, endereço ou
  ponto de referência, área total, de onde vem a água — açude/rio/poço/nascente, telefone de contato)
  - _Resposta:_
- [ ] **18.** O senhor lida com alguma documentação da criação — outorga de uso da água, licença
  ambiental, registro de aquicultor (RGP)? Valeria o app guardar isso?
  - _Resposta:_
  - _(contexto: define se a entity Propriedade ganha campos de documentação na Fase 2 —
    ver `NOTAS-TECNICAS.md` §10)_

---

## Observações para o Kayo
- **Pergunta 9** é a mais importante: as faixas ideais ("bom" x "problema") alimentam os alertas.
  Se ele não souber de cabeça, dá pra levantar por pesquisa de domínio (por espécie, com fontes) e
  confirmar depois.
- **Pergunta 15** revela a oportunidade competitiva (o que os concorrentes fazem mal).
- Quando ele responder por áudio, é só salvar o arquivo na pasta e transcrever com
  `transcrever.py` (ver `CONTEXTO.md`).
