<%
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_orderCls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<!-- #include virtual="/lib/util/rndSerial.asp" -->
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

	'####### �����ֹ���ȣ �̹Ƿ� ���� �ʿ��� tbl_giftcard_order_temp�� idx���� �ʿ��Ͽ� ��ü�Ͽ� ��.
	vIdx = P_NOTI

	''������ ��������� ��� �����.
	IF (vIdx="32") THEN
	    response.write "OK"
	    response.end
	END IF
	'WEB ����� ��� ������� ä�� ��� ���� ó��
	'(APP ����� ��� �ش� ������ ���� �Ǵ� �ּ� ó�� �Ͻñ� �ٶ��ϴ�.)
	IF P_TYPE = "VBANK" THEN		'���������� ��������̸�
		IF P_STATUS <> "02"	THEN	'�Ա��뺸 "02" �� �ƴϸ�(������� ä�� : 00 �Ǵ� 01 ���)
		Response.Write("OK")
		Response.End
		END IF
	END IF

	

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

	IF (vIdx="") THEN
	    Response.Write("FAIL")
	    Response.End
	End If

	Dim vQuery, vMessage, vTemp, vResult, vIOrder, vIsSuccess, userid, userhp
	vMessage = "[" & P_TYPE & "_" & P_RMESG1 & "]"

	vQuery = "UPDATE [db_order].[dbo].[tbl_giftcard_order_temp] SET P_STATUS = '" & P_STATUS & "', P_TID = '" & P_TID & "', P_AUTH_NO = '" & P_AUTH_NO & "' , P_RMESG1 = '" & vMessage & "' "
	vQuery = vQuery & ", P_RMESG2 = '" & P_RMESG2 & "', P_FN_CD1 = '" & P_FN_CD1 & "', P_CARD_ISSUER_CODE = '" & P_CARD_ISSUER_CODE & "', P_CARD_PRTC_CODE = '" & P_CARD_PRTC_CODE & "' "
	vQuery = vQuery & "WHERE temp_idx = '" & vIdx & "'"
	dbget.execute vQuery

	IF P_TYPE = "VBANK" THEN
	'========== ������� ==========
		'// ����Ʈī�� ������´� ���ֹ���ȣ�� �̹� ������ ���·� �Ա�Ȯ�� ó���� �ϸ�� (2016.02.05)
		vQuery = "SELECT TOP 1 userid, buyhp, giftOrderSerial FROM [db_order].[dbo].[tbl_giftcard_order_temp] WHERE temp_idx = '" & vIdx & "'"
		rsget.Open vQuery,dbget,1
		IF Not rsget.Eof THEN
	        userid = rsget("userid")
	        userhp = rsget("buyhp")
	        vIOrder = rsget("giftOrderSerial")
	    ENd IF
	    rsget.close()

		'�̴Ͻý� ����TID ���� Test
		'vQuery = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','GiftCard �������- " & P_STATUS & ":" & P_TID & ":" & vIdx & "'"
		'dbget.Execute vQuery

		IF (vIOrder="") THEN
			vQuery = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','GiftCard ������¿��� - tmpid:" + vIdx+ "'"
			dbget.Execute vQuery

		    Response.Write("FAIL")
		    Response.End
		End If

		On Error Resume Next

		'// �ֹ����� ����
		vQuery = " update [db_order].[dbo].tbl_giftcard_order" + vbCrlf
		vQuery = vQuery + " Set ipkumdiv='4'" + vbCrlf
		vQuery = vQuery + " ,jumunDiv='3'" + vbCrlf
		vQuery = vQuery + " ,paydateid='" & P_TID & "'" + vbCrlf				'����TID�� ����TID�� �ٸ�! ������
		vQuery = vQuery + " ,ipkumdate=getdate()" + vbCrlf
		vQuery = vQuery + " where giftOrderSerial='" + CStr(vIOrder) + "'" + vbCrlf
		dbget.execute vQuery

	    IF (Err) then
			vQuery = " exec [db_sms].[dbo].[usp_SendSMS] '010-6324-9110','1644-6030','GiftCard �ֹ����� :" + vIOrder +":"+ replace(Err.Description,"'","") + "'"
			dbget.Execute vQuery
		    Response.Write("FAIL")
		    Response.End
		end if

	    '// ���� �Ϸ� ���� �߼�::�ֹ��ڿ��� �߼�.
	    Call SendMailGiftOrder(userid,vIOrder,"�ٹ�����<customer@10x10.co.kr>")
    
	    dim osms
	    '// ���� �Ϸ� SMS �߼�
	    set osms = new CSMSClass
	    osms.SendJumunOkMsg userhp, vIOrder
	    set osms = Nothing

	    '// Giftī�� MMS �߼�::�����ο���
	    Call sendGiftCardLMSMsg2016(vIOrder)

		'// ������ �߼� ó��
        vQuery = "update db_order.dbo.tbl_giftcard_order"
        vQuery = vQuery & " set jumundiv=5"
        vQuery = vQuery & " ,senddate=getdate()"
        vQuery = vQuery & " ,ipkumdiv=8"
        vQuery = vQuery & " where giftorderserial='" & CStr(vIOrder) & "'"
        vQuery = vQuery & " and ipkumdiv>3"
        vQuery = vQuery & " and jumundiv<5"
        vQuery = vQuery & " and cancelyn='N'"
        dbget.Execute vQuery

		On Error Goto 0

		Response.Write("OK")
	
	ELSEIF P_TYPE = "BANK" THEN
	'========== �ǽð�������ü ==========
		'// �ǽð�������ü�� mx_return���� ������ �񵿱�� mx_rnoti�� ȣ���ϹǷ� ���ֹ� ó���ؾ� ��
	    SESSION("vIdx")=vIdx
	    SERVER.EXECUTE("/inipay/giftcard/mx_rnoti_RET.asp")   '''OK
	end if

END IF
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->