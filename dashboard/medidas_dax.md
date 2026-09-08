# Medidas DAX

Crie as medidas abaixo na tabela `fato_vendas`, salvo indicacao diferente. Os nomes das colunas seguem o esquema MySQL do projeto.

```DAX
Receita Total =
SUM ( fato_vendas[valor_total] )

Pedidos =
DISTINCTCOUNT ( fato_vendas[invoice_id] )

Clientes Ativos =
DISTINCTCOUNT ( fato_vendas[customer_id] )

Itens Vendidos =
SUM ( fato_vendas[quantity] )

Ticket Medio por Pedido =
DIVIDE ( [Receita Total], [Pedidos], 0 )

Receita por Cliente =
DIVIDE ( [Receita Total], [Clientes Ativos], 0 )

Receita Media por Item =
DIVIDE ( [Receita Total], [Itens Vendidos], 0 )

Receita Acumulada =
CALCULATE (
    [Receita Total],
    FILTER (
        ALLSELECTED ( fato_vendas[invoice_date] ),
        fato_vendas[invoice_date] <= MAX ( fato_vendas[invoice_date] )
    )
)

Receita por Cliente RFM =
CALCULATE (
    [Receita Total],
    CROSSFILTER (
        dim_clientes_rfm[customer_id],
        fato_vendas[customer_id],
        BOTH
    )
)

Clientes Campeoes =
CALCULATE (
    [Clientes Ativos],
    dim_clientes_rfm[segmento] = "Campeões"
)
```

## Observacoes

- Se o campo `segmento` tiver acentos no banco, ajuste o texto do filtro para o valor exato armazenado.
- Prefira uma tabela calendario para medidas de inteligencia de tempo em producao.
- `Receita por Cliente RFM` e opcional: a relacao unidirecional padrao ja permite que filtros da dimensao RFM filtrem a fato.
- Formate medidas de receita e ticket como moeda, pedidos e clientes como numero inteiro e acumulados como moeda.