-- =====================================================
-- BASE DE DADOS: CONTROLO DE ACESSO E PERMISSÕES
-- =====================================================

CREATE DATABASE SistemaSeguranca;
GO

USE SistemaSeguranca;
GO

-- =====================================================
-- TABELA UTILIZADORES
-- =====================================================

CREATE TABLE Utilizadores (
UtilizadorID INT PRIMARY KEY IDENTITY(1,1),

```
Nome VARCHAR(100) NOT NULL,

Username VARCHAR(50) NOT NULL UNIQUE,

PalavraPasse VARCHAR(100) NOT NULL,

TipoUtilizador VARCHAR(20)
    CHECK (
        TipoUtilizador IN (
            'Administrador',
            'Funcionario',
            'Visitante'
        )
    ),

EstadoConta VARCHAR(20)
    DEFAULT 'Ativo'
    CHECK (
        EstadoConta IN (
            'Ativo',
            'Bloqueado'
        )
    ),

DataCriacao DATETIME DEFAULT GETDATE()
```

);
GO

-- =====================================================
-- TABELA PERMISSOES
-- =====================================================

CREATE TABLE Permissoes (
PermissaoID INT PRIMARY KEY IDENTITY(1,1),

```
NomePermissao VARCHAR(100) NOT NULL UNIQUE,

Descricao VARCHAR(255)
```

);
GO

-- =====================================================
-- TABELA UTILIZADOR_PERMISSOES
-- =====================================================

CREATE TABLE UtilizadorPermissoes (
ID INT PRIMARY KEY IDENTITY(1,1),

```
UtilizadorID INT NOT NULL,

PermissaoID INT NOT NULL,

FOREIGN KEY (UtilizadorID)
    REFERENCES Utilizadores(UtilizadorID)
    ON DELETE CASCADE,

FOREIGN KEY (PermissaoID)
    REFERENCES Permissoes(PermissaoID)
    ON DELETE CASCADE,

UNIQUE (UtilizadorID, PermissaoID)
```

);
GO

-- =====================================================
-- TABELA LOG DE ACESSO
-- =====================================================

CREATE TABLE LogAcesso (
LogID INT PRIMARY KEY IDENTITY(1,1),

```
UtilizadorID INT NOT NULL,

DataLogin DATETIME DEFAULT GETDATE(),

EnderecoIP VARCHAR(50),

StatusLogin VARCHAR(20)
    CHECK (
        StatusLogin IN (
            'Sucesso',
            'Falha'
        )
    ),

FOREIGN KEY (UtilizadorID)
    REFERENCES Utilizadores(UtilizadorID)
    ON DELETE CASCADE
```

);
GO

-- =====================================================
-- INSERÇÃO DE DADOS
-- =====================================================

INSERT INTO Utilizadores
(Nome, Username, PalavraPasse, TipoUtilizador)
VALUES
('Carlos Manuel', 'carlos', '123456', 'Administrador'),

('Maria Silva', 'maria', '123456', 'Funcionario'),

('João Pedro', 'joao', '123456', 'Visitante');
GO

INSERT INTO Permissoes
(NomePermissao, Descricao)
VALUES
('Criar Utilizador', 'Permite criar novos utilizadores'),

('Editar Utilizador', 'Permite editar utilizadores'),

('Eliminar Utilizador', 'Permite eliminar utilizadores'),

('Visualizar Relatorios', 'Permite visualizar relatórios');
GO

INSERT INTO UtilizadorPermissoes
(UtilizadorID, PermissaoID)
VALUES
(1,1),
(1,2),
(1,3),
(1,4),

(2,4);
GO

INSERT INTO LogAcesso
(UtilizadorID, EnderecoIP, StatusLogin)
VALUES
(1, '192.168.1.10', 'Sucesso'),

(2, '192.168.1.15', 'Falha'),

(3, '192.168.1.20', 'Sucesso');
GO

-- =====================================================
-- CONSULTAS IMPORTANTES
-- =====================================================

-- Ver todos os utilizadores
SELECT * FROM Utilizadores;

-- Ver permissões dos utilizadores
SELECT
U.Nome,
P.NomePermissao
FROM UtilizadorPermissoes UP
INNER JOIN Utilizadores U
ON UP.UtilizadorID = U.UtilizadorID
INNER JOIN Permissoes P
ON UP.PermissaoID = P.PermissaoID;

-- Ver histórico de acessos
SELECT
U.Nome,
L.DataLogin,
L.EnderecoIP,
L.StatusLogin
FROM LogAcesso L
INNER JOIN Utilizadores U
ON L.UtilizadorID = U.UtilizadorID;

GO

-- =====================================================
-- CRIAÇÃO DE ÍNDICES
-- =====================================================

CREATE INDEX IDX_Utilizadores_Username
ON Utilizadores(Username);
GO

CREATE INDEX IDX_LogAcesso_UtilizadorID
ON LogAcesso(UtilizadorID);
GO

-- =====================================================
-- REMOVER ÍNDICES
-- =====================================================

DROP INDEX IDX_Utilizadores_Username
ON Utilizadores;
GO
