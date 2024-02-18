<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	'# 현재 페이지명 접수
	dim nowViewPage
	nowViewPage = request.ServerVariables("SCRIPT_NAME")
%>
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbhelper.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<!-- #INCLUDE Virtual="/lib/email/maillib2.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_tenCashCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<!-- #include virtual="/inipay/card/order_real_save_function.asp" -->
<%
'' userLevel 문제.

Dim vTemp
Dim vIdx : vIdx=4871312 ''4077670 ''3806071 ''3716621 ''3399270 ''1405244 ''3246901 ''2349145       ''2236713' 2137229''2026896 ''1843561''1782991 ''1783208 '' ''1737371 ''17373711734166 ''1562293 ''1485328 ''1394467 ''1341902 ''1280383''--1206451'' 1173410''1153267 ''1107932 '786575 '608544 ''607607 ''607582 ''572185 ''498910 ''497582 ''497165 ''451958 ''385773 ''155071 change IsPay='N'
'response.write vIdx
'vTemp 		= OrderRealSaveProc(vIdx)

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->