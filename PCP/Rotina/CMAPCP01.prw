#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'
  
/*/{Protheus.doc} CMAPCP01

Funcao para validar o envio de ordens de produção ao Syneco quando o cadastro do produto acabado não possuir especificações 
como a quantidade de fardos para formar um pallet, a operação do PA e do PI;

@type function
@version  1.0
@author Pedro Alves
@since 02/2025
/*/ 
User Function CMAPCP01()
    Local cQuery := "" as char
    Local cAliasTrb := "" as char
    Local cProblema := "" as char
    Local cSolucao := "" as char
    Local lRet := .t. as logical

    // valida se a quantidade de fardos para formar um pallet esta cadastrado no produto
    if  !(Posicione("SB1",1,xFilial("SB1")+M->C2_PRODUTO,"B1_ZZQTPLT") > 0)
        
        cProblema   := "A quantidade de fardo não está cadastrada no Produto."
        cSolucao    := "Cadastrar a quantidade de Fardo no Pallet."
        lRet        := .f.        
    
    // valida se a operacao do PA esta preenchida
    elseif  empty(Posicione("SG2",1,xFilial("SG2")+M->(C2_PRODUTO + C2_ROTEIRO),"G2_OPERAC"))
        
        cProblema   := "A operação do PA "+alltrim(M->C2_PRODUTO)+" está vazia."
        cSolucao    := "Cadastrar a operação do PA no Roteiro de Operações."
        lRet        := .f.        

    else
        // valida se a operacao do PI esta preenchida
        cQuery += " SELECT
        cQuery += "     G1_COMP, G2_OPERAC
        cQuery += " FROM
        cQuery += "     "+RetSqlName("SG1")+"  SG1
        cQuery += "     INNER JOIN	"+RetSqlName("SG2")+"	SG2	ON	SG2.G2_FILIAL	= SG1.G1_FILIAL
        cQuery += "                             AND	SG2.G2_PRODUTO	= SG1.G1_COMP
        cQuery += "                             AND	SG2.G2_CODIGO	= '"+M->C2_ROTEIRO+"'
        cQuery += " WHERE
        cQuery += "         SG1.G1_FILIAL   = '"+xFilial("SG1")+"'
        cQuery += "     AND SG1.G1_COD      = '"+M->C2_PRODUTO+"'
        cQuery += "     AND SG1.G1_REVINI   = '"+M->C2_REVISAO+"'
        cQuery += "     AND SG1.D_E_L_E_T_  = ' '

        TCQuery cQuery New Alias (cAliasTrb:=GetNextAlias())

        While   !(cAliasTrb)->(EoF())

            if  empty((cAliasTrb)->G2_OPERAC)
                cProblema   := "A operação do PI "+alltrim((cAliasTrb)->G1_COMP)+" está vazia."
                cSolucao    := "Cadastrar a operação do PI no Roteiro de Operações."
                lRet        := .f.
                Exit
            endif
            
        (cAliasTrb)->(DBSkip())
        end
        (cAliasTrb)->(DBCloseArea())

    endif

    if  !lRet
        Help("CMAPCP01",, "VALIDAÇÃO SYNECO", NIL, cProblema, 1, 0, NIL, NIL, NIL, NIL, NIL, {cSolucao})
    endif

Return(lRet)
