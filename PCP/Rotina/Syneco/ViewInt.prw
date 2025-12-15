#Include "TOTVS.ch"
#Include "FWMVCDef.ch"


/*/{Protheus.doc} User Function ViewInt
Função para vizualizar o monitor de integração filtrando OP posicionada.
@type Function
@author Bruno Aguiar
@since 009/09/2024
@obs 
 
    Função FWExecView
    Parâmetros
        + cTitulo        , Caractere       , Título da Janela
        + cPrograma      , Caractere       , Nome do programa em MVC
        + nOperation     , Numérico        , Indica a operação se é inclusão (3); alteração (4) ou exclusão (5)
        + oDlg           , Objeto          , Parâmetro descontinuado
        + bCloseOnOK     , Bloco de Código , Bloco de código acionado no fechamento da janela
        + bOk            , Bloco de Código , Bloco de código acionado na validação ao clicar em Confirmar
        + nPercReducao   , Numérico        , Percentual de redução do tamanho da Janela
        + aEnableButtons , Array           , Botões que serão habilitados na Janela
        + bCancel        , Bloco de Código , Bloco de código na validação ao clicar em Cancelar / Fechar
        + cOperatId      , Caractere       , Identificação da operação (usado quando tem mais de um 4 no nOperation no programa MVC)
        + cToolBar       , Caractere       , Indica o relacionamento dos botões com a tela
        + oModelAct      , Objeto          , Model instanciado que será usado pela View
    Retorno
        + nValor        , Numérico  , 0 se foi clicado em Ok e 1 se foi clicado em Cancelar
 
/*/

/*  1=Ordem de Produção; 

    2=Empenho; 

    3=Lote Matéria Prima; 

    4=Apontamento Empenho/Lote; 

    5=Apontamento OP; 

    6=Apontamento Horas Improdutivas; 

    7=Apontamento Perdas; 
 */

User Function ViewInt()
    Local aArea     := FWGetArea()
    Local cFunBkp   := FunName()
    Local cOP       := ""
    Local cFil      := ""
    Local cRotina   := "0"
    Local cRotina2  := "0"

    If cFunBkp == "MATA650"
        cRotina := "1"
        cFil := FWxFilial('SC2')
        cOP := AllTrim(Right(SC2->C2_FILIAL,1)+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
    ElseIf  cFunBkp == "MATA381"
        cRotina  := "2" 
        cRotina2 := "4"
        cFil := FWxFilial('SD4')
        cOP := AllTrim(Right(SD4->D4_FILIAL,1)+SD4->D4_OP)
    ElseIF cFunBkp == "MATA681"
        cRotina := "5"
        cFil := FWxFilial('SH6')
        cOP := AllTrim(Right(SH6->H6_FILIAL,1)+SH6->H6_OP)
    ElseIf cFunBkp == "MATA682"
        cRotina := "6"
        cFil := FWxFilial('SH6')
        cOP := AllTrim(Right(SH6->H6_FILIAL,1)+SH6->H6_ZZOP)
    ElseIf cFunBkp == "MATA685"
        cRotina := "5"
        cFil := FWxFilial('SBC')
        cOP := AllTrim(Right(SBC->BC_FILIAL,1)+SBC->BC_OP)
    Else
        cRotina := "3"
        cOP := AllTrim(ZA2->ZA2_FILIAL + ZA2->ZA2_COD)
    EndIf

    DbSelectArea('ZC2')
    ZC2->(DbSetOrder(1)) 

        If cRotina == "2"
            If ZC2->(DbSeek(FWxFilial('SC2') + AvKey(cOp,"ZC2_OP") + cRotina)) 
                SetFunName("MONINTEG")
                FWExecView('Monitor Integração', 'MONINTEG', MODEL_OPERATION_VIEW)
                SetFunName(cFunBkp)
            Elseif ZC2->(DbSeek(FWxFilial('SC2') + AvKey(cOp,"ZC2_OP") + cRotina2)) 
                SetFunName("MONINTEG")
                FWExecView('Monitor Integração', 'MONINTEG', MODEL_OPERATION_VIEW)
                SetFunName(cFunBkp)
            Else
                MsgInfo("Ordem De Produção sem Integração", "ATENCÃO")
            EndIf
        Else
            If ZC2->(DbSeek(FWxFilial('SC2') + AvKey(cOP, "ZC2_OP") + cRotina ))
                SetFunName("MONINTEG")
                FWExecView('Monitor Integração', 'MONINTEG', MODEL_OPERATION_VIEW)
                SetFunName(cFunBkp)
            Else
                MsgInfo("Ordem De Produção sem Integração", "ATENCÃO")
            EndIf
        EndIf
        


    FWRestArea(aArea)
Return
