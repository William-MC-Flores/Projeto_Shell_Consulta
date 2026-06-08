#!/bin/bash

################################################################################
# SISTEMA DE AGENDAMENTO DE CONSULTAS
# Desenvolvido em Shell Script
# Grupo 6 - Projeto Disciplina Shell Script
################################################################################

# Cores para saída formatada
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variáveis globais
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONSULTAS_DIR="$SCRIPT_DIR/consultas"
RELATORIOS_DIR="$SCRIPT_DIR/relatorios"
BACKUP_DIR="$SCRIPT_DIR/backup"
ARQUIVO_CONSULTAS="$CONSULTAS_DIR/consultas.txt"

################################################################################
# FUNÇÃO: Inicializar ambiente
################################################################################
inicializar_ambiente() {
    # Verificar se os diretórios existem
    if [ ! -d "$CONSULTAS_DIR" ]; then
        mkdir -p "$CONSULTAS_DIR"
    fi
    
    if [ ! -d "$RELATORIOS_DIR" ]; then
        mkdir -p "$RELATORIOS_DIR"
    fi
    
    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR"
    fi
    
    # Criar arquivo de consultas se não existir
    if [ ! -f "$ARQUIVO_CONSULTAS" ]; then
        touch "$ARQUIVO_CONSULTAS"
    fi
}

################################################################################
# FUNÇÃO: Validar data (DD/MM/YYYY)
################################################################################
validar_data() {
    local data=$1
    
    # Validar formato DD/MM/YYYY
    if [[ ! $data =~ ^[0-9]{2}/[0-9]{2}/[0-9]{4}$ ]]; then
        return 1
    fi
    
    # Extrair dia, mês e ano
    local dia=$(echo $data | cut -d'/' -f1)
    local mes=$(echo $data | cut -d'/' -f2)
    local ano=$(echo $data | cut -d'/' -f3)
    
    # Validar intervalo de mês
    if [ "$mes" -lt 1 ] || [ "$mes" -gt 12 ]; then
        return 1
    fi
    
    # Validar intervalo de dia
    if [ "$dia" -lt 1 ] || [ "$dia" -gt 31 ]; then
        return 1
    fi
    
    return 0
}

################################################################################
# FUNÇÃO: Validar horário (HH:MM)
################################################################################
validar_horario() {
    local horario=$1
    
    # Validar formato HH:MM
    if [[ ! $horario =~ ^[0-9]{2}:[0-9]{2}$ ]]; then
        return 1
    fi
    
    # Extrair hora e minuto
    local hora=$(echo $horario | cut -d':' -f1)
    local minuto=$(echo $horario | cut -d':' -f2)
    
    # Validar intervalo de hora (0-23)
    if [ "$hora" -lt 0 ] || [ "$hora" -gt 23 ]; then
        return 1
    fi
    
    # Validar intervalo de minuto (0-59)
    if [ "$minuto" -lt 0 ] || [ "$minuto" -gt 59 ]; then
        return 1
    fi
    
    return 0
}

################################################################################
# FUNÇÃO: Exibir menu principal
################################################################################
exibir_menu() {
    clear
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║        SISTEMA DE AGENDAMENTO DE CONSULTAS 🏥          ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
    echo -e "${YELLOW}Escolha uma opção:${NC}"
    echo ""
    echo "  1 - Agendar consulta"
    echo "  2 - Listar consultas"
    echo "  3 - Pesquisar consulta"
    echo "  4 - Cancelar consulta"
    echo "  5 - Relatório"
    echo "  0 - Sair"
    echo ""
    echo -e "${BLUE}────────────────────────────────────────────────────────${NC}"
}

################################################################################
# FUNÇÃO: Agendar consulta
################################################################################
agendar_consulta() {
    echo -e "${GREEN}=== AGENDAR CONSULTA ===${NC}"
    echo ""
    
    # Leitura do nome do paciente
    read -p "Nome do paciente: " paciente
    if [ -z "$paciente" ]; then
        echo -e "${RED}✗ Nome do paciente não pode estar vazio!${NC}"
        read -p "Pressione ENTER para continuar..."
        return
    fi
    
    # Leitura do nome do médico
    read -p "Nome do médico: " medico
    if [ -z "$medico" ]; then
        echo -e "${RED}✗ Nome do médico não pode estar vazio!${NC}"
        read -p "Pressione ENTER para continuar..."
        return
    fi
    
    # Leitura e validação da data
    while true; do
        read -p "Data (DD/MM/YYYY): " data
        if validar_data "$data"; then
            break
        else
            echo -e "${RED}✗ Formato de data inválido! Use DD/MM/YYYY${NC}"
        fi
    done
    
    # Leitura e validação do horário
    while true; do
        read -p "Horário (HH:MM): " horario
        if validar_horario "$horario"; then
            break
        else
            echo -e "${RED}✗ Formato de horário inválido! Use HH:MM (00:00 a 23:59)${NC}"
        fi
    done
    
    # Salvar consulta no arquivo
    echo "$paciente|$medico|$data|$horario" >> "$ARQUIVO_CONSULTAS"
    
    echo -e "${GREEN}✓ Consulta agendada com sucesso!${NC}"
    echo "  Paciente: $paciente"
    echo "  Médico: $medico"
    echo "  Data: $data"
    echo "  Horário: $horario"
    echo ""
    read -p "Pressione ENTER para continuar..."
}

################################################################################
# FUNÇÃO: Listar consultas
################################################################################
listar_consultas() {
    echo -e "${GREEN}=== LISTAR CONSULTAS ===${NC}"
    echo ""
    
    if [ ! -s "$ARQUIVO_CONSULTAS" ]; then
        echo -e "${YELLOW}Nenhuma consulta agendada.${NC}"
    else
        local contador=1
        echo -e "${BLUE}╔═══╦════════════════════╦════════════════════╦═══════════╦═════════╗${NC}"
        echo -e "${BLUE}║ # ║ Paciente           ║ Médico             ║ Data      ║ Horário ║${NC}"
        echo -e "${BLUE}╠═══╬════════════════════╬════════════════════╬═══════════╬═════════╣${NC}"
        
        cat "$ARQUIVO_CONSULTAS" | while IFS='|' read -r paciente medico data horario; do
            # Truncar nomes muito longos
            paciente_fmt=$(printf "%-18s" "$paciente" | cut -c1-18)
            medico_fmt=$(printf "%-18s" "$medico" | cut -c1-18)
            
            printf "${BLUE}║${NC} %1d ${BLUE}║${NC} %-18s ${BLUE}║${NC} %-18s ${BLUE}║${NC} %-9s ${BLUE}║${NC} %-7s ${BLUE}║${NC}\n" \
                "$contador" "$paciente_fmt" "$medico_fmt" "$data" "$horario"
            
            contador=$((contador + 1))
        done
        
        echo -e "${BLUE}╚═══╩════════════════════╩════════════════════╩═══════════╩═════════╝${NC}"
    fi
    
    echo ""
    read -p "Pressione ENTER para continuar..."
}

################################################################################
# FUNÇÃO: Pesquisar consulta
################################################################################
pesquisar_consulta() {
    echo -e "${GREEN}=== PESQUISAR CONSULTA ===${NC}"
    echo ""
    
    read -p "Digite o nome do paciente para pesquisar: " termo_busca
    
    echo ""
    resultado=$(grep -i "$termo_busca" "$ARQUIVO_CONSULTAS")
    
    if [ -z "$resultado" ]; then
        echo -e "${YELLOW}Nenhuma consulta encontrada para: $termo_busca${NC}"
    else
        echo -e "${BLUE}Resultados da busca:${NC}"
        echo "────────────────────────────────────────────────────────"
        echo "$resultado" | while IFS='|' read -r paciente medico data horario; do
            echo "Paciente: $paciente"
            echo "Médico: $medico"
            echo "Data: $data"
            echo "Horário: $horario"
            echo "────────────────────────────────────────────────────────"
        done
    fi
    
    echo ""
    read -p "Pressione ENTER para continuar..."
}

################################################################################
# FUNÇÃO: Cancelar consulta
################################################################################
cancelar_consulta() {
    echo -e "${GREEN}=== CANCELAR CONSULTA ===${NC}"
    echo ""
    
    read -p "Digite o nome do paciente cuja consulta deseja cancelar: " paciente_cancel
    
    if grep -q "^$paciente_cancel|" "$ARQUIVO_CONSULTAS"; then
        grep -v "^$paciente_cancel|" "$ARQUIVO_CONSULTAS" > "$ARQUIVO_CONSULTAS.tmp"
        mv "$ARQUIVO_CONSULTAS.tmp" "$ARQUIVO_CONSULTAS"
        echo -e "${GREEN}✓ Consulta cancelada com sucesso!${NC}"
    else
        echo -e "${RED}✗ Nenhuma consulta encontrada para esse paciente.${NC}"
    fi
    
    echo ""
    read -p "Pressione ENTER para continuar..."
}

################################################################################
# FUNÇÃO: Gerar relatório
################################################################################
gerar_relatorio() {
    echo -e "${GREEN}=== RELATÓRIO ===${NC}"
    echo ""
    
    total=$(wc -l < "$ARQUIVO_CONSULTAS" 2>/dev/null || echo 0)
    
    echo "Total de consultas agendadas: $total"
    echo ""
    
    if [ "$total" -gt 0 ]; then
        echo -e "${BLUE}Detalhamento das consultas:${NC}"
        echo "────────────────────────────────────────────────────────"
        cat "$ARQUIVO_CONSULTAS" | nl -nln -w2 -s'. '
    fi
    
    echo ""
    read -p "Pressione ENTER para continuar..."
}

################################################################################
# FUNÇÃO: Loop principal
################################################################################
main() {
    inicializar_ambiente
    
    while true; do
        exibir_menu
        
        read -p "Digite sua escolha: " opcao
        
        case $opcao in
            1)
                agendar_consulta
                ;;
            2)
                listar_consultas
                ;;
            3)
                pesquisar_consulta
                ;;
            4)
                cancelar_consulta
                ;;
            5)
                gerar_relatorio
                ;;
            0)
                echo -e "${BLUE}Encerrando sistema...${NC}"
                echo -e "${GREEN}Até logo! 👋${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}✗ Opção inválida! Digite uma opção de 0 a 5.${NC}"
                read -p "Pressione ENTER para continuar..."
                ;;
        esac
    done
}

# Executar aplicação
main
