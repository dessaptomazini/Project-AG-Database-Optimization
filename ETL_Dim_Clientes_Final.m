let
    Fonte = Oficial_Clientes,
    #"Consulta Acrescentada" = Table.Combine({Fonte, Novos_Clientes_Detectados}),
    #"Valor Substituído" = Table.ReplaceValue(#"Consulta Acrescentada","(C)","",Replacer.ReplaceText,{"Cliente"}),
    #"Personalização Adicionada1" = Table.AddColumn(#"Valor Substituído", "Cliente_Limpo_Final", each Text.Trim(Text.TrimEnd([Cliente], {"0".."9", ".", "/", "-", " "}))),
    #"Colunas Removidas" = Table.RemoveColumns(#"Personalização Adicionada1",{"Cliente"}),
    #"Personalização Adicionada" = Table.AddColumn(#"Colunas Removidas", "TamanhoNome", each Text.Length([Cliente_Limpo_Final])),
    #"Linhas Classificadas" = Table.Sort(#"Personalização Adicionada",{{"TamanhoNome", Order.Descending}}),
    #"Duplicatas Removidas" = Table.Distinct(#"Linhas Classificadas", {"CNPJ/CPF"}),
    #"Colunas Removidas1" = Table.RemoveColumns(#"Duplicatas Removidas",{"TamanhoNome"}),
    #"Valor Substituído1" = Table.ReplaceValue(#"Colunas Removidas1","(C)","",Replacer.ReplaceText,{"Cliente_Limpo_Final"})
in
    #"Valor Substituído1"
