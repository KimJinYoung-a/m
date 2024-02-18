var exhibition_component = {
    template : `
    <section v-if="items != null && items.length > 0" class="item_module">
		<header class="head_type1">
			<span class="txt">어머 이건 봐야해</span>
			<h2 class="ttl">눈여겨 볼 기획전</h2>
		</header>
		<Event-List-Md
		    :exhibitions="items"
		></Event-List-Md>
	</section>
    `,
    props : {
        items: { // 배너 리스트
            evt_code : Number,
            evt_name : String,
            banner_img : String,
            sale_and_coupon : String,
            badge1 : String,
            badge2 : String,
            move_url : String,
            wish_yn : Boolean
        }
    }
};