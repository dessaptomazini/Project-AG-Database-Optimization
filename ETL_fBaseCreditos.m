let
    Fonte = SharePoint.Files("https://empresa.sharepoint.com/sites/Projetos", [ApiVersion = 15]),
    #"Linhas Filtradas" = Table.SelectRows(Fonte, each Text.Contains([Folder Path], "BANCO DE DADOS - PROJETO CENTRALIZAÇÃO")),
    #"Linhas Filtradas1" = Table.SelectRows(#"Linhas Filtradas", each ([Name] <> "CNPJs validados.xlsx" and [Name] <> "PLANILHA MESTRA.xlsx")),
    #"Arquivos Ocultos Filtrados1" = Table.SelectRows(#"Linhas Filtradas1", each [Attributes]?[Hidden]? <> true),
    #"Invocar Função Personalizada1" = Table.AddColumn(#"Arquivos Ocultos Filtrados1", "Transformar Arquivo (2)", each #"Transformar Arquivo (2)"([Content])),
    #"Colunas Renomeadas1" = Table.RenameColumns(#"Invocar Função Personalizada1", {"Name", "Nome da Origem"}),
    #"Outras Colunas Removidas1" = Table.SelectColumns(#"Colunas Renomeadas1", {"Nome da Origem", "Transformar Arquivo (2)"}),
    #"Coluna de Tabela Expandida1" = Table.ExpandTableColumn(#"Outras Colunas Removidas1", "Transformar Arquivo (2)", Table.ColumnNames(#"Transformar Arquivo (2)"(#"Arquivo de Amostra (2)"))),
    #"Tipo Alterado" = Table.TransformColumnTypes(#"Coluna de Tabela Expandida1",{{"Nome da Origem", type text}, {"Fonte", type text}, {"Cod. Rastreamento Correios", type text}, {"Nº da comunicação", type text}, {"DRF", type text}, {"Data de Emissão", type date}, {"CNPJ/CPF", type text}, {"Cliente", type text}, {"Data PER/DECOMP", type date}, {"PER/DCOMP Demonstrativo de Crédito", type text}, {"Período de Apuração", type date}, {"Nº do Processo de Crédito", type text}, {"Valor do crédito", type number}, {"Valor do crédito reconhecido", type number}, {"Valor total do pagamento", type any}, {"Valor total utilizado", type any}, {"Principal", type number}, {"Multa", type number}, {"Juros", type number}, {"Nome do Fiscal", type text}, {"Nº das PER/DCOMP vinculadas", type text}, {"Processo de Cobrança", type text}, {"Erro_Obrigatorios", type logical}, {"Erro_Formato_Datas", type logical}, {"Erro_Formato_Valores", type logical}, {"Erro_Formato_Documentos", type logical}, {"Erro_Formato_Textos", type logical}, {"Erro_Formato_Fiscal", type logical}, {"Erro_Formato_Lista_T", type logical}, {"Erro_Formato_Lista_U", type logical}, {"Possui Pendência? ", type logical}, {"CLASSIFICAÇÃO", type text}}),
    #"Colunas Renomeadas" = Table.RenameColumns(#"Tipo Alterado",{{"Nome da Origem", "Localização"}}),
    #"Valor Substituído" = Table.ReplaceValue(#"Colunas Renomeadas",null,"",Replacer.ReplaceValue,{"Fonte"}),
    #"Valor Substituído1" = Table.ReplaceValue(#"Valor Substituído",null,"",Replacer.ReplaceValue,{"Cod. Rastreamento Correios"}),
    #"Valor Substituído2" = Table.ReplaceValue(#"Valor Substituído1",null,"",Replacer.ReplaceValue,{"Nº da comunicação"}),
    #"Valor Substituído3" = Table.ReplaceValue(#"Valor Substituído2",null,"",Replacer.ReplaceValue,{"DRF"}),
    Personalizar1 = Table.AddColumn(#"Valor Substituído3", "CNPJ_Limpo", each fxLimparCNPJ([#"CNPJ/CPF"])),
    #"Personalização Adicionada" = Table.AddColumn(Personalizar1, "CNPJ/CPF FORMATADO", each if Text.Length([CNPJ_Limpo]) = 14 then
    Text.Range([CNPJ_Limpo],0,2) & "." &
    Text.Range([CNPJ_Limpo],2,3) & "." &
    Text.Range([CNPJ_Limpo],5,3) & "/" &
    Text.Range([CNPJ_Limpo],8,4) & "-" &
    Text.Range([CNPJ_Limpo],12,2)
else if Text.Length([CNPJ_Limpo]) = 11 then
    Text.Range([CNPJ_Limpo],0,3) & "." &
    Text.Range([CNPJ_Limpo],3,3) & "." &
    Text.Range([CNPJ_Limpo],6,3) & "-" &
    Text.Range([CNPJ_Limpo],9,2)
else
    [CNPJ_Limpo]),
    #"Tipo Alterado1" = Table.TransformColumnTypes(#"Personalização Adicionada",{{"CNPJ_Limpo", type text}, {"CNPJ/CPF FORMATADO", type text}}),
    #"Colunas Removidas" = Table.RemoveColumns(#"Tipo Alterado1",{"CNPJ/CPF", "CNPJ_Limpo", "Erro_Obrigatorios", "Erro_Formato_Datas", "Erro_Formato_Valores", "Erro_Formato_Documentos", "Erro_Formato_Textos", "Erro_Formato_Fiscal", "Erro_Formato_Lista_T", "Erro_Formato_Lista_U", "Possui Pendência? "}),
    #"Colunas Renomeadas2" = Table.RenameColumns(#"Colunas Removidas",{{"CNPJ/CPF FORMATADO", "CNPJ/CPF"}}),
    #"Coluna Duplicada" = Table.DuplicateColumn(#"Colunas Renomeadas2", "CNPJ/CPF", "CNPJ/CPF - Copiar"),
    #"Colunas Renomeadas4" = Table.RenameColumns(#"Coluna Duplicada",{{"CNPJ/CPF - Copiar", "CNPJ_ChaveLimpa"}}),
    #"Valor Substituído4" = Table.ReplaceValue(#"Colunas Renomeadas4",".","",Replacer.ReplaceText,{"CNPJ_ChaveLimpa"}),
    #"Valor Substituído5" = Table.ReplaceValue(#"Valor Substituído4","/","",Replacer.ReplaceText,{"CNPJ_ChaveLimpa"}),
    #"Valor Substituído6" = Table.ReplaceValue(#"Valor Substituído5","-","",Replacer.ReplaceText,{"CNPJ_ChaveLimpa"}),
    #"Consultas Mescladas" = Table.NestedJoin(#"Valor Substituído6", {"CNPJ/CPF"}, Dim_Clientes_Final, {"CNPJ/CPF"}, "Dim_Clientes_Final", JoinKind.LeftOuter),
    #"Dim_Clientes_Final Expandido" = Table.ExpandTableColumn(#"Consultas Mescladas", "Dim_Clientes_Final", {"Cliente_Limpo_Final"}, {"Cliente_Limpo_Final"}),
    #"Colunas Removidas1" = Table.RemoveColumns(#"Dim_Clientes_Final Expandido",{"Cliente"}),
    #"Colunas Renomeadas3" = Table.RenameColumns(#"Colunas Removidas1",{{"Cliente_Limpo_Final", "Cliente"}}),
    #"Consultas Mescladas1" = Table.NestedJoin(#"Colunas Renomeadas3", {"Cliente"}, Dim_Clientes_Final, {"Cliente_Limpo_Final"}, "Dim_Clientes_Final", JoinKind.LeftOuter),
    #"Dim_Clientes_Final Expandido1" = Table.ExpandTableColumn(#"Consultas Mescladas1", "Dim_Clientes_Final", {"CNPJ/CPF"}, {"Dim_Clientes_Final.CNPJ/CPF"}),
    #"Colunas Renomeadas5" = Table.RenameColumns(#"Dim_Clientes_Final Expandido1",{{"Dim_Clientes_Final.CNPJ/CPF", "CNPJ/CPF_Substituto"}}),
    #"Preenchido Abaixo" = Table.FillDown(#"Colunas Renomeadas5",{"CNPJ/CPF", "CNPJ/CPF_Substituto"}),
    #"Colunas Removidas2" = Table.RemoveColumns(#"Preenchido Abaixo",{"CNPJ/CPF_Substituto"}),
    #"Duplicatas Removidas" = Table.Distinct(#"Colunas Removidas2", {"Nº do Processo de Crédito"})
in
    #"Duplicatas Removidas"
