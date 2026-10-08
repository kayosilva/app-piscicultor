# Faixas ideais da água — tilápia

> Levantamento de referência (pesquisa em 2026-10-07) para alimentar os **alertas** do app
> (pergunta 9 de `PERGUNTAS-ANANIAS.md`). Como o Sr. Ananias não registra nada hoje, estes valores
> entram como **padrão do app, editável pelo produtor**, sem depender de validação dele.
>
> Os três níveis viram o semáforo do app: **verde = ideal**, **amarelo = atenção**,
> **vermelho = crítico**. Os limites foram tirados das fontes abaixo. Onde as fontes não definem
> um corte exato entre dois níveis, o valor é **proposta nossa** e está marcado com `*`.

## Tabela proposta (tilápia, viveiro/tanque convencional)

| Parâmetro (sigla na planilha) | Unidade | 🟢 Ideal | 🟡 Atenção | 🔴 Crítico | Fontes |
| --- | --- | --- | --- | --- | --- |
| Temperatura da água (`T_Agua`) | °C | 25 – 32 | 18 – 25 · 32 – 35\* | < 18 · > 35\* | [1] [2] [4] |
| Oxigênio dissolvido (`OD`) | mg/L | 5 – 12 | 3 – 5 · 12 – 15 | < 3 · > 15 | [2] [3] |
| pH (`PH`) | — | 6,5 – 8,5 | 6,0 – 6,5 · 8,5 – 9,0 | < 6,0 · > 9,0 | [2] [3] |
| Alcalinidade (`KH`) | mg/L CaCO₃ | 60 – 150 | 20 – 60 · > 150\* | < 20 | [1] [2] [3] |
| Dureza (`GH`) | mg/L CaCO₃ | 60 – 150 | 20 – 60 · > 150\* | < 20 | [2] [3] |
| Amônia **total** (`NH3` no kit) | mg/L | < 0,5 | 0,5 – 2,0 | > 2,0 | [3] |
| Amônia **tóxica** NH₃ (calculada) | mg/L | < 0,05 | 0,05 – 0,5 | > 0,5 | [2] [5] |
| Nitrito (`NO2`) | mg/L | < 0,3 | 0,3 – 0,7 | > 0,7 | [2] [3] |
| Nitrato (`NO3`) | mg/L N-NO₃ | ≤ 25 | 25 – 100 | > 100 | [5] |
| Transparência (`Turbi`) | cm (Secchi) | 30 – 50 | 20 – 30 · > 50 | < 20 | [2] [3] |
| Sólidos sedimentáveis (`Soli`) | mL/L (cone Imhoff) | 5 – 50 *(só bioflocos)* | < 5 · > 50\* | — | [6] |

### Frequência e horário sugeridos
- **OD:** 2 vezes por dia, às **7h** (mínimo do dia, de madrugada/amanhecer) e às **18h** [2].
  Queiroz recomenda pelo menos 5 mg/L no fim da tarde [3].
- **pH:** fim da tarde e primeiras horas da manhã. Diferença maior que 2 unidades indica água
  com pouca alcalinidade (pouco "tampão") [2].
- **Temperatura e transparência:** diárias, de preferência no mesmo horário [3]. Secchi é mais
  preciso ao meio-dia [2].
- **Amônia e nitrito:** semanal\* (as fontes lidas não fixam frequência; mais vezes se a
  ração aumentar, o OD cair ou a transparência ficar abaixo de 30 cm).
- **Alcalinidade e dureza:** mensal [2].

## Observações que mudam o app

1. **Amônia: o kit mede a total, o que mata é a tóxica (NH₃).** A fração tóxica depende do pH e
   da temperatura. A 28 °C, 0,05 mg/L de NH₃ corresponde a ~7 mg/L de amônia total com pH 7, mas
   só a ~0,76 mg/L com pH 8 [5]. Proposta: o produtor digita a **amônia total** e o app **calcula
   a NH₃** com o pH e a temperatura da mesma leitura (fórmula de Emerson et al., 1975):
   `fração NH₃ = 1 / (10^(pKa − pH) + 1)`, com `pKa = 0,09018 + 2729,92 / (T °C + 273,15)`.
   É um exemplo concreto da "inteligência do sistema" que ele pediu no áudio.
2. **A tilápia é mais tolerante que a média.** Os limites acima são os conservadores da
   literatura brasileira para piscicultura. A literatura específica mostra que a tilápia
   sobrevive a OD perto de 1 mg/L, pH de 5 a 10 e nitrito bem mais alto, principalmente com
   cloreto na água (sal) [4]. Para alerta, é melhor pecar pelo excesso de cuidado, mas os limites
   precisam ser **editáveis** no app.
3. **Nitrito e cloreto.** A toxicidade do nitrito cai muito com cloreto na água. Recomenda-se
   relação cloreto:nitrito de 6–10:1 [5], e criações intensivas mantêm 100–150 mg/L de cloreto
   [4]. Se ele usa sal no manejo, pode valer registrar.
4. **Unidades dos kits.** Nitrito e nitrato podem vir como íon (mg/L NO₂⁻, NO₃⁻) ou como
   nitrogênio (mg/L N-NO₂, N-NO₃). Para nitrato, 1 mg/L N-NO₃ ≈ 4,43 mg/L NO₃⁻. O cadastro do
   parâmetro precisa guardar a unidade usada no kit dele.
5. **Bioflocos?** Tanque suspenso de geomembrana, medição de sólidos (mL), KH 120 e compra de
   bicarbonato, probiótico e biorremediador sugerem um sistema de **bioflocos** (BFT). Se for o
   caso, as faixas mudam:
   - **sólidos sedimentáveis** passam a ser controlados (5–50 mL/L para tilápia [6]);
   - **alcalinidade** é mantida mais alta (num experimento da Embrapa com tilápia em bioflocos
     ficou em ~250 mg/L CaCO₃ [6]);
   - **transparência (Secchi)** perde o sentido, porque a água fica turva de propósito.
   Isso é pergunta para ele (29, na Mensagem 2 de `PERGUNTAS-ANANIAS.md`). A foto do kit (mesma
   mensagem) resolve a dúvida da unidade de nitrito/nitrato.

## Fontes

1. IMBIRIBA, E. P.; LOURENÇO JÚNIOR, J. B.; CARVALHO, L. O. D. M. **Parâmetros ambientais e
   qualidade da água na piscicultura.** Belém: Embrapa Amazônia Oriental, 2000 (folder).
   <https://www.infoteca.cnptia.embrapa.br/infoteca/bitstream/doc/377896/1/ParametrosAmbientaisQualidadeAgua.pdf>
2. CORRÊA, R. O. **Qualidade da água na piscicultura continental.** Brasília: Embrapa
   (Amazônia Oriental), 2018. 32 p. ISBN 978-85-7035-849-3. Tabelas adaptadas de Boyd (1998),
   Sá (2012) e Kubitza (2003).
   <https://www.infoteca.cnptia.embrapa.br/infoteca/bitstream/doc/1100689/1/TC3217CARTILHAQualidadeAguaV05.pdf>
3. QUEIROZ, J. F. et al. **Recomendações práticas para avaliação da qualidade da água na
   produção de tilápia em tanques-rede.** Jaguariúna: Embrapa Meio Ambiente, 2021. (Circular
   Técnica, 31). Tabela 2 adaptada de Boyd e Tucker (1998).
   <https://www.infoteca.cnptia.embrapa.br/infoteca/bitstream/doc/1131162/1/Queiroz-Recomendacoes-praticas-2021.pdf>
4. POPMA, T.; MASSER, M. **Tilapia: life history and biology.** SRAC Publication 283.
   Southern Regional Aquaculture Center (resumo em The Fish Site).
   <https://thefishsite.com/articles/tilapia-life-history-and-biology>
5. KUBITZA, F. **Water quality impacts on health and performance of fish and shrimp, part 3:
   the nitrogenous compounds ammonia, nitrite and nitrate.** Global Seafood Alliance, 2026.
   <https://www.globalseafood.org/advocate/water-quality-impacts-on-health-and-performance-of-fish-and-shrimp-part-3-the-nitrogenous-compounds-ammonia-nitrite-and-nitrate/>
6. SANTOS, L. F. et al. **Qualidade de água na produção de alevinos de tilápia do Nilo
   alimentados com diferentes níveis de proteína em sistema bioflocos.** CIIC 2016 (Embrapa).
   Cita Avnimelech (2011) para a faixa de 5–50 mL/L de sólidos sedimentáveis.
   <https://www.alice.cnptia.embrapa.br/alice/bitstream/doc/1063050/1/2016AA16.pdf>
