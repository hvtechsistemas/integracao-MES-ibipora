#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
 
/*/{Protheus.doc} ScheedVerOp
Schedule para ver retorno de OP Syneco
@type function
@author Bruno Aguiar
@since	06/09/2024
@see
 
/*/
User function ScheedVerOP(aParam)
    Default aParam   := {"02","001001"}

    If	!Empty(aParam)
		PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2]
	EndIf
    
    u_VerificaOp()
            
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
