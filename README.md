# Sistema de Agendamento de Consultas - Shell Script

## Visão Geral

Sistema completo de gerenciamento de consultas médicas desenvolvido em **Shell Script**, implementando todos os conceitos fundamentais de programação shell e critérios extras de pontuação.

**Grupo 6** - Disciplina: Shell Script  
**Status:** Completo e Pronto para Apresentação  
**Data:** 08/06/2026

---

## Objetivo

Desenvolver um sistema de gerenciamento de consultas que demonstre:
- Manipulação de variáveis
- Entrada/saída de dados
- Estruturas condicionais e de repetição
- Menu interativo com loop principal
- Organização profissional de diretórios

---

## Como Executar

### Pré-requisitos
- Linux/Unix ou **Git Bash/WSL no Windows**
- Permissões de leitura/escrita

### Execução

```bash
cd Clinica/
bash clinica.sh
```

**Senha padrão:** `1234`

---

## Funcionalidades Principais

| # | Funcionalidade | Status | Descrição |
|---|---|---|---|
| 1 | **Agendar Consulta** | Sim | Registra paciente, médico, data e horário com validações |
| 2 | **Listar Consultas** | Sim | Exibe todas as consultas em tabela formatada |
| 3 | **Pesquisar Consulta** | Sim | Busca por paciente, médico ou data (case-insensitive) |
| 4 | **Cancelar Consulta** | Sim | Remove consulta com confirmação e backup automático |
| 5 | **Relatório** | Sim | Estatísticas completas e exportação em arquivo |

---

## Critérios de Pontuação Extras Implementados

```
BRONZE    (+0,5 ponto)  - Confirmação antes de cancelar
PRATA     (+1,0 ponto)  - Autenticação por senha
OURO      (+1,5 pontos) - Backup automático ao sair
DIAMANTE  (+2,0 pontos) - Submenus + Estatísticas

TOTAL: +5,0 pontos extras!
```

---

## Estrutura do Projeto

```
Projeto_Shell_Consulta/
├── README.md                          # Este arquivo
├── RESUMO_ENTREGA.md                  # Resumo executivo do projeto
├── .gitignore                         # Configuração Git
│
└── Clinica/
   ├── clinica.sh                     # SCRIPT PRINCIPAL (executável)
    │
   ├── DOCUMENTAÇÃO
    ├── DOCUMENTACAO.md                # Guia de uso completo
    ├── FLUXOGRAMA.md                  # Fluxogramas visuais do sistema
    ├── RELATORIO_TECNICO.md           # Análise técnica detalhada
    │
   ├── DIRETÓRIOS DE DADOS
    ├── consultas/                     # Armazena dados de consultas
    ├── relatorios/                    # Armazena relatórios gerados
    └── backup/                        # Armazena backups automáticos
```

---

## 🔍 Demonstração Rápida

### 1. Login
```
Digite a senha para acessar o sistema: ****
Autenticação bem-sucedida!
```

### 2. Menu Principal
```
SISTEMA DE AGENDAMENTO DE CONSULTAS

Escolha uma opção:

   1 - Agendar consulta
   2 - Listar consultas
   3 - Pesquisar consulta
   4 - Cancelar consulta
   5 - Relatório
   0 - Sair
```

### 3. Agendar Consulta
```
=== AGENDAR CONSULTA ===

Nome do paciente: João Silva
Nome do médico: Dr. Carlos
Data (DD/MM/YYYY): 25/12/2026
Horário (HH:MM): 14:30

Consulta agendada com sucesso!
  Paciente: João Silva
  Médico: Dr. Carlos
  Data: 25/12/2026
  Horário: 14:30
```

### 4. Listar Consultas
```
╔═══╦════════════════════╦════════════════════╦═══════════╦═════════╗
║ # ║ Paciente           ║ Médico             ║ Data      ║ Horário ║
╠═══╬════════════════════╬════════════════════╬═══════════╬═════════╣
║ 1 ║ João Silva         ║ Dr. Carlos         ║ 25/12/2026║ 14:30   ║
║ 2 ║ Maria Santos       ║ Dra. Patricia      ║ 25/12/2026║ 15:00   ║
╚═══╩════════════════════╩════════════════════╩═══════════╩═════════╝
```

---

## Tecnologias e Técnicas Utilizadas

### Shell Script Avançado
- **Variáveis e Arrays:** Gerenciamento de estado e dados
- **Funções:** Modularização de código (8 funções principais)
- **Controle de Fluxo:** if/then/else, while, for, case/esac
- **Processamento de Texto:** grep, awk, cut, sort, uniq
- **Validações:** Regex para data e horário
- **Formatação:** Cores ANSI, tabelas Unicode

### Segurança
- Autenticação com senha (read -sp - entrada segura)
- Validação de entrada robusta
- Limite de tentativas de login (3x)
- Backup de dados antes de deletar

### Usabilidade
- Interface colorida e intuitiva
- Mensagens de erro/sucesso claras
- Tabelas bem formatadas
- Confirmação antes de ações destrutivas

---

## Checklist de Requisitos

### Obrigatórios
- [x] Variáveis de ambiente e locais
- [x] Entrada de dados (read)
- [x] Saída de dados (echo)
- [x] Estruturas condicionais (if/else/fi)
- [x] Estruturas de repetição (while/for)
- [x] Menu interativo com loop
- [x] Agendar, Listar, Pesquisar, Cancelar, Relatório
- [x] Dados: Paciente, Médico, Data, Horário
- [x] Estrutura de diretórios: consultas/, relatorios/, backup/

### Bônus (Pontuação Extra)
 - [x] Bronze: Confirmação antes de excluir
 - [x] Prata: Autenticação por senha
 - [x] Ouro: Backup automático
 - [x] Diamante: Submenus + Estatísticas

### Entrega
- [x] Fluxograma (FLUXOGRAMA.md)
- [x] Código comentado (clinica.sh)
- [x] Estrutura de diretórios
- [x] Execução completa de funcionalidades
- [x] Relatório técnico (RELATORIO_TECNICO.md)

---

## 👥 Autores

**Grupo 6 - Disciplina Shell Script**

---

## 📝 Notas Importantes

1. **Permissão de Execução:**
   ```bash
   chmod +x Clinica/clinica.sh
   ```

2. **Ambiente WSL/Git Bash:**
   Este projeto foi desenvolvido para rodar em ambientes Unix/Linux. Para Windows:
   - Git Bash
   - WSL (Windows Subsystem for Linux)
   - MSYS2

3. **Dados Persistentes:**
   Os dados são armazenados em arquivos de texto simples (sem banco de dados), permitindo fácil backup e portabilidade.

4. **Backup Automático:**
   Ao encerrar o sistema (opção 0), um backup automático é criado em `backup/`

---

## Conceitos Aprendidos

Este projeto demonstra:
- Programação estruturada em Shell Script
- Manipulação de arquivos de texto
- Processamento com ferramentas Unix (grep, awk, sed)
- Design de interface de usuário em terminal
- Segurança básica (senhas, validação)
- Documentação de código
- Versionamento com Git

---

**Desenvolvido em Shell Script**  
**Pronto para apresentação e avaliação!**