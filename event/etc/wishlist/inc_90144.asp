<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  위시리스트 이벤트
' History : 2018-11-02 최종원 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/event/etc/wishlist/UserWisheventCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
Dim eCode, userid, vreturnurl, orderoption, isParticipation
IF application("Svr_Info") = "Dev" THEN
	eCode   =  "89181"
Else
	eCode   =  "90144"
End If
vreturnurl = Request.ServerVariables("url") &"?"&Request.ServerVariables("QUERY_STRING")

userid = GetEncLoginUserID()

Dim page, i, y, pagereload
page = request("page")
orderoption = request("orderoption")
pagereload	= requestCheckVar(request("pagereload"),2)

if orderoption = "" then
	orderoption = 1
end if

If page = "" Then 
page = 1
end if

dim userWishFolderO
set userWishFolderO = new UserWishFolder

	userWishFolderO.FPageSize	= 6
	userWishFolderO.FCurrPage	= page	
	userWishFolderO.Frectuserid = userid
	userWishFolderO.FRectOrderOption = orderoption
	userwishfoldero.GetUserFolderList()		
	userwishfoldero.GetUsersFolderList()
    isParticipation = userwishfoldero.isParticipatedUser(userid)

Function fnDisplayPaging_New(strCurrentPage, intTotalRecord, intRecordPerPage, intBlockPerPage, strJsFuncName)
	'변수 선언
	Dim intCurrentPage, strCurrentPath, vPageBody
	Dim intStartBlock, intEndBlock, intTotalPage
	Dim strParamName, intLoop

	'현재 페이지 설정
	intCurrentPage = strCurrentPage		'현재 페이지 값

	'해당페이지에 표시되는 시작페이지와 마지막페이지 설정
	intStartBlock = Int((intCurrentPage - 1) / intBlockPerPage) * intBlockPerPage + 1
	intEndBlock = Int((intCurrentPage - 1) / intBlockPerPage) * intBlockPerPage + intBlockPerPage

	'총 페이지 수 설정
	intTotalPage =   int((intTotalRecord-1)/intRecordPerPage) +1
	''eastone 추가
	if (intTotalPage<1) then intTotalPage=1

	vPageBody = ""
	strJsFuncName = trim(strJsFuncName)

	vPageBody = vPageBody & "<div class=""paging"">" & vbCrLf

	'## 이전 페이지
	If intStartBlock > 1 Then
		vPageBody = vPageBody & "	<button class=""prev"" onclick=""" & strJsFuncName & "(" & intStartBlock-1 & ");return false;""><img src="""" alt=""이전페이지로 이동""></button>" & vbCrLf
	Else
		vPageBody = vPageBody & "	<button class=""prev"" onclick=""return false;""><img src="""" alt=""이전페이지로 이동""></button>" & vbCrLf
	End If

	'## 현재 페이지
	If intTotalPage > 1 Then
		For intLoop = intStartBlock To intEndBlock
			If intLoop > intTotalPage Then Exit For
			If Int(intLoop) = Int(intCurrentPage) Then
				vPageBody = vPageBody & "	<a href=""#"" title=""" & intLoop & " 페이지"" class=""current"" onclick=""" & strJsFuncName & "(" & intLoop & ");return false;""><span style=""cursor:pointer;"">" & intLoop & "</span></a>" & vbCrLf
			Else
				vPageBody = vPageBody & "	<a href=""#"" title=""" & intLoop & " 페이지"" onclick=""" & strJsFuncName & "(" & intLoop & ");return false;""><span style=""cursor:pointer;"">" & intLoop & "</span></a>" & vbCrLf
			End If
		Next
	Else
		vPageBody = vPageBody & "	<a href=""#"" title=""1 페이지"" class=""current"" onclick=""" & strJsFuncName & "(1);return false;""><span style=""cursor:pointer;"">1</span></a>" & vbCrLf
	End If

	'## 다음 페이지
	If Int(intEndBlock) < Int(intTotalPage) Then	'####### 다음페이지
		vPageBody = vPageBody & "	<button class=""next"" onclick=""" & strJsFuncName & "(" & intEndBlock+1 & ");return false;""><span style=""cursor:pointer;""><img src="""" alt=""다음 페이지로 이동""></button>" & vbCrLf
	Else
		vPageBody = vPageBody & "	<button class=""next"" onclick=""return false;""><span style=""cursor:pointer;""><img src="""" alt=""다음 페이지로 이동""></button>" & vbCrLf
	End If	

	vPageBody = vPageBody & "</div>" & vbCrLf

	fnDisplayPaging_New = vPageBody
End Function 
%>
<style type="text/css">
.mEvt90144{background:#ffb6b8; min-width:200px ;;}
.mEvt90144 img{width:100%;}
.mEvt90144 button{border:0 none;background-color:transparent;background:none;cursor:pointer;} 
.mEvt90144 button::-moz-focus-inner, input::-moz-focus-inner { border: 0; padding: 0; }
.mEvt90144 button:focus{ outline: none}
.mEvt90144 *{box-sizing: border-box;}
.mEvt90144 .top-area{position:relative; background-color: #ff838c;}
.mEvt90144 .top-area dt,
.mEvt90144 .top-area dd{position:absolute; width:100%; animation: show .8s both 1;}
.mEvt90144 .top-area dt{top:20.7%; }
.mEvt90144 .top-area dd{top:41.3%; animation-delay:.8s}
.mEvt90144 .wishgo{width:80%; animation: moveX .8s infinite ease-in-out; position:absolute; top:0; left:10%}
.mEvt90144 .cont{background:url('http://webimage.10x10.co.kr/fixevent/event/2018/90144/m/bg_img_y.png') repeat-y ; background-size:contain; margin-top:-1px;}
.mEvt90144 .sort{position:relative;}
.mEvt90144 .sort div{width:100%; position: absolute; bottom: 5.5%; text-align: center;}
.mEvt90144 .sort a{display: inline-block; width: 6rem; height: 4rem; text-indent: -9999px; background-image: url('http://webimage.10x10.co.kr/fixevent/event/2018/90144/m/btn_order.png'); background-size: 14rem; background-position-y: 100%;}
.mEvt90144 .sort a:last-child{background-position-x: 100%; } 
.mEvt90144 .sort a.active{background-position-y: 0;}
.mEvt90144 .cont ul li{border-bottom:1px solid #e7dfdf; margin:0 9.5% 3rem; padding-bottom:3rem;}
.mEvt90144 .cont ul li:last-child{border-bottom:0; margin-bottom: 0; padding-bottom:2rem;}
.mEvt90144 .cont ul li span{display: inline-block;    text-align: center;     margin-bottom: 2.8rem;}
.mEvt90144 .cont ul li img{width: 48.3%; margin: .3rem .1rem;}
.mEvt90144 .cont ul li div{text-align:center;}
.mEvt90144 .cont ul li div{font-family: AppleSDGothicNeo; font-size: 1.2rem; text-align: center; display: block; color: #000;}
.mEvt90144 .cont ul li div b{font-family: verdana; font-weight: 600; position: relative;}
.mEvt90144 .cont li div b.vvip:before{ content: ''; display: block; background-image: url('http://webimage.10x10.co.kr/fixevent/event/2018/90144/m/ico_vvip.png'); background-size: contain; position: absolute; width: 5rem; height: 2.5rem; top: -2.5rem; left: 45%; background-repeat: no-repeat;}
.mEvt90144 .cont ul li div p{font-family: verdana; font-weight: 600; font-size: 1.15rem; color: #505050; margin:.4rem 0 1.6rem;}
.mEvt90144 .cont ul li div button img{width: 55%;}
.mEvt90144 .cont ul li.joined{position:relative;}
.mEvt90144 .cont ul li.joined:before{position:absolute; bottom: 16.5%; content:''; background-image: url('http://webimage.10x10.co.kr/fixevent/event/2018/90144/m/txt_wishok.png'); background-repeat:no-repeat; position:absolute; left:80%; display:block; width:6rem; height:6rem; background-size:contain;}
.mEvt90144 .cont .paging{margin-top: 15px; text-align: center; }
.mEvt90144 .cont .paging a{border: none; background: none; font-family: 'Verdana'; font-weight: bold; color: #de7678; margin: 0 .2rem; display: inline-block;}
.mEvt90144 .cont .paging a span{font-size: 1rem; color: #de7678; display: block; width:2.2em; line-height: 2.2rem;}
.mEvt90144 .cont .paging a.current,
.mEvt90144 .cont .paging a.current:hover,
.mEvt90144 .cont .paging a:hover{background-color: unset; border: 0;}
.mEvt90144 .cont .paging a.current span,
.mEvt90144 .cont .paging a.current:hover span,
.mEvt90144 .cont .paging a:hover span{ background-image: url('http://webimage.10x10.co.kr/fixevent/event/2018/90144/m/bg_pagination.png'); background-size: contain; background-repeat: no-repeat; color: #fff; height: 100%;}
.mEvt90144 .cont .paging .prev,
.mEvt90144 .cont .paging .next{background:  50% 50% no-repeat; vertical-align: middle; margin: 0 20px; width: .7rem; text-indent: -9999px; background-position-y: top; background-size: contain;}
.mEvt90144 .cont .paging .prev{background-image:url('http://webimage.10x10.co.kr/fixevent/event/2018/90144/m/btn_prev.png');}
.mEvt90144 .cont .paging .next{background-image:url('http://webimage.10x10.co.kr/fixevent/event/2018/90144/m/btn_next.png');}
.mEvt90144 .notice{position: relative; }
.mEvt90144 .notice span{padding-left: 5%; position: absolute; top:60%; bottom:0; width:100%; height: 100%; font-family: "AppleSDGothicNeo", '맑은고딕'; font-size:.9rem; line-height: 1.9rem; color: #fff; text-align: left;  }
.layer-popup {display:none; position:absolute; left:0; top:0; z-index:9997; width:100%; height:100%;}
.layer-popup .layer {overflow:hidden; position:absolute; left:calc(50% - 44%); top:0; z-index:99999; width:88%;}
.layer-popup .mask {display:block; position:absolute; left:0; top:0; z-index:9998; width:100%; height:100%; background:rgba(0,0,0,.7);}
#lyrSch .layer {top:10rem; left:10%; width:80%; background-color:#f9f9f9; border-radius:1rem;}
.layer-popup .layer ul{width: 90%; margin: 0 auto; overflow-y: auto; max-height: 11.7rem; border-bottom: 1px solid #efefef;}
.layer-popup .layer ul li{height: unset; background-color:#fff }
.layer-popup .layer ul li.on{background-color: #f0f0f0;}
.layer-popup .layer ul li button{display: block; padding:1.1rem 1.25rem; border-top: 1px solid #efefef; width: 100%;     text-align: left;}
.layer-popup .layer ul li span.label.open { background-color: #75d4d5;}
.layer-popup .layer ul li span.label.closed {background-color: #cbcbcb;}
.layer-popup .layer ul li span.label {display: inline-block;width: 3.3rem;height: 1.5rem;color: #fff;font-size: 1rem;line-height: 1.5rem;text-align: center;margin-right:.5rem}
.layer-popup h3{width: 50%; margin: 0 auto; padding: 4rem 0 2rem;}
.layer-popup a.btn-close{position: absolute; top:1.3rem; right: 1.3rem;}
.layer-popup button.layer-btn{width: 60%;margin: 2.5rem auto 4rem; display: block;}
@keyframes bounce2 {from, to{transform:translateY(0);} 50%{transform:translateY(10px)}}
@keyframes moveX {from, to{transform:translateX(0);}	50%{transform:translateX(5px)}}
@keyframes show {from {opacity: 0;}	 to {opacity: 1;}}
@media screen and (max-width:300px){ 
    .mEvt90144 .cont ul li img{width: 47%;}
}
@media screen and (max-width:335px){ 
    .mEvt90144 .notice span{background-color: #ed5457;}
    .sort a{width:5rem; height: 3rem; background-size: 10.5rem;;}
    .joined:before{width:4rem; height: 4rem;}
}
/* 181108 수정 */
.mEvt90144 .cont .paging .prev,
.mEvt90144 .cont .paging .next {vertical-align: -1px;}
.mEvt90144 .cont .paging a span {background-position-y: 1px; padding-bottom: 1px;}
.mEvt90144 .notice ol {width: 100%; padding: 0 3rem 3rem; margin-top: -32%; background-color: #ed5457; }
.mEvt90144 .notice li{font-family: "AppleSDGothicNeo", '맑은고딕'; line-height: 1.9rem; color: #fff; text-align: left;}
.mEvt90144 .notice li:before {content:'·';display:inline-block;width:10px;margin-left:-10px;}
</style>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js"></script>
<script type="text/javascript">
    $(function(){
	<% if pagereload <> "" then%>
	window.parent.$('html,body').animate({scrollTop:$('#cont').offset().top}, 0);
	<% end if %>	        
        // 레이어 닫기
        $('.layer-popup .btn-close').click(function(){
            $('.layer-popup').fadeOut();
        });
        $('.layer-popup .mask').click(function(){
            $('.layer-popup').fadeOut();
        });

        //레이어에서 위시 선택
        $('.layer-popup ul li button').click(function(){
            $(this).parent().addClass('on').siblings().removeClass('on')
        });
    });
function fnSort(sortmet){
    <% if isapp = 1 then %>	
    document.location.replace("<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%=eCode%>&pagereload=ON&orderoption="+sortmet)
    <% else %>
    document.location.href="/event/eventmain.asp?eventid=<%=eCode%>&orderoption="+sortmet
    <% end if %>
}
function fnViewUserWish(userid, idx){
    var link
    <% if isApp = 1 then %>
    link = "/apps/appcom/wish/web2014/my10x10/myWish/myWish.asp?ucid="+userid
    fnAPPpopupBrowserURL('위시','<%=wwwUrl%>'+link);
    <% else %>
    link = "/my10x10/myWish/myWish.asp"
    var frm = document.frmsearch;
    frm.action = link    
    frm.ucid.value = userid    
    frm.submit();	        
    <% end if %>
	addViewCnt(idx);    
}    
function addViewCnt(idx, itemid){
	var str = $.ajax({
		type: "GET",
		url:"/event/etc/wishlist/doWishEvtProc.asp",
		data: "idx="+idx,
		dataType: "text",
		async: false
	}).responseText;	    
}
function setItemCnt(cnt, selectedFidx){
	var frm = document.frm;	
	var result;
	frm.itemCnt.value = cnt; 
    frm.selfidx.value = selectedFidx;      
}
function chkItemCnt(){
	var frm = document.frm;		
	result = true;
	if(frm.itemCnt.value < 4){
		result = false;
	}	
	return result;	
}
function shareWishFolder(){

	<% If not IsUserLoginOK() Then %>		    
        <% If isApp Then %>
            calllogin();
        <% Else %>
            jsevtlogin();
        <% End If %>		
	<% else %>	
        <% if userWishFolderO.FUfolderTotalCount = 0 then %>
        alert("위시리스트 폴더가 없습니다. 폴더를 생성해주세요.");
        return false;
        <% end if %>    
        $('#lyrSch').fadeIn();
        window.parent.$('html,body').animate({scrollTop:$('#lyrSch').offset().top}, 800);
	<% end if %>
}
function fnShare(){
	var frm = document.frm;

    if(frm.selfidx.value == ""){
        alert("공유할 폴더를 선택해주세요.");
        return false;
    }
	if(!chkItemCnt()){
		alert("위시리스트에 상품을 4개 이상\n담아주셔야 공유 가능합니다!");
		return false;
	}
	<% If IsUserLoginOK() Then %>
		<% If Now() > #11/11/2018 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If Now() > #11/02/2018 00:00:00# and Now() < #11/11/2018 23:59:59# Then %>				
				frm.action="/event/etc/wishlist/doWishEvtProc.asp";				
				frm.submit();
			<% Else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% End If %>
		<% End If %>
	<% Else %>
		if(confirm("로그인을 하셔야 참여가 가능 합니다. 로그인 하시겠습니까?")){
			var winLogin = window.open('/login/PopLoginPage.asp','popLogin','width=400,height=300');
			winLogin.focus();
			return;
		}
	<% End If %>	
}
function jsGoPage(iP){
	document.pageFrm.page.value = iP;
	document.pageFrm.submit();
}
function pagedown(){	
	window.$('html,body').animate({scrollTop:$("#lyrSch").offset().top}, 0);
}
</script>
            <div class="mEvt90144">
                <div class="top-area">
                    <p class="bg-img"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90144/m/tit_img.png" alt="나만 알기 아까운 보물 같은 위시 리스트" /></p>
                    <dl>
                        <dt><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90144/m/txt_wish_on.png" alt="위시"></dt>
                        <dd><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90144/m/txt_list_on.png" alt="리스트"></dd>
                    </dl>
                </div>
                <div class="sort">
                    <p class="bg-img"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90144/m/bg_img.png?v=1.03 alt="someone's wish collection" /></p>

                    <% if isParticipation then %>                    
                    <button class="wishgo" onclick="return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90144/m/btn_off.png" alt="내 위시 공유 완료!"></button>
                    <% else %>
                    <button class="wishgo" onclick="shareWishFolder();"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90144/m/btn_on.png" alt="위시 공유하기"></button>
                    <% end if %>                  
                                        
                    <div class="sort">
                        <a href="javascript:fnSort(1);" class="<%=chkIIF(orderoption=1, "active", "")%>">인기순</a>
                        <a href="javascript:fnSort(2);" class="<%=chkIIF(orderoption=2, "active", "")%>">최신순</a>
                    </div>
                </div>
                <div class="cont" id="cont">
                    <ul>
                        <!-- for dev msg : 참여 후_내위시 class="joined"-->
                        <% if userWishFolderO.FResultCount > 0 then %>
                        <% 
                        dim itemArr, itemImg, itemId, vUserid, vFidx, testobj, vViewCnt, vIdx, isVVIP, myBtnImg, isMyWish, myId
                        set testobj = new UserWishFolder
                        For i = 0 to userWishFolderO.FResultCount -1 
                        vUserid = userWishFolderO.FItemList(i).Fuserid
                        vFidx = userWishFolderO.FItemList(i).Ffidx 	
                        vViewCnt = userWishFolderO.FItemList(i).Fviewcnt	
                        vIdx = userWishFolderO.FItemList(i).Fidx	
                        itemArr = userWishFolderO.GetMyItems(vUserid,vFidx)
                        isVVIP = chkIIF(userWishFolderO.FItemList(i).Fuserlevel = 4, " class=""vvip""", "") 	
                        isMyWish = (vUserid = userid)
                        myBtnImg = chkIIF(isMyWish, "http://webimage.10x10.co.kr/fixevent/event/2018/90144/m/btn_more_on.png", "http://webimage.10x10.co.kr/fixevent/event/2018/90144/m/btn_more.png") 																
                        myId = chkIIF(isMyWish, vUserid, printUserId(vUserid,2,"*"))
                        %>								                        
                        <li <%=chkIIF(isMyWish, "class=""joined""", "")%>>
                            <span>
                                <% if isArray(itemArr) then %>	
                                    <% for y=0 to uBound(itemArr,2) %>	
                                    <% if isApp = 1 then %>										
                                        <a href="" onclick="TnGotoProduct('<%=itemArr(0,y)%>'); addViewCnt(<%=vIdx%>); return false;"><img src="<%=getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(itemArr(0,y))&"/"&itemArr(1,y),240,240,"true","false")%>" alt=""></a>                                                                        
                                    <% else %>
                                        <a href="/category/category_itemPrd.asp?itemid=<%=itemArr(0,y)%>" onclick="addViewCnt(<%=vIdx%>);"><img src="<%=getThumbImgFromURL("http://webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(itemArr(0,y))&"/"&itemArr(1,y),240,240,"true","false")%>" alt=""></a>
                                    <% end if %>                                        
                                    <% next %>	
                                <% end if %>									
                            </span>
                            <div>
                                <b <%=isVVIP%>><%=myId%></b>님의 위시
                                <p>view <em><%=FormatNumber(vViewCnt ,0)%></em></p>                                
                                <button type="button" onclick="fnViewUserWish('<%=tenEnc(vUserid)%>', <%=vIdx%>);"><img src="<%=myBtnImg%>" alt=""></button>                                
                            </div>
                        </li>   
                        <% next %>                  
                        <% end if %>
                    </ul>
                <% if userWishFolderO.FResultCount > 0 then %>
                    <div class="pageWrapV15">
                    <%= fnDisplayPaging_New(page,userWishFolderO.FTotalCount,6,5,"jsGoPage") %>
                    </div>                            
                <% end if %>                                
                    <div class="notice">
                        <p class="bg-img"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90144/m/bg_notice.png" alt=""></p>
                        <ol>
                            <li>본 이벤트는 하나의 ID당 1번 응모 가능합니다. </li>
                            <li>당첨자는 20명으로, 11월 12일 공지사항을 통해 발표합니다.</li>
                            <li>공개 설정되어있는 위시리스트 폴더에 <br />총 4가지 이상의 상품을 담아주셔야 응모가 가능합니다.</li>
                            <li>기프트카드는 11월 19일에 일괄 지급될 예정입니다.</li>
                        </ol>
                    </div>
                </div>
                <!-- 레이어 -->
                <div id="lyrSch" class="layer-popup">
                        <div class="layer">
                            <form name="frm" method="post">
                            <input type="hidden" name="eventid" value="<%=eCode%>">
                            <input type="hidden" name="returnurl" value="<%=vreturnurl%>">
                            <input type="hidden" name="itemCnt" value=""> 
                            <input type="hidden" name="selfidx" value="">                                                  
                            <h3><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90144/m/pop_txt.png" alt="공유할 폴더를 선택해주세요"></h3>
                            <% if userid <> "" then %>
                            <ul>
                                <% if userWishFolderO.FUfolderTotalCount > 0 then %>
                                    <% For i = 0 to userWishFolderO.FUfolderTotalCount -1  %>
                                        <li><button type="button" onclick="setItemCnt(<%=userWishFolderO.FFolderItemList(i).FUitemCnt%>,<%=userWishFolderO.FFolderItemList(i).FUfidx%> );"><span class="label open">공개</span><span class="name"><%=userWishFolderO.FFolderItemList(i).FUfoldername%> (<%=userWishFolderO.FFolderItemList(i).FUitemCnt%>)</span></button></li>                                                                                 
                                    <% next %>                               
                                <% end if %>
                            </ul>
                            <% end if %>
                            <button class="layer-btn" type="button" onclick="fnShare()"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90144/m/pop_btn.png" alt="위시 공유하기" /></button>
                            <a href="javascript:void(0);" class="btn-close"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90144/pop_btn_close.png" alt="닫기"></a>
                            </form>                            
                        </div>
                        <div class="mask"></div>
                    </div>
            </div>
<form name="frmsearch" method="post">
<input type="hidden" name="ucid" value="">
</form>				
<% if isapp = 1 then %>
<form name="pageFrm" method="get" action="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%=eCode%>">
<% else %>
<form name="pageFrm" method="get" action="/event/eventmain.asp?eventid=<%=eCode%>">
<% end if %>
	<input type="hidden" name="eventid" value="<%=eCode%>">
	<input type="hidden" name="pagereload" value="ON">
	<input type="hidden" name="page" value="">				
	<input type="hidden" name="orderoption" value="<%=orderoption%>">					
</form>            
<!-- #include virtual="/lib/db/dbclose.asp" -->