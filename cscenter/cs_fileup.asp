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
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
dim fileno, filegubun
    filegubun = requestcheckvar(request("filegubun"),2)
    fileno = requestcheckvar(request("fileno"),10)
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script type="text/javascript" src="/lib/js/jquery.form.min.js"></script> 
<script type="text/javascript" src="/lib/js/iscroll.js"></script>
<script type="text/javascript">

// 업로드 파일 확인 및 처리
function jsCheckUpload() {
	var fileurl='';
	var filegubun='<%= filegubun %>';
	var fileno='<%= fileno %>';

	if($("#sfile").val()!="") {
		var fsize = $('#sfile')[0].files[0].size;

		if (fsize > 5*1024*1024) {
			alert("첨부파일당 최대 5MB까지 허용됩니다.");
			return;
		}
	}

	if($("#sfile").val()!="") {
		$('#ajaxform').ajaxSubmit({
			//submit이후의 처리
			success: function(responseText, statusText){
                var resultObj = JSON.parse(responseText)
                //alert(responseText);
                if(resultObj.response=="OK") {
					fileurl = resultObj.filename
					$("#fileurl").val(fileurl);

					if (filegubun=="R1"){
						if (fileno=="1"){
							$("#sfile1").val(fileurl);
							$("#fileurl1").html("첨부파일1");
							$("#fileurl1").show();
						}else if(fileno=="2"){
							$("#sfile2").val(fileurl);
							$("#fileurl2").html("첨부파일2");
							$("#fileurl2").show();
						}else if(fileno=="3"){
							$("#sfile3").val(fileurl);
							$("#fileurl3").html("첨부파일3");
							$("#fileurl3").show();
						}else if(fileno=="4"){
							$("#sfile4").val(fileurl);
							$("#fileurl4").html("첨부파일4");
							$("#fileurl4").show();
						}else if(fileno=="5"){
							$("#sfile5").val(fileurl);
							$("#fileurl5").html("첨부파일5");
							$("#fileurl5").show();
						}
						fnCloseModal();
					}
				}else if(resultObj.response=="FAIL") {
                    alert(resultObj.faildesc);
					return;
				} else {
                    alert("처리중 오류가 발생했습니다.\n" + responseText);
					return;
				}
			},
			//ajax error
			error: function(err){
				alert("ERR: " + err.responseText);
				return;
            }
		});
    }else{
        alert("파일을 선택해 주세요.");
        return;
	}
}

</script>
</head>
	<div class="layerPopup default-font">
		<header class="tenten-header header-popup">
			<div class="title-wrap">
                <h1>파일,이미지 등록</h1>
                <button type="button" class="btn-close" onclick="fnCloseModal();">닫기</button>
			</div>
		</header>
		<div class="ly-contents stock-inform">
			<div class="scrollwrap">
				<% IF application("Svr_Info")="Dev" THEN %>
					<form name="frmUpload" id="ajaxform" action="<%= uploadImgUrl %>/linkweb/cscenter/cs_fileupload.asp" method="post" enctype="multipart/form-data">
				<% else %>
					<form name="frmUpload" id="ajaxform" action="<%= replace(uploadImgUrl,"http://","https://") %>/linkweb/cscenter/cs_fileupload.asp" method="post" enctype="multipart/form-data">
				<% end if %>
				<div class="noti">
                    <div class="txtOutput default-font">파일이 많은경우 압축(ZIP)해서 등록해 주세요.<br>첨부파일당 최대 5MB까지만 허용됩니다.</div>
                    <div class="addImage mar0">
                        <p><input type="file" id="sfile" name="sfile" /><input type="hidden" name="fileurl" id="fileurl" value=""></p>
                    </div>
				</div>
				<div class="btnWrap">
					<span class="button btB1 btRed cWh1 w100p">
						<button type="button" onclick="jsCheckUpload(); return false;">전송</button>
					</span>
				</div>
                </form>
			</div>
		</div>
	</div>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->