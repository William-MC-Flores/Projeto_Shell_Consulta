# RELATÓRIO TÉCNICO - IMPLEMENTAÇÃO

## Sumário Executivo

Sistema de Agendamento de Consultas em Shell Script com funcionalidades completas de gerenciamento, incluindo todas as requisições obrigatórias e critérios extras de pontuação.

---

## Elementos Obrigatórios Implementados

| Elemento | Status | Localização |
|----------|--------|-------------|
| Variáveis | Sim | Linhas 14-23 |
| Entrada de dados | Sim | `read`, `read -sp` |
| Saída de dados | Sim | `echo -e` com cores |
| Estrutura condicional | Sim | `if/then/else/fi` |
| Estrutura de repetição | Sim | `while true`, `for`, loops |
| Menu interativo | Sim | Loop com `case/esac` |

---

## Funcionalidades Implementadas

### 1. Agendar Consulta
**Funções relacionadas:**
- `validar_data()` - Valida formato DD/MM/YYYY
- `validar_horario()` - Valida formato HH:MM  
- `agendar_consulta()` - Função principal (linhas ~143-180)

**Lógica:**
```
1. Ler Nome Paciente (validar vazio)
2. Ler Nome Médico (validar vazio)
3. Ler Data (loop até validar formato)
4. Ler Horário (loop até validar formato)
5. Salvar em arquivo delimitado por |
6. Exibir confirmação com dados
```

### 2. Listar Consultas
**Função:** `listar_consultas()` (linhas ~183-210)

**Lógica:**
```
1. Verificar se arquivo tem dados
2. Se vazio: exibir mensagem
3. Se tem dados: 
   - Criar tabela com bordas Unicode
   - Numerar cada consulta
   - Usar IFS='|' para parsear dados
   - Truncar nomes longos em 18 caracteres
```

**Exemplo de Saída:**
```
╔═══╦════════════════════╦════════════════════╦═══════════╦═════════╗
║ # ║ Paciente           ║ Médico             ║ Data      ║ Horário ║
╠═══╬════════════════════╬════════════════════╬═══════════╬═════════╣
║ 1 ║ João Silva         ║ Dr. Carlos         ║ 25/12/2026║ 14:30   ║
╚═══╩════════════════════╩════════════════════╩═══════════╩═════════╝
```

### 3. Pesquisar Consulta
**Função:** `pesquisar_consulta()` (linhas ~213-266)

**Lógica:**
```
1. Exibir submenu (Paciente/Médico/Data)
2. Ler termo de busca
3. Usar awk para busca case-insensitive:
   - campo=1 para Paciente
   - campo=2 para Médico
   - campo=3 para Data
4. Exibir resultados em tabela
5. Contar total de resultados
```

**Comando awk:**
```bash
awk -F'|' -v campo=$campo -v termo="$termo_busca" \
    'tolower($campo) ~ tolower(termo) { print }'
```

### 4. Cancelar Consulta
**Função:** `cancelar_consulta()` (linhas ~269-320)

**Lógica:**
```
1. Ler nome do paciente
2. Procurar consulta (grep -i)
3. Se encontrado:
   a. Exibir dados da consulta
   b. Pedir confirmação [s/n] (BRONZE)
   c. Se sim:
      - Fazer backup em pasta backup/
      - Remover linha do arquivo
      - Exibir confirmação
4. Se não encontrado: exibir erro
```

**Backup de Cancelamento:**
```
backup_dir/consultas_canceladas_20260608_140530.bak
```

### 5. Relatório
**Função:** `gerar_relatorio()` (linhas ~323-430)

**Estatísticas (DIAMANTE):**
- Total de consultas
- Contagem por médico (com `sort | uniq -c`)
- Médico com mais consultas (`sort -rn | head -1`)
- Distribuição por data
- Tabela completa com numeração
- Exportação opcional em arquivo

---

## Critérios de Pontuação Extras

### BRONZE (+0,5 pontos)
**Confirmação antes de excluir**
- Localização: `cancelar_consulta()` linhas ~310-312
- Implementação: `read -p "Deseja realmente remover..."`
- Backup automático das consultas canceladas

### PRATA (+1,0 ponto)
**Autenticação por senha**
- Localização: `autenticar_usuario()` linhas ~30-71
- Senha padrão: "1234"
- Até 3 tentativas
- Entrada segura com `read -sp` (sem eco)
- Chamada em `main()` antes de inicializar ambiente

### OURO (+1,5 pontos)
**Backup automático ao sair**
- Localização: `backup_automatico()` linhas ~433-443
- Acionado na opção 0 (Sair)
- Timestamp: YYYYMMDD_HHMMSS
- Valida se dados existem antes de fazer backup
- Armazenado em `backup/backup_consultas_*.txt`

### DIAMANTE (+2,0 pontos)
**Submenus e Estatísticas**
- Localização: `pesquisar_consulta()` e `gerar_relatorio()`
- Submenu de filtros em pesquisa (Paciente/Médico/Data)
- Relatório com estatísticas completas:
  - Total de consultas
  - Consultas por médico
  - Médico com mais consultas
  - Distribuição por data
  - Exportação em arquivo

**TOTAL DE PONTOS EXTRAS: +5,0 pontos**

---

## 🛠️ Tecnologias e Comandos Shell Utilizados

### Variáveis
```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
local data=$1  # Variáveis locais em funções
```

### Entrada/Saída
```bash
read -p "Prompt: " variavel          # Leitura simples
read -sp "Senha: " senha             # Leitura sem eco
echo -e "${RED}Texto${NC}"           # Saída com cores ANSI
```

### Estruturas Condicionais
```bash
if [ -f "$arquivo" ]; then
    # arquivo existe
elif [ -d "$dir" ]; then
    # diretório existe
else
    # nenhum dos anteriores
fi

case $opcao in
    1) comando1 ;;
    2) comando2 ;;
    *) padrão ;;
esac
```

### Estruturas de Repetição
```bash
while true; do
    # loop infinito
done

for i in $(seq 1 5); do
    # loop com range
done

while IFS='|' read -r campo1 campo2; do
    # leitura de arquivo delimitado
done < arquivo.txt
```

### Processamento de Texto
```bash
grep -i "termo" arquivo           # Busca case-insensitive
grep -v "termo" arquivo           # Busca inversa (não contém)
cut -d'|' -f2 arquivo            # Extrair campo delimitado
sort | uniq -c                    # Contar ocorrências
awk -F'|' '{print $1}' arquivo   # Processar campos
nl -nln -w2 -s'. '              # Numeração de linhas
```

### Manipulação de Arquivos
```bash
[ -f "$arquivo" ]     # Arquivo existe?
[ -s "$arquivo" ]     # Arquivo tem conteúdo?
[ -d "$dir" ]         # Diretório existe?
mkdir -p "$dir"       # Criar diretório recursivamente
cp "$origem" "$dest"  # Copiar arquivo (backup)
mv "$origem" "$dest"  # Mover arquivo
```

### Formatação Visual
```bash
clear                           # Limpar tela
echo -e "${BLUE}Texto${NC}"     # Cores ANSI
echo "╔════════════════════╗"   # Bordas Unicode
tput cols                       # Largura do terminal
```

---

## Estrutura de Arquivos

```
Projeto_Shell_Consulta/
│
├── Clinica/
│   ├── clinica.sh              # Script principal (532 linhas)
│   ├── DOCUMENTACAO.md         # Documentação completa
│   ├── FLUXOGRAMA.md          # Fluxogramas visuais
│   ├── RELATORIO_TECNICO.md   # Este arquivo
│   │
│   ├── consultas/
│   │   ├── .gitkeep
│   │   └── consultas.txt       # Banco de dados (criado ao usar)
│   │
│   ├── relatorios/
│   │   ├── .gitkeep
│   │   └── relatorio_*.txt     # Relatórios exportados
│   │
│   └── backup/
│       ├── .gitkeep
│       ├── backup_consultas_*.txt          # Backups automáticos
│       └── consultas_canceladas_*.bak      # Backup de cancelamentos
│
├── .gitignore                  # Excluir arquivos temporários
└── README.md                   # Descrição geral do projeto
```

---

## Validações Implementadas

### Validação de Dados de Entrada

```bash
# Campos obrigatórios vazios
if [ -z "$paciente" ]; then
    echo -e "${RED}Nome do paciente não pode estar vazio!${NC}"
    return
fi

# Validação de formato data (DD/MM/YYYY)
if [[ ! $data =~ ^[0-9]{2}/[0-9]{2}/[0-9]{4}$ ]]; then
    return 1
fi

# Validação de intervalo (dia 1-31)
if [ "$dia" -lt 1 ] || [ "$dia" -gt 31 ]; then
    return 1
fi

# Validação de hora (0-23)
if [ "$hora" -lt 0 ] || [ "$hora" -gt 23 ]; then
    return 1
fi
```

---

## 💾 Formato de Dados

### Arquivo de Consultas (consultas.txt)
```
Paciente|Médico|Data|Horário
João Silva|Dr. Carlos|25/12/2026|14:30
Maria Santos|Dra. Ana|26/12/2026|09:00
Pedro Costa|Dr. Jorge|27/12/2026|16:00
```

### Backup de Cancelamento
```
backup/consultas_canceladas_20260608_140530.bak
Conteúdo: mesma linha da consulta cancelada
```

### Backup Automático
```
backup/backup_consultas_20260608_153000.txt
Conteúdo: cópia completa do arquivo consultas.txt
```

### Relatório Exportado
```
relatorios/relatorio_20260608_153500.txt
Conteúdo: relatório em texto simples com formatação
```

---

## 🎨 Sistema de Cores ANSI

```bash
RED='\033[0;31m'      # Vermelho (erros)
GREEN='\033[0;32m'    # Verde (sucesso)
YELLOW='\033[1;33m'   # Amarelo (avisos)
BLUE='\033[0;34m'     # Azul (informações)
NC='\033[0m'          # Sem cor (reset)
```

**Uso:**
```bash
echo -e "${RED}Erro!${NC}"
echo -e "${GREEN}Sucesso!${NC}"
echo -e "${BLUE}║ Informação ${NC}"
```

---

## Fluxo de Segurança

### Autenticação
```
1. Sistema inicia
2. Exibe tela de login
3. Usuário digita senha (sem eco via read -sp)
4. Valida contra SENHA_PADRAO ("1234")
5. 3 tentativas máximo
6. Se acertar: continua
7. Se errar: encerra com "Acesso negado"
```

### Backup de Segurança
```
1. Usuário seleciona opção 0 (Sair)
2. Sistema chama backup_automatico()
3. Se consultas.txt tem dados:
   - Cria backup_consultas_TIMESTAMP.txt
   - Exibe mensagem de confirmação
4. Encerra sistema
```

---

## Complexidade do Código

| Função | Linhas | Complexidade |
|--------|--------|--------------|
| `validar_data` | 20 | O(1) |
| `validar_horario` | 21 | O(1) |
| `agendar_consulta` | 37 | O(1) |
| `listar_consultas` | 28 | O(n) |
| `pesquisar_consulta` | 53 | O(n) |
| `cancelar_consulta` | 52 | O(n) |
| `gerar_relatorio` | 107 | O(n²) |
| `backup_automatico` | 11 | O(1) |
| **TOTAL** | **532** | **O(n²)** |

---

## Performance e Otimizações

### Positivas
- Uso de `grep` para buscas rápidas
- `awk` para processamento eficiente
- Arquivo de texto simples (sem overhead de BD)
- Sem loops desnecessários

### Possíveis Melhorias
- Banco de dados SQL para grandes volumes
- Índices para buscas mais rápidas
- Cache de estatísticas
- Compressão de backups antigos

---

## 🐛 Tratamento de Erros

### Erros Tratados
1. Campos vazios
2. Formato de data inválido
3. Formato de horário inválido
4. Opção de menu inválida
5. Falha na autenticação
6. Dados não encontrados
7. Arquivo não encontrado

### Recovery
- Mensagens descritivas em vermelho
- Loop para repetir entrada
- Voltar ao menu anterior
- Sem crash do sistema

---

## 📝 Commits Realizados

```
1. init: Estrutura de diretórios
2. feat: Menu interativo base
3. feat: Função agendar com validações
4. feat: Função listar com tabela
5. feat: Função pesquisar com filtros
6. feat: Função cancelar com confirmação (BRONZE)
7. feat: Função relatório com estatísticas (DIAMANTE)
8. feat(prata): Autenticação por senha
9. feat(ouro): Backup automático
10. docs: Documentação técnica
11. docs: Fluxogramas visuais
12. docs: Relatório técnico
```

---

## Destaques Técnicos

### Inovações
- Menu com submenu integrado (pesquisa)
- Backup duplo (cancelamento + automático)
- Estatísticas em tempo real
- Interface colorida com Unicode
- Validação robusta com loops

### Características
- 100% Shell Script puro
- Sem dependências externas
- Portável (Linux, macOS, WSL, Git Bash)
- Escalável para múltiplos usuários
- Documentação completa

---

## Referências Utilizadas

### Comandos Unix/Linux
- `bash` - Shell principal
- `grep`, `awk`, `sed` - Processamento de texto
- `sort`, `uniq` - Ordenação e contagem
- `cp`, `mv` - Manipulação de arquivos
- `date` - Data e hora

### Técnicas Shell
- Funções com parâmetros locais
- Redirecionamento de entrada/saída
- Pipes para processamento em cadeia
- Variáveis de ambiente
- Cores ANSI para formatação

---

## Conceitos Demonstrados

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

**Versão:** 1.0  
**Data:** 08/06/2026  
**Autor:** Grupo 6 - Disciplina Shell Script  
**Total de Pontos:** Obrigatório + 5.0 extras
