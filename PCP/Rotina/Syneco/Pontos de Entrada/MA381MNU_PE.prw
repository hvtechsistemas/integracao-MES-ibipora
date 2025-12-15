/*/{Protheus.doc} MA381MNU
Ponto de entrada que Adiciona opções no menu da rotina
@type function
@version 1.0
@author Bruno Aguiar
@since 09/09/2024
@return variant, aRotina
/*/

User Function MA381MNU()
    Local aRotina := ParamIxb

    aAdd(aRotina,{'Monitor Integração','U_ViewInt()', 0 , 2})
    

Return aRotina
