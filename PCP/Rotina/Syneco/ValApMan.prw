#include "totvs.ch"
#INCLUDE 'Protheus.ch'
#INCLUDE 'rwmake.ch'
#INCLUDE 'TOPCONN.CH'

/*/{Protheus.doc} ValApMan
Função de validação de campo para chegar os apontamentos manuais
@type 
@version 1.0 
@author Bruno Aguiar
@since 11/09/2024
@return variant, Return .T. or .F.
/*/
User Function ValApMan()
    Local cBcoDados     := GetNewPar("MV_ZZCOSKA ", "MSSQL/CCM_SYNECO_HOMOLOG")   as character //Conexão no DbAccess com a outra base de Dados
    Local cServer       := GetNewPar("MV_ZZIPSKA", "10.11.10.25")               as character //Servidor que está configurado o DbAccess
    Local nPorta        := GetNewPar("MV_ZZPOSKA ",  9099 )                         as numeric //Porta da conexão do DbAccess
    Local nHandle       := 0                            as numeric //Ponteiro que armazenará a conexão
    Local lRet          := .F.                          as logical
    Local cAlias        := GetNextAlias()

    nHandle  := TcLink(cBcoDados, cServer, nPorta)
    
    If nHandle < 0
       MsgInfo("Não foi possível conectar! Erro: " + cValToChar(nHandle), "Atenção") 
    Else 

        If AllTrim(RetCodUsr()) $ (GetMV("MV_ZZUSU")) 
                lRet    := .T.
        Else

            cQuery := " SELECT                                              "    +CRLF
            cQuery += " *                                                   "    +CRLF  
            cQuery += " FROM                                                "    +CRLF                       
            cQuery += " SSPIMPORT                                           "    +CRLF
            cQuery += " WHERE                                               "    +CRLF
            cQuery += " OP =  '"+Right(cFilAnt,1)+(M->H6_OP)+"'             "    +CRLF

            If TcSqlExec(cQuery) < 0
                lRet := .F.
            Else
                PlsQuery(cQuery, cAlias)
                DBSelectArea(cAlias)
                (cAlias)->(DBGoTop())

                If (cAlias)->(!EoF())
                    MsgInfo("Ordem de Produção se encontra em produção no Syneco.")
                    lRet := .T.
                Else
                    lRet    := .F.
                EndIf
            EndIf
        EndIf

        TCUnlink(nHandle)

    EndIf

Return lRet
