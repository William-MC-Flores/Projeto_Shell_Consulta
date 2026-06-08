# 🏥 SISTEMA DE AGENDAMENTO DE CONSULTAS

## 📖 Documentação do Sistema

Sistema completo de gerenciamento de consultas médicas desenvolvido em Shell Script, com funcionalidades de agendamento, listagem, pesquisa, cancelamento e geração de relatórios.

---

## 🚀 Como Executar

### Pré-requisitos
- Sistema operacional Unix/Linux ou Git Bash no Windows
- Shell Bash
- Permissões de leitura/escrita no diretório do projeto

### Executar o Sistema

```bash
cd Clinica/
bash clinica.sh
```

**Ou, se desejar dar permissão de execução:**

```bash
chmod +x Clinica/clinica.sh
./Clinica/clinica.sh
```

---

## 🔐 Autenticação

**Senha padrão:** `1234`

O sistema solicita autenticação ao iniciar. Você tem até 3 tentativas para inserir a senha correta.

---

## 📋 Funcionalidades Principais

### 1️⃣ Agendar Consulta
- Registrar paciente, médico, data e horário
- Validação automática de formato (DD/MM/YYYY para data, HH:MM para horário)
- Validação de campos obrigatórios
- Confirmação visual dos dados agendados

### 2️⃣ Listar Consultas
- Exibir todas as consultas agendadas em tabela formatada
- Numeração sequencial
- Campos: Paciente, Médico, Data, Horário
- Mensagem se nenhuma consulta existir

### 3️⃣ Pesquisar Consulta
- Busca por três filtros:
  - Paciente
  - Médico  
  - Data
- Busca case-insensitive (maiúsculas/minúsculas indiferentes)
- Exibição dos resultados em tabela
- Contagem total de resultados

### 4️⃣ Cancelar Consulta
- Localizar consulta por paciente
- Exibir dados antes de cancelar
- Solicitar confirmação [s/n] (BRONZE)
- Backup automático de consultas canceladas

### 5️⃣ Relatório
- **Estatísticas gerais:**
  - Total de consultas
  - Contagem por médico
  - Médico com mais consultas
  - Distribuição por data
- **Detalhamento completo** em tabela
- **Opção de exportar relatório** em arquivo .txt
- Data/hora de geração inclusos

---

## ⭐ Critérios de Pontuação Extras Implementados

| Nível | Pontos | Status | Requisito |
|-------|--------|--------|-----------|
| 🥉 Bronze | +0,5 | ✅ | Confirmação antes de excluir registro |
| 🥈 Prata | +1,0 | ✅ | Autenticação por senha no início |
| 🥇 Ouro | +1,5 | ✅ | Backup automático dos dados ao sair |
| 💎 Diamante | +2,0 | ✅ | Submenus + Estatísticas completas |

**Total de Pontos Extras: +5,0 pontos**

---

## 📁 Estrutura de Diretórios

```
Clinica/
├── clinica.sh                 # Script principal executável
├── consultas/
│   ├── .gitkeep
│   └── consultas.txt          # Banco de dados de consultas (criado ao usar)
├── relatorios/
│   ├── .gitkeep
│   └── relatorio_*.txt        # Relatórios exportados
└── backup/
    ├── .gitkeep
    ├── backup_consultas_*.txt # Backups automáticos (ao sair)
    └── consultas_canceladas_*.bak  # Backups de cancelamentos
```

---

## 💾 Formato de Dados

As consultas são armazenadas em arquivo `.txt` com formato simples delimitado por `|`:

```
Paciente|Médico|Data|Horário
```

### Exemplo:
```
João Silva|Dr. Carlos|25/12/2026|14:30
Maria Santos|Dra. Ana|26/12/2026|09:00
```

---

## 🛡️ Validações Implementadas

- ✅ Campos obrigatórios não podem estar vazios
- ✅ Data deve estar no formato DD/MM/YYYY
- ✅ Dias devem estar entre 01-31
- ✅ Meses devem estar entre 01-12
- ✅ Horário deve estar no formato HH:MM
- ✅ Horas devem estar entre 00-23
- ✅ Minutos devem estar entre 00-59
- ✅ Menus com validação de opções
- ✅ Confirmação antes de cancelar consultas

---

## 🎨 Interface Visual

O sistema utiliza:
- **Cores ANSI** para melhor legibilidade
  - 🟢 Verde: Mensagens de sucesso
  - 🔵 Azul: Informações e bordas
  - 🟡 Amarelo: Avisos
  - 🔴 Vermelho: Erros
- **Tabelas formatadas** com bordas Unicode
- **Menus numerados** para fácil navegação
- **Clear screen** para melhor organização

---

## 🔧 Variáveis Importantes

| Variável | Descrição |
|----------|-----------|
| `SCRIPT_DIR` | Diretório raiz do script |
| `CONSULTAS_DIR` | Pasta de consultas |
| `RELATORIOS_DIR` | Pasta de relatórios |
| `BACKUP_DIR` | Pasta de backups |
| `ARQUIVO_CONSULTAS` | Arquivo de banco de dados |
| `SENHA_PADRAO` | Senha de autenticação (1234) |

---

## 📝 Commits Realizados

1. **init**: Estrutura de diretórios
2. **feat**: Menu interativo base
3. **feat**: Função agendar com validações
4. **feat**: Função listar com tabela
5. **feat**: Função pesquisar com filtros
6. **feat**: Função cancelar com confirmação (BRONZE)
7. **feat**: Função relatório com estatísticas (DIAMANTE)
8. **feat(prata)**: Autenticação por senha
9. **feat(ouro)**: Backup automático

---

## 🐛 Tratamento de Erros

O sistema implementa:
- Verificação de campos vazios
- Validação de formatos
- Tratamento de limites de tentativas
- Mensagens de erro descritivas
- Recovery gracioso em caso de falhas

---

## 🚀 Melhorias Futuras

- [ ] Importar consultas de arquivo
- [ ] Editar consultas existentes
- [ ] Sistema de lembretes automáticos
- [ ] Integração com email
- [ ] Interface gráfica (GUI)
- [ ] Suporte a múltiplos usuários
- [ ] Banco de dados SQL

---

## 📞 Contato

**Projeto:** Grupo 6 - Disciplina Shell Script  
**Data:** Junho de 2026

---

## 📋 Checklist de Entrega

- [x] Fluxograma do sistema
- [x] Código-fonte comentado
- [x] Estrutura de diretórios criada
- [x] Execução completa de funcionalidades
- [x] Relatório técnico (este arquivo)
- [x] Commits bem organizados no Git

---

**Última atualização:** 08/06/2026
