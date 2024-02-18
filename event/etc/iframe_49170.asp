<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/etc/iframe_49170Cls.asp" -->
<%
'####################################################
' Description : 널! 위해 준비했어! - 모바일
' History : 2014.02.06 이종화 생성
'####################################################
	dim eCode, cnt, sqlStr, regdate , i
	Dim iCTotCnt , iCPageSize

	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "21077"
	Else
		eCode 		= "49169"
	End If

	If IsUserLoginOK Then
		'중복 응모 확인
		sqlStr="Select count(sub_idx) " &_
				" From db_event.dbo.tbl_event_subscript " &_
				" WHERE evt_code='" & eCode & "'" &_
				" and userid='" & GetLoginUserID() & "' and convert(varchar(10),regdate,120) = '" &  Left(now(),10) & "'"
		rsget.Open sqlStr,dbget,1
		cnt=rsget(0)
		rsget.Close
	End If

	Dim ifr, page, y
	page = request("page")

	If page = "" Then page = 1
	iCPageSize = 4

	set ifr = new Cevt_49169_c
		ifr.FPageSize = iCPageSize
		ifr.FCurrPage = page
		ifr.FRectEvtcode = eCode
		ifr.evt_itemlist

		iCTotCnt = ifr.FTotalCount 

%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 발렌타인데이 이벤트 널! 위해 준비했어!</title>
<style type="text/css">
.mEvt49170 img {vertical-align:top;}
.foryou .productCodeForm {position:relative; background:url(http://webimage.10x10.co.kr/eventIMG/2014/49170/bg_dot.gif) left top no-repeat; background-size:100%;}
.foryou .productCodeForm legend {visibility:hidden; overflow:hidden; position:absolute; top:-1000%; width:0; height:0; line-height:0;}
.foryou .productCodeForm fieldset {padding:0 235px 0 20px;}
.foryou .productCodeForm .iText {width:100%; height:86px; padding:0 150px 0 60px; border:2px solid #e6e6e6; border-radius:100px; background:#fff url(http://webimage.10x10.co.kr/eventIMG/2014/49170/ico_heart.gif) 20px center no-repeat; background-size:26px 22px; font-size:15px; color:#999; font-weight:bold;}
.foryou .productCodeForm .btnSubmit input {width:90px;}
.foryou .productCodeForm .btnSubmit {position:absolute; right:20px; top:0;}
@media all and (max-width:480px){
	.foryou .productCodeForm fieldset {padding:0 132px 0 20px;}
	.foryou .productCodeForm .iText {height:57px; padding:0 70px 0 37px; background:#fff url(http://webimage.10x10.co.kr/eventIMG/2014/49170/ico_heart.gif) 14px center no-repeat; background-size:17px 14px; font-size:11px;}
	.foryou .productCodeForm .btnSubmit input {width:60px;}
}
.foryouGoodsList ul {overflow:hidden; margin-right:-1px; border-left:1px solid #e4e4e4; border-right:1px solid #e4e4e4;}
.foryouGoodsList ul li {float:left; width:50%;}
.foryouGoodsList ul li a {display:block; position:relative; padding:20px 20px 15px; border-right:1px solid #e4e4e4; border-bottom:1px solid #e4e4e4; color:#fb3766; font-size:12px;}
.foryouGoodsList ul li img {width:100%;}
.foryouGoodsList ul li .name {padding-top:7px;}
.foryouGoodsList ul li .name span {position:absolute; right:20px; bottom:15px; padding-left:10px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/49170/blt_heart.gif) left 3px no-repeat; background-size:7px 6px;}
@media all and (max-width:480px){
	.foryouGoodsList ul li a {font-size:8px;}
	.foryouGoodsList ul li .name span {background:url(http://webimage.10x10.co.kr/eventIMG/2014/49170/blt_heart.gif) left 2px no-repeat; background-size:7px 6px;}
}
</style>
<script>
	function checkform(frm) {
	<% if datediff("d",date(),"2014-02-17")>=0 then %>
		<% If IsUserLoginOK Then %>
			<% if cnt >= 3 then %>
			alert('하루에 세 번 응모 가능합니다.\n\n내일 다시 응모해주세요.');
			return;
			<% else %>
				if (!frm.itemid.value||frm.itemid.value=="상품코드를 입력해주세요")
				{
					alert("상품코드를 입력해주세요");
					frm.itemid.focus();
					document.frm.itemid.value = "";
					return false;
				}
				frm.action = "doEventSubscript49170.asp?evt_code=<%=eCode%>";
				return true;
			<% end if %>
		<% Else %>
			alert('로그인 후에 응모하실 수 있습니다.');
			return;
		<% End If %>
	<% else %>
			alert('이벤트가 종료되었습니다.');
			return;
	<% end if %>
	}
	function jsChkVal2()
	{
		if (document.frm.itemid.value == "상품코드를 입력해주세요"){
			document.frm.itemid.value = "";
		}
	}
	function isNum()
	 { 
		var frm = document.frm;
		val = frm.itemid.value;
		new_val = "";

		for(i=0;i<val.length;i++) {
			char = val.substring(i,i+1);
			if(char<'0' || char>'9') {
				frm.itemid.value = new_val;
				return;
			} else {
				new_val = new_val + char;
			}
		}
	}
	function jsChkUnblur2()
	{
		if(document.frm.itemid.value ==""){
			document.frm.itemid.value="상품코드를 입력해주세요";
		}
	}
	function jsGoPage(iP){
		document.frm.page.value = iP;
		document.frm.submit();
	}
</script>
</head>
<body>
	<div class="mEvt49170">
		<div class="foryou">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49170/txt_for_you_01.gif" alt="텐바이텐의 솔로를 위한 발렌타인데이 이벤트" style="width:100%;" /></p>
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/49170/tit_for_you_01.jpg" alt="널! 위해 준비했어!" style="width:100%;" /></h2>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49170/txt_for_you_02.jpg" alt="달콤 쌉싸름한 발렌타인 데이! 혹시 솔로이신가요?" style="width:100%;" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49170/txt_for_you_03.jpg" alt="걱정 마세요! 텐바이텐이 애인이 되어줄게요 이벤트 기간 : 02.10~02.16 ★당첨자 발표일 : 02.18" style="width:100%;" /></p>

			<!-- 상품코드입력 -->
			<div class="productCodeForm">
				<form name="frm" method="POST" style="margin:0px;" onSubmit="return checkform(this);">
				<input type="hidden" name="eventid" value="<%=eCode%>">
				<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
				<input type="hidden" name="page" value="">
				<fieldset>
					<legend>상품코드 입력하고 선물응모 하기</legend>
					<input type="text" class="iText" title="상품코드 입력" value="상품코드를 입력해주세요" name="itemid"  pattern="[0-9]*" onblur="jsChkUnblur2()" onkeyup="jsChkVal2();isNum();" onclick="jsChkVal2();" maxlength="7"/>
					<div class="btnSubmit"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/49170/btn_submit.png" alt="선물응모 하기" /></div>
				</fieldset>
				</form>
			</div>
			<!-- //상품코드입력 -->

			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49170/txt_for_you_04.jpg" alt="이벤트 참여 방법 : 받고 싶은 상품을 골라주세요! 텐바이텐에서 판매 중인 판매가가 1만원 ~ 4만원 사이의 상품 을 선택하고 상품 코드를 입력 해주세요! 이벤트에 응모해주신 분 중 20분을 추첨해 응모하신 상품을 선물로 드립니다. ★ 선물을 많이 응모할수록 당첨 확률 UP! UP!" style="width:100%;" /></p>

			<div class="foryouEventNote">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/49170/tit_for_you_02.gif" alt="이벤트 안내" style="width:100%;" /></h3>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49170/txt_for_you_note_01.gif" alt="선물 응모하기는 하루에 3회만 가능합니다., 당첨자 추첨 기준은 이벤트 기간 응모한 횟수입니다. 응모횟수가 동일 할 경우, 랜덤으로 추첨합니다., 응모한 상품의 가격대가 4만원 초과시, 당첨에서 제외됩니다. 상품 가격을 확인해주세요!" style="width:100%;" /></p>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49170/txt_for_you_code.gif" alt="상품상세페이지에서 상품코드를 확인하세요" style="width:100%;" /></p>
			</div>
			<% IF ifr.FResultCount > 0 THEN %>
			<!-- 상품 응모 리스트 -->
			<div class="foryouGoodsList">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/49170/tit_for_you_04.gif" alt="이런 상품을 응모해주셨어요" style="width:100%;" /></h3>
				<ul>
					<% For i = 0 to ifr.FResultCount -1 %>
					<li>
						<a href="/category/category_itemPrd.asp?itemid=<%=ifr.FItemList(i).Fitemid%>" target="_parent">
							<img src="<%=ifr.FItemList(i).Fitemimg%>" alt="<%=ifr.FItemList(i).Fitemname%>" />
							<div class="name">
								<strong>NO.<%=iCTotCnt-i-(iCPageSize*(page-1)) %></strong>
								<span><%=printUserId(ifr.FItemList(i).FUserid,2,"*")%>님</span>
							</div>
						</a>
					</li>
					<% Next %>
				</ul>
			</div>
			<div id="paging" style="padding-top:10px;">
				<%=fnDisplayPaging_New(page,ifr.FTotalCount,4,4,"jsGoPage") %>
			</div>
			<!-- //상품 응모 리스트 -->
			<% End If %>
		</div>
	</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->