		<!-- 퀴즈 -->
		<!-- for dev msg 
		 - 10문제씩 노출 됩니다.
		 - 문제 타입별로 typeA-1/ typeA-2 / typeA-3 / typeB 클래스 추가 (힌트레이어에도 동일 적용)
		-->    
		<div class="quiz">
			<ol class="q-list">				
                <% If questionType = 1 Then %>
                    <%' type A %>	
                    <li id="q<%=questionNumber%>" class="q<%=questionNumber%> typeA-<%=numOfType1Image%>">
                        <div class="num" id="countdown"></div>
                        <div class="txt"><p><%=question%></p></div>
                        <div class="image-cont">
                            <% For i=0 To numOfType1Image -1 %>
                            <div class="thumbnail"><img src="<%=type1imageArr(i)%>" alt="" /></div>        
                            <% Next %>                            
                        </div>
                        <div class="answer">
                            <div class="choice">
                                <span><%=questionExample1%></span>
                            </div>
                            <div class="choice">
                                <span><%=questionExample2%></span>
                            </div>
                            <div class="choice">
                                <span><%=questionExample3%></span>
                            </div>
                            <div class="choice">
                                <span><%=questionExample4%></span>
                            </div>
                        </div>
                        <div class="page"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/txt_pagination_<%=questionNumber%>.png" alt="" /></div>
                    </li>           
                <% Else %>
                    <%' type B %>											
                    <li id="q<%=questionNumber%>" class="q<%=questionNumber%> typeB">
                        <p class="num" id="countdown"></p>
                        <div class="txt"><p><%=question%></p></div>
                        <div class="answer">
                            <div class="choice">
                                <div class="thumbnail"><img src="<%=questionExample1img%>" alt="" /></div>   
                                <span><%=type2TextExample1%></span>                             
                            </div>
                            <div class="choice">
                                <div class="thumbnail"><img src="<%=questionExample2img%>" alt="" /></div>                                
                                <span><%=type2TextExample2%></span>                             
                            </div>
                            <div class="choice">
                                <div class="thumbnail"><img src="<%=questionExample3img%>" alt="" /></div>                                
                                <span><%=type2TextExample3%></span>                             
                            </div>
                            <div class="choice">
                                <div class="thumbnail"><img src="<%=questionExample4img%>" alt="" /></div>                                
                                <span><%=type2TextExample4%></span>                             
                            </div>
                        </div>
                        <div class="page"><img src="http://webimage.10x10.co.kr/playing/thing/vol040/m/txt_pagination_<%=questionNumber%>.png" alt="" /></div>
                    </li>                   
                <% End if %>	
			</ol>
		</div>
		<!--// 퀴즈 -->