<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  러브하우스
' History : 2015.09.17 유태욱
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->	
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/contest/classes/contestCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event66174Cls.asp" -->
<%
Dim vGubun, i, evt_code
dim myidx, mydiv, myimgFile2, myimgFile3, myimgFile4, myimgFile5, myopt, myimgContent

g_Contest = CStr(requestCheckVar(request("g_Contest"),10))

IF application("Svr_Info") = "Dev" THEN
	evt_code   =  64888
Else
	evt_code   =  66174
End If

IF application("Svr_Info") = "Dev" THEN
	g_Contest = "con56"
Else
	g_Contest = "con62"
End If

if g_Contest="" then
	Response.Write "<script language='javascript'>"
	Response.Write "	alert('정상적인 페이지가 아닙니다.');"
	Response.Write "</script>"
	dbget.close()	:	Response.End
end if

Dim clsContest, vEntrySDate, vEntryEDate

Set clsContest = New cContest
	clsContest.FContest = g_Contest
	clsContest.FContestChk
	
	if clsContest.FTotalCount > 0 then
		vEntrySDate = clsContest.FOneItem.fentry_sdate
		vEntryEDate = clsContest.FOneItem.fentry_edate
	else
		Response.Write "<script language='javascript'>"
		Response.Write "	alert('해당되는 공모전이 없습니다.');"

		Response.Write "</script>"
		dbget.close()	:	Response.End
	end if

dim vPageSize, vPage, vArrList, vTotalCount, vTotalPage, iCPerCnt, vIsPaging
	vPage = getNumeric(requestCheckVar(Request("page"),5))
	If vPage = "" Then vPage = 1 End If

	vIsPaging = requestCheckVar(Request("paging"),1)
	vPageSize = 3
	iCPerCnt = 10
dim C66174
set C66174 = new Cevent66174_list
	C66174.FPageSize = vPageSize
	C66174.FCurrPage = vPage
	C66174.FRectEventID = evt_code
	C66174.FRectUserid = userid
	C66174.fnEvent_66174_List
	vTotalCount = C66174.FTotalCount

	sqlstr = "select top 1 idx, div, imgFile2, imgFile3, imgFile4, imgFile5, opt, imgContent "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_contest_entry]"
	sqlstr = sqlstr & " where userid='"& userid &"' And div='"&g_Contest&"' "
	sqlstr = sqlstr & " order by idx desc "
	rsget.Open sqlstr, dbget, 1

	If Not rsget.Eof Then
		myidx = rsget(0)
		mydiv = rsget(1)
		myimgFile2 = rsget(2)
		myimgFile3 = rsget(3)
		myimgFile4 = rsget(4)
		myimgFile5 = rsget(5)
		myopt = rsget(6)
		myimgContent = rsget(7)
	End IF
	rsget.close

Dim vImgURL
vImgURL = staticImgUrl & "/contents/contest/" 
%>
<style type="text/css">
img {vertical-align:top;}
.applyForm {padding:0 7.8% 100px; margin-bottom:-50px; background:#f2f4f4;}
.applyForm .houseStory {padding-bottom:6.5%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/66174/m/bg_line.gif) 0 100% repeat-x; background-size:100% 1px;}
.applyForm .houseStory textarea {width:100%; border:2px solid #ddd;}
.applyForm .houseInfo {padding-top:8.5%;}
.applyForm select {width:100%; border:2px solid #ddd; border-radius:0; background-image:none;}
.applyForm input[type=text],.applyForm input[type=file] {width:100%; height:36px; border:2px solid #ddd; border-radius:0; background:#fff;}
.applyForm input[type=file] {padding:5px;}
.applyForm .upload {width:100%; margin-top:4%;}
.applyForm dd {padding:0 9.2% 7%; text-align:center;}
.applyForm .agree {position:relative; padding:5% 0 5.5%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/66174/m/bg_line.gif) 0 0 repeat-x,url(http://webimage.10x10.co.kr/eventIMG/2015/66174/m/bg_line.gif) 0 100% repeat-x; background-size:100% 1px;}
.applyForm .agree input {position:absolute; left:0; top:30%;}
@media all and (min-width:480px){
	.applyForm input[type=text],.applyForm input[type=file] {height:54px;}
	.applyForm input[type=file] {padding:15px; font-size:17px; line-height:10px;}
}
</style>
<script type="text/javascript">
function jsGoPage(a) {
	frmGubun2.page.value = a;
	frmGubun2.submit();
}

$(function(){
	<% If IsUserLoginOK() Then %>
		<% if myimgFile2 <> "" then %>
			document.frmApply.myArea.value="<%= myimgFile2 %>";
		<% end if %>
		<% if myimgContent <> "" then %>
			document.frmApply.imgContent.value="<%= myimgContent %>";
		<% end if %>
		$("#selage option[value=" + <%= myopt %> + "]").attr("selected","selected");
		$("#selwedding option[value=" + <%= myimgFile3 %> + "]").attr("selected","selected");
		$("#selpyongsu option[value=" + <%= myimgFile4 %> + "]").attr("selected","selected");
		$("#selhome option[value=" + <%= myimgFile5 %> + "]").attr("selected","selected");
	<% end if %>
});

function frmSubmit() {
	<% If IsUserLoginOK() Then %>
		<% If Now() > #10/04/2015 23:59:59# Then %>
			alert("응모가 마감되었습니다.");
			return;
		<% Else %>
			<% if usercnt < 1 then %>
				var frm = document.frmApply;

				if (frm.myArea.value == '' || frm.myArea.value == 'ex) 서울시 종로구'){
					alert("사는 지역(시/구)을 입력해 주세요.");
					frm.myArea.focus();
					return;
				}

				if (frm.imgContent.value == '' || frm.imgContent.value == '최대 200자 이내로 작성 해 주세요'){
					alert("나의 워너비 신혼집을 입력해 주세요.");
					frm.imgContent.focus();
					return;
				}
				if(GetByteLength(frm.imgContent.value)>400){
					alert('최대 한글 200자 까지 입력 가능합니다.');
					frm.imgContent.focus();
					return false;
				}

				<% if isapp then %>
				<% else %>
				//* 파일확장자 체크
				for(var ii=1; ii<2; ii++)
				{
					var frmname		 = eval("frm.imgfile"+ii+"");
			
					if(frmname.value != "")
					{
						var sarry        = frmname.value.split("\\");      // 선택된 이미지 화일의 풀 경로
						var maxlength    = sarry.length-1;       // 이미지 화일 풀 경로에서 이미지만 뽑아내기
						var ext = sarry[maxlength].split(".");
			
						if(ext[1].toLowerCase() == "jpg" || ext[1].toLowerCase() == "png"){
							
						}else{
							alert('jpg나 png파일만 업로드가 가능합니다.');
							return;
						} 
					}
				}
				<% end if %>
				if(!document.getElementById('agr').checked) {
					alert("개인정보 취급방침에 동의하셔야만 지원이 가능합니다");
					return;
				}
				frm.mode.value = 'addreg';
				frm.submit();
		   	<% else %>
				alert("한번만 응모 가능 합니다.");
				return;
			<% end if %>
		<% End if %>
	<% Else %>
		<% If isapp="1" Then %>
			parent.calllogin();
			return;
		<% else %>
			parent.jsevtlogin();
			return;
		<% End If %>
	<% End IF %>
}

function frmSubmitedit(idx) {
	<% If IsUserLoginOK() Then %>
		<% If Now() > #10/04/2015 23:59:59# Then %>
			alert("응모가 마감되었습니다.");
			return;
		<% Else %>
			var frm = document.frmApply;

			if (frm.myArea.value == '' || frm.myArea.value == 'ex) 서울시 종로구'){
				alert("사는 지역(시/구)을 입력해 주세요.");
				frm.myArea.focus();
				return;
			}

			if (frm.imgContent.value == '' || frm.imgContent.value == '최대 200자 이내로 작성 해 주세요'){
				alert("나의 워너비 신혼집을 입력해 주세요.");
				frm.imgContent.focus();
				return;
			}
			if(GetByteLength(frm.imgContent.value)>400){
				alert('최대 한글 200자 까지 입력 가능합니다.');
			frm.imgContent.focus();
			return false;
			}
			<% if isapp then %>
			<% else %>
				//* 파일확장자 체크
				for(var ii=1; ii<2; ii++)
				{
					var frmname		 = eval("frm.imgfile"+ii+"");
			
					if(frmname.value != "")
					{
						var sarry        = frmname.value.split("\\");      // 선택된 이미지 화일의 풀 경로
						var maxlength    = sarry.length-1;       // 이미지 화일 풀 경로에서 이미지만 뽑아내기
						var ext = sarry[maxlength].split(".");
			
						if(ext[1].toLowerCase() == "jpg" || ext[1].toLowerCase() == "png"){
							
						}else{
							alert('jpg나 png파일만 업로드가 가능합니다.');
							return;
						}

					}
				}
			<% end if %>
			if(!document.getElementById('agr').checked) {
				alert("개인정보 취급방침에 동의하셔야만 지원이 가능합니다");
				return;
			}
				frm.idx.value = idx;
				frm.mode.value = 'edit';
			frm.submit();
		<% End if %>
	<% Else %>
		<% If isapp="1" Then %>
			parent.calllogin();
			return;
		<% else %>
			parent.jsevtlogin();
			return;
		<% End If %>
	<% End IF %>
}

function jseditComment(idx)	{
	<% If IsUserLoginOK() Then %>
		<% If Now() > #10/04/2015 23:59:59# Then %>
			//alert("공모전이 종료되었습니다.");
			alert("응모가 마감되었습니다.");
			return;
		<% Else %>
			var frm = document.frmApply;

			if (frm.myArea.value == '' || frm.myArea.value == 'ex) 서울시 종로구'){
				alert("사는 지역(시/구)을 입력해 주세요.");
				frm.myArea.focus();
				return;
			}

			if (frm.imgContent.value == '' || frm.imgContent.value == '최대 200자 이내로 작성 해 주세요'){
				alert("나의 워너비 신혼집을 입력해 주세요.");
				frm.imgContent.focus();
				return;
			}

			if(GetByteLength(frm.imgContent.value)>400){
				alert('최대 한글 200자 까지 입력 가능합니다.');
			frm.imgContent.focus();
			return false;
			}

			if(!document.getElementById('agr').checked) {
				alert("개인정보 취급방침에 동의하셔야만 지원이 가능합니다");
				return;
			}
			document.frmdelcom.age.value = frm.age.value;
			document.frmdelcom.myArea.value = frm.myArea.value;
			document.frmdelcom.wedding.value = frm.wedding.value;
			document.frmdelcom.pyongsu.value = frm.pyongsu.value;
			document.frmdelcom.home.value = frm.home.value;
			document.frmdelcom.imgContent.value = frm.imgContent.value;
			
			document.frmdelcom.mode.value = 'edit';
			document.frmdelcom.idx.value = idx;
	   		document.frmdelcom.submit();
		<% End if %>
	<% Else %>
		<% If isapp="1" Then %>
			parent.calllogin();
			return;
		<% else %>
			parent.jsevtlogin();
			return;
		<% End If %>
	<% End IF %>
}

function jsDelComment(idx)	{
	if(confirm("삭제하시겠습니까?")){
		document.frmdelcom.mode.value = 'del';
		document.frmdelcom.idx.value = idx;
   		document.frmdelcom.submit();
	}
}

function loginchk()	{
	<% If Now() > #10/04/2015 23:59:59# Then %>
		alert("이벤트가 종료되었습니다.");
		return;
	<% Else %>
		<% If isapp="1" Then %>
			parent.calllogin();
			return;
		<% else %>
			parent.jsevtlogin();
			return;
		<% End If %>
	<% End if %>
}

function jsCheckLimit(ta) {
	if ("<%=IsUserLoginOK%>"=="False") {
		jsChklogin('<%=IsUserLoginOK%>');
	}

	if (ta=="ta1") {
		if(frmApply.imgContent.value == "최대 200자 이내로 작성 해 주세요"){
			frmApply.imgContent.value ="";
		}
	}else{
		if(frmApply.myArea.value == "ex) 서울시 종로구"){
			frmApply.myArea.value ="";
		}
	}
}
</script>
	<!-- 2015웨딩기획전 : 러브하우스 -->
	<div class="mEvt66174">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/66174/m/tit_love_house_apply.gif" alt="러브하우스" /></h2>
		<!-- 신청서 작성 -->
		<div class="applyForm">
		<form name="frmApply" method="POST" action="<%=staticImgUrl%>/linkweb/enjoy/66174_Contest_upload.asp" onsubmit="return false" enctype="multipart/form-data">
		<input type="hidden" name="div" value="<%=g_Contest %>">
		<input type="hidden" name="idx" value="">
		<input type="hidden" name="mode" value="">
		<input type="hidden" name="optText" value="M">
		<input type="hidden" name="userid" value="<%=userid %>">
		<input type="hidden" name="isapp" value="<%=isApp %>">
			<div class="houseStory">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/66174/m/tit_my_wannabe.gif" alt="나의 워너비 신혼집은?(공개용)" /></h5>
				<textarea name="imgContent" maxlength="200" onClick="jsCheckLimit('ta1');" onKeyUp="jsCheckLimit('ta1');" ><% IF NOT(IsUserLoginOK) THEN %>로그인 후 글을 남길 수 있습니다.<% else %>최대 200자 이내로 작성 해 주세요<% END IF %></textarea>
			</div>
			<div class="houseInfo">
				<h4><img src="http://webimage.10x10.co.kr/eventIMG/2015/66174/m/tit_house_info.gif" alt="러브하우스 상세정보(비공개용)" /></h4>
				<dl class="tPad0">
					<dt><img src="http://webimage.10x10.co.kr/eventIMG/2015/66174/m/tit_age.gif" alt="나이" /></dt>
					<dd>
						<select name="age" id="selage" style="text-align:center;">
							<option value="1" >24세 미만</option>
							<option value="2" >25세~32세</option>
							<option value="3" >33세~40세</option>
							<option value="4" >40세 이상</option>
						</select>
					</dd>
				</dl>
				<dl>
					<dt><img src="http://webimage.10x10.co.kr/eventIMG/2015/66174/m/tit_area.gif" alt="지역(시/구 까지)" /></dt>
					<dd><input type="text" name="myArea" onClick="jsCheckLimit('ta2');" onKeyUp="jsCheckLimit('ta2');" <% IF NOT(IsUserLoginOK) THEN %>value="로그인 후 글을 남길 수 있습니다."<% else %>value="ex) 서울시 종로구"<% END IF %>/></dd>
				</dl>
				<dl>
					<dt><img src="http://webimage.10x10.co.kr/eventIMG/2015/66174/m/tit_time.gif" alt="결혼시기" /></dt>
					<dd>
						<select name="wedding" id="selwedding">
							<option value="1">결혼 예정</option>
							<option value="2">신혼(3년이내)</option>
							<option value="3">마음만은 신혼(3년 이상)</option>
						</select>
					</dd>
				</dl>
				<dl>
					<dt><img src="http://webimage.10x10.co.kr/eventIMG/2015/66174/m/tit_size.gif" alt="집 평수" /></dt>
					<dd>
						<select name="pyongsu" id="selpyongsu">
							<option value="1">10~15평</option>
							<option value="2">15~20평</option>
							<option value="3">21~30평</option>
							<option value="4">30평 이상</option>
						</select>
					</dd>
				</dl>
				<dl>
					<dt><img src="http://webimage.10x10.co.kr/eventIMG/2015/66174/m/tit_type.gif" alt="집 형태" /></dt>
					<dd>
						<select name="home" id="selhome">
							<option value="1">원룸</option>
							<option value="2">오피스텔</option>
							<option value="3">빌라</option>
							<option value="4">아파트</option>
							<option value="5">주택</option>
						</select>
					</dd>
				</dl>
				<% if isapp then %>
					<dl>
						<dt><img src="http://webimage.10x10.co.kr/eventIMG/2015/66174/m/tit_photo.gif" alt="여러분의 신혼집을 찍어서 올려주세요(선택사항/최대 10mb,jpg파일)" /></dt>
						<dd>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66174/m/txt_app_noti.gif" alt="이미지 업로드를 원하시는 분은 모바일웹이나 PC를 이용해주세요" /></p>
						</dd>
					</dl>
				<% else %>
					<dl>
						<dt><img src="http://webimage.10x10.co.kr/eventIMG/2015/66174/m/tit_photo.gif" alt="여러분의 신혼집을 찍어서 올려주세요(선택사항/최대 10mb,jpg파일)" /></dt>
						<dd>
							<input type="file" id="imgfile1" name="imgfile1" />
							<!--
							<input type="image" name="imgfile1" class="upload" src="http://webimage.10x10.co.kr/eventIMG/2015/66174/m/btn_upload.gif" alt="업로드" />
							-->
						</dd>
					</dl>
				<% end if %>
			</div>
			<p class="agree"><input type="checkbox" class="check rMar05" id="agr" name="ch"/> <label for="agr"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66174/m/txt_agree.gif" alt="본 이벤트 참여를 위한 개인정보 취급방침에 동의합니다" /><label></p>
			<p class="confirm"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66174/m/txt_confirm.gif" alt="꼭 상단의 공지사항을 확인 후 응모 부탁드립니다" /></p>
			<% if usercnt < 1 then %>
				<button class="btnSubmit" onclick="frmSubmit(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66174/m/btn_submit.gif" alt="제출하기" /></button>
			<% else %>
				<button class="btnSubmit" onclick="frmSubmitedit('<%=C66174.FItemList(i).Fidx %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66174/m/btn_modify.gif" alt="수정하기" /></button>
			<% end if %>
		</form>
		</div>
		<!--// 신청서 작성 -->
	</div>
	<!-- 2015웨딩기획전 : 러브하우스 -->
<form name="frmdelcom" method="post" action="/event/etc/doEventSubscript66174.asp" style="margin:0px;">
<input type="hidden" name="div" value="<%=g_Contest%>">
<input type="hidden" name="idx" value=""> 
<input type="hidden" name="ecode" value="<%=evt_code%>">
<input type="hidden" name="mode" value="">
<input type="hidden" name="age" value="">
<input type="hidden" name="myArea" value="">
<input type="hidden" name="wedding" value="">
<input type="hidden" name="pyongsu" value="">
<input type="hidden" name="home" value="">
<input type="hidden" name="isapp" value="<%=isApp %>">
<input type="hidden" name="userid" value="<%= userid %>">
<input type="hidden" name="imgContent" value="">
</form>
<form name="frmGubun2" method="post" action="#cmtListList" style="margin:0px;">
<input type="hidden" name="page" value="<%=vPage%>">
<input type="hidden" name="paging" value="o">
</form>	
<% set C66174=nothing %>
<% Set clsContest = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->