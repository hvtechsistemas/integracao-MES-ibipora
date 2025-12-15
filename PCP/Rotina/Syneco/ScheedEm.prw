#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
 
/*/{Protheus.doc} ScheedEm
Schedule para ver retorno de Empenho / Lote da OP Syneco
@type function
@author Bruno Aguiar
@since	11/09/2024
@see
 
/*/
User function ScheedEm(aParam)
    Default aParam   := {"01","0102"}

    If	!Empty(aParam)
		PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2]
	EndIf
    
    u_VerEmpenho()
            
    If	!Empty(aParam)
        RESET ENVIRONMENT        
        aParam := aSize(aParam,0)
        aParam := Nil
    EndIf
 
   
Return .T.
 
/*
    Rotina automatica
*/
// Static Function Scheddef()
//     Local aParam    := {}
//     Local aOrd      := {}
 
//     aParam := { "P",;                    
//     "ParamDef",;
//     "",;  
//     aOrd,;
//     }  
 
// Return aParam
