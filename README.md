# UC4: Administrar e Implantar Servidores de Banco de Dados

- **Carga Horária**: **84 HORAS** (24 aulas de 3h30min)
- **Horário**: 19:00 às 22:30
- **Instituição**: Senac Lapa Tito - Curso Técnico em Desenvolvimento de Sistemas (TDS)

---

## Estrutura Padrão Diária da Aula (Gerenciamento de Tempo)

Em conformidade com as diretrizes da UC, cada aula de 3h30min segue o seguinte ciclo metodológico:

| Bloco | Horário | Etapa Metodológica | Descrição das Atividades |
|---|---|---|---|
| **1** | 19:00 - 19:30 | **Acolhimento e Revisão** | Recepção dos alunos, tolerância de chegada (20 min), revisão dos conceitos da aula anterior, atendimento individual de dúvidas e aquecimento. |
| **2** | 19:30 - 20:00 | **Exposição Prática** | Apresentação clara, objetiva e visual do conceito central do dia, demonstrado diretamente no SGBD pelo professor (sem slides longos). |
| **3** | 20:00 - 20:30 | **Problema Guiado** | Resolução em tempo real de um caso de uso prático com participação ativa da turma. |
| **4** | 20:30 - 20:45 | **Intervalo** | Pausa de 15 minutos para descanso. |
| **5** | 20:45 - 22:00 | **Laboratório "Mão na Massa"** | Desenvolvimento autônomo de atividade prática/desafio individual ou em duplas. O professor circula auxiliando. |
| **6** | 22:00 - 22:30 | **Correção Coletiva e Fechamento** | Demonstração do gabarito em tela, consolidação do aprendizado, feedback imediato e alinhamento para a próxima aula. |

> **Nota para os Alunos que Saem Mais Cedo**: O bloco final de correção inicia rigorosamente às 22:00 para garantir que todos tenham acesso ao gabarito antes de saídas antecipadas por questões de transporte.

## Documentos De Referencia

- **[Tutorial de Scaffold DB-First no Visual Studio 2022](scaffold-visuastudio2022/tutorial-scaffold.md)**: Passo a passo visual documentado com capturas de tela para conectar aplicações ASP.NET Core ao banco de dados sem necessidade de programar código C#.


---

## Indicadores de Competência

1. **Planeja rotinas de backup e restore** da base de dados, conforme especificações técnicas do sistema gerenciador de banco de dados (SGBD).
2. **Planeja e escreve rotinas de procedimentos armazenados e triggers**, de acordo com especificações da aplicação de acesso ao banco.
3. **Desenvolve roteiro de segurança para os dados**, de acordo com normas técnicas, políticas de segurança e melhores práticas em vigor.
4. **Aplica regras de proteção de dados** às informações armazenadas no banco, de acordo com a Lei Geral de Proteção de Dados (LGPD).
5. **Elabora práticas de monitoramento de performance**, conforme as funcionalidades e características do SGBD.
6. **Configura o ambiente de implantação do SGBD e banco de dados**, conforme as capacidades de hardware do servidor e storage necessárias ao projeto de sistema.

---

## Conhecimentos

- Criação, atualização e manipulação de Procedimentos Armazenados (Stored Procedures); Emprego de Triggers (Gatilhos); Codificação de Funções Definidas pelo Usuário (UDF).
- Segurança do banco de dados: segurança da informação (conceito e políticas de acesso, Lei Geral de Proteção de Dados Pessoais - LGPD, redundância, concorrência, integridade e consistência; criptografia; criação de Usuários e autenticação; falhas; ameaças).
- Política de recuperação de dados em programação: Segurança da informação, análise periódica, procedimentos de backup e restore.
- Monitoramento: criação de Indicadores de Performance. Tuning e Tarefas de Desempenho. Indexação. Otimização de Consultas. Plano de Execução (Execution Plan). Erros e Log de Eventos.
- Hardware e Storage: Armazenamento do Banco de Dados. MTBF. RAID. Redundância de Servidores. Downtime e Disponibilidade. Tolerância a Falhas e Alta Disponibilidade.
- Acesso remoto ao banco de dados via rede local e Internet.
- Definição e contraste com Bancos NoSQL.

---

## Habilidades

- Aplicar atualizações de segurança em sistemas.
- Monitorar banco de dados.
- Selecionar informações necessárias ao desenvolvimento do seu trabalho.
- Analisar as etapas do processo de trabalho.
- Interpretar textos técnicos.
- Comunicar-se de maneira assertiva.
- Mediar conflitos nas situações de trabalho.

---

## Guia Rápido de Configuração Local

### Conexão ao SQL Server em LocalDb:
```
(localdb)\MSSQLLocalDB
```

### Scaffold no Console do Gerenciador de Pacotes (Visual Studio):
```powershell
Scaffold-DbContext "Server=(localdb)\MSSQLLocalDB;Database=SEUBANCO_DB;Trusted_Connection=True;TrustServerCertificate=True;" Microsoft.EntityFrameworkCore.SqlServer -OutputDir Models
```

### Connection String para LocalDb no `appsettings.json`:
```json
"ConnectionStrings": {
  "DefaultConnection": "Server=(localdb)\\MSSQLLocalDB;Database=SEUBANCO_DB;Trusted_Connection=True;TrustServerCertificate=True;"
}
```

### Registro no `Program.cs`:
```csharp
using Microsoft.EntityFrameworkCore;
using Teste.Models;

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<ClassDbContext>(options =>
    options.UseSqlServer(connectionString));
```
