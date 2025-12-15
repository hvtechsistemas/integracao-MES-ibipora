#INCLUDE 'Protheus.ch'

/*/{Protheus.doc} MTA650AE
Ponto de Entrada que atua após a Exclusão de Ordem de Operação.
@type function
@version  1.0
@author Bruno Aguiar
@since 04/09/2024
/*/

User Function MTA650AE()

    If ExistBlock("integracaoSyneco.ExcluirOp")
        ExecBlock("integracaoSyneco.ExcluirOp",.F.,.F.) 
    EndIf

Return
