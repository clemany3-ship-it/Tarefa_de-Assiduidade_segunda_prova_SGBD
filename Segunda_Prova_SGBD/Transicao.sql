create database BD_Venda;

Use BD_Venda
Go

CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY IDENTITY,
    nome VARCHAR(100),
    telefone VARCHAR(20),
    endereco VARCHAR(200)
);

CREATE TABLE Funcionario (
    id_funcionario INT PRIMARY KEY IDENTITY,
    nome VARCHAR(100),
    cargo VARCHAR(50),
    telefone VARCHAR(20),
    salario DECIMAL(10,2),
    data_admissao DATE
);

CREATE TABLE Produto (
    id_produto INT PRIMARY KEY IDENTITY,
	id_funcionario INT,
    nome VARCHAR(100),
    preco DECIMAL(10,2),
    stock INT
	FOREIGN KEY (id_funcionario) REFERENCES Funcionario(id_funcionario)
);

CREATE TABLE Venda (
    id_venda INT PRIMARY KEY IDENTITY,
    id_cliente INT,
    id_funcionario INT,
    data_venda DATE,
    total DECIMAL(10,2),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_funcionario) REFERENCES Funcionario(id_funcionario)
);

CREATE TABLE ItemVenda (
    id_item INT PRIMARY KEY IDENTITY,
    id_venda INT,
    id_produto INT,
    quantidade INT,
    preco_unitario DECIMAL(10,2),
    FOREIGN KEY (id_venda) REFERENCES Venda(id_venda),
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto)
);

CREATE TABLE StockMovimento (
    id_movimento INT PRIMARY KEY IDENTITY,
    id_produto INT,
    tipo VARCHAR(10), 
    quantidade INT,
    data_movimento DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto)
);


insert into Cliente values('Clemente',984765918,'Rua A');

INSERT INTO Funcionario (nome, cargo, telefone, salario, data_admissao) VALUES ('Carlos', 'Caixa', '924111111', 50000, '2024-01-10');
INSERT INTO Funcionario (nome, cargo, telefone, salario, data_admissao) VALUES ('Ana', 'Vendedora', '924222222', 45000, '2024-02-15');


INSERT INTO Produto (nome, preco, stock) VALUES ('Arroz 5kg', 5000, 50);
INSERT INTO Produto (nome, preco, stock) VALUES ('Feijão 1kg', 2000, 100);
INSERT INTO Produto (nome, preco, stock) VALUES ('Açúcar 1kg', 1800, 80);
INSERT INTO Produto (nome, preco, stock) VALUES ('Óleo 1L', 2500, 60);

INSERT INTO Venda (id_cliente, id_funcionario, data_venda, total) VALUES (1, 1, GETDATE(), 10000);
INSERT INTO Venda (id_cliente, id_funcionario, data_venda, total) VALUES (2, 2, GETDATE(), 5000);


INSERT INTO ItemVenda (id_venda, id_produto, quantidade, preco_unitario) VALUES (1, 1, 2, 5000);
INSERT INTO ItemVenda (id_venda, id_produto, quantidade, preco_unitario) VALUES (2, 2, 2, 2000);


INSERT INTO ItemVenda (id_venda, id_produto, quantidade, preco_unitario) VALUES (1, 1, 2, 5000);
INSERT INTO ItemVenda (id_venda, id_produto, quantidade, preco_unitario) VALUES (2, 2, 2, 2000);	


INSERT INTO StockMovimento (id_produto, tipo, quantidade) VALUES (1, 'SAIDA', 2);
INSERT INTO StockMovimento (id_produto, tipo, quantidade) VALUES (2, 'SAIDA', 2);
INSERT INTO StockMovimento (id_produto, tipo, quantidade) VALUES (3, 'ENTRADA', 10);

---------------------------------------------------------------
BEGIN TRANSACTION;


INSERT INTO Venda (id_cliente, id_funcionario, data_venda, total)
VALUES (1, 1, GETDATE(), 200);

DECLARE @id_venda INT = SCOPE_IDENTITY();


INSERT INTO ItemVenda (id_venda, id_produto, quantidade, preco_unitario)
VALUES (@id_venda, 1, 2, 100);


INSERT INTO StockMovimento (id_produto, tipo, quantidade)
VALUES (1, 'SAIDA', 2);


UPDATE Produto
SET stock = stock - 2
WHERE id_produto = 1;

COMMIT;

ROLLBACK;
