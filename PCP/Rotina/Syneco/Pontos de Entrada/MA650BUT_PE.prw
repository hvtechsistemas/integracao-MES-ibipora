#INCLUDE 'Protheus.ch'

/*/{Protheus.doc} MA650BUT
Ponto de Entrada utilizado para adicionar itens no menu  principal do fonte MATA650.PRX.
@type Ponto de Entrada
@version 1.0  
@author Bruno Aguiar
@since 02/08/2024
/*/

User Function MA650BUT()

    aAdd(aRotina,{'Monitor Integração','U_ViewInt()',0,5 })

Return aRotina

