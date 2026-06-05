CREATE DATABASE RHDB;
GO

USE RHDB;
GO


-- TABELA DEPARTAMENTOS


CREATE TABLE Departamentos (
    DepartamentoID INT PRIMARY KEY IDENTITY(1,1),

    NomeDepartamento VARCHAR(100)
        NOT NULL UNIQUE
);
GO

-- TABELA FUNCIONARIOS


CREATE TABLE Funcionarios (
    FuncionarioID INT PRIMARY KEY IDENTITY(1,1),

    Nome VARCHAR(100) NOT NULL,

    Email VARCHAR(150)
        UNIQUE NOT NULL,

    Salario VARBINARY(MAX),

    DataContratacao DATE NOT NULL,

    DepartamentoID INT NOT NULL,

    NIF VARBINARY(MAX),

    IBAN VARBINARY(MAX),

    FOREIGN KEY (DepartamentoID)
        REFERENCES Departamentos(DepartamentoID)
);
GO


-- TABELA PROJETOS


CREATE TABLE Projetos (
    ProjetoID INT PRIMARY KEY IDENTITY(1,1),

    NomeProjeto VARCHAR(150)
        NOT NULL UNIQUE
);
GO


-- TABELA ATRIBUICOESPROJETO


CREATE TABLE AtribuicoesProjeto (
    AtribuicaoID INT PRIMARY KEY IDENTITY(1,1),

    FuncionarioID INT NOT NULL,

    ProjetoID INT NOT NULL,

    DataInicio DATE,

    DataFim DATE,

    FOREIGN KEY (FuncionarioID)
        REFERENCES Funcionarios(FuncionarioID),

    FOREIGN KEY (ProjetoID)
        REFERENCES Projetos(ProjetoID)
);
GO


-- INSERIR DEPARTAMENTOS


INSERT INTO Departamentos
(NomeDepartamento)
VALUES
('Vendas'),
('Marketing'),
('Tecnologia');
GO


-- INSERIR PROJETOS


INSERT INTO Projetos
(NomeProjeto)
VALUES
('ERP Empresarial'),
('Sistema RH'),
('Aplicacao Mobile'),
('Portal Web'),
('Business Intelligence');
GO


-- CRIPTOGRAFIA


CREATE MASTER KEY
ENCRYPTION BY PASSWORD = 'SenhaForte@123';
GO

CREATE CERTIFICATE CertificadoRH
WITH SUBJECT = 'Protecao Dados RH';
GO

CREATE SYMMETRIC KEY ChaveRH
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE CertificadoRH;
GO


-- INSERIR FUNCIONARIOS CRIPTOGRAFADOS


OPEN SYMMETRIC KEY ChaveRH
DECRYPTION BY CERTIFICATE CertificadoRH;
GO

INSERT INTO Funcionarios (
    Nome,
    Email,
    Salario,
    DataContratacao,
    DepartamentoID,
    NIF,
    IBAN
)
VALUES
(
    'Carlos Manuel',

    'carlos@empresa.com',

    EncryptByKey(
        Key_GUID('ChaveRH'),
        CAST('350000' AS VARCHAR)
    ),

    '2022-01-10',

    1,

    EncryptByKey(
        Key_GUID('ChaveRH'),
        '123456789LA'
    ),

    EncryptByKey(
        Key_GUID('ChaveRH'),
        'AO06004400001122334455'
    )
),

(
    'Maria Silva',

    'maria@empresa.com',

    EncryptByKey(
        Key_GUID('ChaveRH'),
        CAST('420000' AS VARCHAR)
    ),

    '2021-05-15',

    2,

    EncryptByKey(
        Key_GUID('ChaveRH'),
        '987654321LA'
    ),

    EncryptByKey(
        Key_GUID('ChaveRH'),
        'AO06005566778899001122'
    )
);
GO

CLOSE SYMMETRIC KEY ChaveRH;
GO


-- LOGINS


CREATE LOGIN admin_rh
WITH PASSWORD = 'Admin@123';
GO

CREATE LOGIN gestor_vendas
WITH PASSWORD = 'Gestor@123';
GO

CREATE LOGIN gestor_marketing
WITH PASSWORD = 'Gestor@123';
GO

CREATE LOGIN funcionario_comum
WITH PASSWORD = 'Funcionario@123';
GO

CREATE LOGIN app_folha_pagamentos
WITH PASSWORD = 'Folha@123';
GO


-- USERS


CREATE USER admin_rh
FOR LOGIN admin_rh;
GO

CREATE USER gestor_vendas
FOR LOGIN gestor_vendas;
GO

CREATE USER gestor_marketing
FOR LOGIN gestor_marketing;
GO

CREATE USER funcionario_comum
FOR LOGIN funcionario_comum;
GO

CREATE USER app_folha_pagamentos
FOR LOGIN app_folha_pagamentos;
GO


-- ROLES


CREATE ROLE role_admin_rh;
GO

CREATE ROLE role_gestor_departamento;
GO

CREATE ROLE role_funcionario_comum;
GO

CREATE ROLE role_app_folha_pagamentos;
GO


-- PERMISSOES


GRANT SELECT, INSERT, UPDATE, DELETE
ON Funcionarios
TO role_admin_rh;
GO

GRANT SELECT, INSERT, UPDATE, DELETE
ON Departamentos
TO role_admin_rh;
GO

GRANT SELECT, INSERT, UPDATE, DELETE
ON Projetos
TO role_admin_rh;
GO

GRANT SELECT
ON Funcionarios
TO role_gestor_departamento;
GO

GRANT INSERT
ON AtribuicoesProjeto
TO role_gestor_departamento;
GO

GRANT SELECT
ON Funcionarios
TO role_funcionario_comum;
GO

GRANT SELECT
ON Funcionarios
TO role_app_folha_pagamentos;
GO


-- REVOKE DADOS SENSIVEIS


REVOKE SELECT
ON OBJECT::Funcionarios (Salario)
FROM role_funcionario_comum;
GO

REVOKE SELECT
ON OBJECT::Funcionarios (NIF)
FROM role_funcionario_comum;
GO

REVOKE SELECT
ON OBJECT::Funcionarios (IBAN)
FROM role_funcionario_comum;
GO


-- ATRIBUIR ROLES


ALTER ROLE role_admin_rh
ADD MEMBER admin_rh;
GO

ALTER ROLE role_gestor_departamento
ADD MEMBER gestor_vendas;
GO

ALTER ROLE role_gestor_departamento
ADD MEMBER gestor_marketing;
GO

ALTER ROLE role_funcionario_comum
ADD MEMBER funcionario_comum;
GO

ALTER ROLE role_app_folha_pagamentos
ADD MEMBER app_folha_pagamentos;
GO


-- VIEWS


CREATE VIEW VW_GestorDepartamento
AS
SELECT
    F.FuncionarioID,
    F.Nome,
    F.Email,
    D.NomeDepartamento
FROM Funcionarios F
INNER JOIN Departamentos D
    ON F.DepartamentoID = D.DepartamentoID;
GO

CREATE VIEW VW_FuncionarioComum
AS
SELECT
    FuncionarioID,
    Nome,
    Email
FROM Funcionarios;
GO

-- DESCRIPTOGRAFIA


OPEN SYMMETRIC KEY ChaveRH
DECRYPTION BY CERTIFICATE CertificadoRH;
GO

SELECT
    FuncionarioID,

    Nome,

    CONVERT(
        VARCHAR,
        DecryptByKey(Salario)
    ) AS Salario,

    CONVERT(
        VARCHAR,
        DecryptByKey(NIF)
    ) AS NIF,

    CONVERT(
        VARCHAR,
        DecryptByKey(IBAN)
    ) AS IBAN

FROM Funcionarios;
GO

CLOSE SYMMETRIC KEY ChaveRH;
GO

-- AUDITORIA


CREATE SERVER AUDIT AuditoriaRH
TO FILE (
    FILEPATH = 'C:\AuditoriaSQL\'
);
GO

ALTER SERVER AUDIT AuditoriaRH
WITH (STATE = ON);
GO

CREATE DATABASE AUDIT SPECIFICATION AuditoriaRHDB
FOR SERVER AUDIT AuditoriaRH

ADD (
    SELECT
    ON dbo.Funcionarios
    BY role_funcionario_comum
),

ADD (
    UPDATE
    ON dbo.Funcionarios
    BY PUBLIC
),

ADD (
    SCHEMA_OBJECT_CHANGE_GROUP
);

GO

ALTER DATABASE AUDIT SPECIFICATION AuditoriaRHDB
WITH (STATE = ON);
GO


-- CONSULTAR LOGS


SELECT *
FROM sys.fn_get_audit_file (
    'C:\AuditoriaSQL\*',
    DEFAULT,
    DEFAULT
);
GO


-- TESTES


EXECUTE AS USER = 'funcionario_comum';
GO

SELECT *
FROM VW_FuncionarioComum;
GO

REVERT;
GO

EXECUTE AS USER = 'app_folha_pagamentos';
GO

OPEN SYMMETRIC KEY ChaveRH
DECRYPTION BY CERTIFICATE CertificadoRH;
GO

SELECT
    Nome,

    CONVERT(
        VARCHAR,
        DecryptByKey(Salario)
    ) AS Salario

FROM Funcionarios;
GO

REVERT;
GO


-- INDICES


CREATE INDEX IDX_Funcionarios_Email
ON Funcionarios(Email);
GO

CREATE INDEX IDX_Funcionarios_Departamento
ON Funcionarios(DepartamentoID);
GO

CREATE INDEX IDX_Atribuicoes_Projeto
ON AtribuicoesProjeto(ProjetoID);
GO