#!/bin/bash

echo "# Resultados dos Testes de Carga - WordPress na AWS" > Results.md
echo "" >> Results.md
echo "Testes realizados com Locust para avaliação de desempenho de diferentes configurações de instâncias EC2." >> Results.md
echo "" >> Results.md

for dir in c5-* t3-* t3.*; do
    if [ -d "$dir" ]; then
        echo "## $dir" >> Results.md
        echo "" >> Results.md
        echo "| Usuários | Requests | Falhas | Mediana (ms) | Média (ms) | Mín (ms) | Máx (ms) | Tam. Médio (bytes) | RPS | Falhas/s | P50 | P66 | P75 | P80 | P90 | P95 | P98 | P99 | P99.9 | P99.99 | P100 | Taxa Erro (%) |" >> Results.md
        echo "|----------|----------|--------|--------------|------------|----------|----------|-------------------|-----|----------|-----|-----|-----|-----|-----|-----|-----|-----|-------|--------|------|---------------|" >> Results.md
        
        # Coleta resultados e ordena por número de usuários
        results=()
        
        for result_dir in "$dir"/resultados_*; do
            if [ -d "$result_dir" ]; then
                # Extrai número de usuários do nome da pasta
                users=$(echo "$result_dir" | grep -oP '\d+(?=users)')
                
                # Lê dados do arquivo dados_stats.csv
                stats_file="$result_dir/dados_stats.csv"
                if [ -f "$stats_file" ]; then
                    # Pega linha "Aggregated" que tem os totais
                    line=$(grep "Aggregated" "$stats_file" 2>/dev/null)
                    if [ -n "$line" ]; then
                        # Formato CSV do Locust (colunas):
                        # 1:Type, 2:Name, 3:Request Count, 4:Failure Count, 5:Median Response Time, 
                        # 6:Average Response Time, 7:Min Response Time, 8:Max Response Time, 
                        # 9:Average Content Size, 10:Requests/s, 11:Failures/s,
                        # 12:50%, 13:66%, 14:75%, 15:80%, 16:90%, 17:95%, 18:98%, 19:99%, 20:99.9%, 21:99.99%, 22:100%
                        
                        # Extrai todos os campos
                        read requests failures median avg min_rt max_rt avg_size rps failures_s p50 p66 p75 p80 p90 p95 p98 p99 p999 p9999 p100 <<< $(echo "$line" | awk -F',' '{
                            gsub(/\r/, "", $22);
                            print $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22
                        }')
                        
                        # Calcula taxa de erro
                        if [ -n "$requests" ] && [ "$requests" != "0" ] && [ -n "$failures" ]; then
                            error_rate=$(awk "BEGIN {printf \"%.2f\", ($failures / $requests) * 100}")
                        else
                            error_rate="0.00"
                        fi
                        
                        # Formata valores para exibição
                        requests_fmt=$(printf "%.0f" "$requests" 2>/dev/null || echo "$requests")
                        failures_fmt=$(printf "%.0f" "$failures" 2>/dev/null || echo "$failures")
                        median_fmt=$(printf "%.0f" "$median" 2>/dev/null || echo "$median")
                        avg_fmt=$(printf "%.2f" "$avg" 2>/dev/null || echo "$avg")
                        min_fmt=$(printf "%.2f" "$min_rt" 2>/dev/null || echo "$min_rt")
                        max_fmt=$(printf "%.2f" "$max_rt" 2>/dev/null || echo "$max_rt")
                        avg_size_fmt=$(printf "%.0f" "$avg_size" 2>/dev/null || echo "$avg_size")
                        rps_fmt=$(printf "%.2f" "$rps" 2>/dev/null || echo "$rps")
                        failures_s_fmt=$(printf "%.2f" "$failures_s" 2>/dev/null || echo "$failures_s")
                        p50_fmt=$(printf "%.0f" "$p50" 2>/dev/null || echo "$p50")
                        p66_fmt=$(printf "%.0f" "$p66" 2>/dev/null || echo "$p66")
                        p75_fmt=$(printf "%.0f" "$p75" 2>/dev/null || echo "$p75")
                        p80_fmt=$(printf "%.0f" "$p80" 2>/dev/null || echo "$p80")
                        p90_fmt=$(printf "%.0f" "$p90" 2>/dev/null || echo "$p90")
                        p95_fmt=$(printf "%.0f" "$p95" 2>/dev/null || echo "$p95")
                        p98_fmt=$(printf "%.0f" "$p98" 2>/dev/null || echo "$p98")
                        p99_fmt=$(printf "%.0f" "$p99" 2>/dev/null || echo "$p99")
                        p999_fmt=$(printf "%.0f" "$p999" 2>/dev/null || echo "$p999")
                        p9999_fmt=$(printf "%.0f" "$p9999" 2>/dev/null || echo "$p9999")
                        p100_fmt=$(printf "%.0f" "$p100" 2>/dev/null || echo "$p100")
                        
                        results+=("$users|$requests_fmt|$failures_fmt|$median_fmt|$avg_fmt|$min_fmt|$max_fmt|$avg_size_fmt|$rps_fmt|$failures_s_fmt|$p50_fmt|$p66_fmt|$p75_fmt|$p80_fmt|$p90_fmt|$p95_fmt|$p98_fmt|$p99_fmt|$p999_fmt|$p9999_fmt|$p100_fmt|$error_rate")
                    fi
                fi
            fi
        done
        
        # Ordena por número de usuários e imprime
        printf '%s\n' "${results[@]}" | sort -t'|' -k1 -n | while IFS='|' read -r users requests failures median avg min_rt max_rt avg_size rps failures_s p50 p66 p75 p80 p90 p95 p98 p99 p999 p9999 p100 error_rate; do
            echo "| $users | $requests | $failures | $median | $avg | $min_rt | $max_rt | $avg_size | $rps | $failures_s | $p50 | $p66 | $p75 | $p80 | $p90 | $p95 | $p98 | $p99 | $p999 | $p9999 | $p100 | $error_rate |" >> Results.md
        done
        
        echo "" >> Results.md
    fi
done

echo "" >> Results.md
echo "---" >> Results.md
echo "" >> Results.md
echo "## Legenda" >> Results.md
echo "" >> Results.md
echo "| Coluna | Descrição |" >> Results.md
echo "|--------|-----------|" >> Results.md
echo "| Usuários | Número de usuários virtuais simultâneos |" >> Results.md
echo "| Requests | Total de requisições realizadas |" >> Results.md
echo "| Falhas | Número de requisições que falharam |" >> Results.md
echo "| Mediana (ms) | Tempo de resposta mediano (P50) |" >> Results.md
echo "| Média (ms) | Tempo de resposta médio |" >> Results.md
echo "| Mín (ms) | Menor tempo de resposta |" >> Results.md
echo "| Máx (ms) | Maior tempo de resposta |" >> Results.md
echo "| Tam. Médio (bytes) | Tamanho médio do conteúdo da resposta |" >> Results.md
echo "| RPS | Requisições por segundo (throughput) |" >> Results.md
echo "| Falhas/s | Falhas por segundo |" >> Results.md
echo "| P50-P100 | Percentis de tempo de resposta |" >> Results.md
echo "| Taxa Erro (%) | Porcentagem de requisições com erro |" >> Results.md
echo "" >> Results.md

echo "Results.md gerado com sucesso!"