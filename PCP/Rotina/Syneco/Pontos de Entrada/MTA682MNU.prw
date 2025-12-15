#INCLUDE "Protheus.ch"

/*/{Protheus.doc} MTA682MNU
Ponto de Entrada utilizado para adicionar ações relacionadas no Apontamento de Horas Improdutivas
@type Ponto de Entrada
@version 1.0
@author Bruno Aguiar
@since 12/08/2024
/*/
  
User Function MTA682MNU()
  
    AADD(aRotina, {'Monitor de Integracao','U_ViewInt()', 0, 3, 0, NIL})
  
Return Nil
