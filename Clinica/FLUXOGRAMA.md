# 📊 Fluxograma do Sistema de Agendamento de Consultas

## Fluxo Principal

```
┌─────────────────────────────────────┐
│    INICIAR SISTEMA                  │
│    (clinica.sh)                     │
└──────────────┬──────────────────────┘
               │
               ▼
        ┌──────────────┐
        │   LOGIN 🔐   │
        │ Senha: 1234  │
        └──────┬───────┘
               │
        ┌──────▼──────────┐
        │ Senha Correta?  │
        └──┬───────────┬──┘
           │           │
        Sim│           │Não (3 tentativas)
           │           │
           ▼           ▼
    ┌────────────┐  ┌──────────────┐
    │ Continuar  │  │ ACESSO NEGADO│
    └─────┬──────┘  │ Encerrar     │
          │         └──────────────┘
          │
    ┌─────▼────────────────────┐
    │ INICIALIZAR AMBIENTE     │
    │ - Criar diretórios       │
    │ - Arquivo de dados       │
    └─────┬────────────────────┘
          │
    ┌─────▼──────────────────────────────┐
    │      EXIBIR MENU PRINCIPAL          │
    │  1- Agendar                         │
    │  2- Listar                          │
    │  3- Pesquisar                       │
    │  4- Cancelar                        │
    │  5- Relatório                       │
    │  0- Sair                            │
    └─────┬──────────────────────────────┘
          │
    ┌─────▼──────────────┐
    │  Qual a opção?     │
    └─┬──────┬──────┬──────┬──────┬───┘
      │      │      │      │      │
   1  │   2  │   3  │   4  │   5  │  0
      │      │      │      │      │
   ┌──▼┐ ┌──▼┐ ┌──▼┐ ┌──▼┐ ┌──▼┐ ▼
   │AG │ │LI │ │PE │ │CA │ │RE │ BACKUP
   │EN │ │ST │ │SQ │ │NC │ │LA │ & EXIT
   │DA │ │AR │ │UI │ │EL │ │TÓ │
   │R  │ │   │ │SA │ │AR │ │RI │
   └─┬─┘ └─┬─┘ └──┬┘ └──┬┘ └──┬┘ │
     │     │      │     │     │  │
     └─────┴──────┴─────┴─────┘  │
            │                     │
            ▼                     │
    ┌──────────────┐             │
    │ Voltar Menu  │             │
    └──────┬───────┘             │
           │                     │
           └─────────────────────▼─────────┐
                                           │
                    ┌──────────────────────┘
                    │
                    ▼
          ┌────────────────────┐
          │ Backup Automático  │
          │ (com timestamp)    │
          └─────────┬──────────┘
                    │
                    ▼
          ┌──────────────────────┐
          │ Encerrar Sistema     │
          │ Até logo! 👋         │
          └──────────────────────┘
```

---

## Fluxo de Agendamento de Consulta

```
          ┌──────────────────────┐
          │ AGENDAR CONSULTA     │
          └──────────┬───────────┘
                     │
          ┌──────────▼──────────┐
          │ Ler Nome Paciente   │
          └──────────┬──────────┘
                     │
          ┌──────────▼──────────────────┐
          │ Paciente Vazio?            │
          └──┬─────────────────────┬───┘
             │Sim                 │Não
             ▼                    │
        ┌────────────┐            │
        │ ERRO!      │            │
        │ Voltar     │            │
        └────────────┘            │
                                  ▼
                     ┌──────────────────────┐
                     │ Ler Nome Médico     │
                     └──────────┬───────────┘
                                │
                     ┌──────────▼─────────────┐
                     │ Médico Vazio?         │
                     └┬──────────────────┬──┘
                      │Sim              │Não
                      ▼                 │
                 ┌──────────┐           │
                 │ ERRO!    │           │
                 │ Voltar   │           │
                 └──────────┘           │
                                        ▼
                           ┌────────────────────────┐
                           │ Ler Data (DD/MM/YYYY)  │
                           └────────────┬───────────┘
                                        │
                           ┌────────────▼──────────────┐
                           │ Validar Formato Data     │
                           └┬──────────────────────┬──┘
                             │Inválido             │OK
                             ▼                     │
                        ┌──────────────┐           │
                        │ Repetir      │           │
                        │ (até acertar)│           │
                        └──────────────┘           │
                                                   ▼
                              ┌────────────────────────┐
                              │ Ler Horário (HH:MM)    │
                              └────────────┬───────────┘
                                           │
                              ┌────────────▼──────────────┐
                              │ Validar Formato Horário  │
                              └┬──────────────────────┬──┘
                                │Inválido             │OK
                                ▼                     │
                           ┌──────────────┐           │
                           │ Repetir      │           │
                           │ (até acertar)│           │
                           └──────────────┘           │
                                                      ▼
                              ┌────────────────────────────┐
                              │ Salvar Consulta no Arquivo│
                              │ Paciente|Médico|Data|Hora │
                              └────────────┬───────────────┘
                                           │
                              ┌────────────▼─────────────┐
                              │ Exibir Confirmação ✓     │
                              │ e Dados da Consulta      │
                              └──────────────┬──────────┘
                                             │
                              ┌──────────────▼─────────┐
                              │ Voltar Menu Principal   │
                              └────────────────────────┘
```

---

## Fluxo de Cancelamento com Confirmação (BRONZE)

```
          ┌──────────────────────┐
          │ CANCELAR CONSULTA    │
          └──────────┬───────────┘
                     │
          ┌──────────▼──────────────────┐
          │ Ler Nome do Paciente        │
          └──────────┬──────────────────┘
                     │
          ┌──────────▼──────────────────┐
          │ Procurar Consulta           │
          │ do Paciente                 │
          └─┬────────────────────────┬──┘
            │Encontrada              │Não
            ▼                        │
     ┌────────────────┐             │
     │ Exibir Dados   │             │
     │ da Consulta    │             │
     └────────┬───────┘             │
              │                     │
     ┌────────▼─────────────────┐   │
     │ Confirmar?               │   │
     │ [s/n]                    │   │
     └┬──────────┬──────────────┘   │
      │s         │n                 │
      ▼          │                  │
   ┌─────┐       │                  ▼
   │ SIM │       │ ┌──────────────────────┐
   └──┬──┘       │ │ Cancelada Operação   │
      │          │ │ Voltar Menu          │
      │          └─┴──────────────────────┘
      │
      ▼
   ┌────────────────────────┐
   │ Fazer Backup da Consulta
   │ (consultas_canceladas_*.bak)
   └────────┬───────────────┘
            │
   ┌────────▼──────────────────┐
   │ Remover do Arquivo        │
   │ (grep -v)                 │
   └────────┬──────────────────┘
            │
   ┌────────▼──────────────────┐
   │ Exibir Confirmação ✓      │
   │ Consulta Cancelada!       │
   └────────┬──────────────────┘
            │
   ┌────────▼─────────────────┐
   │ Voltar Menu Principal    │
   └──────────────────────────┘
```

---

## Fluxo de Pesquisa com Múltiplos Filtros

```
          ┌──────────────────────┐
          │ PESQUISAR CONSULTA   │
          └──────────┬───────────┘
                     │
          ┌──────────▼──────────────┐
          │ Menu de Filtros:       │
          │ 1- Por Paciente        │
          │ 2- Por Médico          │
          │ 3- Por Data            │
          └──┬──────┬──────┬───────┘
             │      │      │
          1  │   2  │   3  │
             │      │      │
         ┌───▼┐ ┌───▼┐ ┌───▼──┐
         │PAC │ │MED │ │DATA  │
         │    │ │    │ │      │
         └─┬──┘ └─┬──┘ └──┬───┘
           │      │       │
           ▼      ▼       ▼
    ┌────────────────────────┐
    │ Ler Termo de Busca     │
    └──────────┬─────────────┘
               │
    ┌──────────▼─────────────────────┐
    │ Usar awk para Busca            │
    │ (case-insensitive no campo)    │
    └──────────┬─────────────────────┘
               │
    ┌──────────▼──────────────────┐
    │ Resultados Encontrados?     │
    └┬──────────────────────────┬──┘
     │Sim                       │Não
     │                          │
     │                          ▼
     │                   ┌──────────────┐
     │                   │ Mensagem:    │
     │                   │ Não encontrou│
     │                   └──────────────┘
     │
     ▼
  ┌──────────────────────┐
  │ Exibir Resultados    │
  │ em Tabela Formatada  │
  │ com Numeração        │
  └──────────┬───────────┘
             │
  ┌──────────▼──────────────┐
  │ Mostrar Total de        │
  │ Resultados Encontrados  │
  └──────────┬──────────────┘
             │
  ┌──────────▼─────────────┐
  │ Voltar Menu Principal  │
  └───────────────────────┘
```

---

## Fluxo de Relatório com Exportação (DIAMANTE)

```
          ┌──────────────────────┐
          │ GERAR RELATÓRIO      │
          └──────────┬───────────┘
                     │
          ┌──────────▼──────────────┐
          │ Tem Consultas?          │
          └┬──────────────────────┬─┘
           │Não                  │Sim
           ▼                     │
      ┌─────────────┐            │
      │ Mensagem:   │            │
      │ Nenhuma     │            │
      │ Voltar Menu │            │
      └─────────────┘            │
                                 ▼
                      ┌──────────────────────┐
                      │ Calcular Estatísticas│
                      │ - Total              │
                      │ - Por Médico         │
                      │ - Médico Top        │
                      │ - Por Data           │
                      └──────────┬───────────┘
                                 │
                      ┌──────────▼───────────┐
                      │ Exibir Relatório     │
                      │ com Tabelas          │
                      │ Formatadas           │
                      └──────────┬───────────┘
                                 │
                      ┌──────────▼──────────────┐
                      │ Exportar em Arquivo?   │
                      │ [s/n]                  │
                      └┬──────────────────┬───┘
                        │s               │n
                        ▼               │
                  ┌─────────────┐       │
                  │ Salvar TXT  │       │
                  │ (com data)  │       │
                  └────┬────────┘       │
                       │                │
                  ┌────▼────────────┐   │
                  │ Exibir Local    │   │
                  │ do Arquivo      │   │
                  └────┬────────────┘   │
                       │                │
                       └────────┬───────┘
                                │
                      ┌─────────▼──────────┐
                      │ Voltar Menu        │
                      │ Principal          │
                      └────────────────────┘
```

---

## Estados do Sistema

```
╔════════════════════════════════════════════╗
║           ESTADOS DO SISTEMA               ║
╠════════════════════════════════════════════╣
║                                            ║
║  [1] INICIAL                               ║
║      └─► Login (autenticação)              ║
║                                            ║
║  [2] AUTENTICADO                           ║
║      └─► Menu Principal                    ║
║          ├─► Agendar Consulta              ║
║          ├─► Listar Consultas              ║
║          ├─► Pesquisar Consulta            ║
║          ├─► Cancelar Consulta             ║
║          ├─► Gerar Relatório               ║
║          └─► Sair (Backup Auto)            ║
║                                            ║
║  [3] ENCERRADO                             ║
║      └─► Backup realizado                  ║
║      └─► Saída do programa                 ║
║                                            ║
╚════════════════════════════════════════════╝
```

---

**Versão do Fluxograma:** 1.0  
**Última atualização:** 08/06/2026
