
-- BASE DE DADOS: SISTEMA DE GESTÃO DE BIBLIOTECA UNIVERSITÁRIA


CREATE DATABASE BibliotecaUniversitaria;
GO

USE BibliotecaUniversitaria;
GO

-- TABELA ESTUDANTES


CREATE TABLE Estudantes (
EstudanteID INT PRIMARY KEY IDENTITY(1,1),

```
Nome VARCHAR(100) NOT NULL,

NumeroMatricula VARCHAR(20) NOT NULL UNIQUE,

Curso VARCHAR(100) NOT NULL,

Email VARCHAR(100) UNIQUE,

Telefone VARCHAR(20),

DataCadastro DATETIME DEFAULT GETDATE()
```

);
GO

-- TABELA AUTORES


CREATE TABLE Autores (
AutorID INT PRIMARY KEY IDENTITY(1,1),

```
NomeAutor VARCHAR(100) NOT NULL,

Nacionalidade VARCHAR(50)
```

);
GO


-- TABELA LIVROS


CREATE TABLE Livros (
LivroID INT PRIMARY KEY IDENTITY(1,1),

```
Titulo VARCHAR(255) NOT NULL,

ISBN VARCHAR(50) UNIQUE,

AnoPublicacao INT
    CHECK (AnoPublicacao >= 1900),

Categoria VARCHAR(100),

QuantidadeStock INT NOT NULL
    CHECK (QuantidadeStock >= 0),

AutorID INT NOT NULL,

FOREIGN KEY (AutorID)
    REFERENCES Autores(AutorID)
    ON DELETE CASCADE
```

);
GO


-- TABELA FUNCIONÁRIOS


CREATE TABLE Funcionarios (
FuncionarioID INT PRIMARY KEY IDENTITY(1,1),

```
Nome VARCHAR(100) NOT NULL,

Cargo VARCHAR(50),

Email VARCHAR(100) UNIQUE,

Telefone VARCHAR(20)
```

);
GO


-- TABELA EMPRÉSTIMOS


CREATE TABLE Emprestimos (
EmprestimoID INT PRIMARY KEY IDENTITY(1,1),

```
EstudanteID INT NOT NULL,

LivroID INT NOT NULL,

FuncionarioID INT NOT NULL,

DataEmprestimo DATETIME DEFAULT GETDATE(),

DataDevolucao DATE,

Estado VARCHAR(20)
    DEFAULT 'Emprestado'
    CHECK (
        Estado IN (
            'Emprestado',
            'Devolvido',
            'Atrasado'
        )
    ),

FOREIGN KEY (EstudanteID)
    REFERENCES Estudantes(EstudanteID)
    ON DELETE CASCADE,

FOREIGN KEY (LivroID)
    REFERENCES Livros(LivroID)
    ON DELETE CASCADE,

FOREIGN KEY (FuncionarioID)
    REFERENCES Funcionarios(FuncionarioID)
    ON DELETE CASCADE
```

);
GO


-- TABELA MULTAS


CREATE TABLE Multas (
MultaID INT PRIMARY KEY IDENTITY(1,1),

```
EmprestimoID INT NOT NULL UNIQUE,

ValorMulta DECIMAL(10,2)
    CHECK (ValorMulta >= 0),

Motivo VARCHAR(255),

EstadoPagamento VARCHAR(20)
    DEFAULT 'Pendente'
    CHECK (
        EstadoPagamento IN (
            'Pendente',
            'Pago'
        )
    ),

FOREIGN KEY (EmprestimoID)
    REFERENCES Emprestimos(EmprestimoID)
    ON DELETE CASCADE
```

);
GO


-- INSERÇÃO DE DADOS


INSERT INTO Estudantes
(Nome, NumeroMatricula, Curso, Email, Telefone)
VALUES
('Carlos Manuel', '2025001', 'Informática', '[carlos@gmail.com](mailto:carlos@gmail.com)', '923456789'),

('Maria Silva', '2025002', 'Direito', '[maria@gmail.com](mailto:maria@gmail.com)', '912345678');
GO

INSERT INTO Autores
(NomeAutor, Nacionalidade)
VALUES
('Machado de Assis', 'Brasileiro'),

('Pepetela', 'Angolano');
GO

INSERT INTO Livros
(Titulo, ISBN, AnoPublicacao, Categoria, QuantidadeStock, AutorID)
VALUES
('Dom Casmurro', 'ISBN001', 1899, 'Romance', 10, 1),

('Mayombe', 'ISBN002', 1980, 'Literatura', 5, 2);
GO

INSERT INTO Funcionarios
(Nome, Cargo, Email, Telefone)
VALUES
('Ana Paula', 'Bibliotecária', '[ana@biblioteca.com](mailto:ana@biblioteca.com)', '933111222');
GO

INSERT INTO Emprestimos
(EstudanteID, LivroID, FuncionarioID, DataDevolucao, Estado)
VALUES
(1, 1, 1, '2026-06-20', 'Emprestado'),

(2, 2, 1, '2026-06-18', 'Emprestado');
GO

INSERT INTO Multas
(EmprestimoID, ValorMulta, Motivo)
VALUES
(2, 1500.00, 'Entrega atrasada');
GO


-- CONSULTAS IMPORTANTES


-- Ver todos os livros
SELECT * FROM Livros;

-- Ver estudantes
SELECT * FROM Estudantes;

-- Ver empréstimos
SELECT
E.EmprestimoID,
ES.Nome AS Estudante,
L.Titulo,
E.DataEmprestimo,
E.DataDevolucao,
E.Estado
FROM Emprestimos E
INNER JOIN Estudantes ES
ON E.EstudanteID = ES.EstudanteID
INNER JOIN Livros L
ON E.LivroID = L.LivroID;

-- Ver multas
SELECT
M.MultaID,
ES.Nome,
L.Titulo,
M.ValorMulta,
M.EstadoPagamento
FROM Multas M
INNER JOIN Emprestimos E
ON M.EmprestimoID = E.EmprestimoID
INNER JOIN Estudantes ES
ON E.EstudanteID = ES.EstudanteID
INNER JOIN Livros L
ON E.LivroID = L.LivroID;

GO


-- CRIAÇÃO DE ÍNDICES


CREATE INDEX IDX_Estudantes_Matricula
ON Estudantes(NumeroMatricula);
GO

CREATE INDEX IDX_Livros_Titulo
ON Livros(Titulo);
GO

CREATE INDEX IDX_Emprestimos_EstudanteID
ON Emprestimos(EstudanteID);
GO


-- REMOÇÃO DE ÍNDICES


DROP INDEX IDX_Livros_Titulo
ON Livros;
GO
