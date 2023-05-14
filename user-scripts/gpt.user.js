// ==UserScript==
// @name        don't leak gpt by jlarky
// @namespace   Violentmonkey Scripts
// @match       https://chat.openai.com/*
// @grant       none
// @version     0.0.0
// @downloadURL https://github.com/JLarky/dot-config/raw/master/user-scripts/gpt.user.js
// @updateURL   https://github.com/JLarky/dot-config/raw/master/user-scripts/gpt.user.js
// @author      @jlarky
// ==/UserScript==

/**
 * https://twitter.com/ParasocialFix/status/1657783455885975553
 */

const timeMs = 1000;

function handleMutation(mutations) {
  try {
    for (let mutation of mutations) {
      for (let elem of mutation.addedNodes) {
        if ("querySelector" in elem) {
          const main = elem.querySelectorAll("[data-projection-id] a");
          if (main.length > 0) {
            main.forEach((e) => {
              const text = e.querySelector(".text-ellipsis") || e;
              // I think it only happens once, but just in case:
              if (e.dataset.jlarky === "true") return;
              e.dataset.jlarky = "true";
              // let's go
              const show = () => {
                text.style.transition = "all 0.2s ease-in-out";
                text.style.opacity = "1";
                text.style.filter = "blur(0px)";
              };
              const hide = () => {
                e.style.transition = `all ${timeMs / 1000}s ease-in-out`;
                text.style.opacity = "0.8";
                text.style.filter = "blur(8px)";
              };
              hide();
              e.addEventListener("mouseover", () => {
                show();
              });
              e.addEventListener("mouseout", () => {
                hide();
              });
            });
          }
        }
      }
    }
  } catch (e) {
    console.error(e);
  }
}

const snoozeUntil = new Date("2023-05-14T09:00:00.000");

if (new Date().getTime() > snoozeUntil.getTime()) {
  const observer = new MutationObserver(handleMutation);
  observer.observe(document, { childList: true, subtree: true });
}
