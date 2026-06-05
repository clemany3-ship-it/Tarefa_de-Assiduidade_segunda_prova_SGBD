--Criar a base de dados
CREATE DATABASE BibliotecaDB;
GO
-- Usar a base de dados
USE BibliotecaDB;
GO
-- Criar a tabela Autores
CREATE TABLE Autores (
AutorID INT PRIMARY KEY IDENTITY(1,1), -- Chave primária auto-incrementável
Nome VARCHAR(255) NOT NULL,
Nacionalidade VARCHAR(100)
);
GO
-- Criar a tabela Livros
CREATE TABLE Livros (
LivroID INT PRIMARY KEY IDENTITY(1,1), -- Chave primária auto-incrementável
Titulo VARCHAR(255) NOT NULL,
AnoPublicacao INT,
AutorID INT, -- Chave estrangeira para Autores
FOREIGN KEY (AutorID) REFERENCES Autores(AutorID)
);
GO
-- Inserir dados de exemplo
INSERT INTO Autores (Nome, Nacionalidade)
VALUES('José Saramago', 'Português'),('Gabriel Garcia Marquez', 'Colombiano'),('J.K. Rowling', 'Britânica');
GO
INSERT INTO Livros (Titulo, AnoPublicacao, AutorID)
VALUES('Ensaio sobre a Cegueira', 1995, 1),
('O Evangelho Segundo Jesus Cristo', 1991, 1),
('Cem Anos de Solidão', 1967, 2),
('Harry Potter e a Pedra Filosofal', 1997, 3);
GO
-- Consultar dados
SELECT L.Titulo, L.AnoPublicacao, A.Nome AS Autor, A.Nacionalidade
FROM Livros L
JOIN Autores A ON L.AutorID = A.AutorID;
GO