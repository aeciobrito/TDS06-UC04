CREATE DATABASE PizzariaDB;
GO

USE PizzariaDB;
GO

-- ----------------------------------------------------------------------------
-- 1. CRIAÇÃO DAS TABELAS (DDL)
-- ----------------------------------------------------------------------------

-- Tabela de Clientes
CREATE TABLE Clientes (
    id INT IDENTITY(1,1) NOT NULL,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    endereco VARCHAR(255) NULL,
    CONSTRAINT PK_Clientes PRIMARY KEY CLUSTERED (id),
    CONSTRAINT UQ_Clientes_Telefone UNIQUE (telefone)
);
GO

-- Tabela de Pizzas (Cardápio)
CREATE TABLE Pizzas (
    id INT IDENTITY(1,1) NOT NULL,
    sabor VARCHAR(50) NOT NULL,
    ingredientes VARCHAR(MAX) NULL,
    valor DECIMAL(10, 2) NOT NULL,
    CONSTRAINT PK_Pizzas PRIMARY KEY CLUSTERED (id),
    CONSTRAINT UQ_Pizzas_Sabor UNIQUE (sabor),
    CONSTRAINT CK_Pizzas_Valor CHECK (valor > 0)
);
GO

-- Tabela de Pedidos
CREATE TABLE Pedidos (
    id INT IDENTITY(1,1) NOT NULL,
    cliente_id INT NULL,
    data_hora DATETIME NOT NULL CONSTRAINT DF_Pedidos_DataHora DEFAULT GETDATE(),
    status VARCHAR(20) NOT NULL CONSTRAINT DF_Pedidos_Status DEFAULT 'Em preparo',
    valor_total DECIMAL(10, 2) NOT NULL CONSTRAINT DF_Pedidos_ValorTotal DEFAULT 0.00,
    CONSTRAINT PK_Pedidos PRIMARY KEY CLUSTERED (id),
    CONSTRAINT FK_Pedidos_Clientes 
        FOREIGN KEY (cliente_id) REFERENCES dbo.Clientes (id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);
GO

-- Tabela Associativa N:N (Itens do Pedido)
CREATE TABLE Pedido_Itens (
    pedido_id INT NOT NULL,
    pizza_id INT NOT NULL,
    quantidade INT NOT NULL CONSTRAINT DF_PedidoItens_Qtd DEFAULT 1,
    valor_unitario DECIMAL(10, 2) NOT NULL,
    CONSTRAINT PK_Pedido_Itens PRIMARY KEY CLUSTERED (pedido_id, pizza_id),
    CONSTRAINT FK_PedidoItens_Pedidos 
        FOREIGN KEY (pedido_id) REFERENCES dbo.Pedidos (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_PedidoItens_Pizzas 
        FOREIGN KEY (pizza_id) REFERENCES dbo.Pizzas (id)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    CONSTRAINT CK_PedidoItens_Quantidade CHECK (quantidade > 0),
    CONSTRAINT CK_PedidoItens_ValorUnitario CHECK (valor_unitario > 0)
);
GO

-- ----------------------------------------------------------------------------
-- 4. CARGA INICIAL DE DADOS (DML)
-- ----------------------------------------------------------------------------

-- Inserindo Clientes
INSERT INTO dbo.Clientes (nome, telefone, endereco) VALUES
('Ana Beatriz', '11988887777', 'Rua das Flores, 123'),
('Carlos Silva', '11977776666', 'Avenida Paulista, 1000'),
('Maria Souza', '21966665555', 'Praça da Sé, 456'),
('Bruno Mendes', '11955554444', 'Rua Augusta, 789');

-- Inserindo Cardápio
INSERT INTO dbo.Pizzas (sabor, ingredientes, valor) VALUES
('Calabresa', 'Molho de tomate, queijo mussarela, calabresa fatiada, cebola e azeitonas.', 45.00),
('Mussarela', 'Molho de tomate, queijo mussarela e orégano.', 40.00),
('Quatro Queijos', 'Molho de tomate, mussarela, parmesão, provolone e gorgonzola.', 55.00),
('Frango com Catupiry', 'Molho de tomate, frango desfiado, catupiry e milho.', 52.50),
('Portuguesa', 'Molho, mussarela, presunto, ovo, cebola, pimentão e azeitona.', 50.00);


-- Detalhes dos itens
SELECT 
    pi.pedido_id AS PedidoID,
    pz.sabor AS Pizza,
    pi.quantidade AS Qtd,
    pi.valor_unitario AS PrecoUnit,
    (pi.quantidade * pi.valor_unitario) AS Subtotal
FROM dbo.Pedido_Itens pi
INNER JOIN dbo.Pizzas pz ON pi.pizza_id = pz.id;
GO