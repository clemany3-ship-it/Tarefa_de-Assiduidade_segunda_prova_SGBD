



-- CRIAÇÃO DA BASE DE DADOS


CREATE DATABASE SistemaEncomendas;
GO

USE SistemaEncomendas;
GO


-- TABELA CLIENTES


CREATE TABLE Clientes (
ClienteID INT PRIMARY KEY IDENTITY(1,1),

```
Nome VARCHAR(100) NOT NULL,

Email VARCHAR(255) UNIQUE,

DataNascimento DATE,

Cidade VARCHAR(50) DEFAULT 'Lisboa',

Telefone VARCHAR(20) UNIQUE,

UltimaAtualizacao DATETIME DEFAULT GETDATE(),

CHECK (DataNascimento < GETDATE()),

CHECK (LEN(Telefone) = 9 OR Telefone IS NULL)
```

);
GO


-- TABELA PRODUTOS


CREATE TABLE Produtos (
ProdutoID INT PRIMARY KEY IDENTITY(1,1),

```
NomeProduto VARCHAR(255) NOT NULL UNIQUE,

Descricao TEXT,

Preco DECIMAL(10,2) NOT NULL
    CHECK (Preco > 0),

Stock INT NOT NULL
    CHECK (Stock >= 0)
```

);
GO


-- TABELA ENCOMENDAS


CREATE TABLE Encomendas (
EncomendaID INT PRIMARY KEY IDENTITY(1,1),

```
ClienteID INT NOT NULL,

DataEncomenda DATETIME DEFAULT GETDATE(),

ValorTotal DECIMAL(10,2)
    CHECK (ValorTotal >= 0),

Estado VARCHAR(20)
    DEFAULT 'Pendente'
    CHECK (
        Estado IN (
            'Pendente',
            'Processada',
            'Enviada',
            'Entregue',
            'Cancelada'
        )
    ),

FOREIGN KEY (ClienteID)
    REFERENCES Clientes(ClienteID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
```

);
GO


-- TABELA DETALHES ENCOMENDA


CREATE TABLE DetalhesEncomenda (
DetalheID INT PRIMARY KEY IDENTITY(1,1),

```
EncomendaID INT NOT NULL,

ProdutoID INT NOT NULL,

Quantidade INT NOT NULL
    CHECK (Quantidade > 0),

PrecoUnitarioVenda DECIMAL(10,2) NOT NULL
    CHECK (PrecoUnitarioVenda > 0),

FOREIGN KEY (EncomendaID)
    REFERENCES Encomendas(EncomendaID)
    ON DELETE CASCADE,

FOREIGN KEY (ProdutoID)
    REFERENCES Produtos(ProdutoID)
    ON DELETE NO ACTION,

UNIQUE (EncomendaID, ProdutoID)
```

);
GO


-- INSERÇÃO DE DADOS DE TESTE


INSERT INTO Clientes
(Nome, Email, DataNascimento, Cidade, Telefone)
VALUES
('Carlos Silva', '[carlos@gmail.com](mailto:carlos@gmail.com)', '1998-05-10', 'Lisboa', '923456789'),

('Maria Santos', '[maria@gmail.com](mailto:maria@gmail.com)', '1995-03-20', 'Porto', '912345678');

GO

INSERT INTO Produtos
(NomeProduto, Descricao, Preco, Stock)
VALUES
('Computador HP', 'Computador portátil HP', 350000.00, 10),

('Mouse Logitech', 'Mouse sem fio Logitech', 15000.00, 50),

('Teclado Gamer', 'Teclado RGB mecânico', 25000.00, 20);

GO

INSERT INTO Encomendas
(ClienteID, ValorTotal, Estado)
VALUES
(1, 365000.00, 'Processada'),

(2, 15000.00, 'Pendente');

GO

INSERT INTO DetalhesEncomenda
(EncomendaID, ProdutoID, Quantidade, PrecoUnitarioVenda)
VALUES
(1, 1, 1, 350000.00),

(1, 2, 1, 15000.00),

(2, 2, 1, 15000.00);

GO


-- CONSULTAS IMPORTANTES


-- Ver todos os clientes
SELECT * FROM Clientes;

-- Ver todos os produtos
SELECT * FROM Produtos;

-- Ver encomendas com nome do cliente
SELECT
E.EncomendaID,
C.Nome,
E.DataEncomenda,
E.ValorTotal,
E.Estado
FROM Encomendas E
INNER JOIN Clientes C
ON E.ClienteID = C.ClienteID;

-- Ver detalhes das encomendas
SELECT
D.DetalheID,
P.NomeProduto,
D.Quantidade,
D.PrecoUnitarioVenda
FROM DetalhesEncomenda D
INNER JOIN Produtos P
ON D.ProdutoID = P.ProdutoID;

GO
