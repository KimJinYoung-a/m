<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : 동숭동 제목학원(앱)
' History : 2015.08.31 원승현 생성
'####################################################
	Dim vUserID, eCode, eLinkCode, sqlstr, vJemokChasu
	Dim strSql, ReceiveDate, NowDate, vMainImgName, vPrevDate, vNextDate, vaddClass, vaddLink

	vUserID = GetEncLoginUserID
	ReceiveDate = requestcheckvar(request("Rdate"),32)

	NowDate = left(now(), 10)

	If ReceiveDate = "" Then
		ReceiveDate = NowDate
	End If

	IF application("Svr_Info") = "Dev" THEN
		eCode = "64871"
		eLinkCode = "64872"
	Else
		eCode = "65841"
		eLinkCode = "65803"
	End If



	Select Case Trim(ReceiveDate)
		Case "2015-09-02"
			vJemokChasu = 1
			vMainImgName = "0902"
			vaddClass = " item0902"
			If isApp="1" Then
				vaddLink = "<a href='' onclick='parent.fnAPPpopupProduct(""1300480"");return false;' class='vlink1'><span></span></a><a href=''  onclick='parent.fnAPPpopupProduct(""1050636"");return false;'  class='vlink2'><span></span></a><a href=''  onclick='parent.fnAPPpopupProduct(""1241911"");return false;'  class='vlink3'><span></span></a><a href=''  onclick='parent.fnAPPpopupProduct(""1292307"");return false;'  class='vlink4'><span></span></a>"
			Else
				vaddLink = "<a href='/category/category_itemPrd.asp?itemid=1300480' class='vlink1' target='_blank'><span></span></a><a href='/category/category_itemPrd.asp?itemid=1050636' class='vlink2' target='_blank'><span></span></a><a href='/category/category_itemPrd.asp?itemid=1241911' class='vlink3' target='_blank'><span></span></a><a href='/category/category_itemPrd.asp?itemid=1292307' class='vlink4' target='_blank'><span></span></a>"
			End If

		Case "2015-09-03"
			vJemokChasu = 2
			vMainImgName = "0903"
			vaddClass = ""
			If isApp="1" Then
				vaddLink = "<a href='' onclick='parent.fnAPPpopupProduct(""1213213"");return false;' class='vlink1'><span></span></a>"
			Else
				vaddLink = "<a href='/category/category_itemPrd.asp?itemid=1213213' class='vlink1' target='_blank'><span></span></a>"
			End If

		Case "2015-09-04"
			vJemokChasu = 3
			vMainImgName = "0904"
			vaddClass = ""
			If isApp="1" Then
				vaddLink = "<a href='' onclick='parent.fnAPPpopupProduct(""787928"");return false;' class='vlink1'><span></span></a>"
			Else
				vaddLink = "<a href='/category/category_itemPrd.asp?itemid=787928' class='vlink1' target='_blank'><span></span></a>"
			End If

		Case "2015-09-05"
			vJemokChasu = 4
			vMainImgName = "0905"
			vaddClass = " item0905"
			If isApp="1" Then
				vaddLink = "<a href='' onclick='parent.fnAPPpopupProduct(""1213212"");return false;' class='vlink1'><span></span></a><a href=''  onclick='parent.fnAPPpopupProduct(""1213214"");return false;'  class='vlink2'><span></span></a>"
			Else
				vaddLink = "<a href='/category/category_itemPrd.asp?itemid=1213212' class='vlink1' target='_blank'><span></span></a><a href='/category/category_itemPrd.asp?itemid=1213214' class='vlink2' target='_blank'><span></span></a>"
			End If

		Case "2015-09-06"
			vJemokChasu = 5
			vMainImgName = "0906"
			vaddClass = ""
			If isApp="1" Then
				vaddLink = "<a href='' onclick='parent.fnAPPpopupProduct(""1119270"");return false;' class='vlink1'><span></span></a>"
			Else
				vaddLink = "<a href='/category/category_itemPrd.asp?itemid=1119270' class='vlink1' target='_blank'><span></span></a>"
			End If

		Case "2015-09-07"
			vJemokChasu = 6
			vMainImgName = "0907"
			vaddClass = ""
			If isApp="1" Then
				vaddLink = "<a href='' onclick='parent.fnAPPpopupBrand(""reverse1010"");return false;' class='vlink1'><span></span></a>"
			Else
				vaddLink = "<a href='/street/street_brand.asp?makerid=reverse1010' class='vlink1' target='_blank'><span></span></a>"
			End If

		Case "2015-09-08"
			vJemokChasu = 7
			vMainImgName = "0908"
			vaddClass = ""
			If isApp="1" Then
				vaddLink = "<a href='' onclick='parent.fnAPPpopupBrand(""preiser"");return false;' class='vlink1'><span></span></a>"
			Else
				vaddLink = "<a href='/street/street_brand.asp?makerid=preiser' class='vlink1' target='_blank'><span></span></a>"
			End If

		Case "2015-09-09"
			vJemokChasu = 8
			vMainImgName = "0909"
			vaddClass = ""
			If isApp="1" Then
				vaddLink = "<a href='' onclick='parent.fnAPPpopupProduct(""928486"");return false;' class='vlink1'><span></span></a>"
			Else
				vaddLink = "<a href='/category/category_itemPrd.asp?itemid=928486' class='vlink1' target='_blank'><span></span></a>"
			End If


		Case "2015-09-10"
			vJemokChasu = 9
			vMainImgName = "0910"
			vaddClass = ""
			If isApp="1" Then
				vaddLink = "<a href='' onclick='parent.fnAPPpopupProduct(""1166278"");return false;' class='vlink1'><span></span></a>"
			Else
				vaddLink = "<a href='/category/category_itemPrd.asp?itemid=1166278' class='vlink1' target='_blank'><span></span></a>"
			End If


		Case "2015-09-11"
			vJemokChasu = 10
			vMainImgName = "0911"
			vaddClass = ""
			If isApp="1" Then
				vaddLink = "<a href='' onclick='parent.fnAPPpopupProduct(""878340"");return false;' class='vlink1'><span></span></a>"
			Else
				vaddLink = "<a href='/category/category_itemPrd.asp?itemid=878340' class='vlink1' target='_blank'><span></span></a>"
			End If


		Case Else
			vJemokChasu = 1
			vMainImgName = "0902"
			vaddClass = "item0902"
			If isApp="1" Then
				vaddLink = "<a href='' onclick='parent.fnAPPpopupProduct(""39140"");return false;' class='vlink1'><span></span></a><a href=''  onclick='parent.fnAPPpopupProduct(""1050636"");return false;'  class='vlink2'><span></span></a><a href=''  onclick='parent.fnAPPpopupProduct(""1241911"");return false;'  class='vlink3'><span></span></a><a href=''  onclick='parent.fnAPPpopupProduct(""1292307"");return false;'  class='vlink4'><span></span></a>"
			Else
				vaddLink = "<a href='/category/category_itemPrd.asp?itemid=39140' class='vlink1' target='_blank'><span></span></a><a href='/category/category_itemPrd.asp?itemid=1050636' class='vlink2' target='_blank'><span></span></a><a href='/category/category_itemPrd.asp?itemid=1241911' class='vlink3' target='_blank'><span></span></a><a href='/category/category_itemPrd.asp?itemid=1292307' class='vlink4' target='_blank'><span></span></a>"
			End If

	End Select
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.mEvt65803 button {background-color:transparent;}
.mEvt65803 h2 {visibility:hidden; width:0; height:0;}

.topic h3 {visibility:hidden; width:0; height:0;}

.take {padding-top:9.6%; background:#decbc5 url(http://webimage.10x10.co.kr/eventIMG/2015/65803/bg_wall_v1.png) no-repeat 50% 0; background-size:100% auto;}
.take h3 {visibility:hidden; width:0; height:0;}
.take .navigator {width:75%; margin:0 auto; padding:1.8% 0; border-radius:16px; background-color:#b9a69f; text-align:center;}
.take .navigator li {display:inline-block; margin:0 3px;}
.take .navigator li a {display:block; width:8px; height:8px; border:2px solid #dcd3cf; border-radius:50%; font-size:11px; text-indent:-999em; line-height:0.688em;}
.take .navigator li a.on {border:2px solid #fff; background-color:#fff;}

.take .itembox {position:relative;}
.take .itembox .item .figure {position:relative; width:86.7%; margin:6% 0 10.4% 5.3%;}
.take .itembox .figure .today {position:absolute; top:-10%; right:-8%; width:18%;}
.item .figure a {overflow:hidden; display:block; position:absolute; top:0; left:2%; width:98%; height:0; padding-bottom:61.25%; color:transparent; font-size:11px; line-height:11px; text-align:center;}
.item .figure a span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0; filter:alpha(opacity=0); cursor:pointer;}
.item0902 .figure a.vlink1 {top:15%; left:13%; width:30%; padding-bottom:20.25%;}
.item0902 .figure a.vlink2 {top:20%; left:50%; width:20%; padding-bottom:20.25%;}
.item0902 .figure a.vlink3 {top:60%; left:35%; width:20%; padding-bottom:22.25%;}
.item0902 .figure a.vlink4 {top:30%; left:80%; width:20%; padding-bottom:20.25%;}
.item0905 .figure a.vlink1 {top:23%; left:22%; width:30%; padding-bottom:40.25%;}
.item0905 .figure a.vlink2 {top:25%; left:55%; width:26%; padding-bottom:40.25%;}

.take .itembox button {position:absolute; top:70px; z-index:50; width:12.6%;}
.take .btnPrev {left:1.5%;}
.take .btnNext {right:1.5%;}

.take .field {position:relative;}
.take .field legend {visibility:hidden; width:0; height:0;}
.take .field .inner {position:relative; width:84.6%; margin-left:8%; padding-bottom:5%;}
.field .comming {display:none; position:absolute; bottom:0; left:0; z-index:30; width:100%;}
.field .closed {display:block; position:absolute; bottom:0; left:0; z-index:30; width:100%; background-color:rgba(0,0,0,0.8);}
.field .closed img {-webkit-animation-duration:1s; animation-duration:1s; -webkit-animation-name:flash; animation-name:flash; -webkit-animation-iteration-count:5; animation-iteration-count:5;}
/* flash animation */
@-webkit-keyframes flash {
	0% {opacity:0;}
	100% {opacity:1;}
}
@keyframes flash {
	0% {opacity:0;}
	100% {opacity:1;}
}

.field .itext {overflow:hidden; display:block; position:relative; z-index:20; width:73.52%; height:0; padding-bottom:16.65%;}
.field .itext input {position:absolute; top:0; left:0; width:100%; height:100%; border:0; border-radius:0; background:url(http://webimage.10x10.co.kr/eventIMG/2015/65803/bg_input.png) no-repeat 50% 0; background-size:100% auto; color:#533f2c; font-size:13px; font-weight:bold; line-height:13px; text-align:center;}
.field .btnsubmit {position:absolute; top:0; right:0; width:23.78%;}
.field .btnsubmit input {width:100%;}
::-webkit-input-placeholder {color:#999;}
::-moz-placeholder {color:#999;} /* firefox 19+ */
:-ms-input-placeholder {color:#999;} /* ie */
input:-moz-placeholder {color:#999;}

.lyBox {display:none; position:absolute; top:-25%; left:2.6%; z-index:200; width:97.3%;}
.lyBox .btnclose {position:absolute; top:2% !important; right:6% !important;; width:10.5% !important;}
.dimmed {display:none; position:absolute; top:0; left:0; z-index:100; width:100%; height:100%; background:rgba(0,0,0,.75);}

.namebox {background:#f5f4ef url(http://webimage.10x10.co.kr/eventIMG/2015/65803/bg_ivory.png) repeat-y 50% 0; background-size:100% auto;}
.namebox .hidden {visibility:hidden; width:0; height:0;}
.namebox .sort {overflow:hidden; position:relative; width:188px; margin:0 auto;}
.namebox .sort li {float:left; width:80px; height:37px; margin:0 7px;}
.namebox .sort li a {overflow:hidden; display:block; position:relative; width:100%; height:100%; font-size:11px; line-height:37px; text-align:center;}
.namebox .sort li a span {display:block; position:absolute; top:0; left:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/65803/bg_sort_v1.png) no-repeat 100% 0; background-size:160px auto;}
.namebox .sort li:first-child a span {background-position:0 0;}
.namebox .sort li a.on span {background-position:100% 100%;}
.namebox .sort li:first-child a.on span {background-position:0 100%;}
.namebox .sort li:first-child:after {content:' '; position:absolute; top:5px; left:93px; z-index:5; width:1px; height:20px; background-color:#d4d2cc;}

.nameList {margin-top:6%; padding-bottom:8%;}
.nameList ul {width:290px; margin:0 auto;}
.nameList ul li {position:relative; height:50px; margin-bottom:5%; padding-left:61px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/65803/bg_box.png) no-repeat 50% 0; background-size:100% auto;}
.nameList ul li .name, .nameList ul li .id {display:block;}
.nameList ul li .name {padding-top:10px; color:#000; font-family:helveticaNeue, helvetica, sans-serif !important; font-size:13px;}
.nameList ul li .id {margin-top:5px; color:#555; font-size:10px;}
.nameList ul li .vote {position:absolute; top:5px; right:6px; width:40px; height:40px;}
.nameList ul li .vote button {position:absolute; top:0; left:0; z-index:5; width:40px; height:40px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/65803/btn_heart.png) no-repeat 50% 0; background-size:100% auto; text-indent:-999em;}
.nameList ul li .vote button.on {background-position:0 -40px;}
.nameList ul li .vote strong {position:absolute; top:0; left:0; z-index:10; width:40px; margin-top:24px; color:#fff; font-size:10px; line-height:1.25em; text-align:center;}
.nameList ul li em {position:absolute; top:0; left:0; width:55px; height:50px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/65803/bg_ranking_v1.png) no-repeat 0 0; background-size:550px auto; text-indent:-999em;}
.nameList ul li:nth-child(2) em {background-position:-55px 0;}
.nameList ul li:nth-child(3) em {background-position:-110px 0;}
.nameList ul li:nth-child(4) em {background-position:-165px 0;}
.nameList ul li:nth-child(5) em {background-position:-220px 0;}
.nameList ul li:nth-child(6) em {background-position:-275px 0;}
.nameList ul li:nth-child(7) em {background-position:-330px 0;}
.nameList ul li:nth-child(8) em {background-position:-385px 0;}
.nameList ul li:nth-child(9) em {background-position:-440px 0;}
.nameList ul li:nth-child(10) em {background-position:100% 0;}

.nameList .btnmore {display:block; width:65.625%; margin:7% auto 2%;}

.mine {background-color:#f5eed7;}
.mine .nameList {margin-top:0; padding-top:0;}
.mine .nameList li {margin-top:0;}

.kakao h3 {visibility:hidden; width:0; height:0;}

.noti {padding:5% 3.125%;}
.noti h3 {color:#000; font-size:13px;}
.noti h3 strong {display:inline-block; padding-bottom:1px; border-bottom:2px solid #000; line-height:1.25em;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; margin-top:2px; padding-left:10px; color:#444; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:4px; left:0; width:4px; height:4px; border-radius:50%; background-color:#e66b53;}

@media all and (min-width:480px){
	.take .navigator li {margin:0 5px;}
	.take .navigator li a {width:12px; height:12px; line-height:1em;}

	.take .itembox button {top:100px;}

	.field .itext input {font-size:19px; line-height:19px;}

	.namebox .sort {width:282px;}
	.namebox .sort li {width:120px; height:55px; margin:0 10px;}
	.namebox .sort li a span {background-size:240px auto;}
	.namebox .sort li:first-child:after {top:7px; left:139px; z-index:5; width:2px; height:30px;}

	.nameList ul {width:435px;}
	.nameList ul li {height:75px; padding-left:93px;}
	.nameList ul li .name {padding-top:17px; font-size:19px;}
	.nameList ul li .id {font-size:15px;}
	.nameList ul li em {width:82px; height:75px; background-size:820px auto;}
	.nameList ul li:nth-child(2) em {background-position:-82px 0;}
	.nameList ul li:nth-child(3) em {background-position:-164px 0;}
	.nameList ul li:nth-child(4) em {background-position:-246px 0;}
	.nameList ul li:nth-child(5) em {background-position:-328px 0;}
	.nameList ul li:nth-child(6) em {background-position:-410px 0;}
	.nameList ul li:nth-child(7) em {background-position:-492px 0;}
	.nameList ul li:nth-child(8) em {background-position:-574px 0;}
	.nameList ul li:nth-child(9) em {background-position:-656px 0;}
	.nameList ul li:nth-child(10) em {background-position:100% 0;}

	.nameList ul li .vote {top:7px; right:9px; width:60px; height:60px;}
	.nameList ul li .vote button {width:60px; height:60px;}
	.nameList ul li .vote strong {width:60px; margin-top:36px; font-size:15px;}
	.nameList ul li .vote button.on {background-position:0 -60px;}

	.noti ul {margin-top:16px;}
	.noti h3 {font-size:17px;}
	.noti ul li {margin-top:4px; font-size:13px;}
}

@media all and (min-width:600px){
	.take .itembox button {top:130px;}

	.noti h3 {font-size:20px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:6px; padding-left:15px; font-size:16px;}
	.noti ul li:after {top:9px;}
}

@media all and (min-width:768px){
	.take .itembox button {top:155px;}
}

@media all and (min-width:1024px){
	.take .itembox button {top:205px;}
}
</style>
<script type="text/javascript">
	function fnkakaosendcall()
	{
		var str = $.ajax({
			type: "GET",
			<% if isApp="1" then %>
				url: "/apps/appCom/wish/web2014/event/etc/doEventSubscript65841.asp",
			<% else %>
				url: "/event/etc/doEventSubscript65841.asp",
			<% end if %>
			data: "mode=kakao",
			dataType: "text",
			async: false
		}).responseText;
		if (str=="99")
		{
			<% if isApp="1" then %>
				parent.parent_kakaolink('[텐바이텐] 동숭동 제목학원\n\n들어는 보셨나요?\n재밌다고 소문난 제.목.학.원!\n\n지금 텐바이텐에\n제목학원이 열렸어요.\n\n참을 수 없는 당신의 센스를\n제목으로 기부하세요.\n\n오직 텐바이텐에서!' , 'http://webimage.10x10.co.kr/eventIMG/2015/65803/img_kakao.png' , '200' , '200' , 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%=eLinkCode%>' );
			<% else %>
				parent.parent_kakaolink('[텐바이텐] 동숭동 제목학원\n\n들어는 보셨나요?\n재밌다고 소문난 제.목.학.원!\n\n지금 텐바이텐에\n제목학원이 열렸어요.\n\n참을 수 없는 당신의 센스를\n제목으로 기부하세요.\n\n오직 텐바이텐에서!' , 'http://webimage.10x10.co.kr/eventIMG/2015/65803/img_kakao.png' , '200' , '200' , 'http://m.10x10.co.kr/event/eventmain.asp?eventid=<%=eLinkCode%>' );
			<% end if %>

		}
		else{
			alert('오류가 발생했습니다.');
			return false;
		}	
		return false;
	}


	function goDateChg(date)
	{
		<% if isApp="1" then %>
			document.location.href="/apps/appCom/wish/web2014/event/etc/iframe_65841.asp?Rdate="+date;
		<% else %>
			document.location.href="/event/etc/iframe_65841.asp?Rdate="+date;
		<% end if %>
		return false;
	}


	function gojemokComment(frm)
	{
		<% If vUserID = "" Then %>
			<% if isApp=1 then %>
				parent.calllogin();
				return false;
			<% else %>
				parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eLinkCode)%>');
				return false;
			<% end if %>
		<% End If %>

		if (frm.vTxt.value == '' || GetByteLength(frm.vTxt.value) > 30 || frm.vTxt.value == '최대 15자 이내로 입력해주세요'){
			alert("제목을 붙여주세요.\n15자 까지 작성 가능합니다.");
			frm.vTxt.value="";
			frm.vTxt.focus();
			return false;
		}


		$.ajax({
			type:"GET",
			<% if isApp="1" then %>
				url:"/apps/appCom/wish/web2014/event/etc/doEventSubscript65841.asp",
			<% else %>
				url:"/event/etc/doEventSubscript65841.asp",
			<% end if %>
	        data: $("#frmcomment").serialize(),
			dataType: "text",
			async:false,
			cache:true,
			success : function(Data, textStatus, jqXHR){
				if (jqXHR.readyState == 4) {
					if (jqXHR.status == 200) {
						if(Data!="") {
							var str;
							for(var i in Data)
							{
								 if(Data.hasOwnProperty(i))
								{
									str += Data[i];
								}
							}
							str = str.replace("undefined","");
							res = str.split("|");
							if (res[0]=="OK")
							{
								$("#lyBoxId").empty().html(res[1]);
								$(".dimmed").show();
								$("#lyBoxId").show();
								parent.window.$('html,body').animate({scrollTop:200}, 500);
							}
							else
							{
								errorMsg = res[1].replace(">?n", "\n");
								alert(errorMsg );
								parent.location.reload();
								return false;
							}
						} else {
							alert("잘못된 접근 입니다.");
							parent.location.reload();
							return false;
						}
					}
				}
			},
			error:function(jqXHR, textStatus, errorThrown){
				alert("잘못된 접근 입니다.");
				var str;
				for(var i in jqXHR)
				{
					 if(jqXHR.hasOwnProperty(i))
					{
						str += jqXHR[i];
					}
				}
				alert(str);
				parent.location.reload();
				return false;
			}
		});
	}

	function lyClose()
	{
		$(".lyBox").hide();
		$(".dimmed").fadeOut();
		parent.location.reload();
	}


	function jsCheckLimit(frm) {
		if ("<%=IsUserLoginOK%>"=="False") {
			<% if isApp=1 then %>
				parent.calllogin();
				return false;
			<% else %>
				parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eLinkCode)%>');
				return false;
			<% end if %>
		}

		if (frm.vTxt.value == '최대 15자 이내로 입력해주세요'){
			frm.vTxt.value = '';
		}

		if (frm.vTxt.value.length > 15)
		{
			alert("최대 15자 까지 작성 가능합니다.");
			frm.vTxt.value = frm.vTxt.value.substring(0,15); 
			return false;
		}
	}


	function getNameLadderList(ord, rdate)
	{
		$.ajax({
			type:"GET",
			<% if isApp="1" then %>
				url: "/apps/appCom/wish/web2014/event/etc/doEventSubscript65841.asp",
			<% else %>
				url: "/event/etc/doEventSubscript65841.asp",
			<% end if %>
			data: "mode=list&ord="+ord+"&rdate="+rdate,
			dataType: "text",
			async:false,
			cache:true,
			success : function(Data, textStatus, jqXHR){
				if (jqXHR.readyState == 4) {
					if (jqXHR.status == 200) {
						if(Data!="") {
							var str;
							for(var i in Data)
							{
								 if(Data.hasOwnProperty(i))
								{
									str += Data[i];
								}
							}
							str = str.replace("undefined","");
							res = str.split("|");
							if (res[0]=="OK")
							{
								$("#NameLadderList").empty().html(res[1]);			
							}
							else
							{
//								errorMsg = res[1].replace(">?n", "\n");
//								alert(errorMsg );
//								parent.location.reload();
//								return false;
							}
						} else {
							alert("잘못된 접근 입니다.");
							parent.location.reload();
							return false;
						}
					}
				}
			},
			error:function(jqXHR, textStatus, errorThrown){
				alert("잘못된 접근 입니다.");
				var str;
				for(var i in jqXHR)
				{
					 if(jqXHR.hasOwnProperty(i))
					{
						str += jqXHR[i];
					}
				}
				alert(str);
				parent.location.reload();
				return false;
			}
		});
	}


	function goVoteChk(comidx, rdate, mychk)
	{
<% If Not(TimeSerial(Hour(Now()), minute(Now()), second(Now())) >= TimeSerial(10, 00, 00) And TimeSerial(Hour(Now()), minute(Now()), second(Now())) < TimeSerial(17, 59, 59)) Then %>
	alert('오늘은 마감되었습니다');
	return false;
<% end if %>
		<% If vUserID = "" Then %>
			<% if isApp=1 then %>
				parent.calllogin();
				return false;
			<% else %>
				parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eLinkCode)%>');
				return false;
			<% end if %>
		<% End If %>

		$.ajax({
			type:"GET",
			<% if isApp="1" then %>
				url: "/apps/appCom/wish/web2014/event/etc/doEventSubscript65841.asp",
			<% else %>
				url: "/event/etc/doEventSubscript65841.asp",
			<% end if %>
			data: "mode=vote&comidx="+comidx+"&rdate="+rdate,
			dataType: "text",
			async:false,
			cache:true,
			success : function(Data, textStatus, jqXHR){
				if (jqXHR.readyState == 4) {
					if (jqXHR.status == 200) {
						if(Data!="") {
							var str;
							for(var i in Data)
							{
								 if(Data.hasOwnProperty(i))
								{
									str += Data[i];
								}
							}
							str = str.replace("undefined","");
							res = str.split("|");
							if (res[0]=="OK")
							{
								$("#btn"+res[1]).addClass("on");
								if ($("#vtcnt"+res[1]).html()=="+")
								{
									$("#vtcnt"+res[1]).empty().html("1");
								}
								else
								{
									var prvvtCnt = parseInt($("#vtcnt"+res[1]).html()) + 1
									$("#vtcnt"+res[1]).empty().html(prvvtCnt);
								}
								
								if (mychk == "1")
								{
									$("#mybtn"+res[1]).addClass("on");
									if ($("#myvtcnt"+res[1]).html()=="+")
									{
										$("#myvtcnt"+res[1]).empty().html("1");
									}
									else
									{
										var prvmyvtCnt = parseInt($("#myvtcnt"+res[1]).html()) + 1
										$("#myvtcnt"+res[1]).empty().html(prvmyvtCnt);
									}
								}
							}
							else
							{
								errorMsg = res[1].replace(">?n", "\n");
								alert(errorMsg );
								return false;
							}
						} else {
							alert("잘못된 접근 입니다.");
							parent.location.reload();
							return false;
						}
					}
				}
			},
			error:function(jqXHR, textStatus, errorThrown){
				alert("잘못된 접근 입니다.");
				var str;
				for(var i in jqXHR)
				{
					 if(jqXHR.hasOwnProperty(i))
					{
						str += jqXHR[i];
					}
				}
				alert(str);
				parent.location.reload();
				return false;
			}
		});
	}


	$(function(){
		<% if NowDate = ReceiveDate then %>
			getNameLadderList("dt", "<%=ReceiveDate%>");
		<% else %>
			getNameLadderList("vote", "<%=ReceiveDate%>");
		<% end if %>
	});



	function jemokmorePop()
	{
		<% if isApp="1" then %>
			parent.fnAPPpopupBrowserURL('동숭동 제목학원','<%=wwwURL%>/apps/appCom/wish/web2014/event/etc/65841_popup.asp?rDate=<%=ReceiveDate%>','','');return false;
		<% else %>
			parent.location.href='/event/etc/65841_popup.asp?rDate=<%=ReceiveDate%>'; return false;
		<% end if %>
	}
</script>

</head>
<body>

<div class="mEvt65803">
	<article>
		<h2>동승동 제목학원</h2>
		<section class="topic">
			<h3>정해진 답은 아무것도 없다! 동승동 제목학원</h3>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65803/txt_dongsung_dong_v1.png" alt="제목만 잘 지어도 투표를 통해 매일 10명에게  GIFT CARD 5만원권을 드려요!" /></p>
		</section>

		<section class="take">
			<h3>참여하기</h3>

			<%' for dev msg : tab %>
			<ul class="navigator">
				<li><a href="" onclick="goDateChg('2015-09-02');return false;" <% If ReceiveDate="2015-09-02" Then %>class="on"<% End If %>>9월 2일</a></li>
				<li><a href="" onclick="goDateChg('2015-09-03');return false;" <% If ReceiveDate="2015-09-03" Then %>class="on"<% End If %>>9월 3일</a></li>
				<li><a href="" onclick="goDateChg('2015-09-04');return false;" <% If ReceiveDate="2015-09-04" Then %>class="on"<% End If %>>9월 4일</a></li>
				<li><a href="" onclick="goDateChg('2015-09-05');return false;" <% If ReceiveDate="2015-09-05" Then %>class="on"<% End If %>>9월 5일</a></li>
				<li><a href="" onclick="goDateChg('2015-09-06');return false;" <% If ReceiveDate="2015-09-06" Then %>class="on"<% End If %>>9월 6일</a></li>
				<li><a href="" onclick="goDateChg('2015-09-07');return false;" <% If ReceiveDate="2015-09-07" Then %>class="on"<% End If %>>9월 7일</a></li>
				<li><a href="" onclick="goDateChg('2015-09-08');return false;" <% If ReceiveDate="2015-09-08" Then %>class="on"<% End If %>>9월 8일</a></li>
				<li><a href="" onclick="goDateChg('2015-09-09');return false;" <% If ReceiveDate="2015-09-09" Then %>class="on"<% End If %>>9월 9일</a></li>
				<li><a href="" onclick="goDateChg('2015-09-10');return false;" <% If ReceiveDate="2015-09-10" Then %>class="on"<% End If %>>9월 10일</a></li>
				<li><a href="" onclick="goDateChg('2015-09-11');return false;" <% If ReceiveDate="2015-09-11" Then %>class="on"<% End If %>>9월 11일</a></li>
			</ul>

			<div class="itembox">
				<%
					'// ReceiveDate값을 기준으로 전일, 다음일 값 계산한다.
					If dateadd("d", 1, ReceiveDate) > "2015-09-11" Then
						vNextDate = "alert('이벤트 마지막 날 입니다.');return false;"
					Else
						vNextDate = "goDateChg('"&dateadd("d", 1, ReceiveDate)&"');return false;"
					End If

					If dateadd("d", -1, ReceiveDate) < "2015-09-02" Then
						vPrevDate = "alert('이벤트 첫째 날 입니다.');return false;"
					Else
						vPrevDate = "goDateChg('"&dateadd("d", -1, ReceiveDate)&"');return false;"
					End If
				%>
				<button type="button" class="btnPrev" style="outline:none;" onclick="<%=vPrevDate%>"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65803/btn_prev.png" alt="이전" /></button>
				<button type="button" class="btnNext" style="outline:none;" onclick="<%=vNextDate%>"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65803/btn_next.png" alt="다음" /></button>



				<div class="item<%=vaddClass%>">
					<%' for dev msg : 날짜별 상품 %>
					<div class="figure">
						<%' for dev msg : 해당 일자에만 투데이 아이콘 노출해주세요 %>
						<% If Trim(NowDate) = Trim(ReceiveDate) Then %>
							<em class="today"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65803/ico_today.png" alt="TODAY" /></em>
						<% End If %>
						<%=vaddLink%>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/65803/img_item_<%=vMainImgName%>.png" alt="<%=vMainImgName%>" />
						<p class="deadline" style="margin-top:2%;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65803/txt_time.png" alt="금일부터 응모 및 투표는 6시에 마감됩니다." /></p>
					</div>

					<%' for dev msg : form %>
					<% If ReceiveDate = NowDate Or ReceiveDate > NowDate Then %>
						<div class="field">
							<form method="post" name="frmcomment" id="frmcomment">
								<input type="hidden" name="mode" value="comment">
								<input type="hidden" name="rDate" value="<%=ReceiveDate%>">
								<fieldset>
								<legend>제목 붙이기</legend>
								<%' 받은 날짜가 현재 날짜보다 크면 커밍순 %>
								<% If ReceiveDate > NowDate Then %>
									<p class="comming"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65803/txt_coming_soon_v1.png" alt="Coming Soon" /></p>
								<% Else %>
									<%' 받은 날짜가 현재 날짜와 같더라도 10시부터 18시 사이가 아니면 커밍순 표시 %>
									<% If Not(TimeSerial(Hour(Now()), minute(Now()), second(Now())) >= TimeSerial(10, 00, 00) And TimeSerial(Hour(Now()), minute(Now()), second(Now())) < TimeSerial(17, 59, 59)) Then %>
										<p class="closed"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65803/txt_closed.png" alt="오늘의 제목학원은 마감되었습니다." /></p>
									<% End If %>
								<% End If %>
								<div class="inner">
									<div class="itext"><input type="text" name="vTxt" title="제목 쓰기" value="최대 15자 이내로 입력해주세요" maxlength="15" onClick="jsCheckLimit(frmcomment);" onKeyUp="jsCheckLimit(frmcomment);" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> /></div>
									<div class="btnsubmit"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2015/65803/btn_submit_v1.png" alt="입력" onclick="gojemokComment(frmcomment);return false;" /></div>
								</div>
								</fieldset>
							</form>
						</div>
					<% End If %>

					<%' layer 제목 작성시 보여주세요 카카오톡 밑에 <div class="dimmed"></div> 같이 보여주세요 %>
					<div class="lyBox" id="lyBoxId"></div>

					<%' for dev msg : list %>
					<div class="namebox" id="NameLadderList"></div>

					<%' for dev msg : 내가 쓴 제목 %>
					<%
						sqlstr = " Select top 1 evtcom_idx, evt_code, userid, evtcom_txt, evtcom_regdate, evtcom_using, device, evtcom_point, "
						sqlstr = sqlstr & " (Select count(userid) From db_event.dbo.tbl_event_subscript Where evt_code = '"&eCode&"' And sub_opt2 = c.evtcom_idx And evtgroup_code='"&vJemokChasu&"' And userid='"&vUserID&"') as userchk "
						sqlstr = sqlstr & " From db_event.dbo.tbl_event_comment c Where evt_code='"&eCode&"' And evtgroup_code='"&vJemokChasu&"' And userid='"&vUserID&"' "
						rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
					%>
					<% If Not(rsget.bof Or rsget.eof) Then %>
					<div class="mine">
						<h4><img src="http://webimage.10x10.co.kr/eventIMG/2015/65803/tit_mine.png" alt="내가 쓴 제목" /></h4>
						<div class="nameList">
							<ul>
								<li>
									<strong class="name"><%=ReplaceBracket(db2html(rsget("evtcom_txt")))%></strong>
									<span class="id"><%=printUserId(rsget("userid"),2,"*")%></span>
									<div class="vote">
										<%' for dev msg : 내가 투표한것에는 클래스 on 붙여주세요 %>
										<% If ReceiveDate < NowDate Then %>
											<button type="button" style="cursor:default;outline:none;" <% If rsget("userchk") >= 1 Then %> class="on" <% End If %>>투표하기</button>
										<% Else %>
												<button type="button" id="mybtn<%=rsget("evtcom_idx")%>" style="outline:none;" <% If rsget("userchk") >= 1 Then %> class="on" <% End If %>>투표하기</button>
										<% End If %>
										<strong><span id="myvtcnt<%=rsget("evtcom_idx")%>"><% If rsget("evtcom_point") = 0 Then %>+<% Else %><%=rsget("evtcom_point")%><% End If %></span></strong>
									</div>
								</li>
							</ul>
						</div>
					</div>
					<% End If %>
					<% rsget.close() %>
				</div>

			
			</div>
		</section>


		<% If Trim(ReceiveDate) = Trim(NowDate) Then %>
			<section class="kakao">
				<h3>제목학원 친구랑 함께 등록하기</h3>
				<a href="" onclick="fnkakaosendcall();return false;" title="동숭동 제목학원 알려주기"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65803/btn_kakao_v1.png" alt="제목학원 친구랑 함께 등록하기 친구에게 이 놀라운 소식을 알려주고 제목학원에 함께 도전해 보세요!" /></a>
			</section>
		<% End If %>

		<section class="noti">
			<h3><strong>이벤트 안내</strong></h3>
			<ul>
				<li>텐바이텐 고객님을 위한 이벤트 입니다. 비회원이신 경우 회원가입 후 참여해 주세요.</li>
				<li>본 이벤트는 텐바이텐 모바일에서만 참여 가능합니다.</li>
				<li>투표는 한 ID당 1일 1회만 할 수 있습니다.</li>
				<li>금일부터 응모 및 투표는 6시에 마감됩니다.</li>
				<li>쿠폰은 한 ID당 1일 1회 발급, 1회 사용 할 수 있습니다.</li>
				<li>쿠폰 발급 및 사용은 당일 23시 59분 59초에 마감됩니다.</li>
				<li>입력 된 댓글은 수정 혹은 삭제가 불가능 합니다.</li>
				<li>동일한 투표수를 얻은 경우, 먼저 입력된 제목이 우선 순위로 지정됩니다.</li>
			</ul>
		</section>

		<div class="dimmed"></div>
	</article>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
