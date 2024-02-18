<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
'##################################################
' PageName : /offshop/point/iframe_card_check.asp
' Description : 오프라인샾 point1010 카드등록 - For mobile
' History : 2009.07.17 강준구 생성
' History : 2015-04-17 이종화 생성
'##################################################
%>
<!-- #include virtual="/apps/appCom/wish/web2014/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/offshop/lib/classes/offshopCls.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/offshop/lib/commonFunction.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<script>
<%
	Dim ClsOSPoint, vCardNo, strSql
	vCardNo = requestCheckVar(Request("cardno"),20)
	
	set ClsOSPoint = new COffshopPoint1010			
		ClsOSPoint.FCardNo	= vCardNo
		ClsOSPoint.FGubun	= "o"
		ClsOSPoint.fnGetCardNumberCheck
	
	If ClsOSPoint.FTotCnt > 0 Then
		If ClsOSPoint.FTotCnt = 1000000000 Then
%>
			parent.myinfoForm.cardnochk.value = "x";
			parent.myinfoForm.RealCardNo.value = "";
			alert('같은 아이피로 단시간 내에 연속으로 여러번 확인하였습니다.\n잠시 후 다시 시도해주세요.\n\n고객센터로 문의를 하시려면 Tel.1644-6030으로 연락을 주세요.');
<%
		Else
%>
			parent.myinfoForm.cardnochk.value = "o";
			parent.myinfoForm.RealCardNo.value = parent.myinfoForm.txCard1.value + "" + parent.myinfoForm.txCard2.value + "" + parent.myinfoForm.txCard3.value + "" + parent.myinfoForm.txCard4.value;
			parent.myinfoForm.txCard1.disabled = true;
			parent.myinfoForm.txCard2.disabled = true;
			parent.myinfoForm.txCard3.disabled = true;
			parent.myinfoForm.txCard4.disabled = true;
			alert('카드번호가 확인이 되었습니다.');
<%
		End If
	Else
		'### 매장에서 카드만 받고 온라인 회원테이블에 없는 사람
		strSql = " SELECT Count(*) FROM [db_shop].[dbo].[tbl_total_shop_card] AS A " & _
				 "		INNER JOIN [db_shop].[dbo].[tbl_total_card_list] AS B ON A.CardNo = B.CardNo " & _
				 "	 WHERE A.CardNo = '" & vCardNo & "' AND A.UseYN = 'Y' AND A.UserSeq = '0' AND B.UseYN = 'Y' "
		rsget.Open strSql,dbget
		IF not rsget.Eof THEN
			If rsget(0) > 0 Then
%>
				parent.myinfoForm.cardnochk.value = "o";
				parent.myinfoForm.RealCardNo.value = parent.myinfoForm.txCard1.value + "" + parent.myinfoForm.txCard2.value + "" + parent.myinfoForm.txCard3.value + "" + parent.myinfoForm.txCard4.value;
				parent.myinfoForm.txCard1.disabled = true;
				parent.myinfoForm.txCard2.disabled = true;
				parent.myinfoForm.txCard3.disabled = true;
				parent.myinfoForm.txCard4.disabled = true;
				alert('카드번호가 확인이 되었습니다.');
<%
			Else
%>
				parent.myinfoForm.cardnochk.value = "x";
				parent.myinfoForm.RealCardNo.value = "";
				alert('이미 등록된 카드번호거나 잘못된 카드번호입니다.\n다시 한번 확인해 주세요.');
<%
			End If
		END IF
		rsget.Close
	End If
	
	set ClsOSPoint = nothing
%>
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->