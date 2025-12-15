/*/{Protheus.doc} MA650EMP
 Ponto de entrada Utilizado para manipular informações dos empenhos na abertura da Ordem de Produção
@type function
@version 1.0 
@author Bruno Aguiar
@since 09/09/2024
@return variant, Null
/*/

USER FUNCTION MA650EMP()
Local aItems := aCols 

    If ExistBlock("integracaoSyneco.InsereEmpenho")
        ExecBlock("integracaoSyneco.InsereEmpenho",.F.,.F.) 
    EndIf


    // Exclui OPs intemediarias de Transformação e Amostra Grátis

	If ExistBlock("FPCP001G")
		U_FPCP001G()
	Endif
      
Return
