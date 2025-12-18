# Entregaveis
  6.1. Relatório Técnico (Formato PDF)
    Um documento conciso (máximo 5 páginas) contendo:
      1.Identificação: Nome, matrícula e link para o repositório GitHub.
      2. Estratégia Adotada:
        - Explique qual caminho você escolheu: Escalabilidade Horizontal (Scale-out), Vertical (Scale-up) ou Tuning de Software?
        - Justifique suas escolhas (ex: "Escolhi 4 instâncias t3.micro porque o custo total seria $0.0416/h, bem abaixo do limite...").
      3. Arquitetura Final:
        - Descreva a configuração final usada (Tipo de instância, Quantidade, Parâmetros do Apache/PHP alterados).
      4. Resultados Obtidos:
        - RPS Máximo: Qual foi a vazão máxima estável atingida?
        - Latência P95: O sistema respeitou o SLO de 10000ms?
        - Taxa de Erro: Houve menos de 1% de erros (5xx)?
      5. Análise de Custo:
        - Tabela demonstrando o cálculo do custo horário da camada de aplicação para provar que respeitou o orçamento de US$ 0.50/h.
      6. Gráficos e Evidências:
        - Print da tela do Locust ao final do teste.
        - Gráficos gerados a partir dos dados (RPS x Tempo, Latência x Tempo).
  6.2. Repositório no GitHub
    - O repositório deve ser público e conter todos os artefatos (código, dados, gráficos, etc), incluindo o próprio relatório, no formato Markdown.
 
