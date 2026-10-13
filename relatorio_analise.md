# 🥑 Relatório Visual & Análise de Negócios — Foodie-Fi

Este documento apresenta a análise de dados e os resultados de negócios obtidos no estudo da plataforma **Foodie-Fi**. 

Para tornar a experiência fluida, cada questão conta com o contexto do problema, a tabela com os resultados reais encontrados e um **link direto que leva à linha exata do código SQL correspondente**.

---

## 📊 As 11 Perguntas Analíticas

---

### 1. Quantos clientes o Foodie-Fi já teve no total?
> 💡 **O Desafio:** Garantir que cada cliente seja contabilizado apenas uma única vez, eliminando duplicatas de trocas de planos.

| Métrica | Total Encontrado |
| :--- | :---: |
| **Total de Clientes Únicos** | **1.000 clientes** |

🔗 **[👉 Ver consulta SQL desta pergunta no script](./solucoes_foodie_fi.sql#L14-L21)**

*📌 **Insight:** A base analisada conta com uma amostra perfeita de 1.000 clientes cadastrados.*

---

### 2. Como os testes gratuitos (trials) se distribuem ao longo dos meses do ano?
> 💡 **O Desafio:** Identificar a sazonalidade e quais meses do ano atraíram mais cadastros.

| Mês | Nome do Mês | Novos Testes (Trials) |
| :---: | :--- | :---: |
| 1 | Janeiro | 88 |
| 2 | Fevereiro | 68 |
| 3 | **Março (Pico 🚀)** | **94** |
| 4 | Abril | 81 |
| 5 | Maio | 88 |
| 6 | Junho | 79 |
| 7 | Julho | 89 |
| 8 | Agosto | 88 |
| 9 | Setembro | 87 |
| 10 | Outubro | 79 |
| 11 | Novembro | 75 |
| 12 | Dezembro | 84 |

🔗 **[👉 Ver consulta SQL desta pergunta no script](./solucoes_foodie_fi.sql#L23-L35)**

*📌 **Insight:** Março teve o ápice de novas aquisições (94 clientes), mantendo uma média estável de 83 novos testes por mês.*

---

### 3. Quais planos tiveram eventos iniciados após o ano de 2020?
> 💡 **O Desafio:** Investigar o comportamento da base a partir do ano de 2021.

| Código | Plano | Eventos em 2021 |
| :---: | :--- | :---: |
| 1 | Basic Monthly | 8 |
| 2 | Pro Monthly | 60 |
| 3 | Pro Annual | 63 |
| 4 | Churn (Cancelamento) | 71 |

🔗 **[👉 Ver consulta SQL desta pergunta no script](./solucoes_foodie_fi.sql#L37-L49)**

*📌 **Insight:** Nenhum novo trial foi registrado em 2021; todos os eventos são de clientes antigos mudando para planos profissionais, anuais ou cancelando.*

---

### 4. Quantos clientes cancelaram no total e qual a porcentagem da base?
> 💡 **O Desafio:** Medir a taxa global de evasão (churn) de todo o histórico.

| Métrica | Total de Clientes | Percentual da Base |
| :--- | :---: | :---: |
| **Total de Cancelamentos (Churn)** | 307 | **30.7%** |
| **Clientes Ativos** | 693 | **69.3%** |

🔗 **[👉 Ver consulta SQL desta pergunta no script](./solucoes_foodie_fi.sql#L51-L62)**

*📌 **Insight:** A taxa de retenção global é saudável (quase 70%), com cerca de 3 em cada 10 clientes cancelando ao longo da vida útil.*

---

### 5. Quantos clientes cancelaram logo após o teste gratuito de 7 dias?
> 💡 **O Desafio:** Identificar se o trial gratuito estava gerando abandono imediato sem conversão para planos pagos.

| Métrica | Resultado |
| :--- | :---: |
| **Cancelamentos Imediatos pós-trial** | **92 clientes** |
| **Total da Base** | 1.000 clientes |
| **Taxa de Evasão Imediata** | **9.0%** |

🔗 **[👉 Ver consulta SQL desta pergunta no script](./solucoes_foodie_fi.sql#L64-L83)**

*📌 **Insight:** Uma taxa de apenas 9% de churn imediato é excelente: **91% dos clientes** enxergaram valor no conteúdo e contrataram um plano pago após o teste.*

---

### 6. Para onde vão os clientes logo após o teste gratuito?
> 💡 **O Desafio:** Mapear a primeira escolha paga de cada cliente após os 7 dias grátis.

| ID | Plano Escolhido | Quantidade de Clientes | Participação |
| :---: | :--- | :---: | :---: |
| 1 | **Basic Monthly** | **546** | **54.6%** |
| 2 | **Pro Monthly** | **325** | **32.5%** |
| 4 | **Churn (Cancelou)** | **92** | **9.2%** |
| 3 | **Pro Annual** | **37** | **3.7%** |

🔗 **[👉 Ver consulta SQL desta pergunta no script](./solucoes_foodie_fi.sql#L85-L107)**

*📌 **Insight:** Mais da metade dos clientes opta pela segurança do plano básico mensal (54.6%) como porta de entrada.*

---

### 7. Como estava a base exatamente em 31/12/2020? (Snapshot de Fim de Ano)
> 💡 **O Desafio:** Congelar o tempo no último dia de 2020 para ver a alocação de cada um dos 1.000 clientes.

| ID | Plano em 31/12/2020 | Clientes Ativos | Participação |
| :---: | :--- | :---: | :---: |
| 0 | Trial (Última semana de 2020) | 19 | 1.9% |
| 1 | Basic Monthly | 224 | 22.4% |
| 2 | **Pro Monthly (O Mais Popular)** | **326** | **32.6%** |
| 3 | Pro Annual (Fluxo Garantido) | 195 | 19.5% |
| 4 | Churn (Cancelados até a data) | 236 | 23.6% |

🔗 **[👉 Ver consulta SQL desta pergunta no script](./solucoes_foodie_fi.sql#L109-L138)**

*📌 **Insight:** O plano Pro Monthly fechou o ano como o preferido da base (32.6%). Quase 20% já estavam no plano anual.*

---

### 8. Quantos clientes fizeram upgrade para o plano anual em 2020?
> 💡 **O Desafio:** Descobrir quantos clientes contrataram o plano anual de 1 ano durante 2020.

| Métrica | Resultado |
| :--- | :---: |
| **Upgrades para Plano Anual em 2020** | **195 clientes** |

🔗 **[👉 Ver consulta SQL desta pergunta no script](./solucoes_foodie_fi.sql#L140-L149)**

*📌 **Insight:** Como todo mundo começa no trial, qualquer registro do plano anual em 2020 já representa um upgrade direto de sucesso.*

---

### 9. Quanto tempo, em média, leva para um cliente migrar para o plano anual?
> 💡 **O Desafio:** Medir o ciclo de maturação do cliente até a decisão pelo plano anual.

| Métrica | Média Encontrada |
| :--- | :---: |
| **Tempo médio até o Plano Anual** | **104.6 dias** (~3,5 meses) |

🔗 **[👉 Ver consulta SQL desta pergunta no script](./solucoes_foodie_fi.sql#L151-L170)**

*📌 **Insight:** O cliente precisa de cerca de 3 meses e meio consumindo receitas na plataforma para tomar a decisão pelo plano de longo prazo.*

---

### 10. Detalhamento desses upgrades em faixas de 30 dias
> 💡 **O Desafio:** Analisar quando acontecem os picos de migração para o anual ao longo do tempo.

| Período | Clientes que Viraram Anual |
| :--- | :---: |
| **0 a 30 dias** | **49** |
| **31 a 60 dias** | 24 |
| **61 a 90 dias** | 34 |
| **91 a 120 dias** | 35 |
| **121 a 150 dias** | 42 |
| **151 a 180 dias** | 36 |
| **181 a 210 dias** | 26 |
| **211 a 240 dias** | 4 |
| **241 a 270 dias** | 5 |
| **271 a 300 dias** | 1 |
| **331 a 360 dias** | 1 |
| **361+ dias** | 1 |

🔗 **[👉 Ver consulta SQL desta pergunta no script](./solucoes_foodie_fi.sql#L172-L228)**

*📌 **Insight:** A imensa maioria dos upgrades ocorre até os primeiros 180 dias (6 meses). Após esse período, a taxa cai drasticamente.*

---

### 11. Quantos clientes rebaixaram de Pro Monthly para Basic Monthly em 2020?
> 💡 **O Desafio:** Avaliar a insatisfação de clientes do plano profissional.

| Métrica | Resultado |
| :--- | :---: |
| **Downgrades de Pro para Basic em 2020** | **0 clientes** |

🔗 **[👉 Ver consulta SQL desta pergunta no script](./solucoes_foodie_fi.sql#L230-L248)**

*📌 **Insight:** Ninguém fez downgrade! Uma vez no plano Pro, o cliente permanece nele ou migra para o anual.*

---

## 💳 Desafio de Faturamento: Tabela de Pagamentos 2020

Projeção de cobranças mês a mês aplicando regras de negócio reais (renovação na mesma data, parada no cancelamento e desconto proporcional em upgrades).

🔗 **[👉 Ver código completo da CTE Recursiva de Pagamentos](./solucoes_foodie_fi.sql#L250-L310)**

---

<p align="center">
  Desenvolvido com carinho por <b>Amanda Bomfim</b> 💜
</p>
