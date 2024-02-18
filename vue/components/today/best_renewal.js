Vue.component('best-renewal',{
    props: ['items', 'update_text', 'isapp'],
    template : `
		<div @click="go_bestpage" class="best_2021">
			<div class="today_best">
				<div class="best_ment">
					<p class="now">지금 제일 잘 나가요!</p>
					<p class="rank_ment" v-html="update_text"></p>
				</div>
				<div class="icon">
					<p class="main"><img src="//fiximage.10x10.co.kr/m/2021/best/today_main.png?v=3" alt=""></p>
					<p class="book"><img src="//fiximage.10x10.co.kr/m/2021/best/today_book.png" alt=""></p>
					<p class="pen"><img src="//fiximage.10x10.co.kr/m/2021/best/today_pen.png?v=3" alt=""></p>
					<p class="clock"><img src="//fiximage.10x10.co.kr/m/2021/best/today_clock.png" alt=""></p>
				</div>
			</div>

			<template v-for="(item, index) in items">
				<Product-Item-Today-Best
					@go_item="go_item"
					:key="item.rank"
					:isApp="isapp > 0"
					:item_id="item.item_id"
					:image_url="item.list_image"
					:item_price="item.item_price"
					:sale_percent="item.sale_percent"
					:item_coupon_yn="item.item_coupon_yn"
					:item_coupon_value="item.item_coupon_value"
					:item_coupon_type="item.item_coupon_type"
					:item_name="item.item_name"
					sell_flag="Y"
					:rental_yn="item.rental_yn"
					:rank="item.rank"
					:rank_diff="item.rank_diff"
					:flag_text="item.flag_text"
					:index="index"
				></Product-Item-Today-Best>
			</template>
			<div class="gra">
				<a @click="go_bestpage" href="javascript:void(0)" class="all_rank">전체 랭킹 보러가기 <i class="i_arw_r1"></i></a>
			</div>
		</div>
	`
    , methods : {
        go_item(item_id, ranking, flag_text, event) {
            event.stopPropagation();

            fnAmplitudeEventObjectAction('click_today_best_item', {
                "item_id" : item_id
                , "ranking" : ranking
            });

            if( isapp > 0 ) {
                fnAPPpopupProductRenewal(item_id);
            } else {
                location.href = "/category/category_itemPrd.asp?itemid=" + item_id + "&flag=e";
            }
        }
        , go_bestpage(){
            fnAmplitudeEventObjectAction('click_today_best', {});

            if(isapp > 0){
                fnPopupBest("/apps/appcom/wish/web2014/list/best/best_summary2020.asp");
            }else{
                location.href = "/list/best/renewal/index2020.asp";
            }
        }
    }
})