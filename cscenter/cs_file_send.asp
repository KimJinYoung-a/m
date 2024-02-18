<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 고객센터 파일전송
' History : 2019.11.26 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/classes/cscenter/customer_file_cls.asp" -->

<%
dim certno, i, ccsfile, userhp, dbCertNo, authidx, SmsYN, KakaoTalkYN, regdate, confirmcertno, status, comment
	authidx = requestcheckvar(getNumeric(request("nb")),10)
	certno = requestcheckvar(request("certNo"),40)

if authidx="" or isnull(authidx) or certno="" or isnull(certno) then
	response.write "<script type='text/javascript'>"
	response.write "	alert('정상적인 인증 경로가 아닙니다[0].');"
	response.write "</script>"
	dbget.close()	:	response.End
end if

' 인증코드 & 주문내역 조회
set ccsfile = new ccsfilelist
	ccsfile.frectauthidx = authidx
	ccsfile.getcsfile_one()

if ccsfile.ftotalcount < 1 then
	response.write "<script type='text/javascript'>"
	response.write "	alert('파일전송이 신청되지 않았습니다.');"
	response.write "</script>"
	dbget.close()	:	response.End
end if

userhp = ccsfile.FOneItem.fuserhp
dbCertNo = ccsfile.FOneItem.fcertno
authidx = ccsfile.FOneItem.fauthidx
SmsYN = ccsfile.FOneItem.fSmsYN
KakaoTalkYN = ccsfile.FOneItem.fKakaoTalkYN
regdate = ccsfile.FOneItem.fregdate
status = ccsfile.FOneItem.fstatus
comment = ccsfile.FOneItem.fcomment

if trim(status) <> "0" then
	response.write "<script type='text/javascript'>"
	response.write "	alert('이미 파일이 전송되었습니다.');"
	response.write "</script>"
	dbget.close()	:	response.End
end if
if datediff("d",regdate,date()) > 7 then
	response.write "<script type='text/javascript'>"
	response.write "	alert('파일전송 요청후 7일이후에는 조회가 불가능 합니다.');"
	response.write "</script>"
	dbget.close()	:	response.End
end if

confirmcertno = md5(trim(authidx) & trim(dbCertNo) & replace(trim(userhp),"-",""))
'response.write certNo & "<Br>"
'response.write confirmcertno & "<Br>"

if trim(certno) <> trim(confirmcertno) then
	response.write "<script type='text/javascript'>"
	response.write "	alert('인증된 코드값이 아닙니다.');"
	response.write "</script>"
	dbget.close()	:	response.End
end if

%>

<style>
.addImage.mar0 {background:none}
.txtOutput {min-height:36px; padding:12px 10px 0; font-size:13px; color:#888;}
.myOrderView .cartGroup .pdtWrap .pdtCont {min-height:7.51rem;}
.myOrderView .cartGroup div.pdtWrap div.pdtCont {padding-bottom:0;}
@media all and (min-width:480px){
	.txtOutput {min-height:54px; padding:18px 10px 0; font-size:20px;}
}
</style>
<script type="text/javascript">

// 폼전송
function frmsubmit(){
	frminfo.action = "/cscenter/cs_file_process.asp"
	<% 'frminfo.action = uploadImgUrl/linkweb/cscenter/cs_filesend_upload.asp'; %>
	frminfo.submit();
}

function delimage(ifile){
	document.getElementById(ifile).value = "";
}

function regfile(fileno){
    if (fileno==""){
        return;    
    }
    fnOpenModal("/cscenter/cs_fileup.asp?filegubun=R1&fileno="+fileno);
}

function delimage(ifile,ifileurl){
    $("#"+ifile).val("");
    $("#"+ifileurl).html("");
    $("#"+ifileurl).hide();
}

</script>
</head>
</head>
<body class="default-font body-popup">
	<header class="tenten-header header-popup">
		<div class="title-wrap">
			<h1>[텐바이텐] 파일전송</h1>
			<% '<button type="button" class="btn-close" onclick="">닫기</button> %>
		</div>
	</header>

	<!-- contents -->
	<div id="content" class="content">
		<form name="frminfo" method="post" style="margin:0px;">
		<input type="hidden" name="mode" value="fileedit">
		<input type="hidden" name="authidx" value="<%= authidx %>">
		<input type="hidden" name="certno" value="<%= certno %>">

		<div class="userInfo userInfoEidt inner10">
			<fieldset>
			<legend>고객 정보</legend>
				<dl class="infoInput">
					<dt><label for="receiver">휴대폰번호</label></dt>
					<dd><div class="txtOutput default-font"><%= userhp %></div></dd>
				</dl>
				<dl class="infoInput">
					<dt><label for="notication">문의내용</label></dt>
					<dd><textarea name="comment" class="w100p tMar10" cols="30" rows="3" title="문의내용 작성" placeholder=""><%= comment %></textarea></dd>
				</dl>
				<dl class="infoInput">
					<dt><label>첨부파일</label></dt>
					<dd>
						<div class="txtOutput default-font">파일이 많은경우 압축(ZIP)해서 등록해 주세요.<br>첨부파일당 최대 5MB까지만 허용됩니다.</div>
						<div class="addImage mar0">
							<p>
								<span class="button btS1 btWht cBk1"><a href="#" onClick="regfile('1'); return false;">파일선택</a></span>
								<input type="hidden" id="sfile1" name="sfile1" value="">
								<span class="inp" id="fileurl1" style="display:none;"></span>
								<button class="btnDel" onClick="delimage('sfile1','fileurl1');return false;">파일 삭제</button>
							</p>
						</div>
						<div class="addImage mar0">
							<p>
								<span class="button btS1 btWht cBk1"><a href="#" onClick="regfile('2'); return false;">파일선택</a></span>
								<input type="hidden" id="sfile2" name="sfile2" value="">
								<span class="inp" id="fileurl2" style="display:none;"></span>
								<button class="btnDel" onClick="delimage('sfile2','fileurl2');return false;">파일 삭제</button>
							</p>
						</div>
						<div class="addImage mar0">
							<p>
								<span class="button btS1 btWht cBk1"><a href="#" onClick="regfile('3'); return false;">파일선택</a></span>
								<input type="hidden" id="sfile3" name="sfile3" value="">
								<span class="inp" id="fileurl3" style="display:none;"></span>
								<button class="btnDel" onClick="delimage('sfile3','fileurl3');return false;">파일 삭제</button>
							</p>
						</div>
					</dd>
				</dl>
				<div class="btnWrap">
					<span class="button btB1 btRed cWh1 w100p">
						<button type="button" onclick="frmsubmit(); return false;">전송</button>
					</span>
				</div>
			</fieldset>
		</div>
		</form>
	</div>
	<!-- //contents -->
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>

<%
set ccsfile = nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->