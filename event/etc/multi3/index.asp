<%
'####################################################
' Description :  멀티3번 이벤트
' History : 2018.11.05 최종원 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/multi3EventCls.asp" -->

<%

'공통
dim evt_code, mode, i, y, z, tmpSalePer
dim encUsrId, tmpTx, tmpRn, userid, tempTagArr
dim Omulti3
tmpSalePer = 0
'콘텐츠
dim idx
dim main_copy
dim sub_copy
dim main_color
dim main_content
dim regdate
dim background_img
dim reg_name
dim content_order
dim moddate
dim mod_name

evt_code = requestCheckVar(Request("eventid"),10)

set Omulti3 = new Multi3
Omulti3.FRectEvtCode = evt_code
Omulti3.GetOneContent    

if Omulti3.FResultCount > 0 then 
    idx				= Omulti3.FOneContent.C_idx
    evt_code		= Omulti3.FOneContent.C_evt_code
    main_copy		= replace(Omulti3.FOneContent.C_main_copy, chr(13), "<br />")	
    sub_copy		= replace(Omulti3.FOneContent.C_sub_copy, chr(13), "<br />")
    main_color		= Omulti3.FOneContent.C_main_color
    main_content	= replace(Omulti3.FOneContent.C_main_content, chr(13), "<br />")	
    regdate			= Omulti3.FOneContent.C_regdate	
    background_img	= Omulti3.FOneContent.C_background_img	
    reg_name		= Omulti3.FOneContent.C_reg_name	
    content_order	= Omulti3.FOneContent.C_content_order	
    moddate			= Omulti3.FOneContent.C_moddate
    mod_name		= Omulti3.FOneContent.C_mod_name
end if

'unit
if idx <> "" then
	Omulti3.FRectContentId = idx
	Omulti3.getContentsUnitList
end if
%>    
</head>
		<div class="mEvt-multi3">
            <div class="section top">
                <!-- 타이틀 배경 이미지 -->
                <span>
                    <img src="<%=background_img%>" alt="" />
                </span>
                <!-- 타이틀 -->
                <div class="tit-area">
                    <div>
                        <h2><%=main_copy%></h2>
                        <span class="sub" style="border-bottom-color:<%=main_color%>">                        
                        <%=replace(sub_copy, chr(13), "<br />")%>
                        </span>
                    </div>
                </div>
                <!-- 프롤르그 -->
                <p>
                    <%=main_content%>
                </p>
            </div>            
<!--=================================== 유닛 ===================================-->
        <% if Omulti3.FUnitTotalCount > 0 then %>
			<% for i = 0 to Omulti3.FUnitTotalCount - 1 
				Omulti3.FRectUnitIdx = Omulti3.FUnitList(i).U_idx
				Omulti3.getUnitItemsList				
                tempTagArr = split(Omulti3.FUnitList(i).U_tag, ",")                 
			%>	
<script type="text/javascript">
$(function(){    
    //리스트 첫번째 섹션 롤링
    if ($('#rolling<%=Omulti3.FUnitList(i).U_idx%> .swiper-slide').length > 1) {
        itemSlide1 = new Swiper('#rolling<%=Omulti3.FUnitList(i).U_idx%> .swiper-container',{
            loop:true,
            autoplay:false,
            autoplayDisableOnInteraction:false,
            speed:600,
            pagination:"#rolling<%=Omulti3.FUnitList(i).U_idx%> .pagination",
            paginationClickable:true
        });
    }    
});
</script>            
            <div class="section list">
                <!-- 타이틀 -->
                <div class="tit-area">
                    <em style="background-color:<%=main_color%>">#<%=Omulti3.FUnitList(i).U_unit_class%></em>
                    <% if Omulti3.FUnitList(i).U_unit_main_copy <> "" then %>
                    <h3>
                        <%=replace(Omulti3.FUnitList(i).U_unit_main_copy, chr(13), "<br />")%>
                    </h3>
                    <% end if %>
                </div>
                <!-- 텍스트 -->
                
                    <% if Omulti3.FUnitList(i).U_unit_main_content <> "" then %>
                    <p>
                    <%=replace(Omulti3.FUnitList(i).U_unit_main_content, chr(13), "<br />")%>                    
                    </p>
                    <% end if %>                
                <!-- 태그 -->
                <% if 0 <= Ubound(tempTagArr) then %>
                <ul class="tag ">                                    
                        <% for z=0 to Ubound(tempTagArr) %>
                            <% if isapp = 1 then %>
                                <li><a href="javascript:fnSearchEventText('<%=tempTagArr(z)%>')">#<%=tempTagArr(z)%></a></li>                        
                            <% else %>
                                <li><a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=<%=tempTagArr(z)%>">#<%=tempTagArr(z)%></a></li>                        
                            <% end if %>                        
                        <% next %>                    
                </ul>
                <% end if %>
                <!-- 롤링 -->
                <div class="rolling" id="rolling<%=Omulti3.FUnitList(i).U_idx%>">
                    <div class="swiper-container">
                        <div class="swiper-wrapper">
                        <!--=============================== 아이템 ===============================-->
                        <% if Omulti3.FItemTotalCount > 0 then %>		
                            <% for y=0 to Omulti3.FItemTotalCount - 1 
                            tmpSalePer = Omulti3.getSalePer(Omulti3.FItemList(y).I_itemid)
                            %>
                            <div class="swiper-slide">
                            <% if isapp = 1 then %>
                                <a href="javascript:void(0)" onclick="fnAPPpopupProduct('<%=Omulti3.FItemList(y).I_itemid%>')">
                            <% else %>
                                <a href="/category/category_itemPrd.asp?itemid=<%=Omulti3.FItemList(y).I_itemid%>">
                            <% end if %>                                
                                    <div class="thumbnail">
                                        <!-- 상품이미지 -->
                                        <img src="<%=Omulti3.FItemList(y).I_item_img%>" alt="" />
                                    </div>
                                    <div class="desc">
                                    <% if tmpSalePer <> 0 then %>
                                    <b><%=tmpSalePer%>%</b>
                                    <% end if %>                                        
                                        <em><%=Omulti3.FItemList(y).I_item_name%></em>
                                    </div>
                                </a>
                            </div>
                            <% next %>
                         <% end if %>   
                        <!--=============================== 아이템 ===============================-->
                        </div>
                    </div>
                    <div class="pagination"></div>
                </div>
            </div>
            <% next %>            
        <% end if%>  
<!--=================================== 유닛 ===================================-->                    
	</div>