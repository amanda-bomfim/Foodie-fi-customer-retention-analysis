-- ======================================================================================
-- PROJETO: Foodie-Fi — Análise de Retenção de Clientes e Faturamento
-- AUTORA: Amanda Bomfim
-- SGBD: Microsoft SQL Server (T-SQL)
-- ======================================================================================

USE DWQueue;
GO

-- ======================================================================================
-- SEÇÃO B: PERGUNTAS DE ANÁLISE DE DADOS
-- ======================================================================================

-- --------------------------------------------------------------------------------------
-- 1. Quantos clientes o Foodie-Fi já teve?
-- CONCEITO: COUNT(DISTINCT) elimina duplicatas de clientes com múltiplos eventos.
-- --------------------------------------------------------------------------------------
SELECT 
    COUNT(DISTINCT customer_id) AS total_clientes
FROM [foodie_fi].[subscriptions];


-- --------------------------------------------------------------------------------------
-- 2. Qual é a distribuição mensal dos valores de start_date do plano trial?
-- CONCEITO: Funções de data MONTH() e DATENAME() para agrupar por mês civil.
-- --------------------------------------------------------------------------------------
SELECT 
    MONTH(start_date) AS numero_mes,
    DATENAME(MONTH, start_date) AS nome_mes,
    COUNT(*) AS total_trials
FROM [foodie_fi].[subscriptions]
WHERE plan_id = 0
GROUP BY MONTH(start_date), DATENAME(MONTH, start_date)
ORDER BY numero_mes;


-- --------------------------------------------------------------------------------------
-- 3. Quais valores de start_date de planos ocorrem após o ano de 2020?
-- CONCEITO: Filtro temporal com YEAR() e JOIN para identificar o nome do plano.
-- --------------------------------------------------------------------------------------
SELECT 
    p.plan_name,
    COUNT(*) AS total_eventos
FROM [foodie_fi].[subscriptions] s
JOIN [foodie_fi].[plans] p ON s.plan_id = p.plan_id
WHERE YEAR(s.start_date) > 2020
GROUP BY p.plan_name, p.plan_id
ORDER BY p.plan_id;


-- --------------------------------------------------------------------------------------
-- 4. Qual é a contagem e porcentagem de clientes que cancelaram (churn)?
-- CONCEITO: Subquery escalar no denominador para cálculo proporcional.
-- --------------------------------------------------------------------------------------
SELECT 
    COUNT(DISTINCT customer_id) AS total_churn,
    CAST(ROUND(COUNT(DISTINCT customer_id) * 100.0 / 
        (SELECT COUNT(DISTINCT customer_id) FROM [foodie_fi].[subscriptions]), 1) 
    AS DECIMAL(5,1)) AS porcentagem_churn
FROM [foodie_fi].[subscriptions]
WHERE plan_id = 4;


-- --------------------------------------------------------------------------------------
-- 5. Quantos clientes cancelaram logo após o teste gratuito inicial e qual a porcentagem?
-- CONCEITO: CTE + Window Function LEAD() para inspecionar o próximo evento do cliente.
-- --------------------------------------------------------------------------------------
WITH tabela_com_proximo AS (
    SELECT
        customer_id,
        plan_id,
        LEAD(plan_id) OVER (PARTITION BY customer_id ORDER BY start_date) AS proximo_plano
    FROM [foodie_fi].[subscriptions]
)
SELECT
    COUNT(DISTINCT customer_id) AS cancelaram_pos_trial,
    (SELECT COUNT(DISTINCT customer_id) FROM [foodie_fi].[subscriptions]) AS total_geral,
    CAST(ROUND(COUNT(DISTINCT customer_id) * 100.0 / 
        (SELECT COUNT(DISTINCT customer_id) FROM [foodie_fi].[subscriptions]), 0) 
    AS INT) AS porcentagem
FROM tabela_com_proximo
WHERE plan_id = 0 AND proximo_plano = 4;


-- --------------------------------------------------------------------------------------
-- 6. Qual é o número e a porcentagem de planos para clientes após o teste gratuito?
-- CONCEITO: GROUP BY sobre o resultado do LEAD() para mapear todos os destinos pós-trial.
-- --------------------------------------------------------------------------------------
WITH Proxima_contratacao AS (
    SELECT
        customer_id,
        plan_id,
        LEAD(plan_id) OVER(PARTITION BY customer_id ORDER BY start_date) AS proximo_plano
    FROM [foodie_fi].[subscriptions]
)
SELECT 
    pc.proximo_plano AS plan_id,
    pl.plan_name,
    COUNT(*) AS total_clientes,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(DISTINCT customer_id) FROM [foodie_fi].[subscriptions]), 1) 
    AS DECIMAL(5,1)) AS porcentagem
FROM Proxima_contratacao pc
JOIN [foodie_fi].[plans] pl ON pc.proximo_plano = pl.plan_id
WHERE pc.plan_id = 0
GROUP BY pc.proximo_plano, pl.plan_name
ORDER BY pc.proximo_plano;


-- --------------------------------------------------------------------------------------
-- 7. Contagem de clientes e distribuição percentual em 2020-12-31 (Snapshot)
-- CONCEITO: Snapshot temporal com ROW_NUMBER() ... ORDER BY start_date DESC filtrando ranking = 1.
-- --------------------------------------------------------------------------------------
WITH ultimo_plano_2020 AS (
    SELECT
        sb.customer_id,
        sb.plan_id,
        pl.plan_name,
        sb.start_date,
        ROW_NUMBER() OVER(
            PARTITION BY sb.customer_id 
            ORDER BY sb.start_date DESC
        ) AS Ranking
    FROM [foodie_fi].[subscriptions] sb
    JOIN [foodie_fi].[plans] pl ON sb.plan_id = pl.plan_id
    WHERE sb.start_date <= '2020-12-31'
)
SELECT 
    plan_id,
    plan_name,
    COUNT(*) AS total_clientes,
    CAST(ROUND(COUNT(*) * 100.0 
        / (SELECT COUNT(DISTINCT customer_id) FROM [foodie_fi].[subscriptions] WHERE start_date <= '2020-12-31'), 1) 
    AS DECIMAL(5,1)) AS porcentagem
FROM ultimo_plano_2020
WHERE Ranking = 1
GROUP BY plan_id, plan_name
ORDER BY plan_id;


-- --------------------------------------------------------------------------------------
-- 8. Quantos clientes fizeram upgrade para um plano anual em 2020?
-- CONCEITO: Filtro simples direto na regra de negócio (todo plan_id = 3 é upgrade).
-- --------------------------------------------------------------------------------------
SELECT 
    COUNT(DISTINCT customer_id) AS clientes_upgrade_anual
FROM [foodie_fi].[subscriptions]
WHERE plan_id = 3
  AND YEAR(start_date) = 2020;


-- --------------------------------------------------------------------------------------
-- 9. Média de dias para upgrade para o plano anual a partir da entrada
-- CONCEITO: Duas CTEs unidas por INNER JOIN com cálculo via DATEDIFF e agregação com AVG.
-- --------------------------------------------------------------------------------------
WITH data_trial AS (
    SELECT customer_id, start_date AS data_inicio_trial
    FROM [foodie_fi].[subscriptions]
    WHERE plan_id = 0
),
data_anual AS (
    SELECT customer_id, start_date AS data_inicio_anual
    FROM [foodie_fi].[subscriptions]
    WHERE plan_id = 3
)
SELECT
    CAST(ROUND(AVG(DATEDIFF(day, t.data_inicio_trial, a.data_inicio_anual) * 1.0), 1) 
    AS DECIMAL(5,1)) AS media_dias_para_anual
FROM data_trial t
JOIN data_anual a ON t.customer_id = a.customer_id;


-- --------------------------------------------------------------------------------------
-- 10. Detalhamento da média em períodos de 30 dias (Buckets analíticos)
-- CONCEITO: CASE WHEN para criação de faixas temporais e agrupamento estatístico.
-- --------------------------------------------------------------------------------------
WITH data_trial AS (
    SELECT customer_id, start_date AS data_inicio_trial
    FROM [foodie_fi].[subscriptions]
    WHERE plan_id = 0
),
data_anual AS (
    SELECT customer_id, start_date AS data_inicio_anual
    FROM [foodie_fi].[subscriptions]
    WHERE plan_id = 3
),
dias_para_anual AS (
    SELECT 
        t.customer_id,
        DATEDIFF(day, t.data_inicio_trial, a.data_inicio_anual) AS dias
    FROM data_trial t
    JOIN data_anual a ON t.customer_id = a.customer_id
)
SELECT 
    CASE 
        WHEN dias <= 30  THEN '0 - 30 dias'
        WHEN dias <= 60  THEN '31 - 60 dias'
        WHEN dias <= 90  THEN '61 - 90 dias'
        WHEN dias <= 120 THEN '91 - 120 dias'
        WHEN dias <= 150 THEN '121 - 150 dias'
        WHEN dias <= 180 THEN '151 - 180 dias'
        WHEN dias <= 210 THEN '181 - 210 dias'
        WHEN dias <= 240 THEN '211 - 240 dias'
        WHEN dias <= 270 THEN '241 - 270 dias'
        WHEN dias <= 300 THEN '271 - 300 dias'
        WHEN dias <= 330 THEN '301 - 330 dias'
        WHEN dias <= 360 THEN '331 - 360 dias'
        ELSE '361+ dias'
    END AS faixa_dias,
    COUNT(*) AS total_clientes
FROM dias_para_anual
GROUP BY 
    CASE 
        WHEN dias <= 30  THEN '0 - 30 dias'
        WHEN dias <= 60  THEN '31 - 60 dias'
        WHEN dias <= 90  THEN '61 - 90 dias'
        WHEN dias <= 120 THEN '91 - 120 dias'
        WHEN dias <= 150 THEN '121 - 150 dias'
        WHEN dias <= 180 THEN '151 - 180 dias'
        WHEN dias <= 210 THEN '181 - 210 dias'
        WHEN dias <= 240 THEN '211 - 240 dias'
        WHEN dias <= 270 THEN '241 - 270 dias'
        WHEN dias <= 300 THEN '271 - 300 dias'
        WHEN dias <= 330 THEN '301 - 330 dias'
        WHEN dias <= 360 THEN '331 - 360 dias'
        ELSE '361+ dias'
    END
ORDER BY MIN(dias);


-- --------------------------------------------------------------------------------------
-- 11. Quantos clientes rebaixaram de Pro Monthly para Basic Monthly em 2020?
-- CONCEITO: LEAD() para detectar evento de downgrade direto na linha do tempo.
-- --------------------------------------------------------------------------------------
WITH transicoes_plano AS (
    SELECT
        customer_id,
        plan_id,
        start_date,
        LEAD(plan_id) OVER(PARTITION BY customer_id ORDER BY start_date) AS proximo_plano
    FROM [foodie_fi].[subscriptions]
)
SELECT 
    COUNT(DISTINCT customer_id) AS clientes_downgrade
FROM transicoes_plano
WHERE plan_id = 2             -- Pro Monthly
  AND proximo_plano = 1       -- Basic Monthly (Downgrade)
  AND YEAR(start_date) = 2020;


-- ======================================================================================
-- SEÇÃO C: DESAFIO DE PAGAMENTOS (TABELA DE PAGAMENTOS 2020)
-- CONCEITO: CTE Recursiva para projeção de faturamento mensal e LAG para abatimento.
-- ======================================================================================

WITH periodos_assinatura AS (
    SELECT 
        s.customer_id,
        s.plan_id,
        p.plan_name,
        s.start_date AS data_inicio_plano,
        p.price AS valor_plano,
        LEAD(s.start_date) OVER(
            PARTITION BY s.customer_id 
            ORDER BY s.start_date
        ) AS data_proximo_plano
    FROM [foodie_fi].[subscriptions] s
    JOIN [foodie_fi].[plans] p ON s.plan_id = p.plan_id
    WHERE s.plan_id != 0                 -- Trial gratuito não gera cobrança
      AND s.start_date <= '2020-12-31'
),

recorrencia_pagamentos AS (
    -- Âncora: Primeiro pagamento
    SELECT 
        customer_id,
        plan_id,
        plan_name,
        data_inicio_plano AS payment_date,
        CASE 
            WHEN plan_id = 3 THEN data_inicio_plano 
            WHEN data_proximo_plano IS NULL THEN '2020-12-31'
            ELSE data_proximo_plano 
        END AS data_limite,
        valor_plano AS amount
    FROM periodos_assinatura
    WHERE plan_id != 4                   -- Cancelamento não gera pagamento

    UNION ALL

    -- Parte recursiva: incrementa 1 mês
    SELECT 
        customer_id,
        plan_id,
        plan_name,
        DATEADD(month, 1, payment_date) AS payment_date,
        data_limite,
        amount
    FROM recorrencia_pagamentos
    WHERE DATEADD(month, 1, payment_date) < data_
