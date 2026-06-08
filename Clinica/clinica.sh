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
    
    read -p "Nome do paciente: " paciente
    read -p "Nome do médico: " medico
    read -p "Data (DD/MM/YYYY): " data
    read -p "Horário (HH:MM): " horario
    
    # TODO: Adicionar validações
    
    echo "$paciente|$medico|$data|$horario" >> "$ARQUIVO_CONSULTAS"
    
    echo -e "${GREEN}✓ Consulta agendada com sucesso!${NC}"
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
        echo -e "${BLUE}Paciente${NC} | ${BLUE}Médico${NC} | ${BLUE}Data${NC} | ${BLUE}Horário${NC}"
        echo "────────────────────────────────────────────────────────"
        cat "$ARQUIVO_CONSULTAS" | while IFS='|' read -r paciente medico data horario; do
            echo "$paciente | $medico | $data | $horario"
        done
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
