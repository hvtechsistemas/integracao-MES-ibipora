#INCLUDE 'Protheus.ch'

/*/{Protheus.doc} MTA681MNU
Ponto de Entrada utilizado para adicionar ações relacionadas no Apontamento Produção
@type Ponto de Entrada
@version 1.0 
@author Bruno Aguiar
@since 07/08/2024
/*/

User Function MTA681MNU()
 
    aadd(aRotina,{'Monitor de Integracao','U_ViewInt()' , 0 , 7 , 0,NIL})
 
Return
