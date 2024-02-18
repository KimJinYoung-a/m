<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : CRM 등급업 이벤트
' History : 2018-11-23 이종화
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<%
    dim strSql , userid , eCode
    dim eventcnt : eventcnt = 0
    userid  = GetencLoginUserID

    IF application("Svr_Info") = "Dev" THEN
        eCode = "89196"
    Else
        eCode = "90660"
    End If

    if userid <> "" then 
        strSql = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] where evt_code ="& eCode &" and userid = '"& userid &"'"
        rsget.Open strSql, dbget, 1
        IF Not rsget.Eof Then
            eventcnt = rsget(0)
        End IF
        rsget.Close
    end if 
%>
<style type="text/css">
<% if eventcnt = 0 then  %>
.mEvt90660 {position:relative;}
.mEvt90660 a {display:inline-block; position:absolute; bottom:31.12%; left:16.2%; width:67.6%;}
<% else %>
.mEvt90660 {background-color:#f4f4f4;}
.mEvt90660 > div {position:relative; width:32rem; height:8.75rem; margin:0 auto; background:url(http://webimage.10x10.co.kr/fixevent/event/2018/90660/m/bg_curation.jpg) no-repeat 0 0; text-align:center;}
.mEvt90660 > div p {display:inline-block; position:relative; margin-right:10.11rem; padding:2.56rem 0 .85rem; font-size:1.8rem; color:#fff280; font-weight:bold;}
.mEvt90660 .t1 {display:inline-block; position:absolute; right:-10.11rem; width:9.56rem;}
.mEvt90660 .t2 {display:inline-block; width:8.7rem;}
.mEvt90660 ul {overflow:hidden; width:32rem; margin:0 auto; background-color:#fff;}
.mEvt90660 ul li {float:left; position:relative; width:10.64rem; height:10.64rem;}
.mEvt90660 ul li a {display:inline-block; position:absolute; top:0; left:0; z-index:10; width:100%; height:100%;}
.mEvt90660 ul li i {display:inline-block; position:relative; width:100%; height:100%; border-top:solid #fff .085rem; border-left:solid #fff .085rem}
.mEvt90660 ul li:nth-child(3n-2) i {border-left:0;}
.mEvt90660 ul li i:before {display:inline-block; position:absolute; top:0; left:0; width:100%; height:100%; background-color:rgba(0,0,0,.05); content:' ';}
.mEvt90660 ul li i img {display:inline-block; width:100%; height:100%;}
<% end if %>
</style>
<script>
function fnChkEvt(){
    <% If IsUserLoginOK() Then %>
        <% if eventcnt = 0 then %>
            var frm = document.frmevtchk;
            frm.action="/event/etc/ratingup/ratingup_proc.asp";
            frm.submit();
        <% end if %>
	<% Else %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End IF %>
}
</script>
<% if eventcnt = 0 then  %>
<%'!-- 첫화면 --%>
<div class="mEvt90660" id="beforelayer">
    <h2><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90660/m/tit_curation.jpg?v=1.01" alt="한 번만 더 구매하면 등업 예정인 고객님을 위해상품을 추천해드립니다!" /></h2>
    <a href="" onclick="fnChkEvt();return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90660/m/btn_curation.png?v=1.01" alt="추천 상품 확인하기" /></a>
</div>
<%'!-- 첫화면 --%>
<form name="frmevtchk" method="post" action="">
<input type="hidden" name="eventid" value="<%=eCode%>"/>
</form>
<% else %>
<%
    Dim rsMem, sqlStr, i, pItemArr, FResultCount, lp
    sqlStr = "EXEC db_temp.dbo.usp_WWW_TenEvent_MyRecommendItems_List '" & userId & "'"

    set rsMem = getDBCacheSQL(dbget,rsget,"MyRecommendItems",sqlStr,60*30)

    if (rsMem is Nothing) then 
        response.write ""
        response.end
    end if

    FResultCount = rsMem.RecordCount
    redim preserve FItemList(FResultCount)

    i=0
    if not rsMem.EOF then
        do until rsMem.eof
            set FItemList(i) = new CCategoryPrdItem

            FItemList(i).FItemID		= rsMem("itemid")
            FItemList(i).FImageList120	= "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(rsMem("itemid")) + "/" + rsMem("listimage120")
            
            i=i+1
            rsMem.moveNext
        loop
    end if
    rsMem.Close
%>
<div class="mEvt90660 curation" id="afterlayer">
    <div>
        <p><%=userId%><span class="t1"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90660/m/txt_curation_1.png" alt="고객님을위한"></span></p><br />
        <span class="t2"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90660/m/txt_curation_2.png" alt="추천상품"></span></span>
    </div>
    <%'!-- for dev msg 45개의 상품 노출 --%>
    <ul>
        <% 
            if FResultCount>0 then
                For lp = 0 To FResultCount - 1
                    if isapp = 1 then 
        %>
            <li><a href="" onclick="fnAPPpopupProduct_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=FItemList(lp).FItemID%>&pEtr=<%=eCode%>');return false;"><i><img src="<%=FItemList(lp).FImageList120 %>" alt=""></i></a></li>
        <% 
                    else
        %>
            <li><a href="/category/category_itemprd.asp?itemid=<%=FItemList(lp).FItemID%>&pEtr=<%=eCode%>"><i><img src="<%=FItemList(lp).FImageList120 %>" alt=""></i></a></li>
        <%
                    end if 
                next
            end if 
        %>
    </ul>
</div>
<% end if %>
<!-- #include virtual="/lib/db/dbclose.asp" -->