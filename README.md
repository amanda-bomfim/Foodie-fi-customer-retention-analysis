<p align="center">
  <img src="https://8weeksqlchallenge.com/images/case-study-designs/3.png" alt="Foodie-Fi Logo" width="400">
</p>

<h1 align="center">
  Foodie-Fi: Análise de Retenção de Clientes, Churn e Faturamento de Assinaturas
</h1>

<p align="center">
  Projeto de análise de dados e engenharia analítica desenvolvido sobre a plataforma fictícia de streaming <b>Foodie-Fi</b> (Case Study #3 do <i>#8WeekSQLChallenge</i>), utilizando <b>Microsoft SQL Server (T-SQL)</b> para investigar métricas de retenção pós-trial, transições de planos, snapshots temporais de carteira e modelagem de pagamentos com CTEs recursivas. 🥑
</p>

<p align="center">
  <img alt="SQL Server" src="https://img.shields.io/badge/Microsoft%20SQL%20Server-CC292B?style=for-the-badge&logo=microsoftsqlserver&logoColor=white">
  <img alt="T-SQL" src="https://img.shields.io/badge/T--SQL-025E8C?style=for-the-badge&logo=database&logoColor=white">
  <img alt="Status" src="https://img.shields.io/badge/Status-Conclu%C3%ADdo-brightgreen?style=for-the-badge">
</p>

---

## 📄 Estrutura do Repositório

- 📊 **Para uma leitura visual e amigável das análises:** [RELATÓRIO VISUAL & ANÁLISE DE NEGÓCIOS](./relatorio_analise.md);
- 💻 **Para inspecionar o script completo com todas as queries:** [SCRIPT COMPLETO EM T-SQL](./solucoes_foodie_fi.sql);
- 🌐 **Desafio Oficial:** [8 WEEK SQL CHALLENGE — CASE STUDY #3](https://8weeksqlchallenge.com/case-study-3/).

---

## 📑 Sumário

- [➕ Contexto do Negócio](#-contexto-do-negócio)
- [🗃️ Modelo de Dados](#️-modelo-de-dados)
- [🚶‍♀️ A. A Jornada do Cliente (Customer Journey)](#️-a-a-jornada-do-cliente-customer-journey)
- [📊 B. Resumo dos Resultados das 11 Perguntas Analíticas](#-b-resumo-dos-resultados-das-11-perguntas-analíticas)
- [💳 C. Desafio de Faturamento (Tabela de Pagamentos 2020)](#-c-desafio-de-faturamento-tabela-de-pagamentos-2020)
- [💼 D. Perguntas Fora da Caixa (Visão de Negócios & Métricas)](#-d-perguntas-fora-da-caixa-visão-de-negócios--métricas)
- [💡 Principais Ferramentas e Conceitos Aprendidos](#-principais-ferramentas-e-conceitos-aprendidos)
- [🛠️ Tecnologias Utilizadas](#️-tecnologias-utilizadas)
- [💻 Como Reproduzir este Projeto](#-como-reproduzir-este-projeto)
- [👩‍💻 Autora & Contatos](#-autora--contatos)

---

## ➕ Contexto do Negócio

O **Foodie-Fi** é uma startup digital lançada em 2020 com modelo de negócio baseado em streaming por assinatura (semelhante a plataformas como Netflix e Spotify), porém 100% focada em **vídeos e receitas culinárias sob demanda**.

### O Modelo de Monetização:
* Todo cliente inicia sua experiência obrigatoriamente através de um **período de teste gratuito de 7 dias** (*trial*);
* Ao término do teste, o cliente é automaticamente convertido para um plano pago, a menos que opte pelo cancelamento (*churn*);
* Os clientes têm total flexibilidade para realizar **upgrades**, **downgrades** ou **cancelar** a qualquer momento.

### O Desafio de Negócios:
A equipe de liderança precisava entender profundamente o comportamento dos seus primeiros 1.000 clientes em 2020 para responder:
1. Qual a taxa de conversão pós-trial (quantos abandonam logo após os 7 dias)?
2. Quais planos têm maior preferência na jornada de transição?
3. Quanto tempo um cliente leva até decidir pelo plano anual?
4. Como se comportou o faturamento mês a mês ao longo de 2020, considerando descontos proporcionais em upgrades?

---

## 🗃️ Modelo de Dados

O banco de dados é estruturado no schema `foodie_fi` com duas tabelas relacionais interligadas pela coluna `plan_id`:

### 1. Tabela `plans`
| PLAN_ID | PLAN_NAME | PREÇO (USD) | DESCRIÇÃO DA REGRA DE NEGÓCIO |
|:---:|:---|:---:|:---|
| **0** | Trial | $0.00 | Teste gratuito de 7 dias com acesso total |
| **1** | Basic Monthly | $9.90 | Streaming básico mensal em definição padrão |
| **2** | Pro Monthly | $19.90 | Streaming premium com alta definição e múltiplos acessos |
| **3** | Pro Annual | $199.00 | Acesso anual (desconto de 12 meses pelo preço de 10) |
| **4** | Churn | *null* | Cancelamento do serviço (acesso mantido até o fim do ciclo) |

### 2. Tabela `subscriptions`
Registra a linha do tempo e transições de cada cliente. Cada linha representa um **evento** de contratação, upgrade ou cancelamento:
* `customer_id`: Chave do cliente (1.000 clientes únicos na base inicial);
* `plan_id`: Código de referência do plano;
* `start_date`: Data em que o plano entrou em vigor.

---

## 🚶‍♀️ A. A Jornada do Cliente (Customer Journey)

Com base em uma amostra de 8 clientes fornecida pelo estudo de caso, foi mapeada a jornada de integração e ciclo de vida:

| Cliente | Histórico de Eventos | Jornada Comportamental |
|:---:|:---|:---|
| **#1** | `Trial (01/08/2020)` ➔ `Basic Monthly (08/08/2020)` | Converteu para plano pago básico imediatamente após os 7 dias de trial. |
| **#2** | `Trial (20/09/2020)` ➔ `Pro Annual (27/09/2020)` | Cliente de alto valor: realizou upgrade direto do trial para o plano anual. |
| **#11** | `Trial (19/11/2020)` ➔ `Churn (26/11/2020)` | Abandonou o serviço no 7º dia exato sem converter para nenhum plano pago. |
| **#13** | `Trial (15/12/2020)` ➔ `Basic Monthly (22/12/2020)` ➔ `Pro Monthly (29/03/2021)` | Converteu no básico e, 3 meses depois, realizou upgrade para o plano profissional. |
| **#15** | `Trial (17/03/2020)` ➔ `Pro Monthly (24/03/2020)` ➔ `Churn (29/04/2020)` | Converteu no plano profissional, mas cancelou após cerca de 1 mês de uso. |
| **#16** | `Trial (31/05/2020)` ➔ `Basic Monthly (07/06/2020)` ➔ `Pro Annual (21/10/2020)` | Começou no básico e, após 4 meses e meio de engajamento, migrou para o anual. |
| **#18** | `Trial (06/07/2020)` ➔ `Pro Monthly (13/07/2020)` | Converteu diretamente do trial para o plano profissional mensal. |
| **#19** | `Trial (22/06/2020)` ➔ `Pro Monthly (29/06/2020)` ➔ `Pro Annual (29/08/2020)` | Trajetória de expansão: Trial ➔ Pro Mensal ➔ Pro Anual em apenas 2 meses. |

---

## 📊 B. Resumo dos Resultados das 11 Perguntas Analíticas

* **1. Volume Total de Clientes:** **1.000 clientes únicos** cadastrados na plataforma.
* **2. Sazonalidade dos Testes:** Março teve o ápice de novas aquisições (**94 trials**), com média estável de 83 novos testes/mês ao longo do ano.
* **3. Eventos em 2021:** Apenas renovações, upgrades e cancelamentos; nenhum novo Trial foi registrado após 2020.
* **4. Taxa Global de Cancelamento:** **30.7% (307 clientes)** cancelaram a assinatura em algum momento do histórico, deixando quase 70% de retenção global.
* **5. Evasão Imediata Pós-Trial:** Apenas **9.0% (92 clientes)** cancelaram logo após os 7 dias grátis. Isso comprova que **91% dos clientes** enxergaram valor no catálogo e converteram para planos pagos.
* **6. Destino Pós-Trial:** Mais da metade dos clientes escolhe a segurança do **Basic Monthly (54.6%)**, seguido pelo **Pro Monthly (32.5%)**, **Churn (9.2%)** e **Pro Annual (3.7%)**.
* **7. Fotografia de Fechamento de Ano (Snapshot em 31/12/2020):**
  * **Pro Monthly:** 32.6% (326 clientes ativos — o plano mais popular da empresa)
  * **Churn:** 23.6% (236 clientes cancelados até o final do ano)
  * **Basic Monthly:** 22.4% (224 clientes ativos)
  * **Pro Annual:** 19.5% (195 clientes ativos — garantindo fluxo de caixa previsível)
  * **Trial:** 1.9% (19 clientes na última semana do ano)
* **8. Upgrades para Plano Anual em 2020:** **195 clientes** migraram para o plano anual durante o ano de 2020.
* **9. Tempo Médio até o Plano Anual:** Em média, os clientes levam **104.6 dias** (~3,5 meses) da data de cadastro até decidirem pela assinatura anual.
* **10. Distribuição dos Upgrades Anuais:** Cerca de **85% de todos os upgrades** acontecem nos primeiros 180 dias (6 meses). Após 210 dias, a probabilidade de migração para o anual diminui drasticamente.
* **11. Downgrades de Pro para Basic em 2020:** **0 clientes**. Nenhum usuário rebaixou de plano em 2020, indicando altíssima satisfação e aderência aos recursos premium.

🔗 *Consulte os resultados visuais completos de cada pergunta com links diretos para as consultas em [RELATÓRIO VISUAL & ANÁLISE DE NEGÓCIOS](./relatorio_analise.md).*

---

## 💳 C. Desafio de Faturamento (Tabela de Pagamentos 2020)

Como a tabela original de assinaturas só guarda o início de cada plano, foi desenvolvida uma **CTE Recursiva** para projetar todas as cobranças recorrentes mês a mês ao longo do ano de 2020.

### Regras de Negócio Modeladas no SQL:
1. **Cobrança Recorrente:** Ocorre no mesmo dia do mês a cada 30 dias até o cancelamento do cliente ou o término do exercício em 31/12/2020;
2. **Corte no Churn:** Se o cliente cancela (`plan_id = 4`), as cobranças subsequentes são interrompidas imediatamente;
3. **Desconto de Upgrade Proporcional:** Se um cliente migra do plano Basic ($9.90) para Pro ou Anual no meio de um ciclo já pago, o valor já pago naquele mês é abatido da nova cobrança usando a função `LAG()`.

🔗 *Consulte o código completo da CTE Recursiva de pagamentos em [solucoes_foodie_fi.sql](./solucoes_foodie_fi.sql#L250-L310).*

---

## 💼 D. Perguntas Fora da Caixa (Visão de Negócios & Métricas)

### 1. Como você calcularia a taxa de crescimento do Foodie-Fi?
* **Crescimento de Base Ativa (MoM):** Variação percentual de clientes ativos de um mês para o outro;
* **Crescimento de Receita Recorrente Mensal (MRR Growth):** Acompanhamento da receita mensal gerada através da tabela de pagamentos.

### 2. Quais métricas-chave você recomendaria para a gestão acompanhar?
* **MRR & ARR:** Previsibilidade financeira mensal e anual;
* **Trial Conversion Rate:** Eficiência do funil inicial de aquisição (~91% no Foodie-Fi);
* **Churn Rate:** Taxa de evasão mensal de clientes pagantes;
* **LTV (Lifetime Value) & CAC:** Relação entre o valor total gerado pelo cliente e o custo para adquiri-lo.

### 3. Quais jornadas dos clientes você analisaria para melhorar a retenção?
* **Onboarding nos 7 dias de Trial:** Analisar o consumo nos primeiros 3 dias. Clientes inativos nas primeiras 72 horas têm altíssimo risco de cancelamento no 7º dia;
* **Transição Basic ➔ Pro:** Mapear quais categorias de receitas culinárias mais incentivam o upgrade;
* **Sinais de Desengajamento:** Identificar quedas bruscas de login 30 dias antes do cancelamento efetivo para agir com campanhas preventivas.

### 4. O que perguntar em uma Pesquisa de Saída (Exit Survey)?
1. *Qual o motivo principal do cancelamento?* (Preço, falta de tempo para cozinhar, catálogo sem interesse, problemas técnicos);
2. *Pergunta de Resgate Imediato:* **"Gostaria de pausar sua assinatura por 30 ou 60 dias sem custos em vez de cancelar definitivamente?"**
3. *Feedback aberto:* "O que nós poderíamos ter feito de diferente para você continuar conosco?"

### 5. Alavancas de Negócio para Reduzir Churn e Validação por Teste A/B:
* **As Alavancas:** Recurso de pausa temporária de assinatura, oferta de downgrade com desconto promocional e e-mails de reengajamento personalizados;
* **Validação por Teste A/B:** Divisão da base em 50% Controle (cancelamento padrão) vs 50% Tratamento (novas alavancas ativas), comparando a taxa de cancelamento após 30 e 60 dias com significância estatística.

---

## 💡 Principais Ferramentas e Conceitos Aprendidos

- **Window Functions:** `LEAD()` (próximo evento), `LAG()` (resgate de valor anterior para abatimento) e `ROW_NUMBER()` (snapshots temporais e desduplicação);
- **CTEs (Common Table Expressions) & CTEs Recursivas:** Modularização de consultas e projeção programática de faturamento;
- **Snapshots Temporais:** Técnicas para capturar o estado estático da carteira de clientes em datas específicas de fechamento contábil;
- **Funções de Data:** `DATEDIFF`, `DATEADD`, `MONTH`, `DATENAME`, `YEAR`;
- **Formatação & Tratamento de Dados:** `CAST`, `ROUND`, `CASE WHEN`, `COUNT(DISTINCT)`.

---

## 🛠️ Tecnologias Utilizadas

- **SGBD:** Microsoft SQL Server
- **IDE:** SQL Server Management Studio (SSMS)
- **Linguagem:** T-SQL (Transact-SQL)
- **Versionamento:** Git & GitHub

---

## 💻 Como Reproduzir este Projeto

1. Instale o **Microsoft SQL Server** e o **SQL Server Management Studio (SSMS)**;
2. Baixe o script oficial de criação do banco e dados no portal do [Case Study #3: Foodie-Fi](https://8weeksqlchallenge.com/case-study-3/);
3. Crie as tabelas `plans` e `subscriptions` em seu banco de dados local (ex: `DWQueue`);
4. Execute o arquivo [`solucoes_foodie_fi.sql`](./solucoes_foodie_fi.sql) para reproduzir todas as análises e consultas deste repositório.

---

## 👩‍💻 Autora & Contatos

Projeto desenvolvido por **Amanda Bomfim**.

<p align="left">
  <a href="www.linkedin.com/in/amandabomfim-data">
    <img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn">
  </a>
  <a href="https://github.com/amanda-bomfim">
    <img src="https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white" alt="GitHub">
  </a>
</p>
