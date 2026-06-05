
-- CRIAÇÃO DE ÍNDICES (CREATE INDEX)


USE SistemaEncomendas;
GO

-- Índice para pesquisa rápida por nome do cliente
CREATE INDEX IDX_Clientes_Nome
ON Clientes(Nome);
GO

-- Índice para pesquisa rápida por cidade
CREATE INDEX IDX_Clientes_Cidade
ON Clientes(Cidade);
GO

-- Índice para acelerar buscas de encomendas por cliente
CREATE INDEX IDX_Encomendas_ClienteID
ON Encomendas(ClienteID);
GO

-- Índice para acelerar pesquisas por estado da encomenda
CREATE INDEX IDX_Encomendas_Estado
ON Encomendas(Estado);
GO

-- Índice para pesquisa rápida de produtos pelo nome
CREATE INDEX IDX_Produtos_NomeProduto
ON Produtos(NomeProduto);
GO

-- Índice para melhorar consultas na tabela detalhes
CREATE INDEX IDX_DetalhesEncomenda_EncomendaID
ON DetalhesEncomenda(EncomendaID);
GO

-- Índice para melhorar consultas por produto
CREATE INDEX IDX_DetalhesEncomenda_ProdutoID
ON DetalhesEncomenda(ProdutoID);
GO


-- EXEMPLOS DE CONSULTAS QUE USAM ÍNDICES


-- Pesquisa de cliente pelo nome
SELECT *
FROM Clientes
WHERE Nome = 'Carlos Silva';

-- Pesquisa de encomendas por estado
SELECT *
FROM Encomendas
WHERE Estado = 'Pendente';

-- Pesquisa de produtos pelo nome
SELECT *
FROM Produtos
WHERE NomeProduto = 'Mouse Logitech';

GO


-- REMOÇÃO DE ÍNDICES (DROP INDEX)


-- Remover índice da tabela Clientes
DROP INDEX IDX_Clientes_Nome
ON Clientes;
GO

-- Remover índice da tabela Produtos
DROP INDEX IDX_Produtos_NomeProduto
ON Produtos;
GO

-- Remover índice da tabela Encomendas
DROP INDEX IDX_Encomendas_Estado
ON Encomendas;
GO
