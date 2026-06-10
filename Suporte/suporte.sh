#!/bin/bash

################################################################################
# SISTEMA DE CHAMADOS DE SUPORTE
# Desenvolvido em Shell Script
# Grupo 4 - Projeto Disciplina Shell Script
################################################################################

# Cores para saída formatada
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variáveis globais
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHAMADOS_DIR="$SCRIPT_DIR/chamados"
RELATORIOS_DIR="$SCRIPT_DIR/relatorios"
BACKUP_DIR="$SCRIPT_DIR/backup"
ARQUIVO_CHAMADOS="$CHAMADOS_DIR/chamados.txt"
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
    echo "║     SISTEMA DE CHAMADOS DE SUPORTE - LOGIN             ║"
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
    if [ ! -d "$CHAMADOS_DIR" ]; then
        mkdir -p "$CHAMADOS_DIR"
    fi
    
    if [ ! -d "$RELATORIOS_DIR" ]; then
        mkdir -p "$RELATORIOS_DIR"
    fi
    
    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR"
    fi
    
    # Criar arquivo de chamados se não existir
    if [ ! -f "$ARQUIVO_CHAMADOS" ]; then
        touch "$ARQUIVO_CHAMADOS"
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
# FUNÇÃO: Validar status
################################################################################
validar_status() {
    local status=$1
    
    case $status in
        "Aberto"|"Em Andamento"|"Fechado")
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

################################################################################
# FUNÇÃO: Exibir menu principal
################################################################################
exibir_menu() {
    clear
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║        SISTEMA DE CHAMADOS DE SUPORTE                 ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
    echo -e "${YELLOW}Escolha uma opção:${NC}"
    echo ""
    echo "  1 - Abrir chamado"
    echo "  2 - Listar chamados"
    echo "  3 - Pesquisar chamado"
    echo "  4 - Fechar chamado"
    echo "  5 - Relatório"
    echo "  0 - Sair"
    echo ""
    echo -e "${BLUE}────────────────────────────────────────────────────────${NC}"
}

################################################################################
# FUNÇÃO: Abrir chamado
################################################################################
abrir_chamado() {
    echo -e "${GREEN}=== ABRIR CHAMADO ===${NC}"
    echo ""
    
    # Leitura do nome do cliente
    read -p "Nome do cliente: " cliente
    if [ -z "$cliente" ]; then
        echo -e "${RED}Nome do cliente não pode estar vazio!${NC}"
        read -p "Pressione ENTER para continuar..."
        return
    fi
    
    # Leitura da descrição do problema
    read -p "Descrição do problema: " problema
    if [ -z "$problema" ]; then
        echo -e "${RED}Descrição do problema não pode estar vazia!${NC}"
        read -p "Pressione ENTER para continuar..."
        return
    fi
    
    # Leitura e validação da data
    while true; do
        read -p "Data de abertura (DD/MM/YYYY): " data
        if validar_data "$data"; then
            break
        else
            echo -e "${RED}Formato de data inválido! Use DD/MM/YYYY${NC}"
        fi
    done
    
    # Status padrão é "Aberto"
    status="Aberto"
    
    # Salvar chamado no arquivo
    echo "$cliente|$problema|$data|$status" >> "$ARQUIVO_CHAMADOS"
    
    echo -e "${GREEN}Chamado aberto com sucesso!${NC}"
    echo "  Cliente: $cliente"
    echo "  Problema: $problema"
    echo "  Data de Abertura: $data"
    echo "  Status: $status"
    echo ""
    read -p "Pressione ENTER para continuar..."
}

################################################################################
# FUNÇÃO: Listar chamados
################################################################################
listar_chamados() {
    echo -e "${GREEN}=== LISTAR CHAMADOS ===${NC}"
    echo ""
    
    if [ ! -s "$ARQUIVO_CHAMADOS" ]; then
        echo -e "${YELLOW}Nenhum chamado registrado.${NC}"
    else
        local contador=1
        echo -e "${BLUE}╔═══╦════════════════════╦════════════════════╦═══════════╦═════════════════╗${NC}"
        echo -e "${BLUE}║ # ║ Cliente            ║ Problema           ║ Data      ║ Status          ║${NC}"
        echo -e "${BLUE}╠═══╬════════════════════╬════════════════════╬═══════════╬═════════════════╣${NC}"
        
        cat "$ARQUIVO_CHAMADOS" | while IFS='|' read -r cliente problema data status; do
            # Truncar campos muito longos
            cliente_fmt=$(printf "%-18s" "$cliente" | cut -c1-18)
            problema_fmt=$(printf "%-18s" "$problema" | cut -c1-18)
            status_fmt=$(printf "%-15s" "$status" | cut -c1-15)
            
            printf "${BLUE}║${NC} %1d ${BLUE}║${NC} %-18s ${BLUE}║${NC} %-18s ${BLUE}║${NC} %-9s ${BLUE}║${NC} %-15s ${BLUE}║${NC}\n" \
                "$contador" "$cliente_fmt" "$problema_fmt" "$data" "$status_fmt"
            
            contador=$((contador + 1))
        done
        
        echo -e "${BLUE}╚═══╩════════════════════╩════════════════════╩═══════════╩═════════════════╝${NC}"
    fi
    
    echo ""
    read -p "Pressione ENTER para continuar..."
}

################################################################################
# FUNÇÃO: Pesquisar chamado
################################################################################
pesquisar_chamado() {
    echo -e "${GREEN}=== PESQUISAR CHAMADO ===${NC}"
    echo ""
    echo "Pesquisar por:"
    echo "  1 - Cliente"
    echo "  2 - Problema"
    echo "  3 - Data"
    echo "  4 - Status"
    echo ""
    
    read -p "Escolha uma opção (1-4): " tipo_busca
    
    case $tipo_busca in
        1)
            read -p "Digite o nome do cliente: " termo_busca
            tipo="cliente"
            campo=1
            ;;
        2)
            read -p "Digite a descrição do problema: " termo_busca
            tipo="problema"
            campo=2
            ;;
        3)
            read -p "Digite a data (DD/MM/YYYY): " termo_busca
            tipo="data"
            campo=3
            ;;
        4)
            read -p "Digite o status (Aberto/Em Andamento/Fechado): " termo_busca
            tipo="status"
            campo=4
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
        'tolower($campo) ~ tolower(termo) { print }' "$ARQUIVO_CHAMADOS")
    
    if [ -z "$resultado" ]; then
        echo -e "${YELLOW}Nenhum chamado encontrado para: $termo_busca${NC}"
    else
        echo ""
        echo -e "${BLUE}╔════════════════════╦════════════════════╦═══════════╦═════════════════╗${NC}"
        echo -e "${BLUE}║ Cliente            ║ Problema           ║ Data      ║ Status          ║${NC}"
        echo -e "${BLUE}╠════════════════════╬════════════════════╬═══════════╬═════════════════╣${NC}"
        
        echo "$resultado" | while IFS='|' read -r cliente problema data status; do
            cliente_fmt=$(printf "%-18s" "$cliente" | cut -c1-18)
            problema_fmt=$(printf "%-18s" "$problema" | cut -c1-18)
            status_fmt=$(printf "%-15s" "$status" | cut -c1-15)
            
            printf "${BLUE}║${NC} %-18s ${BLUE}║${NC} %-18s ${BLUE}║${NC} %-9s ${BLUE}║${NC} %-15s ${BLUE}║${NC}\n" \
                "$cliente_fmt" "$problema_fmt" "$data" "$status_fmt"
        done
        
        echo -e "${BLUE}╚════════════════════╩════════════════════╩═══════════╩═════════════════╝${NC}"
        echo ""
        echo -e "${GREEN}Total de resultados: $(echo "$resultado" | wc -l)${NC}"
    fi
    
    echo ""
    read -p "Pressione ENTER para continuar..."
}

################################################################################
# FUNÇÃO: Fechar chamado
################################################################################
fechar_chamado() {
    echo -e "${GREEN}=== FECHAR CHAMADO ===${NC}"
    echo ""
    
    read -p "Digite o nome do cliente do chamado que deseja fechar: " cliente_fechar
    
    if [ -z "$cliente_fechar" ]; then
        echo -e "${RED}Nome do cliente não pode estar vazio!${NC}"
        read -p "Pressione ENTER para continuar..."
        return
    fi
    
    # Procurar chamado do cliente
    resultado=$(grep -i "^$cliente_fechar|" "$ARQUIVO_CHAMADOS")
    
    if [ -z "$resultado" ]; then
        echo -e "${RED}Nenhum chamado encontrado para esse cliente.${NC}"
    else
        echo ""
        echo -e "${YELLOW}Chamado a ser fechado:${NC}"
        echo "────────────────────────────────────────────────────────"
        echo "$resultado" | while IFS='|' read -r cliente problema data status; do
            echo "Cliente: $cliente"
            echo "Problema: $problema"
            echo "Data de Abertura: $data"
            echo "Status: $status"
        done
        echo "────────────────────────────────────────────────────────"
        echo ""
        
        # Confirmação antes de fechar (BRONZE)
        read -p "Deseja realmente fechar este chamado? [s/n]: " confirmacao
        
        if [ "$confirmacao" = "s" ] || [ "$confirmacao" = "S" ]; then
            # Backup do chamado antes de remover
            echo "$resultado" >> "$BACKUP_DIR/chamados_fechados_$(date +%Y%m%d_%H%M%S).bak"
            
            # Remover chamado do arquivo
            grep -iv "^$cliente_fechar|" "$ARQUIVO_CHAMADOS" > "$ARQUIVO_CHAMADOS.tmp"
            mv "$ARQUIVO_CHAMADOS.tmp" "$ARQUIVO_CHAMADOS"
            
            echo -e "${GREEN}Chamado fechado com sucesso!${NC}"
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
    echo -e "${GREEN}=== RELATÓRIO DE CHAMADOS ===${NC}"
    echo ""
    
    total=$(wc -l < "$ARQUIVO_CHAMADOS" 2>/dev/null || echo 0)
    
    if [ "$total" -eq 0 ]; then
        echo -e "${YELLOW}Nenhum chamado registrado no sistema.${NC}"
        echo ""
        read -p "Pressione ENTER para continuar..."
        return
    fi
    
    echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                 ESTATÍSTICAS GERAIS                    ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Total de chamados:${NC} ${GREEN}$total${NC}"
    echo ""
    
    # Contagem por status
    echo -e "${BLUE}CHAMADOS POR STATUS:${NC}"
    echo "────────────────────────────────────────────────────────"
    cut -d'|' -f4 "$ARQUIVO_CHAMADOS" | sort | uniq -c | \
        while read count status; do
            printf "  %-30s: %3d chamado(s)\n" "$status" "$count"
        done
    echo ""
    
    # Status mais frequente
    echo -e "${BLUE}STATUS MAIS FREQUENTE:${NC}"
    status_top=$(cut -d'|' -f4 "$ARQUIVO_CHAMADOS" | sort | uniq -c | sort -rn | head -1 | awk '{$1=""; print $0}' | sed 's/^ //')
    count_top=$(cut -d'|' -f4 "$ARQUIVO_CHAMADOS" | sort | uniq -c | sort -rn | head -1 | awk '{print $1}')
    echo -e "  ${GREEN}$status_top${NC} ($count_top chamados)"
    echo ""
    
    # Chamados por data (primeiras 10 datas)
    echo -e "${BLUE}CHAMADOS POR DATA:${NC}"
    echo "────────────────────────────────────────────────────────"
    cut -d'|' -f3 "$ARQUIVO_CHAMADOS" | sort -u | head -5 | \
        while read data; do
            count=$(grep -c "|$data|" "$ARQUIVO_CHAMADOS")
            printf "  Data: %-10s - %d chamado(s)\n" "$data" "$count"
        done
    echo ""
    
    # Detalhamento completo
    echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║            DETALHAMENTO COMPLETO DOS CHAMADOS         ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}╔═══╦════════════════════╦════════════════════╦═══════════╦═════════════════╗${NC}"
    echo -e "${BLUE}║ # ║ Cliente            ║ Problema           ║ Data      ║ Status          ║${NC}"
    echo -e "${BLUE}╠═══╬════════════════════╬════════════════════╬═══════════╬═════════════════╣${NC}"
    
    contador=1
    cat "$ARQUIVO_CHAMADOS" | while IFS='|' read -r cliente problema data status; do
        cliente_fmt=$(printf "%-18s" "$cliente" | cut -c1-18)
        problema_fmt=$(printf "%-18s" "$problema" | cut -c1-18)
        status_fmt=$(printf "%-15s" "$status" | cut -c1-15)
        
        printf "${BLUE}║${NC} %1d ${BLUE}║${NC} %-18s ${BLUE}║${NC} %-18s ${BLUE}║${NC} %-9s ${BLUE}║${NC} %-15s ${BLUE}║${NC}\n" \
            "$contador" "$cliente_fmt" "$problema_fmt" "$data" "$status_fmt"
        
        contador=$((contador + 1))
    done
    
    echo -e "${BLUE}╚═══╩════════════════════╩════════════════════╩═══════════╩═════════════════╝${NC}"
    echo ""
    
    # Salvar relatório em arquivo
    read -p "Deseja salvar este relatório em arquivo? [s/n]: " salvar_relatorio
    
    if [ "$salvar_relatorio" = "s" ] || [ "$salvar_relatorio" = "S" ]; then
        data_relatorio=$(date +%Y%m%d_%H%M%S)
        arquivo_relatorio="$RELATORIOS_DIR/relatorio_$data_relatorio.txt"
        
        {
            echo "═══════════════════════════════════════════════════════"
            echo "RELATÓRIO DE CHAMADOS - Gerado em: $(date '+%d/%m/%Y %H:%M:%S')"
            echo "═══════════════════════════════════════════════════════"
            echo ""
            echo "ESTATÍSTICAS GERAIS"
            echo "──────────────────────────────────────────────────────"
            echo "Total de chamados: $total"
            echo ""
            echo "CHAMADOS POR STATUS:"
            cut -d'|' -f4 "$ARQUIVO_CHAMADOS" | sort | uniq -c | \
                while read count status; do
                    printf "  %-30s: %3d chamado(s)\n" "$status" "$count"
                done
            echo ""
            echo "DETALHAMENTO DOS CHAMADOS:"
            echo "──────────────────────────────────────────────────────"
            cat "$ARQUIVO_CHAMADOS" | nl -nln -w3 -s'. ' -v 1 | \
                while read num cliente problema data status; do
                    printf "%s Cliente: %s | Problema: %s | Data: %s | Status: %s\n" \
                        "$num" "$cliente" "$problema" "$data" "$status"
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
    if [ -f "$ARQUIVO_CHAMADOS" ] && [ -s "$ARQUIVO_CHAMADOS" ]; then
        data_backup=$(date +%Y%m%d_%H%M%S)
        arquivo_backup="$BACKUP_DIR/backup_chamados_$data_backup.txt"
        
        cp "$ARQUIVO_CHAMADOS" "$arquivo_backup"
        
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
                abrir_chamado
                ;;
            2)
                listar_chamados
                ;;
            3)
                pesquisar_chamado
                ;;
            4)
                fechar_chamado
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
