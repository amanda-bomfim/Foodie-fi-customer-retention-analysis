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

- 📊 **Para uma leitura visual e amigável:** [RELATÓRIO VISUAL & ANÁLISE DE NEGÓCIOS](./relatorio_analise.md);
- 💻 **Para ver o script puro com todas as queries:** [SCRIPT COMPLETO EM T-SQL](./solucoes_foodie_fi.sql);
- 🌐 **Desafio Oficial:** [8 WEEK SQL CHALLENGE — CASE STUDY #3](https://8weeksqlchallenge.com/case-study-3/).

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
| **4** |
