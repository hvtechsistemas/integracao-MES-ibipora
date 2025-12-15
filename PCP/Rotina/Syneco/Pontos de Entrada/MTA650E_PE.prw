#INCLUDE 'Protheus.ch'

/*/{Protheus.doc} MTA650E
Ponto de Entrada Responsável pela Deleção de O.PsEM QUE PONTO : É chamado antes de excluir a Op.
@type Ponto de Entrada
@version 1.0 
@author Bruno Aguiar
@since 17/10/2024
/*/

User Function MTA650E()
    Local aArea := GetArea()
    Local lRet  := .F.
 
    If ExistBlock("integracaoSyneco.ValidaExclusao")
        lRet := ExecBlock("integracaoSyneco.ValidaExclusao",.F.,.F.) 
    EndIf
    
    RestArea(aArea)

Return lRet
