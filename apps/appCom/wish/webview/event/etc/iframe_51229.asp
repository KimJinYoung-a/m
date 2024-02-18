<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 내가 SNS에서 제일 잘 나가 - app
' History : 2014.04.18 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/apps/appcom/wish/webview/event/etc/iframe_51229Cls.asp" -->
<%
	Dim eCode, cnt, sqlStr, regdate, gubun,  i, totalsum
	Dim iCTotCnt , iCPageSize

	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "21150"
	Else
		eCode 		= "51208"
	End If

	Dim ifr, page, y
		page = request("page")

		If page = "" Then page = 1
		iCPageSize = 6

		Function chkurl(v)
			Dim rtval
			Select Case v
				Case "1"
					rtval = "<img src=""http://webimage.10x10.co.kr/eventIMG/2014/51209/ico_facebook.png"" alt=""페이스북"" />"
				Case "2"
					rtval = "<img src=""http://webimage.10x10.co.kr/eventIMG/2014/51209/ico_twitter.png"" alt=""트위터"" />"
				Case "3"
					rtval = "<img src=""http://webimage.10x10.co.kr/eventIMG/2014/51209/ico_instagram.png"" alt=""인스타그램"" />"
				Case "4"
					rtval = "<img src=""http://webimage.10x10.co.kr/eventIMG/2014/51209/ico_pinterest.png"" alt=""핀터레스트"" />"
				Case "5"
					rtval = "<img src=""http://webimage.10x10.co.kr/eventIMG/2014/51209/ico_blog.png"" alt=""네이버 블로그"" />"
			End select	
			Response.write rtval
		End Function 

		set ifr = new Cevt_51208_c
			ifr.FPageSize = iCPageSize
			ifr.FCurrPage = page
			ifr.FRectEvtcode = eCode
			ifr.evt_itemlist

			iCTotCnt = ifr.FTotalCount 
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 내가 SNS에서 제일 잘 나가</title>
<style type="text/css">
	.mEvt51229 {position:relative;}
	.mEvt51229 p {max-width:100%;}
	.mEvt51229 img {vertical-align:top; width:100%;}
	.event1 {padding-top:18px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/51209/mysns_bg_line.png) left top repeat-y; background-size:100% 2px;}
	.event1 .enrollPdtCode {padding-top:16px;}
	.event1 .enrollPdtCode li {overflow:hidden; padding:18px 13px 0 0;}
	.event1 .enrollPdtCode li .num {float:left; width:40%; padding-top:6px;}
	.event1 .enrollPdtCode li:last-child .num {padding-top:10px;}
	.event1 .enrollPdtCode li .frmField {overflow:hidden; float:left; width:60%;}
	.event1 .enrollPdtCode li .frmField .btnSubmit {width:100%; -webkit-border-radius:0;}
	.event1 .enrollPdtCode li .frmField .iText {width:100%; height:26px; padding:0 10px; border:2px solid #ddd; -moz-box-sizing:border-box; box-sizing:border-box;}
	.event1 .enrollPdtCode li .frmField .selectSns {width:103%; margin-right:-3%;}
	.event1 .enrollPdtCode li .frmField .selectSns span {display:block; float:left; width:17%; padding-right:3%; text-align:center;}
	.event1 .enrollPdtCode li .frmField .selectSns span label {display:block; margin-bottom:4px;}
	.event1 .noti {padding:6px 0 13px 10%; color:#999; font-size:0.563em; line-height:13px; letter-spacing:-0.094em;}
	.event1 .pickItem {padding:20px 0; border-top:1px solid #ddd; border-bottom:1px solid #ddd; background:#fafafa;}
	.event1 .pickItem h3 {width:53%; margin:0 auto 16px;}
	.event1 .pickItem ul {overflow:hidden; padding:0 5px 5px;  -moz-box-sizing:border-box; box-sizing:border-box;}
	.event1 .pickItem li {position:relative; float:left; width:33.33333%; padding:0 5px 16px; -moz-box-sizing:border-box; box-sizing:border-box;}
	.event1 .pickItem li .snsIcon {display:inline-block; width:20%; padding-bottom:4px;}
	.event1 .pickItem li .writer {position:absolute; right:5px; top:5px; color:#999; font-size:9px;}

	.event2 {padding:18px 0 22px; background:#e8f9f9;}
	.event2 ul {overflow:hidden; width:100%; padding-top:13px;}
	.event2 li {float:left; width:50%; padding:5px 32px 8px; text-align:center; -moz-box-sizing:border-box; box-sizing:border-box;}
	.event2 li:first-child {border-right:1px solid #ddd;}

	/* paging */
	.paging {width:100%; text-align:center;}
	.paging a {display:inline-block; width:38px; height:38px; border:1px solid #ddd;  text-decoration:none; background-color:#fff; font-size:13px; margin:0 3px; font-weight:bold;}
	.paging a span {display:table-cell; width:38px; height:38px; vertical-align:middle; color:#888;}
	.paging a.arrow {background-color:#ccc; border:1px solid #ccc;}
	.paging a.current span {background-color:#f0f0f0; color:#444;}
	.paging a span.elmBg {text-indent:-9999px; overflow:hidden;}
	.paging a span.prev {background-position:-281px -154px;}
	.paging a span.next {background-position:-229px -154px;}
	.elmBg {background-image:url(http://fiximage.10x10.co.kr/m/2013/common/element01.png); background-repeat:no-repeat; background-size:400px 400px;}
</style>
<script type="text/javascript">

function checkform(frm) {
	<% if datediff("d",date(),"2014-05-10")>=0 then %>
		<% If IsUserLoginOK Then %>
			if (!frm.itemid.value||frm.itemid.value=="상품코드를 입력해주세요")
			{
				alert("상품코드를 입력해주세요");
				frm.itemid.focus();
				document.frm.itemid.value = "";
				return false;
			}

			if(!(frm.spoint[0].checked||frm.spoint[1].checked||frm.spoint[2].checked||frm.spoint[3].checked||frm.spoint[4].checked))
			{
				alert("SNS를 선택해주세요");
				return false;
			}

			if(!frm.evtopt3.value)
			{
				alert("코멘트를 입력해주세요");
				document.frm.evtopt3.value="";
				frm.evtopt3.focus();
				return false;
			}

			if(GetByteLength(frm.evtopt3.value)>150)
			{
				alert('최대 150자 까지 입력 가능합니다.');
				frm.evtopt3.focus();
				return false;
			}

			frm.action = "/apps/appcom/wish/webview/event/etc/doEventSubscript51229.asp";
			return true;
		<% Else %>
			alert('로그인을 하시고 참여해 주세요.');
			return;
		<% End If %>
	<% else %>
			alert('이벤트가 종료되었습니다.');
			return;
	<% end if %>
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
	
	function jsGoPage(iP){
		document.frm.page.value = iP;
		document.frm.submit();
	}

</script>
</head>
<body>
<div class="mEvt51229">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/51209/mysns_head.png" alt="내가 SNS에서 제일 잘 나가" /></h2>
	<!-- EVENT1 -->
	<div class="event1">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/51209/tit_evt01.png" alt="EVENT1. 꼭 갖고 싶은 상품이 있으시다고요?" /></h3>
		<form name="frm" method="POST" style="margin:0px;" onSubmit="return checkform(this);">
		<input type="hidden" name="eventid" value="<%=eCode%>">
		<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
		<input type="hidden" name="page" value="">
		<ol class="enrollPdtCode">
			<li>
				<p class="num"><label for="goodsCode"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51209/txt_step01.png" alt="1 상품코드 입력" /></label></p>
				<div class="frmField">
					<input type="tel" id="goodsCode" class="iText" name="itemid"  pattern="[0-9]*" onkeyup="isNum();" maxlength="7"/>
				</div>
			</li>
			<li>
				<p class="num"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51209/txt_step02.png" alt="2 SNS선택하기" /></p>
				<div class="frmField">
					<div class="selectSns">
						<span>
							<label for="selectSns01"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51209/ico_facebook.png" alt="페이스북" /></label>
							<input type="radio" id="selectSns01" name="spoint" value="1" />
						</span>
						<span>
							<label for="selectSns02"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51209/ico_twitter.png" alt="트위터" /></label>
							<input type="radio" id="selectSns02" name="spoint" value="2" />
						</span>
						<span>
							<label for="selectSns03"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51209/ico_instagram.png" alt="인스타그램" /></label>
							<input type="radio" id="selectSns03" name="spoint" value="3" />
						</span>
						<span>
							<label for="selectSns04"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51209/ico_pinterest.png" alt="핀터레스트" /></label>
							<input type="radio" id="selectSns04" name="spoint" value="4" />
						</span>
						<span>
							<label for="selectSns05"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51209/ico_blog.png" alt="네이버 블로그" /></label>
							<input type="radio" id="selectSns05" name="spoint" value="5" />
						</span>
					</div>
				</div>
			</li>
			<li>
				<p class="num"><label for="snsAddress"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51209/txt_step03.png" alt="3 SNS주소 or ID 계정 남기기" /></label></p>
				<div class="frmField">
					<input type="text" id="snsAddress" class="iText" name="evtopt3" maxlength="150"/>
				</div>
			</li>
			<li>
				<p class="num"><label for="snsAddress"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51209/txt_step04.png" alt="4 응모하기" /></label></p>
				<div class="frmField">
					<input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/51209/btn_submit.png" class="btnSubmit" alt="응모하기" />
				</div>
			</li>
		</ol>
		</form>
		<p class="noti">남겨주신 주소와 계정은 비공개로 응모됩니다. 당신의 개인정보는 소중하니까요<br />당첨자는 텐바이텐 공지사항에서 발표되며, 동시에 SNS계정으로 메시지를 보내드립니다</p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/51209/img_find_code.png" alt="상품상세페이지에서 상품코드를 확인하세요" /></p>
		<!-- PICK ITEM -->
		<% IF ifr.FResultCount > 0 THEN %>
		<div class="pickItem">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/51209/txt_pick_item.png" alt="SNS에서 잘 나가는 핫 피플들의 PICK ITEM" /></h3>
			<ul>
				<% For i = 0 to ifr.FResultCount -1 %>
				<li>
					<div>
						<span class="snsIcon"><% chkurl(ifr.FItemList(i).Fsub_opt2) %></span>
						<span class="writer"><%=printUserId(ifr.FItemList(i).FUserid,2,"*")%>님</span>
						<a href="http://m.10x10.co.kr/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=<%=ifr.FItemList(i).Fitemid%>"><img src="<%=ifr.FItemList(i).FImageIcon1%>" alt="<%=ifr.FItemList(i).Fitemname%>" /></a>
					</div>
				</li>
				<% Next %>
			</ul>
			<%=fnDisplayPaging_New(page,ifr.FTotalCount,iCPageSize,4,"jsGoPage")%>
		</div>
		<% End If %>
		<!--// PICK ITEM -->
	</div>
	<!--// EVENT1 -->

	<!-- EVENT2 -->
	<div class="event2">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/51209/tit_evt02.png" alt="EVENT2. 커피 한 잔은 누가 사줬으면 한다고요?" /></h3>
		<ul>
			<li><a href="#" onclick="openbrowser('')"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51209/btn_share_facebook.png" alt="페이스북- 텐바이텐 포스팅 공유하러 가기" /></a></li>
			<li><a href="#" onclick="openbrowser('http://t.co/IGHq37b8fg')" ><img src="http://webimage.10x10.co.kr/eventIMG/2014/51209/btn_share_twitter.png" alt="트위터- 텐바이텐 포스팅 공유하러 가기" /></a></li>
		</ul>
	</div>
	<!--// EVENT2 -->
</div>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->