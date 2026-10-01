## Documento Técnico: Roteiro de Segurança (`EstacionamentoDB`)

### 1. Identificação dos Ativos Críticos

* `dbo.Clientes`: Contém dados sensíveis protegidos por conformidade/LGPD (CPF, Telefone, Nome).


* `dbo.RegistrosEstacionamento`: Tabela contábil e de movimentação de veículos e valores faturados.


* `dbo.Vagas` e `dbo.Veiculos`: Metadados operacionais.



---

### 2. Matriz de Acesso RBAC

| Objeto / Recurso | Role: `role_app_cancela` | Role: `role_operador_patio` | Role: `role_gerente` |
| --- | --- | --- | --- |
| `dbo.Clientes` | SELECT | SELECT, INSERT | SELECT, INSERT, UPDATE |
| `dbo.Veiculos` | SELECT | SELECT, INSERT | SELECT, INSERT, UPDATE |
| `dbo.Vagas` | SELECT | SELECT | SELECT, INSERT, UPDATE |
| `dbo.RegistrosEstacionamento` | **Nenhum acesso direto** | SELECT | SELECT, INSERT, UPDATE |
| **Procedures de Entrada/Saída** | EXECUTE | EXECUTE | EXECUTE |
| **Comando DELETE (Qualquer tabela)** | **DENY** | **DENY** | **DENY** (Apenas arquivamento) |

---

### 3. Script SQL de Implementação do Hardening

```sql
USE master;
GO

-- ============================================================================
-- 1. CRIAÇÃO DOS LOGINS DE SERVIÇO E USUÁRIOS HUMANOS
-- ============================================================================
CREATE LOGIN login_totem_cancela 
WITH PASSWORD = 'Totem#Seguro2026!', 
     CHECK_POLICY = ON, 
     DEFAULT_DATABASE = EstacionamentoDB;

CREATE LOGIN login_operador 
WITH PASSWORD = 'Operador#Patio2026!', 
     CHECK_POLICY = ON, 
     DEFAULT_DATABASE = EstacionamentoDB;

CREATE LOGIN login_gestor 
WITH PASSWORD = 'Gestor#Master2026!', 
     CHECK_POLICY = ON, 
     DEFAULT_DATABASE = EstacionamentoDB;
GO

-- ============================================================================
-- 2. VINCULAÇÃO DE USUÁRIOS NO BANCO DE DADOS
-- ============================================================================
USE EstacionamentoDB;
GO

CREATE USER usr_totem_cancela FOR LOGIN login_totem_cancela;
CREATE USER usr_operador FOR LOGIN login_operador;
CREATE USER usr_gestor FOR LOGIN login_gestor;
GO

-- ============================================================================
-- 3. CRIAÇÃO DAS ROLES DA APLICAÇÃO (RBAC)
-- ============================================================================
CREATE ROLE role_app_cancela;
CREATE ROLE role_operador_patio;
CREATE ROLE role_gerente;
GO

-- Inclusão dos usuários nas respectivas roles
ALTER ROLE role_app_cancela ADD MEMBER usr_totem_cancela;
ALTER ROLE role_operador_patio ADD MEMBER usr_operador;
ALTER ROLE role_gerente ADD MEMBER usr_gestor;
GO

-- ============================================================================
-- 4. CONCESSÃO E BLOQUEIO DE PRIVILÉGIOS (LEAST PRIVILEGE)
-- ============================================================================

-- A. Configurações da Role da Cancela (Totem automatizado)
-- Consulta básica para validar placa e vaga livre
GRANT SELECT ON dbo.Veiculos TO role_app_cancela;
GRANT SELECT ON dbo.Vagas TO role_app_cancela;

-- Dispara entrada e saída apenas via Stored Procedures controladas
GRANT EXECUTE ON dbo.sp_RegistrarEntradaVeiculo TO role_app_cancela;
GRANT EXECUTE ON dbo.sp_RegistrarSaidaVeiculo TO role_app_cancela;

-- B. Configurações da Role Operador de Pátio
GRANT SELECT, INSERT ON dbo.Clientes TO role_operador_patio;
GRANT SELECT, INSERT ON dbo.Veiculos TO role_operador_patio;
GRANT SELECT ON dbo.Vagas TO role_operador_patio;
GRANT SELECT ON dbo.RegistrosEstacionamento TO role_operador_patio;
GRANT EXECUTE ON dbo.sp_RegistrarEntradaVeiculo TO role_operador_patio;
GRANT EXECUTE ON dbo.sp_RegistrarSaidaVeiculo TO role_operador_patio;

-- C. Configurações da Role Gerente
GRANT SELECT, INSERT, UPDATE ON dbo.Clientes TO role_gerente;
GRANT SELECT, INSERT, UPDATE ON dbo.Veiculos TO role_gerente;
GRANT SELECT, INSERT, UPDATE ON dbo.Vagas TO role_gerente;
GRANT SELECT, INSERT, UPDATE ON dbo.RegistrosEstacionamento TO role_gerente;
GRANT EXECUTE ON dbo.sp_RegistrarEntradaVeiculo TO role_gerente;
GRANT EXECUTE ON dbo.sp_RegistrarSaidaVeiculo TO role_gerente;

-- ============================================================================
-- 5. BLINDAGEM CONTRA EXCLUSÃO ACIDENTAL OU MALICIOSA (DENY)
-- ============================================================================
-- Ninguém apaga registros históricos de uso ou tabelas operacionais
DENY DELETE ON dbo.RegistrosEstacionamento TO role_app_cancela;
DENY DELETE ON dbo.RegistrosEstacionamento TO role_operador_patio;
DENY DELETE ON dbo.RegistrosEstacionamento TO role_gerente;

DENY DELETE ON dbo.Clientes TO role_app_cancela;
DENY DELETE ON dbo.Clientes TO role_operador_patio;
GO

```

---

### 4. Checklist de Hardening Recomendado


**Encapsulamento de DML em Procedures**: Nenhuma aplicação externa possui permissão direta de `INSERT` ou `UPDATE` na tabela `RegistrosEstacionamento`; o acesso ocorre exclusivamente através de procedures com parâmetros tipados.


**Isolamento de Rede da Instância**: O SQL Server deve aceitar conexões apenas locais (`localhost`) ou via rede interna/VPN, mantendo portas padrão (ex.: TCP 1433) fechadas para a internet pública.