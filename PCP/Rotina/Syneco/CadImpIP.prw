#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
 

Static cTitulo := "Linha de Impressão x IP"
 
/*/{Protheus.doc} CadImpIP
Função para cadastro de Linha de Impressao x IP.
@type function
@version  1.0
@author Bruno Aguiar
@since 11/09/2024
@return variant, Null
/*/ 
User Function CadImpIP()
    Local aArea   := GetArea()
    Local oBrowse
     
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("ZC4")
    oBrowse:SetDescription(cTitulo)
    oBrowse:Activate()
     
    RestArea(aArea)
Return Nil
 
/*
    Funcao para moontar o menu
*/
Static Function MenuDef()
    Local aRot := {}
     
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.CadImpIP'    OPERATION 1 ACCESS 0 
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.CadImpIP'    OPERATION 3 ACCESS 0 
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.CadImpIP'    OPERATION 4 ACCESS 0 
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.CadImpIP'    OPERATION 5 ACCESS 0 

Return aRot
 
/*
    Funcao ModelDef
*/
Static Function ModelDef()
    Local oModel := Nil
    Local oStSBM := FWFormStruct(1, "ZC4")
     
    oModel := MPFormModel():New("MCadImpIP",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
    
     
    oModel:AddFields("FORMSBM",/*cOwner*/,oStSBM)
    oModel:SetPrimaryKey({'ZC4_FILIAL','ZC4_CODIGO'})
    oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
     
    oModel:GetModel("FORMSBM"):SetDescription("Formulário do Cadastro "+cTitulo)

Return oModel
 
/*
    Funcao ViewDef
*/
Static Function ViewDef()
    Local oModel := FWLoadModel("CadImpIP")
    Local oStSBM := FWFormStruct(2, "ZC4") 
    Local oView := Nil
 
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    oView:AddField("VIEW_SBM", oStSBM, "FORMSBM")
    oView:CreateHorizontalBox("TELA",100)
    
    oView:SetCloseOnOk({||.T.})
     
    oView:SetOwnerView("VIEW_SBM","TELA")

Return oView
 
