<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 다이어리 스토리 2020 다꾸톡톡 작성
' History : 2019-09-05 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/diarystory2020/lib/worker_only_view.asp" -->
<!-- #include virtual="/diarystory2020/lib/classes/daccutoktokCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
    Dim userid, referer, refip

    referer = request.ServerVariables("HTTP_REFERER")
    refip = request.ServerVariables("REMOTE_ADDR")

    '// 로그인시에만 작성가능
    If not(IsUserLoginOK()) Then
        Response.Write "<script>alert('로그인이 필요한 서비스 입니다.');fnAPPclosePopup();</script>"
        Response.End
    End If

    userid	= getEncLoginUserID
    strHeadTitleName = "다꾸톡톡 쓰기"
    '//이미지 업로드 관련
    Dim encUsrId, tmpTx, tmpRn

    Randomize()
    tmpTx = split("A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z",",")
    tmpRn = tmpTx(int(Rnd*26))
    tmpRn = tmpRn & tmpTx(int(Rnd*26))
        encUsrId = tenEnc(tmpRn & userid)
    '//이미지 업로드 관련

    Dim vImgURL
    vImgURL = staticImgUrl & "/goodsimage/\\" & GetImageSubFolderByItemid("9999999") & "\\"


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
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/diary2020.css?v=1.09" />
<script type="text/javascript" src="/lib/js/iscroll.js"></script>
<script type="text/javascript" src="/lib/js/jquery.form.min.js"></script> 
<script type="text/javascript">
$(function() {

	//창 타이틀 변경
	setTimeout(function(){
		fnAPPchangPopCaption("다꾸톡톡 쓰기");
	}, 100);

    // 다꾸템 등록
    $('.dctem-thumb').click(function(e){
        $('.dctem-alert').css('display','none');
        var posX = Math.round( e.offsetX / $('.dctem-thumb .mark-list').width() * 100 );
        var posY = Math.round( e.offsetY / $('.dctem-thumb .mark-list').height() * 100 );
        $('.dctem-thumb .mark-list').append('<li class="mark" id="markposition_'+posX+posY+'" style="left:' + posX + '%; top:' + posY + '%;"><i class="ico-plus"></i></li>');
        setTimeout(() => {
            if (confirm('이곳에 상품을 등록하시겠습니까?')) {
                fnAPPpopupBrowserURL("구매 리스트","<%=wwwUrl%>/apps/appCom/wish/web2014/diarystory2020/daccu_toktok_myorder.asp?posX="+posX+"&posY="+posY+"&MasterIdxUseItem="+$('#daccuTokMasterIdx').val());
                $("#markposition_"+posX+posY).remove();
                return false;
            }
            else {
                $("#markposition_"+posX+posY).remove();
                return;
            }
        }, 50);
    });

    fnAmplitudeEventMultiPropertiesAction('view_diary_daccutoktok_write','','');    
});

// 업로드 파일 확인 및 처리
function jsCheckUpload() {
	if($("#fileupload").val()!="") {
		$("#fileupmode").val("upload");

		$('#ajaxform').ajaxSubmit({
			//보내기전 validation check가 필요할경우
			beforeSubmit: function (data, frm, opt) {
				if(!(/\.(jpg|jpeg|png)$/i).test(frm[0].upfile.value)) {
					alert("JPG,PNG 이미지파일만 업로드 하실 수 있습니다.");
					$("#fileupload").val("");
					return false;
				}
			},
			//submit이후의 처리
			success: function(responseText, statusText){
                //fnAmplitudeEventMultiPropertiesAction('click_my_review_files','','');
                var resultObj = JSON.parse(responseText)
                //alert(responseText);

				if(resultObj.response=="fail") {
                    alert(resultObj.faildesc);
                    $(".loadingV19").hide();
                    $(".dctem-top .dctem-regist").show();                    
				} else if(resultObj.response=="ok") {
					//파일 집어 넣기
					var $file_len = $(".dctem-top").find('input').length;
					var $files = $(".dctem-top").find('input');
					var $file_idx;
					
					for (i = 0 ; i < $file_len ; i++ ){
						if (!$files.eq(i).val()){
							$files.eq(i).val(resultObj.fileurl);
							$file_idx = i;
							break;
						}
					}
                    $(".loadingV19").hide();
					$(".dctem-top .dctem-thumb").eq($file_idx).show();//껍데기 보여주기
					$(".dctem-top .dctem-thumb").find('img').eq($file_idx).hide().attr("src",resultObj.fileurl+"?"+Math.floor(Math.random()*1000)).fadeIn("fast");//파일 치환
					$(".dctem-top .dctem-regist").eq($file_idx).hide();//해당 위치 찾아가기
                    $(".guide3").show();
                    <%'// 이미지 업로드된 URL을 DB에 일단 넣는다.%>
                    $("#daccuTokMode").val("ImageProc");
                    //alert(resultObj.fileurl);
                    $("#daccuTokMainImageUrl").val(resultObj.fileurl);
                    daccuTokTokImageExec();
				} else {
                    alert("처리중 오류가 발생했습니다.\n" + responseText);
                    $(".loadingV19").hide();
                    $(".dctem-top .dctem-regist").show();                     
				}
				$("#fileupload").val("");
			},
			//ajax error
			error: function(err){
				alert("ERR: " + err.responseText);
                $("#fileupload").val("");
                $(".loadingV19").hide();
                $(".dctem-top .dctem-regist").show();                 
            },
            beforeSend:function() {
                $(".dctem-top .dctem-regist").hide();
                $(".loadingV19").show();
            }
		});
	}
}

// 물리적인 파일 삭제 처리
function jsDelImg(v){
	if(confirm("이미지를 삭제하시겠습니까?\n\n※ 파일이 완전히 삭제되며 복구 할 수 없습니다.")){
		var delimg = $(".fileList").find('input').eq(v).val(); //삭제할 이미지
		$("#filepre").val(delimg);//form에 넣고
		$("#fileupmode").val("delete");
		$('#ajaxform').ajaxSubmit({
			//보내기전
			beforeSubmit: function (data, frm, opt) {

			},
			//submit이후의 처리
			success: function(responseText, statusText){
				var resultObj = JSON.parse(responseText)

				if(resultObj.response=="fail") {
					alert(resultObj.faildesc);
				} else if(resultObj.response=="ok") {
					$(".dctem-top").find('input').eq(v).val(""); //공백 값 넣기

					$(".dctem-top .thumbnail").eq(v).hide();//껍데기 안보이게하기
					$(".dctem-top .dctem-thumb").find('img').eq(v).hide().attr("src","").fadeIn("fast");
					$("#filepre").val("");
					$(".dctem-top .dctem-regist").eq(v).show();//해당 위치 찾아가기
				} else {
					alert("처리중 오류가 발생했습니다.\n" + responseText);
				}

			},
			//ajax error
			error: function(err){
				alert("ERR: " + err.responseText);
			}
		});
	}
}


//-----------------------------------AOS upload-----------------------------------
var _selComp;
var _no;

function fnAPPuploadImage(comp, no) {
    _selComp = comp;
    _no = no;
    
    var paramname = comp.name;
    var upurl = "<%=staticImgUpUrl%>/linkweb/doevaluatewithimage_android_onlyimageupload.asp?itemid=9999999&paramname="+paramname;
    if (no=="1"){		
        callNativeFunction('uploadImage', {"upurl":upurl,"paramname":paramname,"callback": appUploadFinish1});
    }else if(no=="2"){
        callNativeFunction('uploadImage', {"upurl":upurl,"paramname":paramname,"callback": appUploadFinish2});
    }else if(no=="3"){
        callNativeFunction('uploadImage', {"upurl":upurl,"paramname":paramname,"callback": appUploadFinish3});
    }
    $(".loadingV19").show();    
    return false;
}

function _appUploadFinish(ret,ino){
    $(".loadingV19").hide();
    if (_selComp){
        _selComp.value = "<%=vImgURL%>"+ret.name;
		$(".dctem-top .dctem-regist").eq(ino).hide();
		$(".dctem-top .dctem-thumb").eq(ino).show();//껍데기 보여주기
        $(".dctem-top .dctem-thumb").find('img').eq(ino).hide().attr("src","<%=vImgURL%>"+ret.name+"?"+Math.floor(Math.random()*1000)).fadeIn("fast");//파일 치환
        $(".guide3").show();
        <%'// 이미지 업로드된 URL을 DB에 일단 넣는다.%>
        $("#daccuTokMode").val("ImageProc");
        //alert(resultObj.fileurl);
        $("#daccuTokMainImageUrl").val(_selComp.value);
        daccuTokTokImageExec();
    }
}

function appUploadFinish1(ret){	
    _appUploadFinish(ret,0);
}

function appUploadFinish2(ret){
   _appUploadFinish(ret,1);
}

function appUploadFinish3(ret){
   _appUploadFinish(ret,2);
}
//-----------------------------------AOS upload-----------------------------------

<%'// 등록완료 버튼 활성화를 위한 validation 체크 %>
function regStatusCheck() {
    if (!$("#lyrBnrImg").attr("src")==""&&!$("#daccuTokTitle").val()==""&&$("#daccuTokItemList").html() != "") {
        $("#daccuRegButton").addClass("on");
    }
}

<%'// 사용자 이미지 업로드시 Master 데이터 Insert %>
function daccuTokTokImageExec() {
    $.ajax({
        type:"POST",
        url:"/diarystory2020/ajaxDaccuTokTok.asp",
        data: $("#frmData").serialize(),
        dataType: "text",
        async:false,
        cache:true,
        success : function(Data, textStatus, jqXHR){
            if (jqXHR.readyState == 4) {
                if (jqXHR.status == 200) {
                    if(Data!="") {
                        var result = JSON.parse(Data)
                        if(result.response == "ok"){									
							$("#daccuTokMasterIdx").val(result.MasterIdx);										
                            return false;
                        }else{
                            alert(result.faildesc);
                            return false;
                        }
                    } else {
                        alert("잘못된 접근 입니다.");
                        document.location.reload();
                        return false;
                    }
                }
            }
        },
        error:function(jqXHR, textStatus, errorThrown){
            alert("잘못된 접근 입니다.");					
            // document.location.reload();
            return false;
        }
    });
}

<%'// 상품 등록 후 동작 %>
function daccuTokTokAfterDetailProc(xv,yv) {
    <%'// 모달을 닫고 하단 상품 리스트 데이터를 가져온다. %>
    $('.dctem-thumb .mark-list').append('<li class="mark" id="markposition_'+xv+yv+'" style="left:' + xv + '%; top:' + yv + '%;"><i class="ico-plus"></i></li>');
    daccuTokTokDetailProduct();
    setTimeout(() => {
        regStatusCheck();
    }, 50);
}

function daccuTokTokDetailProduct() {
    $.ajax({
        type:"GET",
        url:"/diarystory2020/act_daccu_toktok_detailitemlist.asp?MasterIdx="+$('#daccuTokMasterIdx').val(),
        //data: ,
        dataType: "text",
        async:false,
        cache:true,
        success : function(Data, textStatus, jqXHR){
            if (jqXHR.readyState == 4) {
                if (jqXHR.status == 200) {
                    if(Data!="") {
                        $("#daccuTokItemList").empty().html(Data);
                    } else {
                        alert("잘못된 접근 입니다.");
                        document.location.reload();
                        return false;
                    }
                }
            }
        },
        error:function(jqXHR, textStatus, errorThrown){
            alert("잘못된 접근 입니다.");					
            // document.location.reload();
            return false;
        }
    });
}


function daccuTokTokProc() {
    <%'// 해당 버튼에 on 클래스가 없으면 작동하지 않는다. %>
    if($("#daccuRegButton").hasClass("on")===true) {

        $("#daccuTokMode").val("daccuProc");
        $("#daccuTokProcTitle").val($('#daccuTokTitle').val());
        $.ajax({
            type:"POST",
            url:"/diarystory2020/ajaxDaccuTokTok.asp",
            data: $("#frmData").serialize(),
            dataType: "text",
            async:false,
            cache:true,
            success : function(Data, textStatus, jqXHR){
                if (jqXHR.readyState == 4) {
                    if (jqXHR.status == 200) {
                        if(Data!="") {
                            var result = JSON.parse(Data)
                            if(result.response == "ok"){
                                fnAPPopenerJsCallClose('daccuReload()');
                                return false;
                            }else{
                                alert(result.faildesc);
                                return false;
                            }
                        } else {
                            alert("잘못된 접근 입니다.");
                            document.location.reload();
                            return false;
                        }
                    }
                }
            },
            error:function(jqXHR, textStatus, errorThrown){
                alert("잘못된 접근 입니다.");					
                // document.location.reload();
                return false;
            }
        });
    }
    else {
        return;
    }
}
</script>

</head>
<body class="default-font body-sub diary2020">
    <div id="content" class="content diary-sub">
        <div class="diary-sub">
            <div class="talk talk-wirte">
                <%' 다꾸톡 이미지 %>
                <div class="dctem-top">
                    <% if vProcess="A" then %>
                        <input type="hidden" name="file1" id="andfile1upload" value="<%'EvList.FEvalItem.getImageUrl1%>" />
                        <%' for dev msg 이미지 등록 전 %>
                        <div class="dctem-regist" style="<%'chkIIF(EvList.FEvalItem.Flinkimg1="" or isNull(EvList.FEvalItem.Flinkimg1),"","display:none;")%>">
                            <label for="fileupload" class="btn-regist-thumb" onClick="fnAPPuploadImage(document.getElementById('andfile1upload'), '1');"></label>
                            <p>플러스 버튼을 눌러서<br>다꾸템을 등록해보세요!</p>
                        </div>
                        <div class="loadingV19" style="display:none;">
                            <i></i>
                            <p>이미지 업로드 중</p>
                        </div>                            
                        <%' for dev msg 이미지 등록 후 %>
                        <div class="dctem-thumb" style="display:none;<%'chkIIF(EvList.FEvalItem.Flinkimg1="" or isNull(EvList.FEvalItem.Flinkimg1),"display:none;","")%>">
                            <img id="lyrBnrImg" src="<%'chkIIF(EvList.FEvalItem.Flinkimg1="" or isNull(EvList.FEvalItem.Flinkimg1),"",EvList.FEvalItem.getImageUrl1)%>"/>
                            <p class="dctem-alert"><span class="mark"><i class="ico-plus"></i></span>태그할 영역을 선택해주세요.</p>
                            <ul class="mark-list"></ul>
                        </div>
                    <% Else %>
                        <input type="hidden" name="file1" value="<%'EvList.FEvalItem.getImageUrl1%>" />
                        <%' for dev msg 이미지 등록 전 %>
                        <div class="dctem-regist" style="<%'chkIIF(EvList.FEvalItem.Flinkimg1="" or isNull(EvList.FEvalItem.Flinkimg1),"","display:none;")%>">
                            <label for="fileupload" class="btn-regist-thumb"></label>
                            <p>플러스 버튼을 눌러서<br>다꾸템을 등록해보세요!</p>
                        </div>
                        <div class="loadingV19" style="display:none;">
                            <i></i>
                            <p>이미지 업로드 중</p>
                        </div>                            
                        <%' for dev msg 이미지 등록 후 %>
                        <div class="dctem-thumb" style="display:none;<%'chkIIF(EvList.FEvalItem.Flinkimg1="" or isNull(EvList.FEvalItem.Flinkimg1),"display:none;","")%>">
                            <img id="lyrBnrImg" src="<%'chkIIF(EvList.FEvalItem.Flinkimg1="" or isNull(EvList.FEvalItem.Flinkimg1),"",EvList.FEvalItem.getImageUrl1)%>"/>
                            <p class="dctem-alert"><span class="mark"><i class="ico-plus"></i></span>태그할 영역을 선택해주세요.</p>
                            <ul class="mark-list"></ul>
                        </div>
                    <% End If %>
                </div>

                <%' 다꾸톡 텍스트 %>
                <div class="dctem-conts">
                    <input type="text" class="input-tit" name="daccuTokTitle" id="daccuTokTitle" onchange="regStatusCheck();" onkeyup="regStatusCheck();" placeholder="제목을 입력해주세요">
                    <ul class="dctem-list" id="daccuTokItemList"></ul>
                    <%' for dev msg  이미지 등록된 후 guide3 노출 %>
                    <div class="guide3" style="display:none;" onclick="document.location.reload();"><button>이미지를 교체하시겠어요?</button></div>
                </div>
            </div>
        </div>
        <div class="btn-area">
            <%' for dev msg class="on" 붙여서 활성화(노랑색버튼)%>
            <button class="btn btn-xlarge btn-block color-black" id="daccuRegButton" onclick="daccuTokTokProc();">등록하기</button>
        </div>
    </div>

    <%' 이미지 업로드 Form %>
    <form name="frmUpload" id="ajaxform" action="<%=staticImgUpUrl%>/common/simpleCommonImgUploadProc.asp" method="post" enctype="multipart/form-data" style="display:none; height:0px;width:0px;">
    <input type="file" name="upfile" id="fileupload" onchange="jsCheckUpload();" accept="image/*" />
    <input type="hidden" name="mode" id="fileupmode" value="upload">
    <input type="hidden" name="div" value="SB">
    <input type="hidden" name="tuid" value="<%=encUsrId%>">
    <input type="hidden" name="prefile" id="filepre" value="">
    <input type="hidden" name="itemid" value="9999999">
    </form>
    <%' 이미지 업로드 Form %>

    <%' 작성 폼 데이터 %>
    <form name="frmData" id="frmData" style="display:none; height:0px;width:0px;">
        <input type="hidden" name="daccuTokMasterIdx" id="daccuTokMasterIdx">
        <input type="hidden" name="daccuTokMode" id="daccuTokMode">
        <input type="hidden" name="daccuTokMainImageUrl" id="daccuTokMainImageUrl">
        <input type="hidden" name="daccuTokProcTitle" id="daccuTokProcTitle">
        <input type="hidden" name="returnfolder" value="web2014" />
        <input type="hidden" name="itemid" value="9999999" />
        <input type="hidden" id="apps" name="apps" value="apps">
        <input type="hidden" name="chkp5yn" value="Y" />
    </form>   
    <%'// 작성 폼 데이터 %>

	<div id="lyLoading" style="display:none;position:relative;text-align:center; padding:20px 0;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>
    <div id="modalLayer" style="display:none;"></div>
</body>
</html>
<% 'AOS
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
<!-- #include virtual="/lib/db/dbclose.asp" -->