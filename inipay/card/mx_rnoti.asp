<%
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
Session.Codepage = 949
'*******************************************************************************
' FILE NAME : mx_rnoti.asp
' FILE DESCRIPTION :
' �̴Ͻý� smart phone ���� ��� ���� ������ ����
 '������� : ts@inicis.com
' HISTORY
 '2010. 02. 25 �����ۼ�
 '2010  06. 23 WEB ����� ������� ���� ������� ä�� ��� ���� ó�� �߰�(APP ����� �ش� ����!!)
 'WEB ����� ��� �̹� P_NEXT_URL ���� ä�� ����� ���� �Ͽ����Ƿ�,
 '�̴Ͻý����� �����ϴ� ������� ä�� ��� ������ ���� �Ͻñ� �ٶ��ϴ�.
'*******************************************************************************

'�� �������� �������� ���ʽÿ�. ������ html�±׳� �ڹٽ�ũ��Ʈ�� ���� ��� ������ ������ �� �����ϴ�
'�׸��� ���������� data�� ó���� ��쿡�� �̴Ͻý����� ������ ���� ���� ���� ��������� �ߺ��ؼ� ���� ��
'�����Ƿ� ������ ó���� ����Ǿ�� �մϴ�.
'Response.CacheControl = "no-cache"
'Response.AddHeader "Pragma", "no-cache"
'Response.Expires = -1
'����

%>
<%


'**********************************************************************************
' ó�� �帧
'1) ��� ��� ���� => 2) ���� DB ó�� => 3) DB ó�� ������ "OK ����" ���н� "FAIL" ����
'**********************************************************************************

PGIP = Request.ServerVariables("REMOTE_ADDR")

IF PGIP = "118.129.210.25" OR  PGIP = "211.219.96.165" OR  PGIP = "118.129.210.24" OR PGIP = "39.115.212.9" OR PGIP = "183.109.71.153" OR PGIP = "203.238.37.15" OR  PGIP = "192.168.187.140" OR  PGIP = "172.20.22.40" OR  PGIP = "127.0.0.1" THEN  'PG���� ���´��� IP�� üũ
'PG���� ���´��� IP�� üũ  118.129.210.24, 192.168.187.140, 172.20.22.40, 127.0.0.1�� �系 ��Ʈ������ �׽�Ʈ�ϱ� ���� �뵵��


	'�̴Ͻý� NOTI �������� ���� Value
	Dim P_TID				' �ŷ���ȣ
	Dim P_MID				' �������̵�
	Dim P_AUTH_DT			' ��������
	Dim P_STATUS			' �ŷ����� (00:����, 01:����)
	Dim P_TYPE				' ���Ҽ���
	Dim P_OID				' �����ֹ���ȣ
	Dim P_FN_CD1			' �������ڵ�1
	Dim P_FN_CD2			' �������ڵ�2
	Dim P_FN_NM				' ������� (�����, ī����, ������)
	Dim P_AMT				' �ŷ��ݾ�
	Dim P_UNAME				' ����������
	Dim P_RMESG1			' ����ڵ�
	Dim P_RMESG2			' ����޽���
	Dim P_NOTI				' ��Ƽ�޽���(�������� �ø� �޽���)
	Dim P_AUTH_NO			' ���ι�ȣ
	Dim P_CARD_PRTC_CODE	' �κ��Һο���

	Dim resp, noti(18), resp_time, vIdx

	Dim P_CARD_ISSUER_CODE	'ī��߱޻��ڵ�
	Dim P_CARD_NUM			'ī���ȣ



	'noti server���� ���� value
	resp_time		= Now()
	P_TID			= trim(request("P_TID"))
	P_MID			= trim(request("P_MID"))
	P_AUTH_DT		= trim(request("P_AUTH_DT"))
	P_STATUS		= trim(request("P_STATUS"))
	P_TYPE			= trim(request("P_TYPE"))
	P_OID			= trim(request("P_OID"))
	P_FN_CD1		= trim(request("P_FN_CD1"))
	P_FN_CD2		= trim(request("P_FN_CD2"))
	P_FN_NM			= trim(request("P_FN_NM"))
	P_AMT			= trim(request("P_AMT"))
	P_UNAME			= trim(request("P_UNAME"))
	P_RMESG1		= trim(request("P_RMESG1"))
	''P_RMESG1		= trim(BinaryToText(request("P_RMESG1"),"euc-kr"))
	P_RMESG2		= trim(request("P_RMESG2"))
	P_NOTI			= trim(request("P_NOTI"))
	P_AUTH_NO		= trim(request("P_AUTH_NO"))
	P_CARD_ISSUER_CODE	= trim(request("P_CARD_ISSUER_CODE"))
	P_CARD_NUM			= trim(request("P_AUTH_NO"))
	P_CARD_PRTC_CODE	= trim(request("P_PRTC_CODE"))

	'####### �����ֹ���ȣ �̹Ƿ� ���� �ʿ��� tbl_order_temp�� idx���� �ʿ��Ͽ� ��ü�Ͽ� ��.
	vIdx = P_NOTI

	''������ ��������� ��� �����.
	IF (vIdx="5040330") or (vIdx="4871312") or (vIdx="5095233") or (vIdx="3716621") or (vIdx="2720457") or (vIdx="3806071") or (vIdx="2036402") or (vIdx="1857512") or (vIdx="463313") or (vIdx="463308") or (vIdx="121208") or (vIdx="212222") THEN
	    response.write "OK"
	    response.end
	END IF
	'WEB ����� ��� ������� ä�� ��� ���� ó��
	'(APP ����� ��� �ش� ������ ���� �Ǵ� �ּ� ó�� �Ͻñ� �ٶ��ϴ�.)
	'IF P_TYPE = "VBANK" THEN		'���������� ��������̸�
	'	IF P_STATUS <> "02"	THEN	'�Ա��뺸 "02" �� �ƴϸ�(������� ä�� : 00 �Ǵ� 01 ���)
	'	Response.Write("OK")
	'	Response.End
	'	END IF
	'END IF
	'�׽�Ʈ�� ���� �ּ�ó����


	noti(0) = resp_time
	noti(1) = P_TID
	noti(2) = P_MID
	noti(3) = P_AUTH_DT
	noti(4) = P_STATUS
	noti(5) = P_TYPE
	noti(6) = P_OID
	noti(7) = P_FN_CD1
	noti(8) = P_FN_CD2
	noti(9) = P_FN_NM
	noti(10) = P_AMT
	noti(11) = P_UNAME
	noti(12) = P_RMESG1
	noti(13) = P_RMESG2
	noti(14) = P_NOTI
	noti(15) = P_AUTH_NO
	noti(16) = P_CARD_ISSUER_CODE
	noti(17) = P_CARD_NUM
	noti(18) = P_CARD_PRTC_CODE

	'***********************************************************************************
	 ' ������ ���� �����ͺ��̽��� ��� ���������� ���� �����ÿ��� "OK"�� �̴Ͻý��� ���нô� "FAIL" ��
	 ' �����ϼž��մϴ�. �Ʒ� ���ǿ� �����ͺ��̽� ������ �޴� FLAG ������ ��������
	 ' (����) OK�� �������� �����ø� �̴Ͻý� ���� ������ "OK"�� �����Ҷ����� ��� �������� �õ��մϴ�
	'  ��Ÿ �ٸ� ������ Response.Write�� ���� �����ñ� �ٶ��ϴ�
	'***********************************************************************************


	Dim vQuery, vMessage, vTemp, vResult, vIOrder, vIsSuccess
	vMessage = "[" & P_TYPE & "_" & P_RMESG1 & "]"

	vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] SET P_STATUS = '" & P_STATUS & "', P_TID = '" & P_TID & "', P_AUTH_NO = '" & P_AUTH_NO & "' , P_RMESG1 = '" & vMessage & "' "
	vQuery = vQuery & ", P_RMESG2 = '" & P_RMESG2 & "', P_FN_CD1 = '" & P_FN_CD1 & "', P_CARD_ISSUER_CODE = '" & P_CARD_ISSUER_CODE & "', P_CARD_PRTC_CODE = '" & P_CARD_PRTC_CODE & "' "
	vQuery = vQuery & "WHERE temp_idx = '" & vIdx & "'"
	dbget.execute vQuery

    '''�ȵǳ�..
    ''response.reDirect "/inipay/card/mx_rnoti_RET.asp?vIdx="&vIdx  '''�ȵ�.
    SESSION("vIdx")=vIdx
    SERVER.EXECUTE("/inipay/card/mx_rnoti_RET.asp")   '''OK
''''===========================================================================================================
'    dim uselevel
'	vQuery = "SELECT TOP 1 userlevel FROM [db_order].[dbo].[tbl_order_temp] WHERE temp_idx = '" & vIdx & "'"
'	rsget.Open vQuery,dbget,1
'    uselevel = rsget("userlevel")
'    rsget.close()
'    response.Cookies("uinfo").domain = "10x10.co.kr"
'    response.cookies("uinfo")("muserlevel") = uselevel
'
'
'	vTemp = OrderRealSaveProc(vIdx)
'
'	response.Cookies("uinfo").domain = "10x10.co.kr"
'	response.Cookies("uinfo") = ""
'
'	vResult		= Split(vTemp,"|")(0)
'	vIOrder		= Split(vTemp,"|")(1)
'	vIsSuccess	= Split(vTemp,"|")(2)
'
'	IF vResult = "ok" Then
'		vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] SET IsPay = 'Y', PayResultCode = '" & vResult & "', orderserial = '" & vIOrder & "', IsSuccess = '" & vIsSuccess & "' WHERE temp_idx = '" & vIdx & "'"
'		dbget.execute vQuery
'
'		Response.Write("OK") '����� ������ ������
'	Else
'		vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] SET IsPay = 'N', PayResultCode = '" & vResult & "' WHERE temp_idx = '" & vIdx & "'"
'		dbget.execute vQuery
'
'		Response.Write("FAIL")
'	End If
''''===========================================================================================================
	'**********************************************************************************
	'�̺κп� �α����� ��θ� �������ּ���.
	'�α׸� ����ž� ���� �߻��� ���� ������ ���� �մϴ�.
	'logdate		=	year(now) & right("0" & month(now),2) & right("0" & day(now),2)
	'logfilename	=	"noti_input_"& f_tempDate & logdate & ".log"

	'filepath = "C:\\Inetpub\\5050\\company\\inicis\\test_logic\\mx\\asp\\euckr\\log\\"  & logfilename  '�α׸� ����� ���͸�
	'**********************************************************************************
	' writeLog filepath , noti
END IF



Function writeLog(file, noti)

    Dim fso, ofile, slog

    slog = ""
    slog = slog & "PageCall time:"	& noti(0) & Chr(10)
    slog = slog & "P_TID:"			& noti(1) & Chr(10)
    slog = slog & "P_MID:"			& noti(2) & Chr(10)
    slog = slog & "P_AUTH_DT:"		& noti(3) & Chr(10)
    slog = slog & "P_STATUS:"		& noti(4) & Chr(10)
    slog = slog & "P_TYPE:"			& noti(5) & Chr(10)
    slog = slog & "P_OID:"			& noti(6) & Chr(10)
    slog = slog & "P_FN_CD1:"		& noti(7) & Chr(10)
    slog = slog & "P_FN_CD2:"		& noti(8) & Chr(10)
    slog = slog & "P_FN_NM:"		& noti(9) & Chr(10)
    slog = slog & "P_AMT:"			& noti(10) & Chr(10)
    slog = slog & "P_UNAME:"		& noti(11) & Chr(10)
    slog = slog & "P_RMESG1:"		& noti(12) & Chr(10)
    slog = slog & "P_RMESG2:"		& noti(13) & Chr(10)
    slog = slog & "P_NOTI:"			& noti(14) & Chr(10)
    slog = slog & "P_AUTH_NO:"		& noti(15) & Chr(10)
    slog = slog & chr(13) + chr(10)
    slog = slog & chr(13) + chr(10)
    slog = slog & chr(13) + chr(10)




    Set fso = Server.CreateObject("Scripting.FileSystemObject")
    if fso.fileExists(file) then
        Set ofile = fso.OpenTextFile(file, 8, True)
    else
        Set ofile = fso.CreateTextFile(file, True)
    end if

    ofile.Writeline slog

    ofile.close
    Set ofile = Nothing
    Set fso = Nothing
End Function

Session.Codepage = 65001
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->