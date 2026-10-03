--DEFAULT()
--PRA TEXTO, SUBSTITUIÇÃO POR 'X'
--INT, TROCA POR 0
--DATETIME, TROCA PRO 1900 00:00:00
USE EstacionamentoDB
GO

ALTER TABLE clientes
ALTER COLUMN cpf ADD MASKED WITH (FUNCTION = 'partial(3, "XXXXX", 0)');

ALTER TABLE clientes
ALTER COLUMN telefone ADD MASKED WITH (FUNCTION = 'default()');

SELECT * FROM Clientes

-- Perfis
CREATE ROLE Role_AtendimentoPatio;
CREATE ROLE Role_FiscalDaReceita; -- add

CREATE USER usr_operador_caixa WITHOUT LOGIN;
CREATE USER usr_vigilante WITHOUT LOGIN;

CREATE USER usr_fiscal_contabil WITHOUT LOGIN; -- add

ALTER ROLE Role_AtendimentoPatio ADD MEMBER usr_operador_caixa;
ALTER ROLE Role_AtendimentoPatio ADD MEMBER usr_vigilante;

ALTER ROLE Role_FiscalDaReceita ADD MEMBER usr_fiscal_contabil; --add

GRANT UNMASK TO Role_FiscalDaReceita;
GO

GRANT SELECT ON clientes TO Role_AtendimentoPatio;
GRANT SELECT ON clientes TO Role_FiscalDaReceita; --add

-- Testes
EXECUTE AS USER =  'usr_fiscal_contabil';

SELECT * FROM Clientes;

REVERT;
GO