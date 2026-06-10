# Documentação - Sistema de Chamados de Suporte

## Visão Geral

Este documento fornece um guia completo de uso e implementação do Sistema de Chamados de Suporte desenvolvido em Shell Script.

---

## Funcionalidades Principais

| Nível | Pontos | Status | Descrição |
|-------|--------|--------|-----------|
| Bronze | +0,5 | Sim | Confirmação antes de excluir registro |
| Prata | +1,0 | Sim | Autenticação por senha no início |
| Ouro | +1,5 | Sim | Backup automático dos dados ao sair |
| Diamante | +2,0 | Sim | Submenus + Estatísticas completas |

---

## Estrutura de Diretórios

```
Suporte/
├── suporte.sh                 # Script principal (executável)
├── DOCUMENTACAO.md            # Este arquivo
├── FLUXOGRAMA.md              # Fluxogramas visuais
├── RELATORIO_TECNICO.md       # Análise técnica
├── chamados/                  # Armazena chamados registrados
├── relatorios/                # Armazena relatórios gerados
└── backup/                    # Backup automático dos dados
```

---

## Como Executar

### Pré-requisitos
- Linux/Unix, Mac ou Git Bash/WSL no Windows
- Permissões de leitura e escrita

### Passos

1. Navegue até o diretório Suporte:
```bash
cd Suporte/
```

2. Dê permissão de execução ao script:
```bash
chmod +x suporte.sh
```

3. Execute o script:
```bash
bash suporte.sh
```

4. Digite a senha padrão quando solicitado:
```
Senha: 1234
```

---

## Menu Principal

```
SISTEMA DE CHAMADOS DE SUPORTE

Escolha uma opção:

  1 - Abrir chamado
  2 - Listar chamados
  3 - Pesquisar chamado
  4 - Fechar chamado
  5 - Relatório
  0 - Sair
```

---

## Funcionalidades em Detalhe

### 1. Abrir Chamado

Permite registrar um novo chamado no sistema.

**Campos obrigatórios:**
- Nome do cliente
- Descrição do problema
- Data de abertura (DD/MM/YYYY)

**Status padrão:** Aberto

**Exemplo:**
```
Nome do cliente: João Silva
Descrição do problema: Problema na internet
Data de abertura (DD/MM/YYYY): 10/06/2026

Chamado aberto com sucesso!
  Cliente: João Silva
  Problema: Problema na internet
  Data de Abertura: 10/06/2026
  Status: Aberto
```

### 2. Listar Chamados

Exibe todos os chamados registrados em uma tabela formatada.

**Exibição:**
```
╔═══╦════════════════════╦════════════════════╦═══════════╦═════════════════╗
║ # ║ Cliente            ║ Problema           ║ Data      ║ Status          ║
╠═══╬════════════════════╬════════════════════╬═══════════╬═════════════════╣
║ 1 ║ João Silva         ║ Problema internet  ║ 10/06/2026║ Aberto          ║
║ 2 ║ Maria Santos       ║ Erro no sistema    ║ 10/06/2026║ Em Andamento    ║
╚═══╩════════════════════╩════════════════════╩═══════════╩═════════════════╝
```

### 3. Pesquisar Chamado

Busca chamados por critério específico.

**Critérios disponíveis:**
- 1: Por Cliente
- 2: Por Problema
- 3: Por Data
- 4: Por Status

**Exemplo (Pesquisar por Cliente):**
```
Digite o nome do cliente: João Silva
Total de resultados: 1
```

### 4. Fechar Chamado

Remove um chamado do sistema com confirmação.

**Processo:**
1. Solicita o nome do cliente
2. Exibe o chamado a ser fechado
3. Pede confirmação [s/n]
4. Realiza backup antes de remover
5. Remove o chamado

**Confirmação:**
```
Deseja realmente fechar este chamado? [s/n]: s
Chamado fechado com sucesso!
```

### 5. Relatório

Gera estatísticas completas dos chamados.

**Informações exibidas:**
- Total de chamados
- Contagem por status
- Status mais frequente
- Chamados por data
- Detalhamento completo em tabela
- Opção de exportar para arquivo

**Exemplo:**
```
ESTATÍSTICAS GERAIS
Total de chamados: 5

CHAMADOS POR STATUS:
  Aberto            :  2 chamado(s)
  Em Andamento      :  2 chamado(s)
  Fechado           :  1 chamado(s)

STATUS MAIS FREQUENTE:
  Aberto (2 chamados)
```

---

## Validações Implementadas

 - Campos obrigatórios não podem estar vazios
 - Data deve estar no formato DD/MM/YYYY
 - Dias devem estar entre 01-31
 - Meses devem estar entre 01-12
 - Menus com validação de opções
 - Confirmação antes de fechar chamados

---

## Variáveis Importantes

| Variável | Significado | Valor Padrão |
|----------|-------------|--------------|
| SCRIPT_DIR | Diretório do script | Automático |
| CHAMADOS_DIR | Diretório de chamados | ./chamados |
| RELATORIOS_DIR | Diretório de relatórios | ./relatorios |
| BACKUP_DIR | Diretório de backup | ./backup |
| ARQUIVO_CHAMADOS | Arquivo de dados | chamados/chamados.txt |
| SENHA_PADRAO | Senha de acesso | 1234 |
| USUARIO_LOGADO | Status de autenticação | false |

---

## Melhorias Futuras

- Editar chamados existentes
- Atribuir técnico responsável
- Sistema de prioridade
- Histórico de ações
- Integração com email
- Interface gráfica (GUI)
- Banco de dados (SQLite/MySQL)
- API REST para integração

---

## Checklist de Entrega

 - Variáveis e escopo local
 - Funções e modularização
 - Estruturas de controle (if/case/while)
 - Entrada/saída formatada
 - Processamento de arquivos
 - Tratamento de erros
 - Validação de dados
 - Backup e recuperação
 - Segurança (autenticação)
 - Interface amigável

---

## Suporte e Dúvidas

Para questões sobre o funcionamento do sistema, consulte:
- FLUXOGRAMA.md (para visualizar fluxos)
- RELATORIO_TECNICO.md (para detalhes técnicos)
- Código comentado em suporte.sh

---

**Versão:** 1.0
**Data:** 10/06/2026
**Autor:** Grupo 4 - Disciplina Shell Script
**Total de Pontos:** Obrigatório + 5.0 extras
