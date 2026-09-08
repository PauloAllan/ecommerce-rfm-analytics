# Dashboard Power BI

## Objetivo

Apresentar uma visao executiva do faturamento, pedidos, clientes e comportamento RFM do e-commerce. O arquivo `ecommerce-rfm-dashboard.pbix` foi construido sobre o modelo estrela criado no MySQL.

## Conexao com o MySQL

1. Instale o MySQL Connector/NET compativel com a versao do Power BI Desktop.
2. No Power BI, selecione **Obter dados > MySQL database**.
3. Informe o servidor e o banco `db_ecommerce` configurados no script `script/Script_db_ecommerce.sql`.
4. Use o modo **Importar** para uma primeira carga ou **DirectQuery** quando a atualizacao em tempo real for necessaria.
5. Carregue `fato_vendas` e `dim_clientes_rfm`. As views `vw_rfm_executivo`, `vw_analise_clientes` e `vw_vendas_temporais` sao alternativas para paginas ou visuais agregados.

Nao versionar credenciais, senhas, tokens ou arquivos de configuracao local. No Power BI Service, configure as credenciais da fonte e o gateway na publicacao.

## Modelo semantico

Relacao principal, com filtro em uma unica direcao:

```text
dim_clientes_rfm[customer_id] (1) -> fato_vendas[customer_id] (*)
```

Use `fato_vendas[invoice_date]` como data da venda. Para analises temporais mais completas, crie uma tabela calendario e relacione `Calendario[Data]` com `fato_vendas[invoice_date]`.

## Indicadores sugeridos

- Receita total e ticket medio por pedido.
- Pedidos, clientes ativos e itens vendidos.
- Receita e quantidade de clientes por segmento RFM.
- Evolucao mensal da receita.
- Ranking de paises e clientes por faturamento.

As medidas DAX utilizadas como base estao em `medidas_dax.md`.

## Atualizacao

1. Execute o script SQL e confirme as contagens das tabelas.
2. Atualize as credenciais da fonte no Power BI.
3. Selecione **Atualizar** e valide receita, pedidos e clientes contra as consultas de auditoria do SQL.
4. Publique no workspace e configure o agendamento no Power BI Service.