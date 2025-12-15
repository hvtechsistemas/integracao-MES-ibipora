#INCLUDE 'Protheus.ch'

/*/{Protheus.doc} MT681INC
Ponto de Entrada executado após a gravação dos dados na rotina de inclusão do apontamento de produção PCP Mod2..
@type Ponto de Entrada
@version 1.0
@author Bruno Aguiar
@since 27/08/2024
/*/

User Function MT681INC
    Local cOp       := Right(SH6->H6_FILIAL,1)+AllTrim(SH6->H6_OP)
    Local cOperacao := SH6->H6_OPERAC

    If SH6->H6_PT == "T" 
        integracaoSyneco.U_UpdateIMP(cOp, cOperacao)
    EndIf

Return
