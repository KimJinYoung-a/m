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
' Description : 동숭동 제목학원(모바일 팝업)
' History : 2015.08.31 원승현 생성
'####################################################
	Dim vUserID, eCode, eLinkCode, sqlstr, pagesize, currpage, vLstevtcomIdx, vJemokChasu
	Dim strSql, ReceiveDate, NowDate, vMainImgName, vPrevDate, vNextDate, vaddClass, vaddLink

	PageSize = getNumeric(requestCheckVar(request("psz"),9))
	CurrPage = getNumeric(requestCheckVar(request("cpg"),9))

	vUserID = GetEncLoginUserID
	ReceiveDate = requestcheckvar(request("Rdate"),32)

	NowDate = left(now(), 10)


	IF application("Svr_Info") = "Dev" THEN
		eCode = "64871"
		eLinkCode = "64872"
	Else
		eCode = "65841"
		eLinkCode = "65841"
	End If

	If ReceiveDate <> NowDate Then
		If isApp = "1" Then
			Response.write "<script>parent.fnAPPclosePopup();Return false;</script>"
		Else
			Response.write "<script>parent.location.href='/event/eventmain.asp?eventid="&eLinkCode&"'</script>"
			Response.End
		End If
	End If

	If Trim(PageSize) = "" Or Len(Trim(PageSize))=0 Then
		PageSize="15"
	End If

	If Trim(CurrPage)="" Or Len(Trim(CurrPage))=0 Then
		CurrPage = "0"
	End If

	Select Case Trim(ReceiveDate)
		Case "2015-09-02"
			vJemokChasu = 1

		Case "2015-09-03"
			vJemokChasu = 2

		Case "2015-09-04"
			vJemokChasu = 3

		Case "2015-09-05"
			vJemokChasu = 4

		Case "2015-09-06"
			vJemokChasu = 5

		Case "2015-09-07"
			vJemokChasu = 6

		Case "2015-09-08"
			vJemokChasu = 7

		Case "2015-09-09"
			vJemokChasu = 8

		Case "2015-09-10"
			vJemokChasu = 9

		Case "2015-09-11"
			vJemokChasu = 10

		Case Else
			vJemokChasu = 1

	End Select


	sqlstr = " Select top 1 evtcom_idx  From db_event.dbo.tbl_event_comment Where evt_code = '"&eCode&"' And evtgroup_code='"&vJemokChasu&"' order by evtcom_idx desc "
	rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
	If Not(rsget.bof Or rsget.eof) Then
		vLstevtcomIdx = rsget("evtcom_idx")
	Else
		vLstevtcomIdx = "0"
	End If
	rsget.close()


%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.popWin .content {padding-top:0;}
.nameList {margin-top:10%; padding-bottom:5%;}
.nameList ul {width:290px; margin:0 auto;}
.nameList ul li {position:relative; height:50px; margin-bottom:5%; padding-left:61px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/65803/bg_box.png) no-repeat 50% 0; background-size:100% auto;}
.nameList ul li .name, .nameList ul li .id {display:block;}
.nameList ul li .name {padding-top:10px; color:#000; font-family:helveticaNeue, helvetica, sans-serif !important; font-size:13px; text-indent:-0.05em;}
.nameList ul li .id {margin-top:5px; color:#555; font-size:10px;}
.nameList ul li .vote {position:absolute; top:5px; right:6px; width:40px; height:40px;}
.nameList ul li .vote button {position:absolute; top:0; left:0; width:40px; height:40px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/65803/btn_heart.png) no-repeat 50% 0; background-size:100% auto; text-indent:-999em;}
.nameList ul li .vote button.on {background-position:0 -40px;}
.nameList ul li .vote strong {position:absolute; top:0; left:0; width:40px; margin-top:24px; color:#fff; font-size:10px; line-height:1.25em; text-align:center;}

@media all and (min-width:480px){
	.nameList ul {width:435px;}
	.nameList ul li {height:75px; padding-left:93px;}
	.nameList ul li .name {padding-top:17px; font-size:19px;}
	.nameList ul li .id {font-size:15px;}
	.nameList ul li .vote {top:7px; right:9px; width:60px; height:60px;}
	.nameList ul li .vote button {width:60px; height:60px;}
	.nameList ul li .vote strong {width:60px; margin-top:36px; font-size:15px;}
	.nameList ul li .vote button.on {background-position:0 -60px;}
}
</style>
<script>
	function goVoteChk(comidx, rdate, mychk)
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

	var isloading=true;

	$(function() {
		getjemokList();

		//스크롤 이벤트 시작
		$(window).scroll(function() {
//			alert($(window).scrollTop());
//			alert($(document).height() - $(window).height() - 400);
		  if ($(window).scrollTop() >= $(document).height() - $(window).height() - 400){
	          if (isloading==false){
	            isloading=true;
				var pg = $("#popularfrm input[name='cpg']").val();
				pg++;
				$("#popularfrm input[name='cpg']").val(pg);
				setTimeout("getjemokList()",50);
			  }
		  }
		});
	});

	function getjemokList() {

		var str=$.ajax({
			type:"GET",
			url:"/event/etc/doEventSubScript65841.asp",
			data:$("#popularfrm").serialize(),
			dataType:"text",
			async:false
		}).responseText;

		if(str!="") {
			if($("#popularfrm input[name='cpg']").val()=="0") {
				//내용 넣기
				$('#incjemokListValue').html(str);
			} else {
				$('#incjemokListValue').append(str);
			}
			isloading=false;
		} else {
			$(window).unbind("scroll");
		}
	}

</script>
</head>
<body class="bgGry">
<form id="popularfrm" name="popularfrm" method="get" style="margin:0px;">
	<input type="hidden" name="cpg" id="cpg" value="<%=CurrPage%>" />
	<input type="hidden" name="psz" id="psz" value="<%=PageSize%>">
	<input type="hidden" name="rDate" id="rDate" value="<%=ReceiveDate%>" />
	<input type="hidden" name="mode" id="mode" value="popupList" />
	<input type="hidden" name="vLstevtcomIdx" id="vLstevtcomIdx" value="<%=vLstevtcomIdx%>" />
</form>
<div class="heightGrid bgGry">
	<div class="container popWin">
	<% If isApp="1" Then %>

	<% Else %>
		<div class="header">
			<h1>동숭동 제목학원</h1>
			<p class="btnPopClose"><button type="button" class="pButton" onclick="parent.location.href='/event/eventmain.asp?eventid=<%=eLinkCode%>';">닫기</button></p>
		</div>
	<% End If %>
		<!-- content area -->
		<div class="content" id="contentArea">
			<p>&nbsp;</p>
			<p>&nbsp;</p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65803/txt_dongsung_dong_popop.png" alt="정해진 답은 아무것도 없다! 동숭동 제목학원" /></p>
			<div class="nameList">
				<ul id="incjemokListValue">
					<%' for dev msg : <li>...</li>는 15개까지 노출해주세요 %>

				</ul>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->