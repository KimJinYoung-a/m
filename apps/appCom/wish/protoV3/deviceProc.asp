<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/deviceProc.asp
' Discription : Wish APP Pushid ��� ����
' Request : json > type, pushid, OS, versioncode, versionname, verserion :: type-reg,rmv
' Response : response > ���, response, faildesc
' History : 2014.03.21 ������ : �ű� ����
'###############################################

'//��� ���
Response.ContentType = "text/html"

Dim sFDesc
Dim sType, sDeviceId
Dim sOS, sVerCd, sVerNm, sJsonVer, sAppKey, sMinUpVer, sCurrVer, sCurrVerNm, sUUID, snID
Dim sData : sData = Request("json")
Dim oJson


'// ���۰�� ��¡
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sType = oResult.type
	sDeviceId = requestCheckVar(oResult.pushid,256)

	sOS = requestCheckVar(oResult.OS,10)
	sVerCd = requestCheckVar(oResult.versioncode,20)
	sVerNm = requestCheckVar(oResult.versionname,32)
	sJsonVer = requestCheckVar(oResult.version,10)

	sAppKey = getWishAppKey(sOS)
	
	''if (sAppKey="6") and (sVerCd>"38") then  ''�ȵ���̵� 39�������� uuid �߰� //2016/06/25
	''if ((sAppKey="6") and (sVerCd>"38")) or ((sAppKey="5") and (sVerCd>"1.3")) then  ''�ȵ���̵� 39�������� , ios 1.4 ���� uuid �߰� //2016/06/25  //�ּ� V2
	    if Not ERR THEN
	        sUUID = requestCheckVar(oResult.uuid,40)
	        if ERR THEN Err.Clear ''uuid �������� ����
	    END IF
	''end if
	
	''2015/07/23
    ''if ((sAppKey="6") and (sVerCd>="66")) or ((sAppKey="5") and (sVerCd>="1.96")) then  ''�ȵ���̵� 66�������� , ios 1.96 ���� nid �߰� //2015/07/23  //�ּ� V2
	    if Not ERR THEN
    	    snID = requestCheckVar(oResult.nid,40)
    	    if ERR THEN Err.Clear ''uuid �������� ����
	    END IF
	''end if
	
set oResult = Nothing

'// json��ü ����
Set oJson = jsObject()

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "ó���� ������ �߻��߽��ϴ�."

elseif (sType<>"reg") and (sType<>"rmv") then
	'// �߸��� �ݽ��� �ƴ�
oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "�߸��� �����Դϴ�."
elseif (sDeviceId="") then
	'// �߸��� sDeviceId
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "�߸��� �����Դϴ�."
elseif sAppKey="" then
	'// �߸��� ����
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "�Ķ���� ������ �����ϴ�."

else
	dim sqlStr

	if sDeviceId<>"" then
		'// ���� ��� ���� ����
		if (sType="reg") then  ''���ۼ������� ���ũ�� �޾ƿ�
    		sqlStr = "IF NOT EXISTS(select regidx from db_contents.dbo.tbl_app_regInfo where appkey=" & sAppKey & " and deviceid='" & sDeviceId & "') " & vbCrLf
    		sqlStr = sqlStr & "begin " & vbCrLf
    		sqlStr = sqlStr & "	insert into db_contents.dbo.tbl_app_regInfo " & vbCrLf
    		sqlStr = sqlStr & "		(appKey,deviceid,regdate,appVer,lastact,isAlarm01,isAlarm02,isAlarm03,isAlarm04,isAlarm05,regrefip) values " & vbCrLf
    		sqlStr = sqlStr & "	(" & sAppKey			'�۰���Key
    		sqlStr = sqlStr & ",'" & sDeviceId & "'"	'���ӱ�� DeviceID
    		sqlStr = sqlStr & ",getdate()"				'�������� �Ͻ�
    		sqlStr = sqlStr & ",'"&sVerCd&"'"			'����                       ''/2014/03/21
    		sqlStr = sqlStr & ",'reg'"                  '' �����׼Ǳ���
    		sqlStr = sqlStr & ",'Y'"					'���ø���Ʈ �˸� ����
    		sqlStr = sqlStr & ",'Y'"					'�������� �˸� ����
    		sqlStr = sqlStr & ",'Y'"					'�̺�Ʈ �� ���� �˸� ����
    		sqlStr = sqlStr & ",'N','N','"&Request.ServerVariables("REMOTE_ADDR")&"') " & vbCrLf
    		sqlStr = sqlStr & " end"& vbCrLf

    		sqlStr = sqlStr & " ELSE"& vbCrLf
    		sqlStr = sqlStr & " begin " & vbCrLf
    		sqlStr = sqlStr & " update db_contents.dbo.tbl_app_regInfo" & vbCrLf
    	    sqlStr = sqlStr & "	set lastact='rrg'" & vbCrLf                         ''�������� ���� ��
    	    sqlStr = sqlStr & "	,appVer='"&sVerCd&"'" & vbCrLf
    	    sqlStr = sqlStr & "	,isusing='Y'" & vbCrLf
    	    sqlStr = sqlStr & "	,lastUpdate=getdate()" & vbCrLf
    	    sqlStr = sqlStr & "	where appkey=" & sAppKey & " and deviceid='" & sDeviceId & "'" & vbCrLf
    		sqlStr = sqlStr & " end"& vbCrLf
    		dbget.Execute(sqlStr)
    	elseif (sType="rmv") then ''�������� �Ȱ�� ����
    	    sqlStr = "update db_contents.dbo.tbl_app_regInfo" & vbCrLf
    	    sqlStr = sqlStr & "	set isusing='N'" & vbCrLf
    	    sqlStr = sqlStr & "	,lastact='rmv'" & vbCrLf
    	    sqlStr = sqlStr & "	,lastUpdate=getdate()" & vbCrLf
    	    sqlStr = sqlStr & "	where appkey=" & sAppKey & " and deviceid='" & sDeviceId & "'" & vbCrLf
    	    dbget.Execute(sqlStr)
    	end if

        ''����α� �ۼ�
    	call addDeviceLog(sAppKey,sDeviceId,"",sVerCd,sType)
	end if
    
    if (sDeviceId<>"") and (sType<>"rmv") then
        '' uuid �߰� 2014/06/25 --------------------------------
        ''call addUUIDInfo(sAppKey,sDeviceId,sUUID)
        '' nid �߰� 2015/07/23 --------------------------------
        call addUUIDNidInfo(sAppKey,sDeviceId,sUUID,snid)
        ''------------------------------------------------------
    end if

	oJson("response") = getErrMsg("1000",sFDesc)

end if

if ERR then Call OnErrNoti()
On Error Goto 0

'Json ���(JSON)
oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->