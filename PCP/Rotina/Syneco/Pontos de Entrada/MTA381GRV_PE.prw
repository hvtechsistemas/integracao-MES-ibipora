/*/{Protheus.doc} MTA381GRV
 Ponto de entrada utilizado para realizar operações complementares após a inclusão, exclusão ou alteração de empenho.
@type function
@version 1.0 
@author Bruno Aguiar
@since 09/09/2024
@return variant, Null
/*/


User Function MTA381GRV
Local ExpL1 := PARAMIXB[1]
Local ExpL2 := PARAMIXB[2]


If ExpL1 
    If ExistBlock("integracaoSyneco.InsereEmpenho")
        ExecBlock("integracaoSyneco.InsereEmpenho",.F.,.F.) 
    EndIf
ElseIf ExpL2 
    If ExistBlock("integracaoSyneco.ExcluirEmpenho")
        ExecBlock("integracaoSyneco.ExcluirEmpenho",.F.,.F.) 
    EndIf
else
    If ExistBlock("integracaoSyneco.InsereEmpenho")
        integracaoSyneco.U_InsereEmpenho('2')
    EndIf
EndiF

Return
