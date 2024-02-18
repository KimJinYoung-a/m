<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/apps/appCom/wish/web2014/login/checkLogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/web2014/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/sp_item_qnacls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description : 마이텐바이텐 - 상품문의하기
' History : 2014-09-01 이종화 
'####################################################
dim itemid, page, idx
dim emailok, usermail, smsok, userhp, contents
Dim secretYN

	itemid = getNumeric(requestCheckVar(request("itemid"),16))
	idx = getNumeric(requestCheckVar(request("id"),8))
	if itemid="" then itemid="0"

	dim LoginUserid
	LoginUserid = getLoginUserid()
	usermail = GetLoginUserEmail()

	'상품기본정보 접수
	dim oItem, ItemContent
	set oItem = new CatePrdCls
	oItem.GetItemData itemid

	if oItem.FResultCount=0 then
		Call Alert_AppClose("존재하지 않는 상품입니다.")
		dbget.Close(): response.End
	end if

	'상품문의 접수(수정시)
	if idx<>"" then
		dim myitemqna
		set myitemqna = new CItemQna
		myitemqna.FPageSize = 1
		myitemqna.FCurrpage = 1
		myitemqna.FRectUserID = LoginUserid
		myitemqna.FRectId = idx
    	myitemqna.GetMyItemQnaList
    	If myitemqna.FResultCount>0 Then
    		emailok = myitemqna.FItemList(0).Femailok
    		usermail = myitemqna.FItemList(0).Fusermail
    		smsok = myitemqna.FItemList(0).Fsmsok
    		userhp = myitemqna.FItemList(0).Fuserhp
    		contents = myitemqna.FItemList(0).FContents
			secretYN = myitemqna.FItemList(0).FsecretYN
    	else
			Call Alert_AppClose("없거나 삭제된 문의입니다.")
			dbget.Close(): response.End
    	end if
    	set myitemqna = Nothing
	end if

dim i
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<title>10x10: 상품 문의하기</title>
<script>
	function jsCheckLimit() {
		if ("<%=IsUserLoginOK%>"=="False") {
			alert('로그인을 해주세요.');
			return;
		}
	}

	// 상품 문의 등록
	function GotoItemQnA(){
			var frm = document.qnaform;

			if((frm.emailok.checked)&&(!validEmail(frm.usermail))){
				return false;
			}

			if(frm.contents.value.length < 1){
				alert("내용을 적어주셔야 합니다.");
				frm.contents.focus();
				return false;
			}

			if(confirm("상품에 대해 문의 하시겠습니까?")){
				frm.action = "/apps/appcom/wish/web2014/my10x10/doitemqna.asp";
				frm.submit();
				return true;
			} else {
				return false;
			}
	}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content" id="contentArea">
		<form name="qnaform" method="post">
		<input type="hidden" name="id" value="<%=idx%>">
		<input type="hidden" name="itemid" value="<% = itemid %>">
		<input type="hidden" name="cdl" value="<%= oItem.Prd.FcdL %>">
		<input type="hidden" name="qadiv" value="02">
		<input type="hidden" name="mode" value="<%=chkIIF(idx="","write","modi")%>">
		<input type="hidden" name="userid" value="<%= LoginUserid %>">
		<input type="hidden" name="UserName" value="<%= GetLoginUserName %>" >
		<input type="hidden" name="flag" value="fd">
			<div class="qnaPdt">
				<div class="pPhoto">
					<% if oItem.Prd.IsSoldOut then %><p><span><em>품절</em></span></p><% end if %>
					<img src="<%=getThumbImgFromURL(oItem.Prd.FImageBasic,286,286,"true","false")%>" alt="<%= Replace(oItem.Prd.FItemName,"""","") %>" />
				</div>
				<div class="pdtCont">
					<p class="pBrand"><%= oItem.Prd.FBrandName %></p>
					<p class="pName"><%= oItem.Prd.FItemName %></p>
					<p class="pPrice tMar10">
						<% = FormatNumber(oItem.Prd.getRealPrice,0) %>원
						<% If oItem.Prd.IsSaleItem Then %>
						<span class="cRd1">[<% = oItem.Prd.getSalePro %>]</span>
						<% end if %>
					</p>
				</div>
			</div>
			<div class="qnaWrite inner10">
				<textarea name="contents" class="w100p tMar10" cols="30" rows="8" title="문의내용 작성" placeholder="문의하실 내용을 입력하세요."><%=contents%></textarea>
				<div class="overHidden">
					<p class="ftLt w30p tMar10"><input type="checkbox" id="receiveMail" name="emailok" value="Y" <%=chkIIF(emailok="Y","checked='checked'","")%>/> <label for="receiveMail"><strong class="fs12">답변메일 받기</strong></label></p>
					<p class="ftLt w70p lPad10"><input type="email" class="w100p" name="usermail" value="<% = usermail %>" maxlength="128" /></p>
				</div>
<!-- 				<div class="overHidden tPad10"> -->
<!-- 					<p class="ftLt w30p tMar10"><input type="checkbox" id="receivSMS" name="smsok" value="Y" <%=chkIIF(smsok="Y","checked='checked'","")%>/> <label for="receivSMS"><strong class="fs12">답변SMS 받기</strong></label></p> -->
<!-- 					<p class="ftLt w70p lPad10"><input type="tel" class="w100p" name="userhp" value="<% = userhp %>" maxlength="128" /></p> -->
<!-- 				</div> -->
				<div class="tMar10">
					<p><input type="checkbox" id="lock" name="secretYN" value="Y" <%=chkiif(secretYN="Y","checked","")%>/> <label for="lock"><strong class="fs12">비밀글로 문의하기</strong></label></p>
				</div>
				<p class="fs11 tMar20 lMar10 rMar10">※ 주문후 반품,교환,취소 등에 관한 문의는 1:1 게시판을 이용해주시기 바랍니다.</p>
			</div>
		</form>
		</div>
		<div class="floatingBar">
			<div class="btnWrap">
				<div class="ftBtn"><span class="button btB1 btRed cWh1 w100p"><input type="botton" value="<%=chkIIF(idx="","등록","수정")%>" class="btRed" onclick="GotoItemQnA();" /></span></div>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
<% set oItem = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->