#INCLUDE 'Protheus.ch'
#INCLUDE 'FWMVCDef.ch'
#INCLUDE 'TopConn.ch'
#INCLUDE "TBICONN.ch"

#Define TITULO              "Monitor de Integração"
#Define ALIAS_FORM0         "ZC2"
#Define ALIAS_GRID0         "ZC3"
#Define DB_SQLSERVER		"MSSQL"


/*/{Protheus.doc} MONINTEG
Rotina de Monitoração de Integração
@type function
@author Bruno Aguiar
@since	06/09/2024
/*/

User Function MONINTEG()
	Local 	oBrowse   			:= Nil

	oBrowse:= FWMBrowse():New()
	oBrowse:SetAlias(ALIAS_FORM0)
	oBrowse:SetDescription(TITULO)

	oBrowse:AddLegend("ZC2_STATUS == 'I'" ,"BR_VERDE" 		,"Integrado"			)
	oBrowse:AddLegend("ZC2_STATUS == 'E'" ,"BR_VERMELHO" 	,"Erro Integracao"		)

	oBrowse:Activate()

Return (oBrowse)


Static Function MenuDef()
	Local aRotina	:= {}

	ADD OPTION aRotina TITLE "Visualizar"       ACTION "VIEWDEF.MONINTEG"	 OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE "Reprocessar" 	    ACTION "U_REPROCESS"   		 OPERATION 6 ACCESS 0
	ADD OPTION aRotina TITLE 'Legenda'    		ACTION 'u_zMVC01Leg'     	 OPERATION 6 ACCESS 0 

Return(aRotina)


Static Function ModelDef()
	Local oModel		:= Nil
	Local oStruZA1      := FWFormStruct( 1, ALIAS_FORM0	,/*bAvalCampo*/,/*lViewUsado*/ )
	Local oStruZA2      := FWFormStruct( 1, ALIAS_GRID0	,/*bAvalCampo*/,/*lViewUsado*/ )

	oModel := MPFormModel():New("MONINTE",/*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/)
	oModel:SetDescription(TITULO)

	oModel:AddFields("ZC2MASTER",,oStruZA1)
	oModel:AddGrid("ZC3GRID"	,"ZC2MASTER"	,oStruZA2	,/*bLinePre*/	,/*bPosValidacao*/,/*bLinePost*/	,,, /*bLoadZ02*/)

	oModel:SetRelation(  'ZC3GRID' , {{ 'ZC3_FILIAL' , 'xFilial("ZC3")' } , { 'ZC3_OP' , 'ZC2_OP' }, {'ZC3_ROTINA', 'ZC2_ROTINA'}}  , ZC3->( IndexKey(1) ))

	oModel:GetModel('ZC3GRID'):SetOnlyView()
	oModel:GetModel( "ZC3GRID" ):SetOptional(.T.)
	oModel:GetModel("ZC2MASTER"):SetDescription(TITULO)

	oModel:SetPrimaryKey({"ZC2_FILIAL+ZC2_OP"})


Return(oModel)


Static Function ViewDef()
	Local oModel	:= FWLoadModel("MONINTEG")
	Local oStruZA1	:= FWFormStruct(2,ALIAS_FORM0)
	Local oStruZA2	:= FWFormStruct(2,ALIAS_GRID0)
	Local nPorZC2	:= 20
	Local nPorZC3	:= 80
	Private oView	:= Nil

	oView:=FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField("VIEW_ZC2"	,oStruZA1	,"ZC2MASTER")
	oView:AddGrid("VIEW_ZC3"	,oStruZA2	,"ZC3GRID"	)

	oStruZA1:SetProperty("ZC2_OP"	    ,MVC_VIEW_TITULO	,"Ordem Producao"	    )
	oStruZA1:SetProperty("ZC2_DATA"	    ,MVC_VIEW_TITULO	,"Data Integracao"	    )

    oStruZA2:SetProperty("ZC3_DATA"	    ,MVC_VIEW_TITULO	,"Data Integracao"	    )
    oStruZA2:SetProperty("ZC3_HORA"	    ,MVC_VIEW_TITULO	,"Hora Integracao"	    )
    oStruZA2:SetProperty("ZC3_USER"	    ,MVC_VIEW_TITULO	,"Usuario Integracao"	)
    oStruZA2:SetProperty("ZC3_MSGINT"	,MVC_VIEW_TITULO	,"Mensagem Processo"	)

	oStruZA2:RemoveField("ZC3_OP")

	oView:CreateHorizontalBox("TELAZC2"	,nPorZC2)
	oView:CreateHorizontalBox("TELAZC3"	,nPorZC3)

	oView:SetOwnerView("VIEW_ZC2"	,"TELAZC2")
	oView:SetOwnerView("VIEW_ZC3"	,"TELAZC3")


Return(oView)

User Function zMVC01Leg()
    Local aLegenda := {}
     
    AADD(aLegenda,{"BR_VERDE",       "Integrado"  	})
    AADD(aLegenda,{"BR_VERMELHO",    "Erro"			})
     
    BrwLegenda("Status da Integracao", "Status", aLegenda)
Return


User Function REPROCESS()
    Local cChvOp := SubStr(ZC2->ZC2_OP,1,TamSX3("C2_FILIAL")[01]+TamSX3("C2_NUM")[01])
	Local lRet  := .T.
    
    If ZC2->ZC2_STATUS == "I"
        MsgInfo("A OP posicionada já foi integrada com sucesso!", "ATENÇÃO")
    Else
		if FwAlertYesNo("Deseja reprocessar a Integração da OP?", )

			// posiciona na OP
			DBSelectArea("SC2")
			SC2->(DBSetOrder(1))
			If	!SC2->(DbSeek(cChvOp))
				FwAlertInfo("Ordem de Produção não encontrada!","ATENÇÃO")
			Else

				If ZC2->ZC2_ROTINA == "6" .And. ZC2->ZC2_EVENTO == "R"
					integracaoSyneco.U_ReenviaHrs(3)

				ElseIf ZC2->ZC2_ROTINA == "5" .And. ZC2->ZC2_EVENTO == "R"
					integracaoSyneco.U_ReenviaOP(3)

				// ElseIf ZC2->ZC2_ROTINA == "7" .And. ZC2->ZC2_EVENTO == "R"
				// 	integracaoSyneco.U_ReenviaPerda(3)

				ElseIf ZC2->ZC2_ROTINA == "4" .And. ZC2->ZC2_EVENTO == "R"
					integracaoSyneco.U_ReenviaEmpenho(3)
					
				ElseIf ZC2->ZC2_ROTINA == "1" .And. ZC2->ZC2_EVENTO ==  "E"
					ExecBlock("integracaoSyneco.InsereOp",.F.,.F.,)
					
				ElseiF ZC2->ZC2_ROTINA == "2" .And. ZC2->ZC2_EVENTO == "E"
					ExecBlock("integracaoSyneco.InsereEmpenho",.F.,.F.,)

				EndIf

				MsgInfo("Reprocessamento Finalizado.")

			endif

        Else
            MsgInfo("Reprocessamento Cancelado", "ATENÇÃO")
        EndIf
    EndIf

Return lRet 
