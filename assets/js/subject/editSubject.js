import { Socket } from "phoenix"
import {
  addNewEditableParagraph,
  deleteParagraph,
  getParagraphs,
  getHeaderAssetId,
  storeParagraphContainerMarkup,
  uploadAssetFactory
} from '../shared/form'

let EDIT_SUBJECT_CHANNEL
let IMAGE_UPLOADER_CHANNEL
let paragraphMarkup = storeParagraphContainerMarkup()

function setupHeaderImageUploading() {
  const headerImageInput = document.querySelector("input[type=file][accept='image/*'][data-type=header]")
  const headerImageContainer = document.querySelector(".header-image-container")
  const uploadHeaderImageFn = uploadAssetFactory({assetType: 'header'})
  headerImageInput.addEventListener("change", () => uploadHeaderImageFn(headerImageInput, IMAGE_UPLOADER_CHANNEL, { headerImageContainer }))
}

function setupParagraphImageUploading() {
  const paragraphImageInputs = document.querySelectorAll("input[type=file][accept='image/*'][data-type=paragraph]")
  const paragraphImageContainers = document.querySelectorAll(".paragraph-image-container")
  for (let i = 0; i < paragraphImageInputs.length; i += 1) {
    const el = paragraphImageInputs[i]
    const uploadParagraphImageFn = uploadAssetFactory({assetType: 'paragraph'})
    const opts = { paragraphImageContainer: paragraphImageContainers[i] }
    el.addEventListener("change", () => uploadParagraphImageFn(el, IMAGE_UPLOADER_CHANNEL, opts))
  }
}

function init() {
  const deleteParagraphButtons = document.getElementsByClassName("delete-paragraph-button")
  for (let i=0; i<deleteParagraphButtons.length; i+=1) {
    deleteParagraphButtons[i].addEventListener("click", () => deleteParagraph(deleteParagraphButtons[0]))
  }

  setupHeaderImageUploading()

  setupParagraphImageUploading()

  document.querySelector("#add-paragraph-button").addEventListener("click", () => addNewEditableParagraph(paragraphMarkup, IMAGE_UPLOADER_CHANNEL))

  document.querySelector("#submit-button").addEventListener('click', () => {
    const params = {
      name: document.querySelector("#name-field").value,
      description: document.querySelector("#description-field").value,
      paragraphs: getParagraphs(),
      header_asset_id: getHeaderAssetId(),
      image_url: `https://via.placeholder.com/${Math.ceil(Math.random() * 500 + 200)}x${Math.ceil(Math.random() * 400 + 300)}`
    }

    EDIT_SUBJECT_CHANNEL.push("submit", params).receive("ok", () => {
      window.location = `/subject/${window.location.pathname.split('/')[2]}`
    })
  })
}

(function () {
  const id = window.location.pathname.split('/')[2]
  let socket = new Socket("/socket", {params: {token: window.userToken}})
  const edit_subject_channel_id = `edit_subject:${id}`
  const image_uploader_channel_id = `image_uploader:${id}`
  socket.connect()
  EDIT_SUBJECT_CHANNEL = socket.channel(edit_subject_channel_id, {})
  IMAGE_UPLOADER_CHANNEL = socket.channel(image_uploader_channel_id, {})

  EDIT_SUBJECT_CHANNEL.join()
    .receive("ok", resp => {
      console.log(`Joined ${edit_subject_channel_id} successfully`, resp)
      IMAGE_UPLOADER_CHANNEL.join().receive("ok", resp => {
        console.log(`Joined ${image_uploader_channel_id} successfully`, resp)
        init()
      })
    })
    .receive("error", resp => { console.log(`Unable to join ${id}`, resp) })
})()
