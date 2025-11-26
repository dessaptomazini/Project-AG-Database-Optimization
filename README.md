📊 Projeto de Automação e Saneamento de Dados Financeiros/Jurídicos

🎯 O Desafio de Negócio
O departamento jurídico enfrentava dificuldades na consolidação de dados de créditos tributários provenientes de múltiplas planilhas mensais descentralizadas. Os principais problemas eram:

Duplicidade de Clientes e CNPJ: O mesmo cliente aparecia com grafias diferentes em arquivos diferentes (ex: "Empresa X Ltda", "Empresa X", "Empresa X - 123"), impedindo uma visão consolidada.

Processo Manual: Inexistência de qualquer dashboard impedindo análise de qualquer natureza (financeira, volume de trabalho, tempo e sazonalidade de demanda) por 5 anos.

Conexão de Dados Complexa: Dificuldade em cruzar dados de processos jurídicos (base interna) com dados de faturamento e honorários (dataset financeiro externo) devido à falta de chaves únicas padronizadas.

💡 A Solução Implementada
Desenvolvi uma solução de BI ponta a ponta ("End-to-End") focada em Engenharia de Dados no Power Query para garantir a integridade da informação antes da visualização.

🛠️ Principais Técnicas Utilizadas
1. ETL Automático (SharePoint)
Implementei uma conexão direta com a Pasta do SharePoint da empresa.
Criei um script em Linguagem M que detecta automaticamente novos arquivos mensais (.xlsx), filtra arquivos temporários ou de controle, e combina os dados em uma única tabela fato (fBaseCreditos).
O sistema é 100% automático: basta salvar o arquivo na pasta e o painel se atualiza.

2. Algoritmo de Padronização de Clientes (Deduplicação)
Para resolver a duplicidade de nomes, criei uma lógica avançada no Power Query (Dim_Clientes_Final) que:

- Identifica todos os CNPJs únicos na base.
- Agrupa todas as variações de nomes encontradas para aquele CNPJ.
- Aplica uma lógica para selecionar automaticamente o nome mais completo (maior string de texto) como o "Nome Oficial".
- Realiza uma limpeza robusta de caracteres especiais e números indesejados nos nomes.

Resultado: Uma dimensão de clientes única e limpa que retroalimenta a tabela fato, eliminando duplicatas nos relatórios.

3. Modelagem de Dados (Star Schema & Bridge Tables)
Criação de uma tabela dimensão calendário (dCalendario) para análises temporais.

Resolução de relacionamentos complexos ("Muitos-para-Muitos") entre Notas Fiscais e Processos utilizando uma tabela ponte de CNPJs únicos (Dim_CNPJ_CPF) criada via DAX, garantindo a integridade dos filtros cruzados.

📂 Estrutura dos Arquivos
Este repositório contém apenas os scripts de lógica (devido à confidencialidade dos dados):

ETL_Padronizacao_Clientes.m: Lógica de limpeza e deduplicação de clientes.
ETL_Ingestao_Automatica.m: Script de conexão e combinação de arquivos do SharePoint.
Medidas_e_Modelagem.dax: Principais métricas e tabelas calculadas.
