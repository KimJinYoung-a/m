<!-- #include file="./lgdacom/md5.asp" -->

<%
     '/*
     '* [���� �������ó��(DB) ������]
     '*
     '* 1) ������ ������ ���� hashdata�� ������ �ݵ�� �����ϼž� �մϴ�.
     '*
     '*/

     '/*
     '* ���������� ���� 
     '*/
    Dim LGD_RESPCODE            ' �����ڵ�: 0000(����) �׿� ����
    Dim LGD_RESPMSG             ' ����޼���
    Dim LGD_MID                 ' �������̵� 
    Dim LGD_OID                 ' �ֹ���ȣ
    Dim LGD_AMOUNT              ' �ŷ��ݾ�
    Dim LGD_TID                 ' LG���÷������� �ο��� �ŷ���ȣ
    Dim LGD_PAYTYPE             ' ���������ڵ�
    Dim LGD_PAYDATE             ' �ŷ��Ͻ�(�����Ͻ�/��ü�Ͻ�)
    Dim LGD_HASHDATA            ' �ؽ���
    Dim LGD_FINANCECODE         ' ��������ڵ�(ī������/�����ڵ�/������ڵ�)
    Dim LGD_FINANCENAME         ' ��������̸�(ī���̸�/�����̸�/������̸�)
    Dim LGD_ESCROWYN            ' ����ũ�� ���뿩��
    Dim LGD_TIMESTAMP           ' Ÿ�ӽ�����
    Dim LGD_FINANCEAUTHNUM      ' ������� ���ι�ȣ(�ſ�ī��, ������ü, ��ǰ��)

     '/*
     '* �ſ�ī�� ������� ����
     '*/
    Dim LGD_CARDNUM             ' ī���ȣ(�ſ�ī��)
    Dim LGD_CARDINSTALLMONTH    ' �Һΰ�����(�ſ�ī��) 
    Dim LGD_CARDNOINTYN         ' �������Һο���(�ſ�ī��) - '1'�̸� �������Һ� '0'�̸� �Ϲ��Һ�
    Dim LGD_TRANSAMOUNT         ' ȯ������ݾ�(�ſ�ī��)
    Dim LGD_EXCHANGERATE        ' ȯ��(�ſ�ī��)

     '/*
     '* �޴���
     '*/
    Dim LGD_PAYTELNUM           ' ������ �̿����ȭ��ȣ

     '/*
     '* ������ü, ������
     '*/
    Dim LGD_ACCOUNTNUM          ' ���¹�ȣ(������ü, �������Ա�) 
    Dim LGD_CASTAMOUNT          ' �Ա��Ѿ�(�������Ա�)
    Dim LGD_CASCAMOUNT          ' ���Աݾ�(�������Ա�)
    Dim LGD_CASFLAG             ' �������Ա� �÷���(�������Ա�) - 'R':�����Ҵ�, 'I':�Ա�, 'C':�Ա���� 
    Dim LGD_CASSEQNO            ' �Աݼ���(�������Ա�)
    Dim LGD_CASHRECEIPTNUM      ' ���ݿ����� ���ι�ȣ
    Dim LGD_CASHRECEIPTSELFYN   ' ���ݿ����������߱������� Y: �����߱��� ����, �׿� : ������
    Dim LGD_CASHRECEIPTKIND     ' ���ݿ����� ���� 0: �ҵ������ , 1: ����������

     '/*
     '* OKĳ����
     '*/
    Dim LGD_OCBSAVEPOINT        ' OKĳ���� ��������Ʈ
    Dim LGD_OCBTOTALPOINT       ' OKĳ���� ��������Ʈ
    Dim LGD_OCBUSABLEPOINT      ' OKĳ���� ��밡�� ����Ʈ

     '/*
     '* ��������
     '*/
	Dim LGD_BUYER               ' ������
	Dim LGD_PRODUCTINFO         ' ��ǰ��
	Dim LGD_BUYERID             ' ������ ID
	Dim LGD_BUYERADDRESS        ' ������ �ּ�
    Dim LGD_BUYERPHONE          ' ������ ��ȭ��ȣ
	Dim LGD_BUYEREMAIL          ' ������ �̸���
	Dim LGD_BUYERSSN            ' ������ �ֹι�ȣ
    Dim LGD_PRODUCTCODE         ' ��ǰ�ڵ�
    Dim LGD_RECEIVER            ' ������
	Dim LGD_RECEIVERPHONE       ' ������ ��ȭ��ȣ
	Dim LGD_DELIVERYINFO        ' �����

	Dim LGD_MERTKEY				' LG���÷��� ���� mertkey
	Dim resultMSG				' ���ó�� �޽���

    LGD_RESPCODE            = trim(request("LGD_RESPCODE"))
    LGD_RESPMSG             = trim(request("LGD_RESPMSG"))
    LGD_MID                 = trim(request("LGD_MID"))
    LGD_OID                 = trim(request("LGD_OID"))
    LGD_AMOUNT              = trim(request("LGD_AMOUNT"))
    LGD_TID                 = trim(request("LGD_TID"))
    LGD_PAYTYPE             = trim(request("LGD_PAYTYPE"))
    LGD_PAYDATE             = trim(request("LGD_PAYDATE"))
    LGD_HASHDATA            = trim(request("LGD_HASHDATA"))
    LGD_FINANCECODE         = trim(request("LGD_FINANCECODE"))
    LGD_FINANCENAME         = trim(request("LGD_FINANCENAME"))
    LGD_ESCROWYN            = trim(request("LGD_ESCROWYN"))
    LGD_TRANSAMOUNT         = trim(request("LGD_TRANSAMOUNT"))
    LGD_EXCHANGERATE        = trim(request("LGD_EXCHANGERATE"))
    LGD_CARDNUM             = trim(request("LGD_CARDNUM"))
    LGD_CARDINSTALLMONTH    = trim(request("LGD_CARDINSTALLMONTH"))
    LGD_CARDNOINTYN         = trim(request("LGD_CARDNOINTYN"))
    LGD_TIMESTAMP           = trim(request("LGD_TIMESTAMP"))
    LGD_FINANCEAUTHNUM      = trim(request("LGD_FINANCEAUTHNUM"))
    LGD_PAYTELNUM           = trim(request("LGD_PAYTELNUM"))
    LGD_ACCOUNTNUM          = trim(request("LGD_ACCOUNTNUM"))
    LGD_CASTAMOUNT          = trim(request("LGD_CASTAMOUNT"))
    LGD_CASCAMOUNT          = trim(request("LGD_CASCAMOUNT"))
    LGD_CASFLAG             = trim(request("LGD_CASFLAG"))
    LGD_CASSEQNO            = trim(request("LGD_CASSEQNO"))
    LGD_CASHRECEIPTNUM      = trim(request("LGD_CASHRECEIPTNUM"))
    LGD_CASHRECEIPTSELFYN   = trim(request("LGD_CASHRECEIPTSELFYN"))
    LGD_CASHRECEIPTKIND     = trim(request("LGD_CASHRECEIPTKIND"))
    LGD_OCBSAVEPOINT        = trim(request("LGD_OCBSAVEPOINT"))
    LGD_OCBTOTALPOINT       = trim(request("LGD_OCBTOTALPOINT"))
    LGD_OCBUSABLEPOINT      = trim(request("LGD_OCBUSABLEPOINT"))

	LGD_BUYER               = trim(request("LGD_BUYER"))
	LGD_PRODUCTINFO         = trim(request("LGD_PRODUCTINFO"))
	LGD_BUYERID             = trim(request("LGD_BUYERID"))
	LGD_BUYERADDRESS        = trim(request("LGD_BUYERADDRESS"))
    LGD_BUYERPHONE          = trim(request("LGD_BUYERPHONE"))
	LGD_BUYEREMAIL          = trim(request("LGD_BUYEREMAIL"))
	LGD_BUYERSSN            = trim(request("LGD_BUYERSSN"))
    LGD_PRODUCTCODE         = trim(request("LGD_PRODUCTCODE"))
    LGD_RECEIVER            = trim(request("LGD_RECEIVER"))
	LGD_RECEIVERPHONE       = trim(request("LGD_RECEIVERPHONE"))
	LGD_DELIVERYINFO        = trim(request("LGD_DELIVERYINFO"))

     '/*
     '* hashdata ������ ���� mertkey�� ���������� -> ������� -> ���������������� Ȯ���ϽǼ� �ֽ��ϴ�. 
     '* LG���÷������� �߱��� ����Ű�� �ݵ�� ������ �ֽñ� �ٶ��ϴ�.
     '*/  

    LGD_MERTKEY = "95160cce09854ef44d2edb2bfb05f9f3" '[�ݵ�� ����] mertkey 

	LGD_HASHDATA2 = md5(LGD_MID & LGD_OID & LGD_AMOUNT & LGD_RESPCODE & LGD_TIMESTAMP & LGD_MERTKEY)

	
     '/*
     '* ���� ó����� ���ϸ޼���
     '*
     '* OK   : ���� ó����� ����
     '* �׿� : ���� ó����� ����
     '*
     '* �� ���ǻ��� : ������ 'OK' �����̿��� �ٸ����ڿ��� ���ԵǸ� ����ó�� �ǿ��� �����Ͻñ� �ٶ��ϴ�.
     '*/    
    resultMSG = "������� ���� DBó��(NOTE_URL) ������� �Է��� �ֽñ� �ٶ��ϴ�." '������� ���ϸ޼���

	
	if (LGD_HASHDATA2 = LGD_HASHDATA) then
	    if (LGD_RESPCODE = "0000") then
             '/*
             '* �ŷ����� ��� ���� ó��(DB) �κ�
             '* ���� ��� ó���� �����̸� "OK"
             '*/    
             'if( �������� ����ó����� ���� ) 
             	resultMSG = "OK"   
	    else 
             '/*
             '* �ŷ����� ��� ���� ó��(DB) �κ�
             '* ������� ó���� �����̸� "OK"
             '*/  
             'if( �������� ����ó����� ���� ) 
             	resultMSG = "OK"    
	    end if
	else
         '/*
         '* hashdata���� ���� �α׸� ó���Ͻñ� �ٶ��ϴ�. 
         '*/      
    	 'resultMSG = "������� ���� DBó��(NOTE_URL) �ؽ��� ������ �����Ͽ����ϴ�."    
	end if

    Response.Write(resultMSG)
%>
 
