// TODO review & implement helpful comments in assets/js/socket.js

import { Socket } from "phoenix"

let channel = void 0

function assignEventHandlersToPage() {
  let deleteButton = document.querySelector("#delete-button")
  deleteButton.addEventListener('click', () => {
    channel.push("delete", {})
    window.location = "/"
  })
}

(function () {
  const id = window.location.pathname.split('/')[2]
  let socket = new Socket("/socket", {params: {token: window.userToken}})

  socket.connect()

  const channel_id = `subject:${id}`

  channel = socket.channel(channel_id, {})

  channel.join()
    .receive("ok", resp => {
      console.log(`Joined ${channel_id} successfully`, resp)
      assignEventHandlersToPage() 
    })
    .receive("error", resp => { console.log(`Unable to join ${channel_id}`, resp) })
})()
