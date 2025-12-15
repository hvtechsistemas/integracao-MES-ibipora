#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} ScheedHoras
 
Schedule para ver retorno de Horas Improdutivas Syneco
 
@author Bruno Aguiar
@since 12/08/2024
@see
/*/
User function ScheedHoras(aParam)
    Default aParam   := {"01","0102"}

    If	!Empty(aParam)
		PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2]
	EndIf
    
    u_VerHoras()
            
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
