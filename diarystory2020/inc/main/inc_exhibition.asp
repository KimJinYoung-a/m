<%
public function couponDisp(couponVal)
	if couponVal = "" or isnull(couponVal) then exit function
	couponDisp = chkIIF(couponVal > 100, couponVal, couponVal & "%")
end function
	dim hoteventlist
	set hoteventlist = new cdiary_list
		hoteventlist.FCurrPage  = 1
		hoteventlist.FPageSize	= 5
		hoteventlist.FselOp		= 0 '0 신규순 1 종료 임박 2 인기순
		hoteventlist.FEvttype   = "1"
		hoteventlist.Fisweb	 	= "0"
		hoteventlist.Fismobile	= "1"
		hoteventlist.Fisapp	 	= "1"
		hoteventlist.fnGetdievent
%>

		<section class="diary-evt" id="diaryNav2">
			<div class="diary-nav">
				<ul>
					<li><a href="#diaryNav1">추천 문구템</a></li>
					<li class="on"><a href="#diaryNav2">기획전</a></li>
					<li><a href="#diaryNav3">다이어리 찾기</a></li>
				</ul>
			</div>
			<% If hoteventlist.FResultCount > 0 Then  %>
			<div class="diary-card cont4">
				<ul>
				<% 
				dim tmp
				FOR i = 0 to hoteventlist.FResultCount-1 				
				%>
					<li>
					<% if isapp = 1 then %>
						<a href="javascript:fnAPPpopupEvent('<%=hoteventlist.FItemList(i).fevt_code %>');">
					<% else %>
						<a href="/event/eventmain.asp?eventid=<%=hoteventlist.FItemList(i).fevt_code %>">
					<% end if %>					
							<div class="thumbnail">
								<img src="<%=hoteventlist.FItemList(i).fevt_mo_listbanner %>" alt="" />
								<!-- for dev msg: 사은품 증정 -->
								<div class="badge-group">
									<% If hoteventlist.FItemList(i).fisgift Then %>
									<div class="badge badge-count2 badge-count2-gift">
										<em>사은품증정</em>
									</div>
									<% End If %>
									<% If hoteventlist.FItemList(i).fisfreedelivery Then %>
									<div class="badge badge-count2">
										<em>무료배송</em>
									</div>								
									<% End If %>
								</div>	
							</div>
							<div class="desc">
								<div class="tit ellipsis"><%=split(hoteventlist.FItemList(i).FEvt_name,"|")(0)%></div>
								<div class="subcopy">
									<span><%=hoteventlist.FItemList(i).FEvt_subcopyK%></span>
									<% if hoteventlist.FItemList(i).fissale and hoteventlist.FItemList(i).FSalePer <> "" and hoteventlist.FItemList(i).FSalePer <> "0"  then %><em class="discount sale">~<%=hoteventlist.FItemList(i).FSalePer%>%</em><% end if %>
									<% if hoteventlist.FItemList(i).fiscoupon and hoteventlist.FItemList(i).FSaleCPer <> "" and hoteventlist.FItemList(i).FSaleCPer <> "0" then %><em class="discount coupon"> <%=couponDisp(hoteventlist.FItemList(i).FSaleCPer)%></em><% end if %>									
								</div>
							</div>
						</a>
					</li>
				<% next %>
				</ul>
				<a href="" class="btn-down btn-item-more" style="display:<%=chkIIF(i > 2, "","none")%>">기획전 더보기</a>				
			</div>
			<% end if %>
		</section>