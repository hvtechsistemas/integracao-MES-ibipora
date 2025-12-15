#INCLUDE 'Protheus.ch'

/*/{Protheus.doc} MTA650I
Ponto de Entrada que atua na geração de Ordens de Produção
@type function
@version 1.0 
@author Bruno Aguiar
@since 04/09/2024
/*/

User Function MTA650I()

    If ExistBlock("integracaoSyneco.InsereOp")
        If (SC2->C2_TPPR $ 'I|R|O|C') .And. (!Empty(SC2->C2_ROTEIRO))
        ExecBlock("integracaoSyneco.InsereOp",.F.,.F.,)
      EndIf
    EndIf

    If ExistBlock("FPCP001E")
		  U_FPCP001E()
	  Endif


Return
