-- Limpa o banco se já existir
DROP DATABASE IF EXISTS Oficina;
CREATE DATABASE Oficina;
USE Oficina;

-- Tabela Cliente
CREATE TABLE Cliente (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Endereco VARCHAR(150),
    Cartao VARCHAR(50),
    CPF VARCHAR(14) UNIQUE,
    Telefone VARCHAR(20)
);

-- Tabela Veículo
CREATE TABLE Veiculo (
    idVeiculo INT AUTO_INCREMENT PRIMARY KEY,
    Modelo VARCHAR(50) NOT NULL,
    Placa VARCHAR(10) UNIQUE NOT NULL,
    Ano INT,
    Cor VARCHAR(30),
    Cliente_idCliente INT,
    FOREIGN KEY (Cliente_idCliente) REFERENCES Cliente(idCliente)
);

-- Tabela Mecânico
CREATE TABLE Mecanico (
    idMecanico INT AUTO_INCREMENT PRIMARY KEY,
    Codigo INT UNIQUE,
    Nome VARCHAR(100) NOT NULL,
    Endereco VARCHAR(150),
    Telefone VARCHAR(20),
    Especialidade VARCHAR(50)
);

-- Tabela Defeito do Veículo
CREATE TABLE Defeito_Veiculo (
    idDefeito INT AUTO_INCREMENT PRIMARY KEY,
    Descricao VARCHAR(150) NOT NULL,
    Peca VARCHAR(50),
    Diagnostico VARCHAR(150),
    Tipo_Servico VARCHAR(50),
    Valor DECIMAL(10,2),
    Veiculo_idVeiculo INT,
    Mecanico_idMecanico INT,
    FOREIGN KEY (Veiculo_idVeiculo) REFERENCES Veiculo(idVeiculo),
    FOREIGN KEY (Mecanico_idMecanico) REFERENCES Mecanico(idMecanico)
);

-- Tabela Pagamento
CREATE TABLE Pagamento (
    idPagamento INT AUTO_INCREMENT PRIMARY KEY,
    Valor DECIMAL(10,2) NOT NULL,
    Promocao VARCHAR(50),
    Forma_Pagamento VARCHAR(30),
    Cliente_idCliente INT,
    Mecanico_idMecanico INT,
    Defeito_idDefeito INT,
    FOREIGN KEY (Cliente_idCliente) REFERENCES Cliente(idCliente),
    FOREIGN KEY (Mecanico_idMecanico) REFERENCES Mecanico(idMecanico),
    FOREIGN KEY (Defeito_idDefeito) REFERENCES Defeito_Veiculo(idDefeito)
);

-- Tabela Entrega
CREATE TABLE Entrega (
    idEntrega INT AUTO_INCREMENT PRIMARY KEY,
    Status VARCHAR(50),
    Data DATE,
    Cliente_idCliente INT,
    FOREIGN KEY (Cliente_idCliente) REFERENCES Cliente(idCliente)
);
-- Clientes
INSERT INTO Cliente (Nome, Endereco, Cartao, CPF, Telefone)
VALUES 
('João Martins', 'Rua A, 123', 'Visa', '111.111.111-11', '62999990000'),
('Maria Silva', 'Rua B, 456', 'MasterCard', '222.222.222-22', '62988887777');

-- Veículos
INSERT INTO Veiculo (Modelo, Placa, Ano, Cor, Cliente_idCliente)
VALUES 
('Gol', 'ABC1234', 2015, 'Preto', 1),
('Civic', 'XYZ9876', 2020, 'Branco', 2);

-- Mecânicos
INSERT INTO Mecanico (Codigo, Nome, Endereco, Telefone, Especialidade)
VALUES 
(101, 'Carlos Mecânico', 'Rua Oficina, 45', '62977776666', 'Motor'),
(102, 'Pedro Reparador', 'Av Mecânica, 12', '62966665555', 'Elétrica');

-- Defeitos
INSERT INTO Defeito_Veiculo (Descricao, Peca, Diagnostico, Tipo_Servico, Valor, Veiculo_idVeiculo, Mecanico_idMecanico)
VALUES 
('Troca de correia dentada', 'Correia', 'Correia gasta', 'Preventivo', 450.00, 1, 1),
('Troca de bateria', 'Bateria', 'Bateria descarregada', 'Substituição', 300.00, 2, 2);

-- Pagamentos
INSERT INTO Pagamento (Valor, Promocao, Forma_Pagamento, Cliente_idCliente, Mecanico_idMecanico, Defeito_idDefeito)
VALUES
(450.00, 'Nenhuma', 'Cartão de Crédito', 1, 1, 1),
(300.00, 'Desconto 10%', 'Dinheiro', 2, 2, 2);

-- Entregas
INSERT INTO Entrega (Status, Data, Cliente_idCliente)
VALUES
('Entregue', '2025-08-20', 1),
('Aguardando retirada', '2025-08-21', 2);
-- 1. Listar todos os clientes e seus veículos
SELECT c.Nome, v.Modelo, v.Placa
FROM Cliente c
JOIN Veiculo v ON c.idCliente = v.Cliente_idCliente;

-- 2. Buscar todos os serviços realizados acima de R$300
SELECT d.Descricao, d.Valor, c.Nome AS Cliente, m.Nome AS Mecanico
FROM Defeito_Veiculo d
JOIN Veiculo v ON d.Veiculo_idVeiculo = v.idVeiculo
JOIN Cliente c ON v.Cliente_idCliente = c.idCliente
JOIN Mecanico m ON d.Mecanico_idMecanico = m.idMecanico
WHERE d.Valor > 300;

-- 3. Valor total gasto por cada cliente
SELECT c.Nome, SUM(p.Valor) AS Total_Gasto
FROM Cliente c
JOIN Pagamento p ON c.idCliente = p.Cliente_idCliente
GROUP BY c.Nome
HAVING SUM(p.Valor) > 400;

-- 4. Listar pagamentos ordenados do maior para o menor
SELECT c.Nome, p.Valor, p.Forma_Pagamento
FROM Pagamento p
JOIN Cliente c ON p.Cliente_idCliente = c.idCliente
ORDER BY p.Valor DESC;

-- 5. Relatório de mecânicos e a quantidade de serviços realizados
SELECT m.Nome, COUNT(d.idDefeito) AS Servicos
FROM Mecanico m
LEFT JOIN Defeito_Veiculo d ON m.idMecanico = d.Mecanico_idMecanico
GROUP BY m.Nome
ORDER BY Servicos DESC;
