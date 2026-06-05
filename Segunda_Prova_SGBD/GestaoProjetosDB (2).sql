CREATE DATABASE GestaoProjetosDB;
USE GestaoProjetosDB;
CREATE TABLE Colaboradores (
ColaboradorID INT PRIMARY KEY AUTO_INCREMENT,
Nome VARCHAR(100) NOT NULL,
Email VARCHAR(255) NOT NULL UNIQUE,
Funcao VARCHAR(100)
);
CREATE TABLE Projetos (
ProjetoID INT PRIMARY KEY AUTO_INCREMENT,
NomeProjeto VARCHAR(255) NOT NULL,
Descricao TEXT,
DataInicio DATE NOT NULL,
DataFim DATE,
GestorID INT,
FOREIGN KEY (GestorID) REFERENCES Colaboradores(ColaboradorID)
);
CREATE TABLE Tarefas (
TarefaID INT PRIMARY KEY AUTO_INCREMENT,
NomeTarefa VARCHAR(255) NOT NULL,
Descricao TEXT,
DataInicio DATE NOT NULL,
DataFim DATE,
Estado VARCHAR(50) DEFAULT 'Pendente' CHECK (Estado IN ('Pendente', 'Em Progresso', 'Concluída', 'Cancelada')),
74
ResponsavelID INT,
ProjetoID INT NOT NULL,
FOREIGN KEY (ResponsavelID) REFERENCES Colaboradores(ColaboradorID),
FOREIGN KEY (ProjetoID) REFERENCES Projetos(ProjetoID) ON DELETE CASCADE
);
CREATE TABLE ParticipacaoProjeto (
ParticipacaoID INT PRIMARY KEY AUTO_INCREMENT,
ColaboradorID INT NOT NULL,
ProjetoID INT NOT NULL,
DataEntrada DATE NOT NULL,
DataSaida DATE,
FOREIGN KEY (ColaboradorID) REFERENCES Colaboradores(ColaboradorID),
FOREIGN KEY (ProjetoID) REFERENCES Projetos(ProjetoID) ON DELETE CASCADE,
UNIQUE (ColaboradorID, ProjetoID) -- Um colaborador só pode participar uma vez num projeto
);