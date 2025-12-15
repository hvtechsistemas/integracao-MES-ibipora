#include "totvs.ch"
#INCLUDE 'Protheus.ch'
#INCLUDE 'rwmake.ch'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'TbiConn.CH'

/*/{Protheus.doc} CMAPCP02

Rotina para alterar as quantidades e indices de perdas dos componentes.
Rotina para excluir os compenentes das estruturas vinculadas.

@type function
@version  1.0
@author Pedro Alves
@since 02/2025
/*/
User Function CMAPCP02()
	Local oDlg := nil as object
	Local oSize := nil as object
	Local oSize2 := nil as object
    Local oSize3 := nil as object
    Local oSay := nil as object
    Local oSay2 := nil as object
    Local oSay3 := nil as object
    Local aArea := GetArea() as array
	Local aAreaSX3 := SX3->(GetArea()) as array    
    Local cCodOrig := Criavar("G1_COMP",.F.) as char
	Local cGrpOrig := Criavar("G1_GROPC",.F.) as char
	Local cDescOrig := Criavar("B1_DESC",.F.) as char
	Local cOpcOrig := Criavar("G1_OPC",.F.) as char
    Local cCodMaqDe := CriaVar("H1_CODIGO",.F.) as char
    Local cDescDeMaq := CriaVar("H1_DESCRI",.F.) as char
    Local cDescAteMaq := CriaVar("H1_DESCRI",.F.) as char
    Local cCodMaqAte := CriaVar("H1_CODIGO" ,.F.) as char
	Local lOk := .F. as logical
    	
    Private slReplica := SuperGetMv("MV_PCPRLEP", .F., 2) == 1 as logical
    Private oProdOrig := nil as object
    Private oMark := nil as object

    dbSelectArea("SG1")
    DEFINE MSDIALOG oDlg FROM  140, 000 TO 385, 615 TITLE "Edição de Componentes" PIXEL

        oSize := FwDefSize():New(.T.,,,oDlg)
        oSize:AddObject( "LABEL1" 	,  100, 50, .T., .T. )
        oSize:AddObject( "LABEL2"   ,  100, 50, .T., .T. )
        oSize:lProp 	:= .T. 
        oSize:aMargins 	:= { 6, 6, 6, 6 } 
        oSize:Process()

        oSize2 := FwDefSize():New()
        oSize2:aWorkArea := oSize:GetNextCallArea( "LABEL1" )
        oSize2:AddObject( "ESQ",  100, 50, .T., .T. )
        oSize2:AddObject( "DIR",  100, 50, .T., .T. ) 
        oSize2:lLateral := .T.
        oSize2:lProp 	:= .T. 
        oSize2:aMargins := { 3, 3, 3, 3 } 
        oSize2:Process()

        oSize3 := FwDefSize():New()
        oSize3:aWorkArea := oSize:GetNextCallArea( "LABEL2" )
        oSize3:AddObject( "ESQ",  100, 50, .T., .T. ) 
        oSize3:AddObject( "DIR",  100, 50, .T., .T. )
        oSize3:lLateral := .T.
        oSize3:lProp 	:= .T.
        oSize3:aMargins := { 3, 3, 3, 3 } 
        oSize3:Process()

        DEFINE SBUTTON oBtn FROM 800,500 TYPE 5 ENABLE OF oDlg

        @ oSize:GetDimension("LABEL1","LININI")         , oSize:GetDimension("LABEL1","COLINI")     TO oSize:GetDimension("LABEL1","LINEND"), oSize:GetDimension("LABEL1","COLEND")  LABEL "Componente" OF oDlg PIXEL        
            
            @ oSize2:GetDimension("ESQ","LININI")+12    , oSize2:GetDimension("ESQ","COLINI")       SAY "Produto"                   SIZE 24,7   OF oDlg PIXEL 
            @ oSize2:GetDimension("ESQ","LININI")+10    , oSize2:GetDimension("ESQ","COLINI")+30    MSGET oProdOrig VAR cCodOrig    F3 "SB1"    Picture PesqPict("SG1","G1_COMP")   Valid NaoVazio(cCodOrig) .And. ExistCpo("SB1",cCodOrig) .And. A200IniDsc(1,oSay,cCodOrig) SIZE 105,09 OF oDlg PIXEL
            @ oSize2:GetDimension("ESQ","LININI")+24    , oSize2:GetDimension("ESQ","COLINI")+33    SAY oSay Prompt cDescOrig       SIZE 130,6  OF oDlg PIXEL

            
            @ oSize2:GetDimension("DIR","LININI")+12    , oSize2:GetDimension("DIR","COLINI")       SAY RetTitle("G1_GROPC")        SIZE 42,13   OF oDlg PIXEL
            @ oSize2:GetDimension("DIR","LININI")+10    , oSize2:GetDimension("DIR","COLINI")+40    MSGET cGrpOrig                  F3 "SGAPCP" Picture PesqPict("SG1","G1_GROPC")  Valid Vazio(cGrpOrig) .Or. ExistCpo("SGA",cGrpOrig)  SIZE 15,09 OF oDlg PIXEL

            @ oSize2:GetDimension("DIR","LININI")+12    , oSize2:GetDimension("DIR","COLINI")+85    SAY RetTitle("G1_OPC")          SIZE 30,7    OF oDlg PIXEL
            @ oSize2:GetDimension("DIR","LININI")+10    , oSize2:GetDimension("DIR","COLINI")+120   MSGET cOpcOrig                              Picture PesqPict("SG1","G1_OPC")    Valid If(!Empty(cGrpOrig),NaoVazio(cOpcOrig) .And.ExistCpo("SGA",cGrpOrig+cOpcOrig),Vazio(cOpcOrig)) SIZE 15,09 OF oDlg PIXEL


        @ oSize:GetDimension("LABEL2","LININI")         , oSize:GetDimension("LABEL2","COLINI")     TO oSize:GetDimension("LABEL2","LINEND"), oSize:GetDimension("LABEL2","COLEND") LABEL "Máquina" OF oDlg PIXEL 

            @ oSize3:GetDimension("ESQ","LININI")+12    , oSize3:GetDimension("ESQ","COLINI")       SAY "Máquina De"                SIZE 30,10  OF oDlg PIXEL
            @ oSize3:GetDimension("ESQ","LININI")+10    , oSize3:GetDimension("ESQ","COLINI")+40    MSGET cCodMaqDe                 F3 "SH1"    Picture PesqPict("SH1","H1_CODIGO") Valid A200DscMaq(1,oSay2,cCodMaqDe)     SIZE 60,9 OF oDlg PIXEL
            @ oSize3:GetDimension("ESQ","LININI")+24    , oSize3:GetDimension("ESQ","COLINI")+40    SAY oSay2 Prompt cDescDeMaq     SIZE 130,6  OF oDlg PIXEL
          
          
            @ oSize3:GetDimension("DIR","LININI")+12    , oSize2:GetDimension("DIR","COLINI")       SAY "Máquina Até"               SIZE 42,13  OF oDlg PIXEL
            @ oSize3:GetDimension("DIR","LININI")+10    , oSize3:GetDimension("DIR","COLINI")+40    MSGET cCodMaqAte                F3 "SH1"    Picture PesqPict("SH1","H1_CODIGO") Valid A200DscMaq(2,oSay3,cCodMaqAte)    SIZE 60,9 OF oDlg PIXEL
            @ oSize3:GetDimension("DIR","LININI")+24    , oSize3:GetDimension("DIR","COLINI")+40    SAY oSay3 Prompt cDescAteMaq    SIZE 130,6  OF oDlg PIXEL

    ACTIVATE MSDIALOG oDlg CENTER   ON INIT EnchoiceBar(oDlg, {|| lOk := .T., oDlg:End()}, {|| lOk := .F., oDlg:End()} )

    If  lOk 
        Processa({|| Pcp02Comp(cCodOrig, cGrpOrig, cOpcOrig, cCodMaqDe, cCodMaqAte)})
    EndIf

	SX3->(RestArea(aAreaSX3))
	RestArea(aArea)

Return

/*
    funcao para montar o markbrowse para selecao e edicao dos componentes
*/
static function Pcp02Comp(cCodOrig, cGrpOrig, cOpcOrig, cCodMaqDe, cCodMaqAte)
	Local cFilSG1 := "" as char
	Local lPyme := .F. as logical
    
    Private aRotina := MenuDef() as array	
	Private cCadastro := "Edição de Componentes" as char
	Private cMarca200 := ThisMark() as char
	Private lMarkAll := .F. as logical
	Private lHelpList := .F. as logical

    If !Empty(cGrpOrig) .And. !Empty(cOpcOrig)
        lPyme := .T.
    EndIF

    cFilSG1 := " G1_FILIAL='" + xFIlial("SG1") + "' "
    cFilSG1 += " AND G1_COMP='" + cCodOrig + "' "
    cFilSG1 += " AND G1_ZZMAQ >='"+cCodMaqDe+"' 
    cFilSG1 += " AND G1_ZZMAQ <='"+cCodMaqAte+"'
 
    If !lPyme
        cFilSG1 += " AND G1_GROPC='" + cGrpOrig + "' "
        cFilSG1 += " AND G1_OPC='" + cOpcOrig + "' "
    EndIf

    dbSelectArea("SG1")
    SG1->(dbSetOrder(1))
    If  !SG1->(MsSeek(xFIlial("SG1")))
        Help(" ",1,"RECNO")
    Else
        
        cFilSG1 += " AND (SELECT COUNT(*) FROM " + RetSqlName('SB1') + " SB1 WHERE B1_COD=G1_COD AND (B1_REVATU=G1_REVFIM OR G1_REVFIM='ZZZ')) > 0 "

        oMark:= FWMarkBrowse():New()
        oMark:SetAlias( "SG1" )
        oMark:SetDescription("Edição de Componentes")
        oMark:SetFieldMark( "G1_OK" )
        oMark:SetFilterDefault("@"+cFilSG1)
        oMark:SetValid({|| ValidMarca() })
        oMark:SetAfterMark({|| RELockSG1() })        
        oMark:SetAllMark({|| FWMsgRun(, {|| MarkAll(oMark) }, "Aguarde", "Marcando/Desmarcando registro...") })
        oMark:Activate()

    EndIf

	DbSelectArea("SG1")
	RetIndex("SG1")
	DbClearFilter()

Return()

/*/{Protheus.doc} MenuDef
Menu Def
@author Bruno Aguiar
@since 29/01/2025
@version 1.0
@return lRet, logico, indica se pode ou nao marcar o registro para substituicao
/*/
Static Function MenuDef()
    Local aRotina := {} as array    

    ADD OPTION aRotina TITLE "Alterar"  ACTION "u_PCP02GRV(4)"  OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluir"  ACTION "u_PCP02GRV(5)"  OPERATION 5 ACCESS 0

Return aRotina

/*/{Protheus.doc} PCP02ALT

funcao para gravar as alteracoes ou exclusoes dos componentes.

@type function
@author Pedro Alves
@since 03/2025
/*/
user function PCP02GRV(nOperacao)
    Local aArea := GetArea() as array    
    Local nTotReg := 0 as numeric
    Local cAliasTrb := "" as character
    Local lOk := .t. as logical

    if  nOperacao == 4
        lOk := loadParam()
    endif

    if  lOK
        
        if  hasMarking(@nTotReg,@cAliasTrb)

            if  !FWAlertYesNo("Deseja realmente "+iif(nOperacao==4,"alterar","excluir")+" "+cValToChar(nTotReg)+" componente(s)?","ATENÇÃO")
                return()
            endif

            if  nOperacao == 4
                Processa({|| PCP02ALT(nTotReg,@cAliasTrb) }, "Aguarde")           
            elseif nOperacao == 5
                Processa({|| PCP02DEL(nTotReg,@cAliasTrb) }, "Aguarde")           
            endif

        endif        

    endif
    
    RestArea(aArea)

return()

/*
    funcao para gravar a alteracao o componente.
*/
static function PCP02ALT(nTotReg,cAliasTrb)
    Local aCab := {} as array
    Local aItemAux := {} as array
    Local aItens := {} as array
    Local nNewQtd := mv_par01 as numeric
    Local nNewPerda := mv_par02 as numeric
    Local nRecord := 0 as numeric
    Local nTotOk := 0 as numeric            

    Private lMsHelpAuto := .T.
	Private lMsErroAuto := .F.
    
    ProcRegua(nTotReg) // Regua

    DBSelectArea(cAliasTrb)
    (cAliasTrb)->(DBGoTop())	
    While	!(cAliasTrb)->(EoF())

        nRecord++
        IncProc("Alterando componente..."+StrZero(nRecord,6)+" de "+StrZero(nTotReg,6)+".")
        
        DBSelectArea("SG1")
        SG1->(DBGoTo((cAliasTrb)->RECSG1))
        
        // Preenchimento dos campos
        aAdd(aCab,{"G1_COD",    SG1->G1_COD})
        
        aAdd(aItemAux,{"G1_COD"     ,SG1->G1_COD    , nil})
        aAdd(aItemAux,{"G1_COMP"    ,SG1->G1_COMP   , nil})
        aAdd(aItemAux,{"G1_TRT"     ,SG1->G1_TRT    , nil})        

        if  nNewQtd > 0 .and.  (nNewQtd <> SG1->G1_QUANT)
            aAdd(aItemAux,{"G1_QUANT"   , nNewQtd   , nil})
        endif

        If  (nNewPerda <> SG1->G1_PERDA)
            aAdd(aItemAux,{"G1_PERDA"   ,nNewPerda  , nil})
        endif
        
        aAdd(aItemAux,{"LINPOS","G1_COD+G1_COMP+G1_TRT",SG1->G1_COD,SG1->G1_COMP,SG1->G1_TRT})                
        aadd(aItens,aItemAux)
        
        lMsErroAuto := .F.
		MSExecAuto({|x,y,z| PCPA200(x,y,z)},aCab,aItens,4)

        If  !lMsErroAuto			
            nTotOk++
        Else            
            MostraErro()            
        EndIf

        aCab        := {}
        aItemAux    := {}
        aItens      := {}
                
    (cAliasTrb)->(DBSkip())
    end
    (cAliasTrb)->(DBCloseArea())

    if  nTotOk > 0
        FWAlertSuccess("Foram alterados <b>"+cValToChar(nTotOk)+"</b> componentes!","ATENÇÃO")
    else
        FWAlertWarning("Não foi possível alterar o componente!","ATENÇÃO")
    endif

return()

/*
    funcao para gravar a exclusao do componente.
*/
static function PCP02DEL(nTotReg,cAliasTrb)
    Local aCab := {} as array
    Local aItemAux := {} as array
    Local aItens := {} as array    
    Local nRecord := 0 as numeric
    Local nTotOk := 0 as numeric        

    Private lMsHelpAuto := .T.
	Private lMsErroAuto := .F.
    
    ProcRegua(nTotReg) // Regua

    DBSelectArea(cAliasTrb)
    (cAliasTrb)->(DBGoTop())	
    While	!(cAliasTrb)->(EoF())

        nRecord++
        IncProc("Excluíndo componente..."+StrZero(nRecord,6)+" de "+StrZero(nTotReg,6)+".")
        
        DBSelectArea("SG1")
        SG1->(DBGoTo((cAliasTrb)->RECSG1))        
                
        // Preenchimento dos campos
        aAdd(aCab,{"G1_COD",    SG1->G1_COD})

        aAdd(aItemAux,{"G1_COD"     ,SG1->G1_COD    , nil})
        aAdd(aItemAux,{"G1_COMP"    ,SG1->G1_COMP   , nil})
        aAdd(aItemAux,{"G1_TRT"     ,SG1->G1_TRT    , nil})
        aAdd(aItemAux,{"AUTDELETA"  ,"S"            , nil})
        aAdd(aItemAux,{"LINPOS"     ,"G1_COD+G1_COMP+G1_TRT",SG1->G1_COD,SG1->G1_COMP,SG1->G1_TRT})                        
        aadd(aItens,aItemAux)
                
        lMsErroAuto := .F.
		MSExecAuto({|x,y,z| PCPA200(x,y,z)},aCab,aItens,4)

        If  !lMsErroAuto			
            nTotOk++
        Else            
            MostraErro()            
        EndIf

        aCab        := {}
        aItemAux    := {}
        aItens      := {}
                
    (cAliasTrb)->(DBSkip())
    end
    (cAliasTrb)->(DBCloseArea())

    if  nTotOk > 0
        FWAlertSuccess("O componente foi excluído em <b>"+cValToChar(nTotOk)+"</b> estrutura(s)!","ATENÇÃO")
    else
        FWAlertWarning("Não foi possível excluir o componente!","ATENÇÃO")
    endif

return()

/*
    funcao para verificar se algum registro foi marcado
*/
static function hasMarking(nTotReg,cAliasTrb)    
    Local cQuery := "" as char 
    Local lRet := .t. as logical
    
    cQuery += " SELECT    
    cQuery += "     SG1.R_E_C_N_O_  AS RECSG1          
    cQuery += " FROM
    cQuery += "     "+RetSqlName("SG1")+"  SG1
    cQuery += " WHERE
    cQuery += "         SG1.G1_FILIAL   = '"+xFilial("SG1")+"'
    cQuery += "     AND SG1.G1_OK       = '"+oMark:Mark()+"'
    cQuery += "     AND SG1.D_E_L_E_T_  = ' '

    TCQuery cQuery New Alias (cAliasTrb:=GetNextAlias())
    
    Count To nTotReg    
    if  !(nTotReg > 0)
        FWAlertWarning("Nenhum registro foi marcado!","ATENÇÃO")
        (cAliasTrb)->(DBCloseArea())
        lRet := .f.
    endif
                    
return(lRet)

/*
    Cria as perguntas da rotina.
*/
Static Function loadParam()
	Local aRetP1 := {} as array
    Local aParamBox := {} as array      
    Local nRecord := 0 as numeric
	Local lRet := .F. as logical
    Local bTOkParam := {|| Pcp02TOk() }
		    		
	aAdd(aParamBox,{1,"Quantidade"	, Criavar("G1_QUANT",.F.)   ,PesqPict("SG1","G1_QUANT")	,"",""		,".t." ,070,.F.})
	aAdd(aParamBox,{1,"Índice Perda", Criavar("G1_PERDA",.F.)   ,PesqPict("SG1","G1_PERDA")	,"",""		,".t." ,050,.F.})	      
	
	aRetP1 := {}
    For nRecord := 1 To Len(aParamBox)
        aAdd(aRetP1,aParamBox[nRecord][3])
    Next nRecord

    If  ParamBox(aParamBox,"Perguntas",@aRetP1,bTOkParam/*bOk*/,/*aButtons*/,.T./*lCentered*/,/*nPosx*/,/*nPosy*/,/*oDlgWizard*/,/* cLoad*/,.f./* lCanSave*/,/*lUserSave*/)
        lRet := .T.
    EndIf
    
Return(lRet)

/*
    funcao para validar os dados digitados nos parametros
*/
static function Pcp02TOk()
    Local lRet := .t.

    if  !(mv_par01 > 0)
        Help("CMAPCP02",, "QUANTIDADE", NIL, "A quantidade precisa ser maior que zero.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Informar uma quantidade válida."})
		lRet := .f.
    endif

return(lRet)

/*/{Protheus.doc} A200IniDsc
Inicializa a descricao dos codigos digitados
@author Bruno Aguiar
@since 29/01/2025
@version 1.0
@param 01 - nOpcao    , numerico , Indica se esta validando origem (1) ou destino (2)
@param 02 - oSay      , objeto   , Objeto say que deve ser atualizado
@param 03 - cProduto  , caracter , Codigo do produto digitado
@return lRet, logico
/*/
Static Function A200IniDsc(nOpcao,oSay,cProduto)
	Local lRet		   := .T.

	SB1->(MsSeek(xFilial("SB1")+cProduto))

	If nOpcao == 1
		cDescOrig :=  SB1->B1_DESC

		// Preenche descricao do produto
		oSay:SetText(cDescOrig)
	EndIf

	// Troca a cor do texto para vermelho
	oSay:SetColor(CLR_HRED,GetSysColor(15))


Return (lRet)


/*/{Protheus.doc} A200DscMaq
Inicializa a descricao dos codigos digitados
@author Bruno Aguiar
@since 29/01/2025
@version 1.0
@param 01 - nOpcao    , numerico , Indica se esta validando origem (1) ou destino (2)
@param 02 - oSay      , objeto   , Objeto say que deve ser atualizado
@param 03 - cProduto  , caracter , Codigo do produto digitado
@return lRet, logico
/*/
Static Function A200DscMaq(nOpcao,oSay,cCodMaq)
	Local lRet		   := .T.

	SH1->(MsSeek(xFilial("SH1")+cCodMaq))

	If nOpcao == 1
		cDescDeMaq := SH1->H1_DESCRI

		// Preenche descricao do produto
		oSay:SetText(cDescDeMaq)
    Else
		cDescAteMaq := SH1->H1_DESCRI

		// Preenche descricao do produto
		oSay:SetText(cDescAteMaq)
	EndIf

	// Troca a cor do texto para vermelho
	oSay:SetColor(CLR_HRED,GetSysColor(15))


Return (lRet)

/*/{Protheus.doc} MarkAll
Marca todos os registros
@author brunno.costa
@since 21/01/2019
@version 1.0
@param 01 - oMark, objeto, objeto da MarkBrowse
/*/
Static Function MarkAll(oMark)
	Local aArea  := GetArea()
	lMarkAll  := .T.

	While !SG1->(Eof())
		If oMark:IsMark(oMark:Mark()) .OR. ValidMarca()
			oMark:MarkRec()
		EndIf
		SG1->(DbSkip())
	End

	lMarkAll  := .F.
	lHelpList := .F.

	RestArea(aArea)
	oMark:Refresh(.F.)
Return

/*/{Protheus.doc} ValidMarca
Valida a marcacao de registros para substituicao
@author brunno.costa
@since 21/01/2019
@version 1.0
@return lRet, logico, indica se pode ou nao marcar o registro para substituicao
/*/
Static Function ValidMarca()
	Local lExibHelp  := .T.
	Local lRet       := .T.
	Local aBloqueio  := {}
	Local lInRefresh := IsInCallStack("LINEREFRESH")
	Local nRecno     := SG1->(Recno())

	If !lInRefresh
		If !RegValido(nRecno)//Verifica se o registro esta excluido ou se esta em EOF - sem registros dentro da condicao de filtro
			lRet := .F.
			SG1->(DbSkip())                   //Forca desposicianamento de registro
			SG1->(DbGoTop())                  //Posiciona no primeiro registro
			oMark:Refresh()                   //Atualiza MarkBrowse eliminando registros invalidos
			IF SG1->(Eof())
				//Não existem registros válidos para a substituição.
				//Reinicie o processo utilizando outro 'Produto Original'.
				Help( ,  , "Help", , "Não existem registros válidos para a substituição.", 1, 0, , , , , , {"Reinicie o processo utilizando outro 'Produto Original'."})
			Else
				//Este registro foi excluído por outro usuário.
				//Selecione outro registro e tente novamente.
				Help( ,  , "Help", ,  "Este registro foi excluído por outro usuário.", 1, 0, , , , , , {"Selecione outro registro e tente novamente."})
			EndIf
		EndIf
	EndIf

	If lRet .and. !SG1->(Eof()) .AND. !IsInCallStack("SHOWDATA") .AND. !IsInCallStack("LINEREFRESH")
		soRecNo := Iif(soRecNo == Nil, JsonObject():New(), soRecNo)
		If !oMark:IsMark(oMark:Mark())
			If SG1->(SimpleLock())                              //Bloqueou registro atual da SG1
				soRecNo[cValToChar(SG1->(RecNo()))] := .T.
			Else                                                //NAO Bloqueou registro atual da SG1
				lRet      := .F.
				If soRecNo[cValToChar(SG1->(RecNo()))] == Nil .OR.;
				   soRecNo[cValToChar(SG1->(RecNo()))] .OR. !lMarkAll

					aBloqueio := StrTokArr(TCInternal(53),"|")
					//Esta estrutura 'X' está bloqueada para o usuário: Y
					//"Entre em contato com o usuário ou tente novamente."
					Help( ,  , "Help", ,  "Esta estrutura" + AllTrim(SG1->G1_COD) + "está bloqueada para o usuário:" + aBloqueio[1] + scCRLF + scCRLF + " [" + aBloqueio[2] + "]";
						, 1, 0, , , , , , {"Entre em contato com o usuário ou tente novamente."})
				EndIf
				soRecNo[cValToChar(SG1->(RecNo()))] := .F.
			EndIf

		Else                                                  //Desbloqueia registro atual da SG1
			soRecNo[cValToChar(SG1->(RecNo()))] := Nil
			//Remove lock - Fonte PCPA200EVDEF
			SG1UnLockR(SG1->(RecNo()))
		EndIf
	EndIf

	If lRet .and. slReplica .AND. !Empty(SG1->G1_LISTA)
		lRet       := .F.

		If lMarkAll .AND. !lHelpList
			lHelpList := .T.
		ElseIf lMarkAll .AND. lHelpList
			lExibHelp := .F.
		EndIf

		If lExibHelp
			Help(,,'Help',,"Registro inválido para substituição pois está relacionado a uma lista e o parâmetro MV_PCPRLEP está com conteúdo '1'.",1,0,,,,,,;
						{"Utilize um registro válido ou reconfigure o parâmetro MV_PCPRLEP."})
		EndIf
	EndIf
Return lRet

/*/{Protheus.doc} RegValido
Verifica se o registro ainda está válido para ser selecionado
@author marcelo.neumann
@since 26/04/2019
@version 1.0
@param nRecno, caracter, Recno a ser validado
@return lValido, logical, Indica se o registro ainda está válido
/*/
Static Function RegValido(nRecno)

	Local aArea     := GetArea()
	Local cAliasTmp := GetNextAlias()
	Local cQuery    := ""
	Local cFiltro   := StrTran(oMark:GetFilterDefault(), "@", " ", 1, 1)
	Local lValido   := .F.

	cQuery := "SELECT 1 FROM " + RetSqlName("SG1")
	cQuery += " WHERE R_E_C_N_O_ = " + cValToChar(nRecno)
	cQuery +=   " AND " + cFiltro

	dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAliasTmp, .T., .F.)
	If (cAliasTmp)->(!EOF())
		lValido := .T.
	EndIf
	(cAliasTmp)->(DbCloseArea())

	RestArea(aArea)

Return lValido

/*/{Protheus.doc} RELockSG1
Reloca a SG1 após bug frame que remove o lock pré-existe em MarkBrowse
@author brunno.costa
@since 11/04/2019
@version 1.0
/*/
Static Function RELockSG1()
	If !SG1->(Eof()) .AND. !IsInCallStack("SHOWDATA") .AND. !IsInCallStack("LINEREFRESH")
		soRecNo := Iif(soRecNo == Nil, JsonObject():New(), soRecNo)
		If soRecNo[cValToChar(SG1->(RecNo()))]
			SG1->(SimpleLock())
		EndIf
	EndIf
Return
