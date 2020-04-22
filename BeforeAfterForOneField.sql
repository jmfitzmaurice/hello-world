SELECT TOP 1 WFCON_Prompt, WFH_AttText15, WFD_AttText15
FROM WFElements, WFHistoryElements, WFDefinitions, WFConfigurations,  WFFieldDefinitions 
WHERE WFD_ID = WFH_OrgID AND DEF_ID = WFCON_DEFID AND FDEF_ID = WFCON_FDEFID
AND (DEF_ID = 144) AND (WFD_ID = 1079) AND (FDEF_Name = 'WFD_AttText5')
AND WFH_Version = 1 AND WFD_AttText15 <> WFH_AttText15
