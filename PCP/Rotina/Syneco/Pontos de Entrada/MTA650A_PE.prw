#INCLUDE 'Protheus.ch'

/*/{Protheus.doc} MTA650A
Ponto de Entrada que atua após a gravação de todos os registros de alteração realizado na função A650Altera(rotina de alteração do cadastramento de Ordens de Produção).
@type function
@version 1.0
@author Bruno Aguiar
@since 04/09/2024
/*/

User Function MTA650A()
    If (SC2->C2_TPPR $ 'I|R|O') .And. (!Empty(SC2->C2_ROTEIRO))

        If ExistBlock("integracaoSyneco.InsereOp")
            integracaoSyneco.U_InsereOp('2')
        EndIf
        
    ElseIf SC2->C2_TPPR == 'E'
        If ExistBlock("integracaoSyneco.ExcluirOp")
            ExecBlock("integracaoSyneco.ExcluirOp",.F.,.F.)
        EndIf
    EndIf

Return
