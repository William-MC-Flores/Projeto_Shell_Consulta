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
ARQUIVO_SENHA="$SCRIPT_DIR/.senha"
SENHA_PADRAO="1234"  # Senha padrão do sistema
USUARIO_LOGADO=false

################################################################################
# FUNÇÃO: Autenticar usuário com senha (PRATA +1.0)
################################################################################
autenticar_usuario() {
    clear
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║     SISTEMA DE AGENDAMENTO DE CONSULTAS - LOGIN       ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
    
    # Tentar login até 3 vezes
    tentativas=3
    
    while [ $tentativas -gt 0 ]; do
        read -sp "Digite a senha para acessar o sistema: " senha
        echo ""
        
        if [ "$senha" = "$SENHA_PADRAO" ]; then
            echo -e "${GREEN}Autenticação bem-sucedida!${NC}"
            USUARIO_LOGADO=true
            sleep 1
            return 0
        else
            tentativas=$((tentativas - 1))
            if [ $tentativas -gt 0 ]; then
                echo -e "${RED}Senha incorreta! Tentativas restantes: $tentativas${NC}"
                echo ""
            fi
        fi
    done
    
    echo -e "${RED}Acesso negado! Limite de tentativas excedido.${NC}"
    sleep 2
    exit 1
}

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
    echo "║        SISTEMA DE AGENDAMENTO DE CONSULTAS            ║"
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
        echo -e "${RED}Nome do paciente não pode estar vazio!${NC}"
        read -p "Pressione ENTER para continuar..."
        return
    fi
    
    # Leitura do nome do médico
    read -p "Nome do médico: " medico
    if [ -z "$medico" ]; then
        echo -e "${RED}Nome do médico não pode estar vazio!${NC}"
        read -p "Pressione ENTER para continuar..."
        return
    fi
    
    # Leitura e validação da data
    while true; do
        read -p "Data (DD/MM/YYYY): " data
        if validar_data "$data"; then
            break
        else
            echo -e "${RED}Formato de data inválido! Use DD/MM/YYYY${NC}"
        fi
    done
    
    # Leitura e validação do horário
    while true; do
        read -p "Horário (HH:MM): " horario
        if validar_horario "$horario"; then
            break
        else
            echo -e "${RED}Formato de horário inválido! Use HH:MM (00:00 a 23:59)${NC}"
        fi
    done
    
    # Salvar consulta no arquivo
    echo "$paciente|$medico|$data|$horario" >> "$ARQUIVO_CONSULTAS"
    
    echo -e "${GREEN}Consulta agendada com sucesso!${NC}"
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
    echo "Pesquisar por:"
    echo "  1 - Paciente"
    echo "  2 - Médico"
    echo "  3 - Data"
    echo ""
    
    read -p "Escolha uma opção (1-3): " tipo_busca
    
    case $tipo_busca in
        1)
            read -p "Digite o nome do paciente: " termo_busca
            tipo="paciente"
            campo=1
            ;;
        2)
            read -p "Digite o nome do médico: " termo_busca
            tipo="médico"
            campo=2
            ;;
        3)
            read -p "Digite a data (DD/MM/YYYY): " termo_busca
            tipo="data"
            campo=3
            ;;
        *)
            echo -e "${RED}Opção inválida!${NC}"
            read -p "Pressione ENTER para continuar..."
            return
            ;;
    esac
    
    echo ""
    echo -e "${BLUE}Resultados da busca por $tipo: ${NC}"
    
    # Usar awk para buscar no campo específico
    resultado=$(awk -F'|' -v campo=$campo -v termo="$termo_busca" \
        'tolower($campo) ~ tolower(termo) { print }' "$ARQUIVO_CONSULTAS")
    
    if [ -z "$resultado" ]; then
        echo -e "${YELLOW}Nenhuma consulta encontrada para: $termo_busca${NC}"
    else
        echo ""
        echo -e "${BLUE}╔════════════════════╦════════════════════╦═══════════╦═════════╗${NC}"
        echo -e "${BLUE}║ Paciente           ║ Médico             ║ Data      ║ Horário ║${NC}"
        echo -e "${BLUE}╠════════════════════╬════════════════════╬═══════════╬═════════╣${NC}"
        
        contador=0
        echo "$resultado" | while IFS='|' read -r paciente medico data horario; do
            paciente_fmt=$(printf "%-18s" "$paciente" | cut -c1-18)
            medico_fmt=$(printf "%-18s" "$medico" | cut -c1-18)
            
            printf "${BLUE}║${NC} %-18s ${BLUE}║${NC} %-18s ${BLUE}║${NC} %-9s ${BLUE}║${NC} %-7s ${BLUE}║${NC}\n" \
                "$paciente_fmt" "$medico_fmt" "$data" "$horario"
            
            contador=$((contador + 1))
        done
        
        echo -e "${BLUE}╚════════════════════╩════════════════════╩═══════════╩═════════╝${NC}"
        echo ""
        echo -e "${GREEN}Total de resultados: $(echo "$resultado" | wc -l)${NC}"
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
    
    if [ -z "$paciente_cancel" ]; then
        echo -e "${RED}Nome do paciente não pode estar vazio!${NC}"
        read -p "Pressione ENTER para continuar..."
        return
    fi
    
    # Procurar consulta do paciente
    resultado=$(grep -i "^$paciente_cancel|" "$ARQUIVO_CONSULTAS")
    
    if [ -z "$resultado" ]; then
        echo -e "${RED}Nenhuma consulta encontrada para esse paciente.${NC}"
    else
        echo ""
        echo -e "${YELLOW}Consulta a ser cancelada:${NC}"
        echo "────────────────────────────────────────────────────────"
        echo "$resultado" | while IFS='|' read -r paciente medico data horario; do
            echo "Paciente: $paciente"
            echo "Médico: $medico"
            echo "Data: $data"
            echo "Horário: $horario"
        done
        echo "────────────────────────────────────────────────────────"
        echo ""
        
        # Confirmação antes de cancelar (BRONZE)
        read -p "Deseja realmente remover esta consulta? [s/n]: " confirmacao
        
        if [ "$confirmacao" = "s" ] || [ "$confirmacao" = "S" ]; then
            # Backup da consulta antes de remover
            echo "$resultado" >> "$BACKUP_DIR/consultas_canceladas_$(date +%Y%m%d_%H%M%S).bak"
            
            # Remover consulta do arquivo
            grep -iv "^$paciente_cancel|" "$ARQUIVO_CONSULTAS" > "$ARQUIVO_CONSULTAS.tmp"
            mv "$ARQUIVO_CONSULTAS.tmp" "$ARQUIVO_CONSULTAS"
            
            echo -e "${GREEN}Consulta cancelada com sucesso!${NC}"
        else
            echo -e "${YELLOW}Operação cancelada.${NC}"
        fi
    fi
    
    echo ""
    read -p "Pressione ENTER para continuar..."
}

################################################################################
# FUNÇÃO: Gerar relatório com estatísticas (DIAMANTE)
################################################################################
gerar_relatorio() {
    echo -e "${GREEN}=== RELATÓRIO DE CONSULTAS ===${NC}"
    echo ""
    
    total=$(wc -l < "$ARQUIVO_CONSULTAS" 2>/dev/null || echo 0)
    
    if [ "$total" -eq 0 ]; then
        echo -e "${YELLOW}Nenhuma consulta agendada no sistema.${NC}"
        echo ""
        read -p "Pressione ENTER para continuar..."
        return
    fi
    
    echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                 ESTATÍSTICAS GERAIS                    ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Total de consultas agendadas:${NC} ${GREEN}$total${NC}"
    echo ""
    
    # Contagem por médico
    echo -e "${BLUE}CONSULTAS POR MÉDICO:${NC}"
    echo "────────────────────────────────────────────────────────"
    cut -d'|' -f2 "$ARQUIVO_CONSULTAS" | sort | uniq -c | \
        while read count medico; do
            printf "  %-30s: %3d consulta(s)\n" "$medico" "$count"
        done
    echo ""
    
    # Médico com mais consultas
    echo -e "${BLUE}MÉDICO COM MAIS CONSULTAS:${NC}"
    medico_top=$(cut -d'|' -f2 "$ARQUIVO_CONSULTAS" | sort | uniq -c | sort -rn | head -1 | awk '{$1=""; print $0}' | sed 's/^ //')
    count_top=$(cut -d'|' -f2 "$ARQUIVO_CONSULTAS" | sort | uniq -c | sort -rn | head -1 | awk '{print $1}')
    echo -e "  ${GREEN}$medico_top${NC} ($count_top consultas)"
    echo ""
    
    # Consultas por data (primeiras 10 datas)
    echo -e "${BLUE}CONSULTAS PRÓXIMAS (por data):${NC}"
    echo "────────────────────────────────────────────────────────"
    cut -d'|' -f3 "$ARQUIVO_CONSULTAS" | sort -u | head -5 | \
        while read data; do
            count=$(grep -c "|$data|" "$ARQUIVO_CONSULTAS")
            printf "  Data: %-10s - %d consulta(s)\n" "$data" "$count"
        done
    echo ""
    
    # Detalhamento completo
    echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║            DETALHAMENTO COMPLETO DAS CONSULTAS         ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}╔═══╦════════════════════╦════════════════════╦═══════════╦═════════╗${NC}"
    echo -e "${BLUE}║ # ║ Paciente           ║ Médico             ║ Data      ║ Horário ║${NC}"
    echo -e "${BLUE}╠═══╬════════════════════╬════════════════════╬═══════════╬═════════╣${NC}"
    
    contador=1
    cat "$ARQUIVO_CONSULTAS" | while IFS='|' read -r paciente medico data horario; do
        paciente_fmt=$(printf "%-18s" "$paciente" | cut -c1-18)
        medico_fmt=$(printf "%-18s" "$medico" | cut -c1-18)
        
        printf "${BLUE}║${NC} %1d ${BLUE}║${NC} %-18s ${BLUE}║${NC} %-18s ${BLUE}║${NC} %-9s ${BLUE}║${NC} %-7s ${BLUE}║${NC}\n" \
            "$contador" "$paciente_fmt" "$medico_fmt" "$data" "$horario"
        
        contador=$((contador + 1))
    done
    
    echo -e "${BLUE}╚═══╩════════════════════╩════════════════════╩═══════════╩═════════╝${NC}"
    echo ""
    
    # Salvar relatório em arquivo
    read -p "Deseja salvar este relatório em arquivo? [s/n]: " salvar_relatorio
    
    if [ "$salvar_relatorio" = "s" ] || [ "$salvar_relatorio" = "S" ]; then
        data_relatorio=$(date +%Y%m%d_%H%M%S)
        arquivo_relatorio="$RELATORIOS_DIR/relatorio_$data_relatorio.txt"
        
        {
            echo "═══════════════════════════════════════════════════════"
            echo "RELATÓRIO DE CONSULTAS - Gerado em: $(date '+%d/%m/%Y %H:%M:%S')"
            echo "═══════════════════════════════════════════════════════"
            echo ""
            echo "ESTATÍSTICAS GERAIS"
            echo "──────────────────────────────────────────────────────"
            echo "Total de consultas: $total"
            echo ""
            echo "CONSULTAS POR MÉDICO:"
            cut -d'|' -f2 "$ARQUIVO_CONSULTAS" | sort | uniq -c | \
                while read count medico; do
                    printf "  %-30s: %3d consulta(s)\n" "$medico" "$count"
                done
            echo ""
            echo "DETALHAMENTO DAS CONSULTAS:"
            echo "──────────────────────────────────────────────────────"
            cat "$ARQUIVO_CONSULTAS" | nl -nln -w3 -s'. ' -v 1 | \
                while read num paciente medico data horario; do
                    printf "%s Paciente: %s | Médico: %s | Data: %s | Horário: %s\n" \
                        "$num" "$paciente" "$medico" "$data" "$horario"
                done
        } > "$arquivo_relatorio"
        
        echo -e "${GREEN}Relatório salvo em: $arquivo_relatorio${NC}"
    fi
    
    echo ""
    read -p "Pressione ENTER para continuar..."
}

################################################################################
# FUNÇÃO: Fazer backup automático dos dados (OURO +1.5)
################################################################################
backup_automatico() {
    if [ -f "$ARQUIVO_CONSULTAS" ] && [ -s "$ARQUIVO_CONSULTAS" ]; then
        data_backup=$(date +%Y%m%d_%H%M%S)
        arquivo_backup="$BACKUP_DIR/backup_consultas_$data_backup.txt"
        
        cp "$ARQUIVO_CONSULTAS" "$arquivo_backup"
        
        echo -e "${GREEN}Backup automático realizado com sucesso!${NC}"
        echo "  Arquivo: $arquivo_backup"
    fi
}

################################################################################
# FUNÇÃO: Loop principal
################################################################################
main() {
    # Autenticar usuário antes de acessar o sistema (PRATA)
    autenticar_usuario
    
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
                echo -e "${BLUE}Realizando backup automático...${NC}"
                backup_automatico
                echo ""
                echo -e "${BLUE}Encerrando sistema...${NC}"
                echo -e "${GREEN}Até logo!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Opção inválida! Digite uma opção de 0 a 5.${NC}"
                read -p "Pressione ENTER para continuar..."
                ;;
        esac
    done
}

# Executar aplicação
main
