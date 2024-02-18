<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'#######################################################
'	History	: 2014.09.17 한용민 생성
'	Description : CS Center
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/cscenter/thanks10x10cls.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
dim oip, myoip, searchFlag, page, evt_type, listisusing, i

evt_type = "T"		'고마워텐텐 지정

	page = getNumeric(requestCheckVar(request("page"),5))
	searchFlag = requestCheckVar(request("sf"),2)
	if page = "" then page = 1
		
set oip = new cthanks10x10_list
	oip.FPageSize = 5
	oip.FCurrPage = page
	oip.FsearchFlag = searchFlag
	oip.fthanks10x10_list()

set myoip = new cthanks10x10_list
	myoip.FsearchFlag = "my"
	myoip.fthanks10x10_mylist()
%>
<script type="text/javascript">
	// 글짜수 제한 
	function reg(){
		if(frmcontents.contents.value =="로그인 후 글을 남길 수 있습니다."){
			parent.jsChklogin_mobile('','<%=Server.URLencode("/cscenter/thanks10x10.asp")%>');
				return false;
		}

		if (GetByteLength(frmcontents.contents.value) > 2000){
			alert("내용이 제한길이를 초과하였습니다. 1000자 까지 작성 가능합니다.");
			frmcontents.contents.focus();
		}else if(frmcontents.contents.value ==''){
			alert("격려의 메시지를 입력해주세요.");
			frmcontents.contents.focus();
		}else{
			jsEventSubmit();	
		}
	}

	function jsEventSubmit(){
		<% If IsUserLoginOK() Then %>
			var str = $.ajax({
				type: "POST",
				url: "/cscenter/lib/thanks10x10_process.asp",
				data: $("#frmcontents").serialize(),
				dataType: "text",
				async: false
			}).responseText;
			//alert(str1);
			var str1 = str.split("||")
			console.log(str);
			if (str1[0] == "01"){
				alert(str1[1]);
				return false;
			}else if (str1[0] == "02"){
				alert(str1[1]);
				return false;
			}else if (str1[0] == "03"){
				alert(str1[1]);
				return false;
			}else if (str1[0] == "04"){
				alert(str1[1]);
				location.reload();
				return false;
			}else{
				alert('오류가 발생했습니다.');
				return false;
			}
		<% Else %>
			<% if isApp=1 then %>
				parent.calllogin();
				return false;
			<% else %>
				parent.jsChklogin_mobile('','<%=Server.URLencode("/cscenter/thanks10x10.asp")%>');
				return false;
			<% end if %>
		<% End IF %>
	}

	// 고객글 삭제하기
	function delete_comment(idx){
		var ret;
		ret = confirm('해당 글을 삭제 하시겠습니까?');
		
		if (ret){
			document.frmcontents.target = 'view';
			document.frmcontents.idx.value = +idx
			document.frmcontents.submit();
		}
	}

	function TnGubunSelect(objval){
		document.frmcontents.gubun.value=objval;
	}

	// 클릭 확인
	function jsCheckLimit() {
		if ("<%=IsUserLoginOK%>"=="False") {
			parent.jsChklogin_mobile('','<%=Server.URLencode("/cscenter/thanks10x10.asp")%>');
			return false;
		}
	}
	
	function jsGoPage(iP){
		document.pageFrm.page.value = iP;
		document.pageFrm.submit();
	}

	$(function(){
		// 스크롤 확인
		$(window).scroll(function(){
			var linkurl;
			if($(window).scrollTop() >= ($(document).height()-$(window).height())-512) {
				//alert(linkurl);
				//추가 페이지 접수
				$.ajax({
					url: "act_thanks10x10.asp?page="+$("#page").val(),
					cache: false,
					async: false,
					success: function(message) {
						//alert(message);
						if(message!="") {
							$str = $(message)
							// 박스 내용 추가
							$('#listview').append($str);
							$("#page").val((Number($("#page").val())+1));
						}
					}
				});
			}
		});
	});

</script>
</head>
<body class="default-font">
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- contents -->
			<div id="content" class="content">
				<div class="thanks-wrap">
					<div class="thanks-head">
						<div>
							<div>
								<h2>Thank You.</h2>
								<p>기분 좋은 쇼핑하셨나요?<br />서비스에 만족하셨나요?<br />이벤트가 즐거우셨나요?</p>
							</div>
						</div>
					</div>
					<div class="thx-write-wrap">
						<form name="frmcontents" id="frmcontents" method="post" style="margin:0px;">
						<input type="hidden" name="idx">
						<input type="hidden" name="gubun" value="0">
						<input type="hidden" id="page" value="2">
						<fieldset>
							<legend class="hidden">코멘트 작성 폼</legend>
							<div class="thx-tag-wrap">
								<ul>
									<li class="selected"><button type="button" value="0" class="thx-tag thx-tag-black" onClick="TnGubunSelect(this.value);"><div>Best<br />Friend</div></button></li>
									<li><button type="button" value="1" class="thx-tag thx-tag-pink" onClick="TnGubunSelect(this.value);"><div>I Love<br />you</div></button></li>
									<li><button type="button" value="2" class="thx-tag thx-tag-blue" onClick="TnGubunSelect(this.value);"><div>Very<br />Good</div></button></li>
									<li><button type="button" value="3" class="thx-tag thx-tag-orange" onClick="TnGubunSelect(this.value);"><div>Always<br />Smile</div></button></li>
									<li><button type="button" value="4" class="thx-tag thx-tag-green" onClick="TnGubunSelect(this.value);"><div>Thank<br />you</div></button></li>
								</ul>
							</div>
							<div class="write">
								<textarea title="코멘트 작성" cols="40" rows="5" placeholder="여러분, 텐바이텐을 칭찬해주세요!" name="contents" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%>></textarea>
								<button type="button" onclick="reg()">등록하기</button>
							</div>
						</fieldset>
						</form>
						<ul class="noti">
							<li>여러분들이 보내주신 소중한 칭찬 글은 텐바이텐이 감사의 답변을 작성한 후 함께 게시됩니다.</li>
							<li>통신예절에 어긋나는 글이나 상업적인 글, 타 사이트에 관련된 글 또는 도용한 글은 관리자에 의해 사전 통보 없이 삭제될 수 있습니다.</li>
						</ul>
					</div>
					<% If myoip.FResultCount > 0 Then %>
					<div class="thx-list-wrap">
						<ul>
							<% For i = 0 To myoip.FResultCount -1 %>
							<li>
								<% If myoip.FItemList(i).fgubun="0" Then %>
								<div class="thx-tag thx-tag-black"><div>Best<br />Friend</div></div>
								<% ElseIf myoip.FItemList(i).fgubun="1" Then %>
								<div class="thx-tag thx-tag-pink"><div>I Love<br />you</div></div>
								<% ElseIf myoip.FItemList(i).fgubun="2" Then %>
								<div class="thx-tag thx-tag-blue"><div>Very<br />Good</div></div>
								<% ElseIf myoip.FItemList(i).fgubun="3" Then %>
								<div class="thx-tag thx-tag-orange"><div>Always<br />Smile</div></div>
								<% ElseIf myoip.FItemList(i).fgubun="4" Then %>
								<div class="thx-tag thx-tag-green"><div>Thank<br />you</div></div>
								<% end if %>
								<div class="thx-content-box">
									<div class="thx-cont"><%= nl2br(myoip.FItemList(i).fcontents) %></div>
									<p class="cont-info"><%= printUserId(myoip.FItemList(i).fuserid,2,"*") %> <span><%= FormatDate(myoip.FItemList(i).freg_date,"0000.00.00") %></span></p>
									<% if myoip.FItemList(i).fcomment <> "" then %>
									<div class="thx-answer">
										<%= nl2br(myoip.FItemList(i).fcomment) %>
									</div>
									<% end if %>
								</div>
							</li>
							<% Next %>
						</ul>
					</div>
					<% end if %>
					<% If oip.FResultCount > 0 Then %>
					<div class="thx-list-wrap">
						<ul id="listview">
							<% For i = 0 To oip.FResultCount -1 %>
							<li>
								<% If oip.FItemList(i).fgubun="0" Then %>
								<div class="thx-tag thx-tag-black"><div>Best<br />Friend</div></div>
								<% ElseIf oip.FItemList(i).fgubun="1" Then %>
								<div class="thx-tag thx-tag-pink"><div>I Love<br />you</div></div>
								<% ElseIf oip.FItemList(i).fgubun="2" Then %>
								<div class="thx-tag thx-tag-blue"><div>Very<br />Good</div></div>
								<% ElseIf oip.FItemList(i).fgubun="3" Then %>
								<div class="thx-tag thx-tag-orange"><div>Always<br />Smile</div></div>
								<% ElseIf oip.FItemList(i).fgubun="4" Then %>
								<div class="thx-tag thx-tag-green"><div>Thank<br />you</div></div>
								<% end if %>
								<div class="thx-content-box">
									<div class="thx-cont"><%= nl2br(oip.FItemList(i).fcontents) %></div>
									<p class="cont-info"><%= printUserId(oip.FItemList(i).fuserid,2,"*") %> <span><%= FormatDate(oip.FItemList(i).freg_date,"0000.00.00") %></span></p>
									<% if oip.FItemList(i).fcomment <> "" then %>
									<div class="thx-answer">
										<%= nl2br(oip.FItemList(i).fcomment) %>
									</div>
									<% end if %>
								</div>
							</li>
							<% Next %>
						</ul>
					</div>
					<% end if %>
				</div>
			</div>
			<!-- //contents -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
<script type="text/javascript">
	$(function(){
		$('.thx-tag-wrap button').click(function(){
			$('.thx-tag-wrap li').removeClass('selected');
			$(this).parent('li').addClass('selected');
		});
	});
</script>
</body>
</html>
<%
Set oip = Nothing
Set myoip = Nothing
%>	
<!-- #include virtual="/lib/db/dbclose.asp" -->