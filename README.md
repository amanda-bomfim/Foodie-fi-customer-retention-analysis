<h1 align="center">
  Análise de Retenção de Clientes e Faturamento — Foodie-Fi
</h1>

<p align="center">
  Este projeto foi desenvolvido com o objetivo de analisar o ciclo de vida, comportamento de conversão e retenção de assinantes da plataforma de streaming Foodie-Fi, além de modelar as cobranças e a receita financeira da empresa ao longo de 2020 utilizando <b>Microsoft SQL Server (T-SQL)</b>. 🥑
</p>

<p align="center">
  <img alt="SQL Server" src="https://img.shields.io/badge/Microsoft%20SQL%20Server-CC292B?style=for-the-badge&logo=microsoftsqlserver&logoColor=white">
  <img alt="T-SQL" src="https://img.shields.io/badge/T--SQL-025E8C?style=for-the-badge&logo=database&logoColor=white">
  <img alt="Status" src="https://img.shields.io/badge/Status-Conclu%C3%ADdo-brightgreen?style=for-the-badge">
</p>

---

## 📄 Estrutura do repositório

- Veja o script com todas as consultas resolvidas: [SOLUÇÕES EM SQL (T-SQL)](./solucoes_foodie_fi.sql);
- Conheça o case original: [8 WEEK SQL CHALLENGE — CASE 3](https://8weeksqlchallenge.com/case-study-3/).

---

## ➕ Contexto

O **Foodie-Fi** é uma startup digital criada em 2020 com o modelo de streaming por assinatura (semelhante a plataformas como Netflix e Spotify), voltada exclusivamente para vídeos e receitas culinárias sob demanda. 

Em modelos de assinatura digital (*SaaS / Streaming*), o maior desafio do negócio é a **conversão e retenção**: atrair clientes por meio de um período de teste gratuito (*trial*) e garantir que eles vejam valor suficiente para continuar pagando mensalmente ou anualmente, minimizando a taxa de cancelamento (*churn*).

A liderança da Foodie-Fi precisava entender profundamente como os seus primeiros 1.000 clientes se comportaram em 2020:
- Quantos clientes realmente convertem para planos pagos após os 7 dias gratuitos?
- Quais planos têm maior preferência na jornada de transição?
- Quanto tempo um cliente leva até decidir pelo plano anual?
- Como se comportou o faturamento mês a mês, considerando upgrades com descontos proporcionais?

---

## ⚠️ Informações gerais

O conjunto de dados da empresa é composto pelas tabelas `plans` e `subscriptions`. 

### Planos Disponíveis no Foodie-Fi:
| PLAN_ID | PLAN_NAME | PREÇO (USD) | DESCRIÇÃO |
|:---:|:---|:---:|:---|
| **0** | Trial | $0.00 | Teste gratuito de 7 dias com acesso total |
| **1** | Basic Monthly | $9.90 | Streaming básico mensal em definição padrão |
| **2** | Pro Monthly | $19.90 | Streaming premium com alta definição e múltiplos acessos |
| **3** | Pro Annual | $199.00 | Acesso anual (desconto de 12 meses pelo preço de 10) |
| **4** | Churn | *null* | Cancelamento do serviço |

### Regras de Negócio e Critérios da Análise:
* **Entrada Universal:** 100% dos clientes obrigatoriamente iniciam pelo período de teste de 7 dias (*trial*);
* **Corte de Cancelamento:** Quando o cliente cancela (`churn`), ele não gera novas cobranças após a data de corte;
* **Upgrades Proporcionais:** Clientes que sobem de plano no meio do ciclo recebem desconto do valor pago no mês corrente;
* **Período de Análise Financeira:** O estudo financeiro e as projeções cobrem todo o exercício do ano de 2020 (até 31/12/2020).

---

## 🔍 Principais Descobertas & Métricas de Negócio

* **Conversão do Trial:** **91% dos clientes** convertem para algum plano pago após os 7 dias de teste gratuito. Apenas **9% (92 clientes)** abandonam a plataforma logo após o teste.
* **Plano Campeão:** O plano mais escolhido imediatamente após o teste é o **Basic Monthly (54.6%)**, seguido pelo **Pro Monthly (32.5%)**.
* **Tempo até o Plano Anual:** Em média, os clientes levam **104.6 dias** (~3,5 meses) desde a entrada na plataforma até realizarem o upgrade para o plano anual.
* **Satisfação do Plano Pro:** **0 clientes** realizaram downgrade de *Pro Monthly* para *Basic Monthly* em 2020, indicando alto valor percebido e aderência aos recursos avançados.
* **Fotografia de Fechamento de 2020 (Snapshot em 31/12/2020):**
  * Pro Monthly: 32.6% (326 clientes)
  * Churn: 23.6% (236 clientes)
  * Basic Monthly: 22.4% (224 clientes)
  * Pro Annual: 19.5% (195 clientes)
  * Trial: 1.9% (19 clientes na última semana do ano)

---

## 🚀 Tecnologias

* **SGBD:** Microsoft SQL Server
* **Linguagem:** T-SQL (Transact-SQL)
* **Ferramenta de Desenvolvimento:** SQL Server Management Studio (SSMS)
* **Técnicas Avançadas de SQL Utilizadas:**
  * **Window Functions:** `LEAD()` (próximo plano), `LAG()` (abatimento de upgrade) e `ROW_NUMBER()` (snapshots temporais e desduplicação);
  * **CTEs & CTE Recursiva:** Projeção mensal de séries temporais de pagamentos;
  * **Manipulação de Datas:** `DATEDIFF`, `DATEADD`, `MONTH`, `DATENAME`, `YEAR`;
  * **Agregação e Tipagem:** `CAST`, `ROUND`, `CASE WHEN`, `COUNT(DISTINCT)`.

---

<p align="center">
  Feito com 💜 por <b>Amanda Bomfim</b> 👋
</p>
<p align="center">
  <a href="www.linkedin.com/in/amandabomfim-data">
    <img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn">
  </a>
  <a href="https://github.com/amanda-bomfim">
    <img src="https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white" alt="GitHub">
  </a>
</p>
