-- 1. Criar o banco de dados para o projeto
CREATE DATABASE IF NOT EXISTS db_ecommerce;
USE db_ecommerce;

CREATE TABLE IF NOT EXISTS dim_clientes_rfm (
    customer_id INT PRIMARY KEY,
    recencia INT,
    frequencia INT,
    monetario DECIMAL(12, 2),
    r_score INT,
    f_score INT,
    m_score INT,
    rf_score VARCHAR(5),
    segmento VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS fato_vendas (
    invoice_id VARCHAR(20),
    stock_code VARCHAR(20),
    description VARCHAR(255),
    quantity INT,
    invoice_date DATETIME,
    price DECIMAL(10, 2),
    customer_id INT,
    country VARCHAR(50),
    valor_total DECIMAL(12, 2),
    FOREIGN KEY (customer_id) REFERENCES dim_clientes_rfm(customer_id)
);

SELECT COUNT(*) FROM dim_clientes_rfm;
SELECT COUNT(*) FROM fato_vendas;

-- Verificar quantidade de registros importados
SELECT COUNT(*) AS total_clientes FROM dim_clientes_rfm;
SELECT COUNT(*) AS total_transacoes FROM fato_vendas;


-- Testar o relacionamento Star Schema entre Fato e Dimensão
SELECT 
    c.segmento,
    COUNT(DISTINCT v.invoice_id) AS total_pedidos,
    SUM(v.valor_total) AS faturamento_total
FROM fato_vendas v
INNER JOIN dim_clientes_rfm c ON v.customer_id = c.customer_id
GROUP BY c.segmento
ORDER BY faturamento_total DESC;

-----------

SELECT 
    c.segmento,
    COUNT(DISTINCT c.customer_id) AS qtd_clientes,
    COUNT(DISTINCT v.invoice_id) AS total_pedidos,
    ROUND(SUM(v.valor_total), 2) AS faturamento_total,
    ROUND(AVG(v.valor_total), 2) AS ticket_medio_item
FROM fato_vendas v
INNER JOIN dim_clientes_rfm c ON v.customer_id = c.customer_id
GROUP BY c.segmento
ORDER BY faturamento_total DESC;

SELECT * FROM dim_clientes_rfm limit 100;
SELECT * FROM fato_vendas limit 10;

-- Consolida o comportamento financeiro e o volume de compras por categoria de cliente

CREATE OR REPLACE VIEW vw_rfm_executivo AS
SELECT 
    c.segmento,
    COUNT(DISTINCT c.customer_id) AS total_clientes,
    COUNT(DISTINCT v.invoice_id) AS total_pedidos,
    ROUND(SUM(v.valor_total), 2) AS receita_total,
    ROUND(AVG(v.valor_total), 2) AS ticket_medio_item
FROM fato_vendas v
INNER JOIN dim_clientes_rfm c ON v.customer_id = c.customer_id
GROUP BY c.segmento;

-- base granular de cada cliente com suas notas RFM e total gasto, ideal para criar tabelas de perfil e filtros no Power BI.

CREATE OR REPLACE VIEW vw_analise_clientes AS
SELECT 
    c.customer_id,
    c.segmento,
    c.recencia AS dias_sem_comprar,
    c.frequencia AS total_compras,
    c.monetario AS valor_historico,
    c.rf_score,
    COUNT(DISTINCT v.invoice_id) AS transacoes_no_periodo,
    ROUND(SUM(v.valor_total), 2) AS faturamento_periodo
FROM dim_clientes_rfm c
LEFT JOIN fato_vendas v ON c.customer_id = v.customer_id
GROUP BY 
    c.customer_id, 
    c.segmento, 
    c.recencia, 
    c.frequencia, 
    c.monetario, 
    c.rf_score;

-- Estrutura as vendas por data e país, permitindo criar gráficos de linha (tendência) e mapas

CREATE OR REPLACE VIEW vw_vendas_temporais AS
SELECT 
    DATE(v.invoice_date) AS data_venda,
    YEAR(v.invoice_date) AS ano,
    MONTH(v.invoice_date) AS mes,
    v.country AS pais,
    c.segmento,
    COUNT(DISTINCT v.invoice_id) AS qtd_pedidos,
    SUM(v.quantity) AS qtd_itens_vendidos,
    ROUND(SUM(v.valor_total), 2) AS receita
FROM fato_vendas v
INNER JOIN dim_clientes_rfm c ON v.customer_id = c.customer_id
GROUP BY 
    DATE(v.invoice_date), 
    YEAR(v.invoice_date), 
    MONTH(v.invoice_date), 
    v.country, 
    c.segmento;






