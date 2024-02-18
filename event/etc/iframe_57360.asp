<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
'####################################################
' Description : 너의 목소리가 들려2
' History : 2014.12.04 원승현 생성
'####################################################

dim eCode, vUserID, userid, myuserLevel, vPageSize, vPage, vLinkECode, prevEventJoinChk, EventJoinChk, usrSelectItemid, preveCode, sqlStr
	vUserID = GetLoginUserID()
	myuserLevel = GetLoginUserLevel
	userid = vUserID
	
	IF application("Svr_Info") = "Dev" THEN
		eCode = "21389"
		preveCode = "21367"
	Else
		eCode = "57360"
		preveCode = "56870"
	End If

	If IsUserLoginOK Then
		sqlStr = ""
		sqlStr = sqlStr & " SELECT count(sub_idx) " &VBCRLF
		sqlStr = sqlStr & " FROM db_event.dbo.tbl_event_subscript " &VBCRLF
		sqlStr = sqlStr & " WHERE evt_code='"&preveCode&"' " &VBCRLF
		sqlStr = sqlStr & " and userid='" & GetLoginUserID() & "' And sub_opt2 > 0 "
		rsget.Open sqlStr, dbget, 1
			prevEventJoinChk = rsget(0) '// 기존 너의목소리가 들려 1 이벤트 참여여부
		rsget.Close

		sqlStr = ""
		sqlStr = sqlStr & " SELECT count(sub_idx) " &VBCRLF
		sqlStr = sqlStr & " FROM db_event.dbo.tbl_event_subscript " &VBCRLF
		sqlStr = sqlStr & " WHERE evt_code='"&eCode&"' " &VBCRLF
		sqlStr = sqlStr & " and userid='" & GetLoginUserID() & "' "
		rsget.Open sqlStr, dbget, 1
			EventJoinChk = rsget(0) '// 현재 이벤트 참여여부
		rsget.Close

		'// 기존 이벤트에 상품 1개 이상 선택한 후 참여했을 시..
		If prevEventJoinChk > 0 Then
			sqlStr = ""
			sqlStr = sqlStr & " SELECT sub_opt3 " &VBCRLF
			sqlStr = sqlStr & " FROM db_event.dbo.tbl_event_subscript " &VBCRLF
			sqlStr = sqlStr & " WHERE evt_code='"&preveCode&"' " &VBCRLF
			sqlStr = sqlStr & " and userid='" & GetLoginUserID() & "' And sub_opt2 > 0 "
			rsget.Open sqlStr, dbget, 1
				usrSelectItemid = rsget(0)
			rsget.Close
		End If

	End If

%>
<style type="text/css">
.mEvt57360 img {width:100%; vertical-align:top;}
.mEvt57360 .myWishItem {background:#f4f4f4;}
.mEvt57360 .myWishItem dd {position:relative; width:305px; height:405px; margin:0 auto;}
.mEvt57360 .myWishItem ul { overflow:hidden; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/57360/bg_product.gif) left top no-repeat; background-size:100% 100%;}
.mEvt57360 .myWishItem li {position:relative; float:left; width:105px; height:135px; text-align:center; }
.mEvt57360 .myWishItem li:nth-child(3n) {width:95px;}
.mEvt57360 .myWishItem li p {width:95px; text-align:left;}
.mEvt57360 .myWishItem li input {display:inline-block; position:absolute; left:50%; bottom:15px; margin-left:-13px;}
.mEvt57360 .myWishItem .apply {position:absolute; right:0; bottom:38px; width:95px;}
@media all and (min-width:480px){
	.mEvt57360 .myWishItem dd {width:456px; height:606px;}
	.mEvt57360 .myWishItem ul {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/57360/bg_product02.gif);}
	.mEvt57360 .myWishItem li {width:157px; height:202px;}
	.mEvt57360 .myWishItem li p {width:142px;}
	.mEvt57360 .myWishItem li input {bottom:23px; margin-left:-20px;}
	.mEvt57360 .myWishItem .apply {bottom:57px; width:142px;}
}
</style>
<script type="text/javascript">

function jsSubmitComment(){
	var frm = document.frmcom;
	
	<% If vUserID = "" Then %>
		alert('로그인을 하셔야 응모할 수가 있습니다.');
		top.location.href = "/login/login.asp?backpath=%2Fevent%2Feventmain%2Easp%3Feventid%3D<%=eCode%>"
	<% End If %>

	<% If vUserID <> "" Then %>
		<% if prevEventJoinChk < 1 then %>
			alert("기존 너의 목소리가 들려 이벤트에 참여하신 분들 중\n한개 이상의 상품을 선택하신 분들만 참여하실 수 있는 이벤트 입니다.");
			return false;
		<% end if %>

		<% if EventJoinChk > 0 then %>
			alert("이미 이벤트 응모가 완료되었습니다.");
			return false;
		<% end if %>

		if ($("input:checkbox[name='SelChkUsrValue']").is(":checked")==false)
		{
			alert("한개 이상의 상품을 선택해주세요.");
			return false;
		}
		else
		{
		   frm.submit();
		}
	<% End If %>
}

</script>
</head>
<body>
<div class="evtCont">
	<form name="frmcom" method="post" action="doEventSubscript57360.asp" style="margin:0px;" target="prociframe">
	<!-- 위시, 응답하라! -->
	<div class="mEvt57360">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/57360/tit_answer_wish.gif" alt="위시, 응답하라!" /></h2>
		<dl class="myWishItem">
			<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/57360/tit_my_wish.gif" alt="MY WISH ITEM" /></dt>
			<dd>
				<ul>
					<% If vUserID <> "" Then %>
						<% If prevEventJoinChk > 0 Then %>
							<%
								sqlStr = ""
								sqlStr = sqlStr & " SELECT itemid, icon1image, itemname " &VBCRLF
								sqlStr = sqlStr & " FROM db_item.dbo.tbl_item " &VBCRLF
								sqlStr = sqlStr & " WHERE itemid in ("&usrSelectItemid&") " 
								rsget.Open sqlStr, dbget, 1
									Do Until rsget.eof
							%>
									<li>
										<p><a href="/category/category_itemPrd.asp?itemid=<%=rsget("itemid")%>" target="_blank"><img src="http://webimage.10x10.co.kr/image/icon1/<%=GetImageSubFolderByItemid(rsget("itemid"))%>/<%=rsget("icon1image")%>" alt="<%=rsget("itemname")%>" /></a></p>
										<input type="checkbox" name="SelChkUsrValue" value="<%=rsget("itemid")%>"/>
									</li>
							<%
								rsget.movenext
								Loop
								rsget.Close	
							%>
						<% End If %>
					<% End If %>
				</ul>
				<p class="apply"><a href="" onclick="jsSubmitComment();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57360/btn_apply.png" alt="응모하기" /></a></p>
			</dd>
		</dl>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57360/txt_noti.gif" alt="이벤트 유의사항" /></p>
	</div>
	<!--// 위시, 응답하라! -->
	</form>
</div>
<iframe name="prociframe" id="prociframe" frameborder="0" width="0px" height="0px" frameborder="0" marginheight="0" marginwidth="0"></iframe>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->