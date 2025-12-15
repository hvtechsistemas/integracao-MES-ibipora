#Include "Protheus.Ch"

/*/{Protheus.doc} PCP200MNU
Permite ao usuário adicionar novas opções no menu da rotina de cadastro de estrutura. As novas opções devem ser adicionadas no vetor "aRotina", que é utilizado para a montagem do menu funcional.
@version 1.0
@author Bruno Aguiar
@since 28/01/2024
@return variant, aRotina
/*/

User Function PCP200MNU()

    AADD(aRotina, {"Editar Componentes", "U_CMAPCP02()", 0, 9, 0, NIL})
 
Return Nil
