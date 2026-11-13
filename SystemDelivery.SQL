-- Projeto de banco de dados para um sistema de delivery
-- SGBD: MySQL 8+
-- Os dados abaixo são exemplos fictícios para estudo.

CREATE DATABASE IF NOT EXISTS db_delivery
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE db_delivery;

CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefone VARCHAR(20),
    cidade VARCHAR(50)
);

CREATE TABLE produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    estoque INT NOT NULL
);

CREATE TABLE pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    id_produto INT,
    quantidade INT NOT NULL,
    data_pedido DATE,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE SET NULL,
    FOREIGN KEY (id_produto) REFERENCES produtos(id_produto) ON DELETE SET NULL
);

CREATE TABLE entregas (
    id_entrega INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    entregador VARCHAR(100) NOT NULL,
    endereco_entrega VARCHAR(200) NOT NULL,
    status_entrega ENUM('Pendente', 'Em rota', 'Entregue', 'Cancelada') DEFAULT 'Pendente',
    valor_frete DECIMAL(6, 2) DEFAULT 5.00,
    data_saida DATETIME,
    data_entrega DATETIME,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido) ON DELETE CASCADE
);

INSERT INTO clientes (nome, email, telefone, cidade) VALUES
('Ana Silva', 'ana@delivery.com', '11999990001', 'São Paulo'),
('Bruno Santos', 'bruno@delivery.com', '11999990002', 'Campinas'),
('Carlos Lima', 'carlos@delivery.com', '21999990003', 'João Pessoa'),
('Daniela Souza', 'daniela@delivery.com', '31999990004', 'Belo Horizonte'),
('Eduardo Costa', 'eduardo@delivery.com', '41999990005', 'Curitiba'),
('Fernanda Dias', 'fernanda@delivery.com', '51999990006', 'Porto Alegre'),
('Gabriel Alves', 'gabriel@delivery.com', '61999990007', 'Brasília'),
('Heloísa Rocha', 'heloisa@delivery.com', '71999990008', 'Salvador'),
('Igor Mendes', 'igor@delivery.com', '81999990009', 'Recife'),
('Juliana Melo', 'juliana@delivery.com', '85999990010', 'Fortaleza');

INSERT INTO produtos (descricao, preco, estoque) VALUES
('X-Burguer Artesanal', 28.50, 50),
('Pizza Calabresa Grande', 45.00, 30),
('Batata Frita Suprema', 18.00, 100),
('Combo Temaki + Sunomono', 39.90, 40),
('Açaí Turbinado 500ml', 22.00, 60),
('Refrigerante Lata 350ml', 6.00, 200),
('Suco Natural Laranja 1L', 14.00, 80),
('Porção de Pastéis (6 un)', 24.00, 45),
('Brownie de Chocolate', 8.50, 70),
('Marmitex Executiva Frango', 25.00, 35);

INSERT INTO pedidos (id_cliente, id_produto, quantidade, data_pedido) VALUES
(1, 1, 2, '2026-11-01'),
(2, 2, 1, '2026-11-01'),
(3, 3, 1, '2026-11-02'),
(4, 4, 2, '2026-11-02'),
(5, 5, 1, '2026-11-03'),
(6, 6, 3, '2026-11-03'),
(7, 7, 1, '2026-11-04'),
(8, 8, 2, '2026-11-04'),
(9, 9, 4, '2026-11-05'),
(10, 10, 1, '2026-11-05');

INSERT INTO entregas (
    id_pedido, entregador, endereco_entrega, status_entrega,
    valor_frete, data_saida, data_entrega
) VALUES
(1, 'Marcos Oliveira', 'Rua das Flores, 120 - São Paulo', 'Entregue', 5.00, '2026-11-01 19:00:00', '2026-11-01 19:35:00'),
(2, 'Paulo Henrique', 'Av. Brasil, 450 - Campinas', 'Entregue', 6.00, '2026-11-01 20:10:00', '2026-11-01 20:50:00'),
(3, 'Lucas Ferreira', 'Rua Copacabana, 88 - Rio de Janeiro', 'Entregue', 7.50, '2026-11-02 12:30:00', '2026-11-02 13:05:00'),
(4, 'Rafael Gomes', 'Av. Afonso Pena, 900 - Belo Horizonte', 'Entregue', 5.50, '2026-11-02 19:45:00', '2026-11-02 20:20:00'),
(5, 'Thiago Martins', 'Rua XV de Novembro, 300 - Curitiba', 'Entregue', 5.00, '2026-11-03 13:00:00', '2026-11-03 13:30:00'),
(6, 'Marcos Oliveira', 'Rua dos Andradas, 75 - Porto Alegre', 'Entregue', 6.50, '2026-11-03 18:20:00', '2026-11-03 18:55:00'),
(7, 'Paulo Henrique', 'SQS 308, Bloco B - Brasília', 'Cancelada', 8.00, NULL, NULL),
(8, 'Lucas Ferreira', 'Av. Sete de Setembro, 210 - Salvador', 'Em rota', 7.00, '2026-11-04 20:00:00', NULL),
(9, 'Rafael Gomes', 'Rua da Aurora, 55 - Recife', 'Em rota', 6.00, '2026-11-05 19:15:00', NULL),
(10, 'Thiago Martins', 'Av. Beira Mar, 1000 - Fortaleza', 'Pendente', 9.00, NULL, NULL);

-- Consulta de exemplo: pedidos, clientes, produtos e status da entrega.
SELECT
    c.nome AS cliente,
    pr.descricao AS produto,
    e.entregador,
    e.status_entrega,
    e.valor_frete,
    e.data_entrega
FROM entregas AS e
INNER JOIN pedidos AS p ON e.id_pedido = p.id_pedido
INNER JOIN clientes AS c ON p.id_cliente = c.id_cliente
INNER JOIN produtos AS pr ON p.id_produto = pr.id_produto;
