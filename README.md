# 🚗 Banco de Dados - Oficina de Carros  

## 📌 Descrição  
Este projeto tem como objetivo implementar um banco de dados para uma **oficina mecânica**, permitindo o gerenciamento de:  

- **Clientes** e seus veículos  
- **Mecânicos** e suas especialidades  
- **Defeitos/Serviços** realizados em veículos  
- **Pagamentos** de serviços prestados  
- **Entregas** dos veículos aos clientes  

O banco foi construído com base em um **modelo entidade-relacionamento (ER)**, posteriormente transformado em **esquema lógico** e implementado em **MySQL**.  

---

## 📊 Modelo Conceitual (ER)  
O modelo conceitual foi desenvolvido para representar todas as entidades e relacionamentos da oficina.  

Entidades principais:  
- Cliente  
- Veículo  
- Mecânico  
- Defeito_Veiculo  
- Pagamento  
- Entrega  

Relacionamentos principais:  
- Cliente possui Veículo  
- Mecânico conserta Defeito  
- Cliente realiza Pagamento  
- Entrega está associada ao Cliente  

> Caso queira visualizar o diagrama ER:  
> `![Diagrama ER](Oficina.png)`  

---

## 🗂️ Modelo Lógico (Relacional)  
As tabelas foram normalizadas e construídas em MySQL.  

**Tabelas Criadas:**  
- `Cliente`  
- `Veiculo`  
- `Mecanico`  
- `Defeito_Veiculo`  
- `Pagamento`  
- `Entrega`  

Cada tabela possui chaves primárias, estrangeiras e restrições de integridade referencial.  

---

## ⚙️ Estrutura do Banco de Dados  

### 🔹 Criação do Banco e Tabelas
```sql
DROP DATABASE IF EXISTS Oficina;
CREATE DATABASE Oficina;
USE Oficina;

CREATE TABLE Cliente (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Endereco VARCHAR(150),
    Cartao VARCHAR(50),
    CPF VARCHAR(14) UNIQUE,
    Telefone VARCHAR(20)
);

CREATE TABLE Veiculo (
    idVeiculo INT AUTO_INCREMENT PRIMARY KEY,
    Modelo VARCHAR(50) NOT NULL,
    Placa VARCHAR(10) UNIQUE NOT NULL,
    Ano INT,
    Cor VARCHAR(30),
    Cliente_idCliente INT,
    FOREIGN KEY (Cliente_idCliente) REFERENCES Cliente(idCliente)
);

CREATE TABLE Mecanico (
    idMecanico INT AUTO_INCREMENT PRIMARY KEY,
    Codigo INT UNIQUE,
    Nome VARCHAR(100) NOT NULL,
    Endereco VARCHAR(150),
    Telefone VARCHAR(20),
    Especialidade VARCHAR(50)
);

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

CREATE TABLE Entrega (
    idEntrega INT AUTO_INCREMENT PRIMARY KEY,
    Status VARCHAR(50),
    Data DATE,
    Cliente_idCliente INT,
    FOREIGN KEY (Cliente_idCliente) REFERENCES Cliente(idCliente)
);
INSERT INTO Cliente (Nome, Endereco, Cartao, CPF, Telefone)
VALUES 
('João Martins', 'Rua A, 123', 'Visa', '111.111.111-11', '62999990000'),
('Maria Silva', 'Rua B, 456', 'MasterCard', '222.222.222-22', '62988887777');

INSERT INTO Veiculo (Modelo, Placa, Ano, Cor, Cliente_idCliente)
VALUES 
('Gol', 'ABC1234', 2015, 'Preto', 1),
('Civic', 'XYZ9876', 2020, 'Branco', 2);

INSERT INTO Mecanico (Codigo, Nome, Endereco, Telefone, Especialidade)
VALUES 
(101, 'Carlos Mecânico', 'Rua Oficina, 45', '62977776666', 'Motor'),
(102, 'Pedro Reparador', 'Av Mecânica, 12', '62966665555', 'Elétrica');

INSERT INTO Defeito_Veiculo (Descricao, Peca, Diagnostico, Tipo_Servico, Valor, Veiculo_idVeiculo, Mecanico_idMecanico)
VALUES 
('Troca de correia dentada', 'Correia', 'Correia gasta', 'Preventivo', 450.00, 1, 1),
('Troca de bateria', 'Bateria', 'Bateria descarregada', 'Substituição', 300.00, 2, 2);

INSERT INTO Pagamento (Valor, Promocao, Forma_Pagamento, Cliente_idCliente, Mecanico_idMecanico, Defeito_idDefeito)
VALUES
(450.00, 'Nenhuma', 'Cartão de Crédito', 1, 1, 1),
(300.00, 'Desconto 10%', 'Dinheiro', 2, 2, 2);

INSERT INTO Entrega (Status, Data, Cliente_idCliente)
VALUES
('Entregue', '2025-08-20', 1),
('Aguardando retirada', '2025-08-21', 2);
