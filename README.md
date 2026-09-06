# E-Commerce RFM Analytics 📊

Solução analítica de inteligência de negócios desenvolvida para transformar dados brutos de transações de e-commerce em insights estratégicos para times de marketing e retenção.

---

## 📌 Status do Projeto

- [x] **Etapa 1:** Extração, Limpeza de Dados e Cálculo da Matriz RFM em Python
- [ ] **Etapa 2:** Modelagem de Banco de Dados Relacional (MySQL - Star Schema)
- [ ] **Etapa 3:** Desenvolvimento do Dashboard Executivo Interativo (Power BI)

---

## 🎯 Objetivo de Negócio

Mapear o desempenho de vendas da empresa e categorizar os clientes com base no seu comportamento de compra (**Recência**, **Frequência** e **Valor Monetário**). A partir dessa segmentação, a empresa pode direcionar estratégias como:
* Campanhas de reativação para clientes em risco de *churn*.
* Ações de fidelização e recompensas exclusivas para os clientes *Campeões*.
* Estratégias de incentivo à segunda compra para *Novos Clientes*.

---

## 🛠️ Tecnologias Utilizadas

* **Python 3.13** (Pandas, OpenPyXL, NumPy)
* **Jupyter Notebook** (VS Code)
* **Git & GitHub** (Controle de versão)
* **MySQL / DBeaver** *(Próxima etapa)*
* **Power BI** *(Próxima etapa)*

---

## 📸 Etapa 1: Processamento e Limpeza dos Dados (Concluída)

Nesta primeira fase, tratamos uma base transacional contendo mais de **1 milhão de registros brutos**:

1. **Sanitização de Dados:** Remoção de registros sem ID de cliente, tratamento de valores nulos e filtragem de transações de devolução/cancelamento.
2. **Engenharia de Recursos:** Criação da métrica `ValorTotal` (`Quantity * Price`).
3. **Cálculo da Matriz RFM:** Agrupamento por cliente para calcular os pilares R, F e M.
4. **Segmentação por Quintis:** Divisão estatística (`pd.qcut`) em notas de 1 a 5 e categorização dos perfis de clientes (ex: *Campeões*, *Hibernando*, *Leais*).
5. **Exportação:** Geração das tabelas limpas `fato_vendas.csv` e `dim_clientes_rfm.csv`.

### Registro da Execução (VS Code)

![Execução da Limpeza de Dados em Python](./assets/notebookCode.jpeg)
> *Configuração do ambiente virtual (.venv), instalação das bibliotecas necessárias (Pandas, OpenPyXL) e primeiros testes de leitura e visualização da estrutura dos dados.*

---

## 📂 Estrutura do Repositório

```text
ecommerce-rfm-analytics/
├── .venv/                      # Ambiente virtual Python
├── dados/                      # Arquivos CSV brutos e processados
│   ├── online_retail_II.csv
│   ├── fato_vendas.csv
│   └── dim_clientes_rfm.csv
├── 01_limpeza_e_rfm.ipynb      # Notebook com código de ETL e segmentação
└── README.md                   # Documentação do projeto
```