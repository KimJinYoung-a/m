<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 마이텐바이텐 반품 파일이미지 등록
' History : 2019.11.28 한용민 생성
'####################################################
%>
<!-- #include virtual="/apps/appcom/wish/web2014/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
dim fileno, filegubun
    filegubun = requestcheckvar(request("filegubun"),2)
    fileno = requestcheckvar(request("fileno"),10)

dim iandOrIos, iappVer, vProcess
iappVer = getAppVerByAgent(iandOrIos)

if (iandOrIos="a") then
    if (FnIsAndroidKiKatUp) then
        if (iappVer>="1.48") then
            ''신규 업노드    
            vProcess = "A"
        else
            ''어플리케이션 1.48 이상 버전업이 필요하다.
            vProcess = "I"
        end if
    else
        '' 기존
        vProcess = "I"
    end if
else
    ''기존.
    vProcess = "I"
end If

function getAppVerByAgent(byref iosOrAnd)
    dim agnt : agnt =  Lcase(Request.ServerVariables("HTTP_USER_AGENT"))
    dim pos1 : pos1 = Instr(agnt,"tenapp ")
    dim buf 
    dim retver : retver=""
    getAppVerByAgent = retver
    
    if (pos1<1) then exit function
    buf = Mid(agnt,pos1,255)
    
    iosOrAnd = MID(agnt,pos1 + LEN("tenapp "),1)
    getAppVerByAgent = Trim(MID(agnt,pos1 + LEN("tenapp ")+1,4))
end function

function FnIsAndroidKiKatUp()
    dim iiAgent : iiAgent= Lcase(Request.ServerVariables("HTTP_USER_AGENT"))
    FnIsAndroidKiKatUp = (InStr(iiAgent,"android 4.4")>0)
    FnIsAndroidKiKatUp = FnIsAndroidKiKatUp or (InStr(iiAgent,"android 5")>0) or (InStr(iiAgent,"android 6")>0) or (InStr(iiAgent,"android 7")>0) or (InStr(iiAgent,"android 8")>0) or (InStr(iiAgent,"android 9")>0) or (InStr(iiAgent,"android 10")>0) or (InStr(iiAgent,"android 11")>0) or (InStr(iiAgent,"android 12")>0)
end function
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type="text/javascript" src="/lib/js/jquery.form.min.js"></script> 
<script type="text/javascript" src="/lib/js/iscroll.js"></script>
<script type="text/javascript">

//-----------------------------------AOS upload-----------------------------------
var _selComp;

function fnAPPuploadImage(comp) {
	_selComp = comp;

    var paramname = comp.name;
    <% IF application("Svr_Info")="Dev" THEN %>
        var upurl = "<%= uploadImgUrl %>/linkweb/cscenter/cs_fileupload.asp?sfile="+paramname;
    <% else %>
        var upurl = "<%= replace(uploadImgUrl,"http://","https://") %>/linkweb/cscenter/cs_fileupload.asp?sfile="+paramname;
    <% end if %>
    callNativeFunction('uploadImage', {"upurl":upurl,"paramname":paramname,"callback": appUploadFinish});
    return false;
}

function _appUploadFinish(ret){
    if (_selComp){
        var fileurl=ret.name;
        $("#fileurl").val(fileurl);
        $("#fileurldisp").html("첨부파일");
        $("#fileurldisp").show();
    }
}

function appUploadFinish(ret){	
    _appUploadFinish(ret);
}

//-----------------------------------AOS upload-----------------------------------

function filesubmit(){
    var fileurl=$("#fileurl").val();
    var filegubun='<%= filegubun %>';
    var fileno='<%= fileno %>';

    if (filegubun==""){
        alert('파일을 입력해 주세요.');
        return;
    }

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
}

//-----------------------------------IOS upload-----------------------------------
// 업로드 파일 확인 및 처리
function jsCheckUpload() {
	var fileurl='';
	var filegubun='<%= filegubun %>';
	var fileno='<%= fileno %>';

	if($("#sfile").val()!="") {
		$('#ajaxform').ajaxSubmit({
			//submit이후의 처리
			success: function(responseText, statusText){
                var resultObj = JSON.parse(responseText)
                //alert(responseText);
                if(resultObj.response=="OK") {
					fileurl = resultObj.filename
					$("#fileurl").val(fileurl);
                    $("#fileurldisp").html("첨부파일");
                    $("#fileurldisp").show();
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

function fnCheckCameraPermission(scriptFunc) {
    console.log("fnCheckCameraPermission");	
    callNativeFunction('checkCameraPermission', {
        "scriptFunc" : scriptFunc
    });
}
function runFileUpload(){
	var element = document.getElementById("sfile");	
	element.setAttribute('type','file');	
	element.onclick = null;
	$("#sfile").trigger('click');
}
function checkPermission(){
	fnCheckCameraPermission("runFileUpload()");	
}
//-----------------------------------IOS upload-----------------------------------

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
                <div class="noti">
                    <div class="txtOutput default-font">파일이 많은경우 압축(ZIP)해서 등록해 주세요.<br>첨부파일당 최대 5MB까지만 허용됩니다.</div>
                    <% if vProcess="A" then %>
                        <div class="addImage mar0">
                            <p>
                                <span class="button btS1 btWht cBk1"><label for="sfile" class="btnUpload">파일선택</label></span>
                                <span class="inp" id="fileurldisp" style="display:none;"></span>
                            </p>
                        </div>
                        <% IF application("Svr_Info")="Dev" THEN %>
                            <form name="frmUpload" id="ajaxform" action="<%= uploadImgUrl %>/linkweb/cscenter/cs_fileupload.asp" method="post" enctype="multipart/form-data" style="display:none; height:0px;width:0px;">
                        <% else %>
                            <form name="frmUpload" id="ajaxform" action="<%= replace(uploadImgUrl,"http://","https://") %>/linkweb/cscenter/cs_fileupload.asp" method="post" enctype="multipart/form-data" style="display:none; height:0px;width:0px;">
                        <% end if %>
                        <div class="addImage mar0">
                            <p>
                                <input type="hidden" name="fileurl" id="fileurl" value="">
                                <input type="file" id="sfile" name="sfile" onclick="fnAPPuploadImage(document.frmUpload.sfile); return false;" />
                            </p>
                        </div>
                        </form>
                    <% else %>
                        <div class="addImage mar0">
                            <p>
                                <span class="button btS1 btWht cBk1"><label for="sfile" class="btnUpload">파일선택</label></span>
                                <span class="inp" id="fileurldisp" style="display:none;"></span>
                            </p>
                        </div>
                        <%'!--IOS 이미지 업로드 Form --%>
                        <% IF application("Svr_Info")="Dev" THEN %>
                            <form name="frmUpload" id="ajaxform" action="<%= uploadImgUrl %>/linkweb/cscenter/cs_fileupload.asp" method="post" enctype="multipart/form-data" style="display:none; height:0px;width:0px;">
                        <% else %>
                            <form name="frmUpload" id="ajaxform" action="<%= replace(uploadImgUrl,"http://","https://") %>/linkweb/cscenter/cs_fileupload.asp" method="post" enctype="multipart/form-data" style="display:none; height:0px;width:0px;">
                        <% end if %>
                        <input type="hidden" name="fileurl" id="fileurl" value="">
                        <% If iappVer < "2.36"Then %>
                            <input type="file" name="sfile" id="sfile" onchange="jsCheckUpload()" />								
                        <% Else %>
                            <input type="button" name="sfile" id="sfile" onclick="checkPermission()" onchange="jsCheckUpload()" />												
                        <% End if %>
                        </form>
                        <%'!--IOS 이미지 업로드 Form --%>
                    <% end if %>
                </div>
				<div class="btnWrap">
					<span class="button btB1 btRed cWh1 w100p">
						<button type="button" onclick="filesubmit(); return false;">전송</button>
					</span>
				</div>
			</div>
		</div>
	</div>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->