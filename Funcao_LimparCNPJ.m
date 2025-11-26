let
    // Garante que o valor é texto antes de limpar
    TextoConvertido = Text.From(texto),

    // Remove o "hífen suave" invisível (o caractere problemático)
    TextoSemHifenSuave = Text.Replace(TextoConvertido, "#(00AD)", ""),

    // Remove outros caracteres de pontuação comuns
    TextoSemPontuacao = Text.Remove(TextoSemHifenSuave, {".", "/", "-"}),

    // Remove espaços normais no início e fim
    TextoFinalAparado = Text.Trim(TextoSemPontuacao)
in
    TextoFinalAparado
