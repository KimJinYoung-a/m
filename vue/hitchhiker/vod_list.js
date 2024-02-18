Vue.component('Video-List',{
	template : `
		<div class="vod_list">
			<article
				v-for="(video, index) in videos"
				:key="video.content_idx"
				class="vod_item"
			>
				<div class="player">
					<div class="thumb"
						:style="{ 'background-image': 'url(' + video.thumbnail_image + ')' }"
						@click="control_vod($event, index, video)"
					></div>
					<div class="vod">
						<iframe :src="video.video_url + '?enablejsapi=1&rel=0&playsinline=1'" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
					</div>
				</div>
				<div class="vod_info">
					<div class="label_vol">vol.<b>{{ video.title }}</b></div>
					<div class="vod_name">{{ video.sub_copy }}</div>
				</div>
			</article>
		</div>
	`,
	props : {
		isApp : { type : Boolean, default : false }, // 앱 여부
		videos : {
			content_idx : { type: Number, default: 0 },
			thumbnail_image : { type : String, default : '' },
			title : { type : String, default : '' },
			sub_copy : { type : String, default : '' },
			video_url : { type : String, default : '' },
		}
	},
	methods : {
		control_vod(e, index, video) {
			fnAmplitudeEventMultiPropertiesAction('click_hitchhiker_video'
					, 'item_index|itemid', `${index}|${video.content_idx}`); // 클릭 Amplitude 이벤트 전송
			$(e.target).fadeOut(400);
			$(e.target).next('.vod').children('iframe')[0].contentWindow.postMessage('{"event":"command","func":"' + 'playVideo' + '","args":""}', '*');
		},
	}
})