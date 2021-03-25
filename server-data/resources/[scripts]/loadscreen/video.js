function onYouTubeIframeAPIReady() {
  var player;
  player = new YT.Player('YouTubeBackgroundVideoPlayer', {
      videoId: '3jW86-Kspd4', // YouTube Video ID
      width: 1920,               // Player width (in px)
      height: 1080,              // Player height (in px)
      playerVars: {
        playlist: '3jW86-Kspd4',
          autoplay: 1,        // Auto-play the video on load
          autohide: 1,
          disablekb: 1, 
          controls: 0,        // Hide pause/play buttons in player
          showinfo: 0,        // Hide the video title
          modestbranding: 1,  // Hide the Youtube Logo
          loop: 1,            // Run the video in a loop
          fs: 0,              // Hide the full screen button
          autohide: 0,         // Hide video controls when playing
          rel: 0,
          enablejsapi: 1
      },
      events: {
        onReady: function(e) {
            e.target.mute();
            e.target.setPlaybackQuality('hd1080');
        },
        onStateChange: function(e) {
          if(e && e.data === 1){
              var videoHolder = document.getElementById('home-banner-box');
              if(videoHolder && videoHolder.id){
                videoHolder.classList.remove('loading');				
              }
			  
			  var x = document.getElementById("myAudio");
				x.play();
				x.volume = 0.12;
          }else if(e && e.data === 0){
            e.target.playVideo()
          }
        }
      }
  });
}