<% response.Charset = "UTF-8" %>
<script>
	//카카오 SNS 공유
	Kakao.init('c967f6e67b0492478080bcf386390fdd');

	// 카카오톡 링크 버튼을 생성합니다. 처음 한번만 호출하면 됩니다.
	Kakao.Link.createTalkLinkButton({
	  //1000자 이상일경우 , 1000자까지만 전송 
	  //메시지에 표시할 라벨
	  container: '#kakaoa',
	  label: '<%=eName%>',
	  <% if evt_mo_listbanner <>"" then %>
	  image: {
		//500kb 이하 이미지만 표시됨
		src: '<%=evt_mo_listbanner%>',
		width: '200',
		height: '200'
	  },
	  <% end if %>
	   appButton: {
		text: '10X10 앱으로 이동',
		execParams :{
			android : {"url":"http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=<%=eCode%>"},
			iphone : {"url":"http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=<%=eCode%>"}
		}
	  }
	});
</script>