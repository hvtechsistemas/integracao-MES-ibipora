#Include "Totvs.ch"
#Include "TBICONN.ch"
 
/*/{Protheus.doc} zVerificaOp
Função para verificar se a ordem de produção enviada para o Syneco teve apontamento de produção e/ou perda. (via Job ou Menu)
@type  Function
@author Bruno Aguiar
@since 07/08/2024
*/
 
User Function VerificaOp()
    Private cDeFilial       		:= Space(TamSX3("ZC2_FILIAL")[01])
	Private cAteFilial      		:= Space(TamSX3("ZC2_FILIAL")[01])
	Private cDeOP      		        := Space(TamSX3("ZC2_OP")[01])
	Private cAteOP      		    := Space(TamSX3("ZC2_OP")[01])
    Private cEmprLog                := ""


    cEmprLog := FWCodEmp()

    DbSelectArea("SH6")
    DbSetOrder(1)
	
    If IsBlind()
       integracaoSyneco.U_ReenviaOP(1)
    Else
        ValidPerg()
	    cDeFilial      	:= MV_PAR01
	    cAteFilial     	:= MV_PAR02
	    cDeOP     	    := MV_PAR03
	    cAteOP     	    := MV_PAR04
        integracaoSyneco.U_ReenviaOP(2, cDeFilial, cAteFilial, cDeOP, cAteOP)
    EndIf
 
Return 

/*
Funçao para carregar as perguntas
*/
Static Function ValidPerg()
    Local cGrupoPerg	    := "Enviar Apontamento de Producao"             
    Local cTituloPerg	    := "Enviar Apontamento de Producao" 
    Local aRet 			    := {} 
    Local aPergs		    := {}
    Local lRet			    := .F.
    
	aAdd(aPergs, {1, "Filial De:"   		        ,cDeFilial          ,        ,"", ""    , ".T.", 50,  .F.})
	aAdd(aPergs, {1, "Filial Até:"  		        ,cAteFilial         ,        ,"", ""    , ".T.", 50,  .F.})
	aAdd(aPergs, {1, "Ordem de Producao De:"  		,cDeOP              ,        ,"", "SC2" , ".T.", 50,  .F.})
	aAdd(aPergs, {1, "Ordem de Producao Até:"  		,cAteOP             ,        ,"", "SC2" , ".T.", 50,  .F.})
		
	lRet := ParamBox(aPergs,cTituloPerg,@aRet,,,,,,,cGrupoPerg,.T.,.T.)
             		
Return (lRet)
