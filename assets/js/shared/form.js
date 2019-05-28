/* storeParagraphContainerMarkup() : unmounted DOM element
 * In order to add more editable paragraphs to the page, we need to store the markup of an editable paragraph.
 * This function grabs the first mounted editable paragraph DOM element. It then clones it, strips the content/header, 
 * and returns the empty clone. It is up to the caller of this function to store the returned empty editable paragraph. 
 */
export function storeParagraphContainerMarkup() {
  if (document.querySelector(".paragraph-container") === null) {
    throw new Error('storeParagraphContainerMarkup called on a page with no editable paragraph elements.')
  }

  let paragraphMarkup = document.querySelector(".paragraph-container").cloneNode(true)
  paragraphMarkup.children[1].setAttribute("value", "")
  paragraphMarkup.children[3].children[0].innerHTML = ""
  paragraphMarkup.children[3].children[1].setAttribute("style", "display: none;")
  paragraphMarkup.children[3].children[1].children[0].removeAttribute("src")
  return paragraphMarkup
}

/* getParagraphs() : [ { header: String, content: String, order: Number }, ... ]
 * This function gets all paragraph headers and contents and assembles them into an array of objects. Each object stores
 * the order that the paragraph appears on the page.
 */
export function getParagraphs() {
  let paragraphs = []

  const headerEls = document.getElementsByClassName("paragraph-header")
  const contentContainerEls = document.getElementsByClassName("paragraph-content-container")

  for (let i = 0; i < headerEls.length; i += 1) {
    const params = {
      header: headerEls[i].value,
      content: contentContainerEls[i].querySelector("textarea").value,
      order: i
    }

    if (contentContainerEls[i].querySelector("img").getAttribute("src")) {
      const split_img_src = contentContainerEls[i].querySelector("img").getAttribute("src").split("___")
      if (split_img_src.length === 2) {
        params.asset_id = split_img_src[0].split('/')[split_img_src[0].split('/').length - 1]
      }
    }

    paragraphs.push(params)
  }

  return paragraphs
}

export function addNewEditableParagraph(paragraphMarkup, imageUploaderChannel) {
  const paragraphContainers = document.getElementsByClassName("paragraph-container")
  paragraphContainers[paragraphContainers.length - 1].insertAdjacentHTML("afterend", paragraphMarkup.outerHTML)

  const deleteParagraphButtons = document.getElementsByClassName("delete-paragraph-button")
  const newDeleteParagraphButton = deleteParagraphButtons[deleteParagraphButtons.length - 1]
  newDeleteParagraphButton.addEventListener("click", () => deleteParagraph(newDeleteParagraphButton))

  const paragraphImageInputs = document.querySelectorAll("input[type=file][accept='image/*'][data-type=paragraph]")
  const newParagraphImageInput = paragraphImageInputs[paragraphImageInputs.length - 1]
  const paragraphImageContainers = document.querySelectorAll(".paragraph-image-container")
  const newParagraphImageContainer = paragraphImageContainers[paragraphImageContainers.length - 1]

  newParagraphImageInput.addEventListener("change", () => uploadAssetFactory({ assetType: 'paragraph' })(newParagraphImageInput, imageUploaderChannel, { paragraphImageContainer: newParagraphImageContainer }))
}

export function deleteParagraph(deleteButtonEl) {
  if (document.getElementsByClassName("paragraph-container").length === 1) {
    return
  }

  deleteButtonEl.parentElement.parentElement.outerHTML = ''
}

export const uploadAssetFactory = ({ assetType }) => (imageInput, imageUploaderChannel, opts) => {
  const image = imageInput.files[0]

  if (!image) {
    return
  }

  const reader = new FileReader()
  reader.onload = function({target: {result}}) {
    let array = new Uint8Array(result)
    const payload = { raw_bytes: array, filename: image.name }

    imageUploaderChannel.push("upload", payload).receive("ok", ({filename, uri, id}) => {
      const image = new Image()
      const asset_location = `/images/content/originals/${uri}`
      image.src = asset_location

      switch (assetType) {
        case 'header':
          const { headerImageContainer } = opts

          image.onload = () => {
            headerImageContainer.setAttribute("style", "")
            headerImageContainer.children[0].setAttribute("src", asset_location)
            headerImageContainer.children[1].innerHTML = filename
          }
          break
        case 'paragraph':
          const { paragraphImageContainer } = opts

          image.onload = () => {
            paragraphImageContainer.setAttribute("style", "")
            paragraphImageContainer.children[0].setAttribute("src", asset_location)
            paragraphImageContainer.children[1].innerHTML = filename
          }
          break
        case 'other':
          break
        default:
          break
      }

      image.onerror = () => setTimeout(() => image.src = asset_location, 1000)
    }).receive("error", console.error)
  }

  reader.readAsArrayBuffer(image)
}

export function getHeaderAssetId() {
  const src = document.querySelector('.header-image').getAttribute("src")

  if (!src) {
    return void 0
  }

  const split_img_src = src.split("___")

  if (split_img_src.length === 2) {
    return split_img_src[0].split('/')[split_img_src[0].split('/').length - 1]
  } else {
    return void 0
  }
}
