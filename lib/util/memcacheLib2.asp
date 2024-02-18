<%
''ÂüÁ¶ »çÀÌÆ®
''http://na-s.jp/memcachedCOM/index.en.html
''http://memcached.org/

DIM G_MEM_ADDR 
Dim G_IS_DEVSERVER : G_IS_DEVSERVER = (application("Svr_Info") = "Dev")

Dim G_SPLIT_MEM_ARRAY  : G_SPLIT_MEM_ARRAY = "[@||@]"
Dim G_SPLIT_MEM_KEYVAL : G_SPLIT_MEM_KEYVAL = "[|@|]"
Dim G_SPLIT_MEM_VALARRAY : G_SPLIT_MEM_VALARRAY = "[@|@]"
Dim G_MEM_KEY_ARRAY_ENDFIX : G_MEM_KEY_ARRAY_ENDFIX = ":::" 

Dim G_DUMINVAL : G_DUMINVAL = "........................................................................................................................"
G_DUMINVAL = G_DUMINVAL + G_DUMINVAL
G_DUMINVAL = G_DUMINVAL + G_DUMINVAL
G_DUMINVAL = G_DUMINVAL + G_DUMINVAL
G_DUMINVAL = G_DUMINVAL + G_DUMINVAL
G_DUMINVAL =""

IF (G_IS_DEVSERVER) THEN
    G_MEM_ADDR = "61.252.133.55" 
ELSE
    G_MEM_ADDR = "192.168.0.123"
end if

''µð¹ö±ë¿ë
function debugWrite(iMsg)
    'if (Not G_IS_DEVSERVER) then Exit function
    response.write iMsg&"<br>"
end function

function OnErrNotiByVal(ival)
    Const lngMaxFormBytes = 800
    dim strServerIP
    dim errDescription, errSource
    dim strMethod,datNow
exit function
    errDescription = ERR.Description
    errSource =  "["&ERR.Number&"]"&ERR.Source

	strServerIP = Request.ServerVariables("LOCAL_ADDR")

    dim strMsg : strMsg=""

    strMsg = strMsg & "errDescription: "&errDescription&"<br>"
    strMsg = strMsg & "errSource: "&errSource&"<br>"&"<br>"
    strMsg = strMsg & "keyVal: "&ival&"<br>"&"<br>"
    
    strMsg = strMsg & "<li>¼­¹ö:<br>"
	strMsg = strMsg & application("Svr_Info") & ":"&strServerIP
	strMsg = strMsg & "<br><br></li>"

	'// Á¢¼ÓÀÚ ºê¶ó¿ìÀú Á¤º¸
	strMsg = strMsg & "<li>ºê¶ó¿ìÀú Á¾·ù:<br>"
	strMsg = strMsg & Server.HTMLEncode(Request.ServerVariables("HTTP_USER_AGENT"))
	strMsg = strMsg & "<br><br></li>"

	strMsg = strMsg & "<li>Á¢¼ÓÀÚ IP:<br>"
	strMsg = strMsg & Server.HTMLEncode(Request.ServerVariables("REMOTE_ADDR"))
	strMsg = strMsg & "<br><br></li>"

	strMsg = strMsg & "<li>°æÀ¯ÆäÀÌÁö:<br>"
	strMsg = strMsg & request.ServerVariables("HTTP_REFERER")
	strMsg = strMsg & "<br><br></li>"

	'// ¿À·ù ÆäÀÌÁö Á¤º¸
	strMsg = strMsg & "<li>ÆäÀÌÁö:<br>"
	strMethod = Request.ServerVariables("REQUEST_METHOD")
	strMsg = strMsg & "HOST : " & Request.ServerVariables("HTTP_HOST") & "<BR>"
	strMsg = strMsg & strMethod & " : "

	If strMethod = "POST" Then
		strMsg = strMsg & Request.TotalBytes & " bytes to "
	End If

	strMsg = strMsg & Request.ServerVariables("SCRIPT_NAME")
	strMsg = strMsg & "</li>"

	If strMethod = "POST" Then
		strMsg = strMsg & "<br><li>POST Data:<br>"

		'½ÇÇà¿¡ °ü·ÃµÈ ¿¡·¯¸¦ Ãâ·ÂÇÕ´Ï´Ù.
		If Request.TotalBytes > lngMaxFormBytes Then
			strMsg = strMsg & Server.HTMLEncode(Left(Request.Form, lngMaxFormBytes)) & " . . ."'
		Else
			strMsg = strMsg & Server.HTMLEncode(Request.Form)
		End If
		strMsg = strMsg & "</li>"
	elseif strMethod = "GET" then
		strMsg = strMsg & "<br><li>GET Data:<br>"
		strMsg = strMsg & Request.QueryString
	End If
	strMsg = strMsg & "<br><br></li>"

	'// ¿À·ù ¹ß»ý½Ã°£ Á¤º¸
	strMsg = strMsg & "<li>½Ã°£:<br>"
	datNow = Now()
	strMsg = strMsg & Server.HTMLEncode(FormatDateTime(datNow, 1) & ", " & FormatDateTime(datNow, 3))
	on error resume next
		Session.Codepage = bakCodepage
	on error goto 0
	strMsg = strMsg & "<br><br></li>"


    '### ½Ã½ºÅÛÆÀ ±¸¼º¿ø¿¡°Ô ¿À·ù ¹ß»ý ³»¿ë ¹ß¼Û ###
	dim cdoMessage,cdoConfig
	Set cdoConfig = CreateObject("CDO.Configuration")

    '-> ¼­¹ö Á¢±Ù¹æ¹ýÀ» ¼³Á¤ÇÕ´Ï´Ù
	cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2 '1 - (cdoSendUsingPickUp)  2 - (cdoSendUsingPort)
	'-> ¼­¹ö ÁÖ¼Ò¸¦ ¼³Á¤ÇÕ´Ï´Ù
	cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver")="110.93.128.94"
	'-> Á¢±ÙÇÒ Æ÷Æ®¹øÈ£¸¦ ¼³Á¤ÇÕ´Ï´Ù
	cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
	'-> Á¢¼Ó½ÃµµÇÒ Á¦ÇÑ½Ã°£À» ¼³Á¤ÇÕ´Ï´Ù
	cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 30
	'-> SMTP Á¢¼Ó ÀÎÁõ¹æ¹ýÀ» ¼³Á¤ÇÕ´Ï´Ù
	cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
	'-> SMTP ¼­¹ö¿¡ ÀÎÁõÇÒ ID¸¦ ÀÔ·ÂÇÕ´Ï´Ù
	cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = "MailSendUser"
	'-> SMTP ¼­¹ö¿¡ ÀÎÁõÇÒ ¾ÏÈ£¸¦ ÀÔ·ÂÇÕ´Ï´Ù
	cdoConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = "wjddlswjddls"
	cdoConfig.Fields.Update

	Set cdoMessage = CreateObject("CDO.Message")
	Set cdoMessage.Configuration = cdoConfig

	cdoMessage.To 		= "kobula@10x10.co.kr;thensi7@10x10.co.kr;skyer9@episode.co.kr;kjy8517@10x10.co.kr;tozzinet@10x10.co.kr;errmail@10x10.co.kr"
	cdoMessage.From 	= "webserver@10x10.co.kr"
	cdoMessage.SubJect 	= "["&date()&"] MemCached ÆäÀÌÁö ¿À·ù ¹ß»ý"
	cdoMessage.HTMLBody	= strMsg

	cdoMessage.BodyPart.Charset="ks_c_5601-1987"         '/// ÇÑ±ÛÀ» À§ÇØ¼± ²À ³Ö¾î ÁÖ¾î¾ß ÇÕ´Ï´Ù.
    cdoMessage.HTMLBodyPart.Charset="ks_c_5601-1987"     '/// ÇÑ±ÛÀ» À§ÇØ¼± ²À ³Ö¾î ÁÖ¾î¾ß ÇÕ´Ï´Ù.

	cdoMessage.Send

	Set cdoMessage = nothing
	Set cdoConfig = nothing

end function

''ÇÑ±Û °ü·Ã ÀÎÄÚµù¿ë
function fnMemValEncrypt(v)
    dim Obj, ienc, ilen
    Set Obj = Server.CreateObject("nonnoi_ASPEncrypt.ASPEncrypt")
    Obj.RegisterName = "SEO SEOK"
    Obj.RegisterKey  = "63918C68A2D78AF7-5755"
    Obj.CipherAlgorithm = 1  '18,1 fast
    ienc = Obj.EncryptString(v,"")
    ilen = LEN(ienc)
    if (G_DUMINVAL<>"") then
        if (ilen>600 and ilen<1400) then ienc=ienc+G_DUMINVAL ''¼Óµµ°ü·Ã 1000=>600
    end if
    fnMemValEncrypt = ienc
    set Obj = nothing
end function

''ÇÑ±Û °ü·Ã µðÄÚµù¿ë 
function fnMemValDecrypt(v)
    dim Obj
    Set Obj = Server.CreateObject("nonnoi_ASPEncrypt.ASPEncrypt")
    Obj.RegisterName = "SEO SEOK"
    Obj.RegisterKey  = "63918C68A2D78AF7-5755"
    Obj.CipherAlgorithm = 1    '18,1 fast
    fnMemValDecrypt = replace(Obj.DecryptString(v,""),G_DUMINVAL,"")
    set Obj = nothing
end function

''Å°¯“ ÇØ½Ã 
function fnHashMemKey(ipreFix,iKey)
    dim Obj
    Set Obj = Server.CreateObject("nonnoi_ASPEncrypt.ASPEncrypt")  ''object is faster then asp code
    Obj.RegisterName = "SEO SEOK"
    Obj.RegisterKey  = "63918C68A2D78AF7-5755"
    Obj.HashAlgorithm = 0 ''md5
    'fnHashMemKey = ipreFix&":"&Obj.HashString(iKey)
    fnHashMemKey = replace(ipreFix,"_","")&""&Obj.HashString(iKey)
    set Obj = nothing
    'call debugWrite(fnHashMemKey)
end function

''Array¸¦ Memcashed¿ë StringÀ¸·Î º¯È¯
function Arr2MemStr(iArr)
    dim i, retVal
    retVal = ""
    for i=LBound(iArr) to UBound(iArr)
        retVal = retVal & Trim(iArr(i)) 
        if i<UBound(iArr) then
            retVal = retVal & G_SPLIT_MEM_VALARRAY
        end if
    next
    Arr2MemStr = retVal
end function

''serialize Dictionary to String
''key[||]value@||@key[||]value , array spliter-@|@
function Dic2MemStr(iDic)
    dim i,cnt, ikey, ival
    dim j, iArrStr
    cnt = iDic.Count
    
    ''rw "iDic.Count="&cnt
    for i=0 to cnt-1
        'rw "iDic.item(i)="&iDic.item(i)&TypeName(iDic.item(i))&(iDic.item(i))
        'rw "iDic.items()(i)="&iDic.items()(i)&TypeName(iDic.items()(i))&(iDic.items()(i))
        ikey = Trim(iDic.Keys()(i))
        ival = iDic.item(ikey)
        ''rw ikey&":"&TypeName(ival)&":"&isArray(ival)
        
        if isArray(ival) then
            ival = Arr2MemStr(ival)
            ikey = ikey & G_MEM_KEY_ARRAY_ENDFIX  ''¹ë·ù°¡ Array ÀÎ°æ¿ì ±¸ºÐ
        end if
        
        iArrStr = iArrStr & ikey &G_SPLIT_MEM_KEYVAL& Trim(ival) & G_SPLIT_MEM_ARRAY
    next
    Dic2MemStr = iArrStr
end Function

function MemStr2Dic(iStr,iDic)
    dim i, iArr1, iKey, iVal
    iDic.RemoveAll()
    iArr1 = split(iStr,G_SPLIT_MEM_ARRAY)
    for i=LBound(iArr1) to UBound(iArr1)
        if (iArr1(i)<>"") then
            iKey = SplitValue(iArr1(i),G_SPLIT_MEM_KEYVAL,0)
            iVal = SplitValue(iArr1(i),G_SPLIT_MEM_KEYVAL,1) 
            
            ''if (InStr(iVal,G_SPLIT_MEM_VALARRAY)>0) then
            ''rw "iKey=="&iKey&"//"
            if (RIGHT(iKey,LEN(G_MEM_KEY_ARRAY_ENDFIX))=G_MEM_KEY_ARRAY_ENDFIX) then
                iKey = LEFT(iKey,LEN(iKey)-LEN(G_MEM_KEY_ARRAY_ENDFIX))
                iVal = split(iVal,G_SPLIT_MEM_VALARRAY)
                ''rw "iKey="&iKey
            end if
            iDic.Item(iKey)=iVal
        end if
    Next
end function

'' SQL ¿ë
function getMemCacheSQL(idbget,isql,icacheSec)
    dim omem, cmd, rsRet
    
 dim otime : otime=Timer()
    
    set omem = CreateObject("memcachedCOM.Distributed")
    omem.open G_MEM_ADDR   ''omem.TryOpen "61.252.133.4"
    
    Set cmd = CreateObject("ADODB.Command")
    
    cmd.ActiveConnection = idbget
    cmd.CommandText = isql
    ''cmd.CommandType = adCmdStoredProc
    
    on Error Resume Next
    set getMemCacheSQL = omem.Execute(cmd,,icacheSec)
        if Err Then
            set getMemCacheSQL=Nothing
            debugWrite "err memcmd;"
            call OnErrNotiByVal(cmd.CommandText)
            Set cmd.ActiveConnection = Nothing
            Set cmd = Nothing
            omem.close()
            set omem = Nothing
            On Error Goto 0
            Exit function
        end if    
    On Error Goto 0
    
    Set cmd.ActiveConnection = Nothing
    Set cmd = Nothing

    omem.close()  ''omem.TryClose()
    set omem = Nothing
    
  debugWrite "actTime:"&FormatNumber(Timer()-otime,4)
end function

'' simple value get
function MemValGetExists(ipreFix,iKeyStr,byref iVal)
    dim omem, memVal
 dim otime : otime=Timer()
    set omem = CreateObject("memcachedCOM.Distributed")
    omem.open G_MEM_ADDR
    
    on Error Resume Next ''°£È¤ ¿À·ù³ª´Â CASE ÀÖÀ½ (TEST È¯°æ¿¡¼­ memcached¸¦ ³»·È´Ù ¿Ã¸®´Â Áß Äõ¸® ÇßÀ»°æ¿ì)
    memVal = omem.get(fnHashMemKey(ipreFix,iKeyStr))
        if Err Then
            MemValGetExists = False
            debugWrite "err mem;"
            call OnErrNotiByVal(fnMemValDecrypt(fnHashMemKey(ipreFix,iKeyStr))&":"&iKeyStr)
            omem.close()
            set omem = Nothing
            On Error Goto 0
            Exit function
        end if    
    On Error Goto 0
    
    omem.close()
    set omem = Nothing
    
    if (isEmpty(memVal)) then
        MemValGetExists = False
        debugWrite "n!"&":"&FormatNumber(Timer()-otime,4)
    else
        MemValGetExists = True
        iVal = fnMemValDecrypt(memVal)
        debugWrite "h!"&":"&LEN(memVal)&":"&Len(iVal)&":"&FormatNumber(Timer()-otime,4)
    end if
end function

'' simple value set
function MemValSet(ipreFix,iKeyStr,iVal,icacheSec)
    dim omem, memVal
    set omem = CreateObject("memcachedCOM.Distributed")
    omem.open G_MEM_ADDR
 
    call omem.set(fnHashMemKey(ipreFix,iKeyStr),fnMemValEncrypt(iVal),icacheSec)
 
    omem.close()
    set omem = Nothing
end function

'' dictionary value set
function  MemValSetDic(ipreFix,iKeyStr,iDic,icacheSec)
    dim omem, memVal, valStr
    set omem = CreateObject("memcachedCOM.Distributed")
    omem.open G_MEM_ADDR
 
    if (LCASE(TypeName(iDic))="dictionary") then
        valStr = Dic2MemStr(iDic)
        
        call omem.set(fnHashMemKey(ipreFix,iKeyStr),fnMemValEncrypt(valStr),icacheSec)
    end if
 
    omem.close()
    set omem = Nothing
end function



'' MemCached-Docruzerd Wrapper
Class CDocWrapper
    private FDocruzer
    private FuseMemcache
    private FQueryType  '' 1:value(count),  2:Array
    private FKeyPreFix
    
    private FOrignQuery
    private FCacheSec
    
    private FMemExists
    private FMemVal
    private FMemArrayStr
    private Fcollec
    
    public LC_KOREAN 
    public CS_EUCKR  
    
    private function getDicValueMem(iarrKey)
        getDicValueMem = Fcollec.Item(iarrKey)
    end function
    
    private function setDicValueMem(iarrKey,iarrVal)
        Fcollec.Item(iarrKey) = iarrVal
        ''Fcollec.Add iarrKey,iarrVal
        ''rw "iarrKey,iarrVal="&iarrKey&","&TypeName(iarrVal)
    end function

    public function BeginSession()
        if (FuseMemcache) then
            
        else
            BeginSession = FDocruzer.BeginSession()
        end if
    end function

    public function SubmitQuery(iSvrAddr, iSvrPort, _
						iAuthCode, iLogs, iScn, _
						iSearchQuery,iSortQuery, _
						iFRectSearchTxt,iStartNum, iFPageSize, _
						iDocruzerLC, iDocruzerCS)
	''dim otime : otime=Timer()
        if (FuseMemcache) then
            FOrignQuery = iSearchQuery&iSortQuery&iStartNum&iFPageSize
            if (FQueryType=1) then
                if (MemValGetExists(FKeyPreFix,FOrignQuery,FMemVal)) then 
                    FMemExists = True
                    SubmitQuery = 1
                    EXIT Function
                end if
            elseif (FQueryType=2) then
                if (MemValGetExists(FKeyPreFix,FOrignQuery,FMemArrayStr)) then 
                    call MemStr2Dic(FMemArrayStr,Fcollec)
                    FMemExists = True
                    SubmitQuery = 1
                    EXIT Function
                end if
            end if
        end if
        
        if (FuseMemcache) then  '' use memcached but Miss
            SET FDocruzer = Server.CreateObject("ATLDocruzer_3_2.Client")
            if (FDocruzer.BeginSession<0) then 
                SubmitQuery = -1
                Exit function 
            end if
        end if
    
        SubmitQuery = FDocruzer.SubmitQuery(iSvrAddr, iSvrPort, _
					iAuthCode, iLogs, iScn, _
					iSearchQuery,iSortQuery, _
					iFRectSearchTxt,iStartNum, iFPageSize, _
					iDocruzerLC, iDocruzerCS)
	 ''debugWrite "doc"&":"&FormatNumber(Timer()-otime,4)
    end function

    public function GetResult_TotalCount(byRef iTotalCount)
        if (FuseMemcache) then
            if (FMemExists) and (FQueryType=1) then
                iTotalCount = FMemVal
                Exit function
            end if
            
            if (FMemExists) and (FQueryType=2) then
                iTotalCount = getDicValueMem("TotalCount")
                Exit function
            end if
        end if
        
        Call FDocruzer.GetResult_TotalCount(iTotalCount)
        
        if (FuseMemcache) and (FQueryType=1) then ''¸âÄ³½Ã »ç¿ëÇÏ°í µ¥ÀÌÅ¸ ¸Þ¸ð¸®¿¡ Á¸Àç ¾ÈÇÏ¸é
            FMemVal = iTotalCount
        end if
        
        if (FuseMemcache) and (FQueryType=2) then 
            call setDicValueMem("TotalCount",iTotalCount)
        end if
        
    end function

    public function GetResult_RowSize(byRef iResultcount) ''°Ë»ö°á°ú¼ö
        if (FuseMemcache) then
            if (FMemExists) and (FQueryType=2) then
                iResultcount = getDicValueMem("RowSize")
                Exit function
            end if
        end if
        
        call FDocruzer.GetResult_RowSize(iResultcount)
        
        if (FuseMemcache) and (FQueryType=2) then 
            call setDicValueMem("RowSize",iResultcount)
        end if
    end function
    
    public function GetResult_Rowid(byRef iRowids,byRef iScores)
        if (FuseMemcache) then
            if (FMemExists) and (FQueryType=2) then
                iRowids = getDicValueMem("Rowids")
                iScores = getDicValueMem("Scores")
                Exit function
            end if
        end if
        
        call FDocruzer.GetResult_Rowid(iRowids, iScores)
        
        if (FuseMemcache) and (FQueryType=2) then 
            call setDicValueMem("Rowids",iRowids)
            call setDicValueMem("Scores",iScores)
        end if
    end function
    
    public function GetResult_Row(byRef iarrData,byRef iarrSize, iRows )
        if (FuseMemcache) then
            if (FMemExists) and (FQueryType=2) then
                iarrData = getDicValueMem("arrData"&iRows)
                Exit function
            end if
        end if
        
        call FDocruzer.GetResult_Row(iarrData, iarrSize, iRows)
        
        if (FuseMemcache) and (FQueryType=2) then 
            call setDicValueMem("arrData"&iRows,iarrData)
        end if
    end function
    
    public function EndSession()
        if (Not FuseMemcache) then
            FDocruzer.EndSession()
        else
            ''Store Value
            if (Not FMemExists) then
                if (FQueryType=1) then 
                    Call MemValSet(FKeyPreFix,FOrignQuery,FMemVal,FCacheSec)
                end if
                
                if (FQueryType=2) then 
                    Call MemValSetDic(FKeyPreFix,FOrignQuery,Fcollec,FCacheSec)
                end if
            end if
        end if
    end function

    public function InItWrapper(isUseMem,iKeyPreFix,iQueryType,icacheSec)
        FuseMemcache = isUseMem
        FQueryType   = iQueryType
        FCacheSec    = icacheSec
        FKeyPreFix   = iKeyPreFix
        if (FuseMemcache) then
            Set Fcollec = CreateObject("Scripting.Dictionary")
            
            'rw "IsObject(Fcollec)"&IsObject(Fcollec)
            'rw "TypeName(Fcollec)"&TypeName(Fcollec)
            'rw "IsArray(Fcollec)"&IsArray(Fcollec)
        else
            SET FDocruzer = Server.CreateObject("ATLDocruzer_3_2.Client")
        end if
    end function

    Private Sub Class_Initialize()
        FMemExists = false
        LC_KOREAN = 1
        CS_EUCKR  = 1
	End Sub

	Private Sub Class_Terminate()
        SET FDocruzer = NOTHING
        SET Fcollec   = NOTHING
	End Sub
	
End Class
%>