let Hooks = {}

Hooks.PlayVideo = {
  mounted() {
    let that = this
    let tag = document.createElement('script')
    tag.id = 'iframe-demo'
    tag.src = 'https://www.youtube.com/iframe_api'
    let firstScriptTag = document.getElementsByTagName('script')[0]
    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag)

    let player = {}
    window.onYouTubeIframeAPIReady = function () {
      player = new YT.Player('video-player', {
        events: {
          'onStateChange': onPlayerStateChange
        }
      })
    }

    this.handleEvent("video_played", (payload) => {
      player.playVideo()
    })

    this.handleEvent("video_paused", (payload) => {
      player.pauseVideo()
    })

    function onPlayerStateChange(event) {
      if (event.data == 1) {
        that.pushEvent("play_video", {})
      } else if (event.data == 2) {
        that.pushEvent("pause_video", {})
      }
    }
  }
}

export default Hooks