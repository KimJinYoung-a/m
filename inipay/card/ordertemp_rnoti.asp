<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"

Session.Codepage = 949
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbhelper.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<!-- #INCLUDE Virtual="/lib/email/maillib2.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_tenCashCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<!-- #include virtual="/inipay/common/orderTempFunction.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<%

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

Dim PGIP : PGIP = Request.ServerVariables("REMOTE_ADDR")

IF (application("Svr_Info")="Dev") or PGIP = "118.129.210.25" OR  PGIP = "211.219.96.165" OR  PGIP = "118.129.210.24" OR PGIP = "39.115.212.9" OR PGIP = "183.109.71.153" OR PGIP = "203.238.37.15" OR  PGIP = "192.168.187.140" OR  PGIP = "172.20.22.40" OR  PGIP = "127.0.0.1" THEN  'PG���� ���´��� IP�� üũ
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
	IF (vIdx="5888089") or (vIdx="6218228") or (vIdx="3095118") or (vIdx="3716621") or (vIdx="2720457") or (vIdx="3806071") or (vIdx="2036402") or (vIdx="1857512") or (vIdx="463313") or (vIdx="463308") or (vIdx="121208") or (vIdx="212222") or (vIdx="13215151") THEN
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


	Dim vQuery, vMessage
	vMessage = "[" & P_TYPE & "_" & P_RMESG1 & "]"

	vQuery = "UPDATE [db_order].[dbo].[tbl_order_temp] SET P_STATUS = '" & P_STATUS & "', P_TID = '" & P_TID & "', P_AUTH_NO = '" & P_AUTH_NO & "' , P_RMESG1 = '" & vMessage & "' "
	vQuery = vQuery & ", P_RMESG2 = '" & P_RMESG2 & "', P_FN_CD1 = '" & P_FN_CD1 & "', P_CARD_ISSUER_CODE = '" & P_CARD_ISSUER_CODE & "', P_CARD_PRTC_CODE = '" & P_CARD_PRTC_CODE & "' "
	vQuery = vQuery & "WHERE temp_idx = '" & vIdx & "'"
	dbget.execute vQuery

  
'' �� ���.
''    SESSION("vIdx")=vIdx
''    SERVER.EXECUTE("/inipay/card/mx_rnoti_RET.asp")   '''OK
''''===========================================================================================================
    
    ''��ٱ��� userlevel ���� getLoginUserLevel�� �Ǿ� ����.
    Dim iuserlevel, iPrice, iErrNotiCNT : iErrNotiCNT = 0
    vQuery = "select userlevel,price from [db_order].[dbo].[tbl_order_temp] where temp_idx = '" & vIdx & "'"
    rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
    IF Not rsget.EOF THEN
    	iuserlevel			= rsget("userlevel")
    	iPrice          = rsget("price")
    END IF
    rsget.close
    
    ''2018/05/03 �����ݾ� ����
    if (Trim(CStr(P_AMT))<>Trim(CStr(iPrice))) then
		' vQuery = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','�����ݾ� ���� ����(Mo_IniNoti) :" + vIdx +":"+CStr(P_AMT)+":"+CStr(iPrice)+ "'"
    	' dbget.Execute vQuery

		vQuery = " exec [db_log].[dbo].[usp_ErrorNoti_Input_With_SMS] '"&vIdx&"','IniNoti','Order Check0 err:"&CStr(P_AMT)+":"+CStr(iPrice)&"'"
		dbget.Execute vQuery

		vQuery = " exec [db_log].[dbo].[usp_ErrorNoti_getCount] '"&vIdx&"','IniNoti'"
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
		IF Not rsget.EOF THEN
			iErrNotiCNT		= rsget("cnt")
		END IF
		rsget.close

        if (P_STATUS="00") and (iErrNotiCNT<5) then
        	Response.Write("FAIL")
		else
			Response.Write("OK")
		end if
        

        dbget.close()
    	response.end
    end if
    
    response.Cookies("uinfo").domain = "10x10.co.kr"
    response.cookies("uinfo")("muserlevel") = iuserlevel
    session("ssnuserlevel") = iuserlevel
    
    Dim retChkOK, oshoppingbag, iErrStr, ireserveParam 
    iErrStr = ""
    G_TempBabuni_SoldOut_Check = False  '' Async�� ����ð�� ǰ��üũ ����.
    retChkOK = fnCheckOrderTemp(vIdx, oshoppingbag,iErrStr, ireserveParam, "")
     
    if NOT(retChkOK) then
        ' vQuery = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','Order Check1 err(Payed Mo_IniNoti) :" + vIdx +":"+ replace(iErrStr,"'","") + "'"
    	' dbget.Execute vQuery

		vQuery = " exec [db_log].[dbo].[usp_ErrorNoti_Input_With_SMS] '"&vIdx&"','IniNoti','Order Check1 err:"&replace(iErrStr,"'","")&"'"
		dbget.Execute vQuery

		vQuery = " exec [db_log].[dbo].[usp_ErrorNoti_getCount] '"&vIdx&"','IniNoti'"
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
		IF Not rsget.EOF THEN
			iErrNotiCNT		= rsget("cnt")
		END IF
		rsget.close

        if (P_STATUS="00") and (iErrNotiCNT<5) then
        	Response.Write("FAIL")
		else
			Response.Write("OK")
		end if

        dbget.close()
        response.end
    end if
    
    if (oshoppingbag is Nothing) then
        ' vQuery = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','Order Check2 err(Payed Mo_IniNoti) :" + vIdx +":"+ replace(iErrStr,"'","") + "'"
    	' dbget.Execute vQuery

		vQuery = " exec [db_log].[dbo].[usp_ErrorNoti_Input_With_SMS] '"&vIdx&"','IniNoti','Order Check2 err:"&replace(iErrStr,"'","")&"'"
		dbget.Execute vQuery

		vQuery = " exec [db_log].[dbo].[usp_ErrorNoti_getCount] '"&vIdx&"','IniNoti'"
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
		IF Not rsget.EOF THEN
			iErrNotiCNT		= rsget("cnt")
		END IF
		rsget.close

        if (P_STATUS="00") and (iErrNotiCNT<5) then
        	Response.Write("FAIL")
		else
			Response.Write("OK")
		end if

        dbget.close()
        response.end
    end if
    
    ''201712 �ӽ���ٱ��� ����.
    dim iorderserial
    iErrStr = ""
    iorderserial = oshoppingbag.SaveOrderDefaultDB_TmpBaguni(vIdx, iErrStr)
    
    if (iErrStr<>"") then
    	' vQuery = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','Order Check3 err(Payed Mo_IniNoti) :" + vIdx +":"+ replace(iErrStr,"'","") + "'"
    	' dbget.Execute vQuery

		vQuery = " exec [db_log].[dbo].[usp_ErrorNoti_Input_With_SMS] '"&vIdx&"','IniNoti','Order Check3 err:"&replace(iErrStr,"'","")&"'"
		dbget.Execute vQuery

		vQuery = " exec [db_log].[dbo].[usp_ErrorNoti_getCount] '"&vIdx&"','IniNoti'"
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
		IF Not rsget.EOF THEN
			iErrNotiCNT		= rsget("cnt")
		END IF
		rsget.close

        if (P_STATUS="00") and (iErrNotiCNT<5) then
        	Response.Write("FAIL")
		else
			Response.Write("OK")
		end if

        dbget.close()
    	response.end
    end if



    Dim vResult, vIsSuccess, iPaymethod
    iPaymethod =""
    iErrStr = ""
    Call oshoppingbag.SaveOrderResultDB_TmpBaguni(vIdx, iPaymethod, iErrStr, vResult, vIsSuccess)
    
    if (iErrStr<>"") then
        ' vQuery = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030',''Order Saved err(Payed Mo_IniNoti2) :" + vIdx +":"+ replace(iErrStr,"'","") + "'"
    	' dbget.Execute vQuery

		vQuery = " exec [db_log].[dbo].[usp_ErrorNoti_Input_With_SMS] '"&vIdx&"','IniNoti','Order Saved err:"&replace(iErrStr,"'","")&"'"
		dbget.Execute vQuery

		vQuery = " exec [db_log].[dbo].[usp_ErrorNoti_getCount] '"&vIdx&"','IniNoti'"
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
		IF Not rsget.EOF THEN
			iErrNotiCNT		= rsget("cnt")
		END IF
		rsget.close

        if (P_STATUS="00") and (iErrNotiCNT<5) then
        	Response.Write("FAIL")
		else
			Response.Write("OK")
		end if

    	dbget.close()
        response.end
    end if
    
    On Error resume Next
    dim osms, helpmail
    helpmail = oshoppingbag.GetHelpMailURL
    
    IF (vIsSuccess) THEN
        call sendmailorder(iorderserial,helpmail)
    
        set osms = new CSMSClass
    	osms.SendJumunOkMsg ireserveParam.FBuyhp, iorderserial
        set osms = Nothing
    
    end if
    on Error Goto 0
    

    Response.Write("OK") '����� ������ ������
    
    session("ssnuserlevel") = ""
    response.Cookies("uinfo").domain = "10x10.co.kr"
	response.Cookies("uinfo")("muserlevel") = ""
    response.Cookies("uinfo").Expires = Date - 1

END IF


%>
<!-- #include virtual="/lib/db/dbclose.asp" -->