function count() {
  const inputText = document.getElementsByClassName("input_text")[0];
  inputText.addEventListener("keyup", () => {
    const countVal = inputText.value.length;
    const charNum = document.getElementsByClassName("text_count")[0];
    charNum.innerHTML = `${countVal}文字`;
    const inputButton = document.getElementById("input_button");
    if (countVal >= 200) {
      inputButton.disabled = false;
      inputButton.classList.remove("input_button_disable");
      inputButton.classList.add("input_button");
    } else {
      inputButton.disabled = true;
      inputButton.classList.remove("input_button");
      inputButton.classList.add("input_button_disable");
    }
  });
};

window.addEventListener('turbo:load', count);
