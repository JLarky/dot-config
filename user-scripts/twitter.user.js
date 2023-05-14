// ==UserScript==
// @name        no feed by jlarky
// @namespace   Violentmonkey Scripts
// @match       *://*.twitter.com/*
// @grant       none
// @version     0.0.0
// @author      @jlarky
// ==/UserScript==

function handleMutation(mutations) {
  try {
    for (let mutation of mutations) {
      for (let elem of mutation.addedNodes) {
        if ("querySelector" in elem) {
          const main = elem.querySelector('[data-testid="primaryColumn"]');
          if (
            main != null &&
            (location.pathname === "/" || location.pathname === "/home")
          ) {
            console.log(main);
            console.log(main != null);
            main.style.opacity = "0";
          }
          const dm = elem.querySelector('[data-testid="DMDrawer"]');
          if (dm !== null) dm.style.opacity = "0";
          const badge = elem.querySelector('[aria-label*="unread items"]');
          console.log(badge);
          if (badge !== null) dm.style.opacity = "0";
        }
      }
    }
  } catch (e) {
    console.error(e);
  }
}

if (new Date().getTime() > 1683160604718 + 100000) {
  const observer = new MutationObserver(handleMutation);
  observer.observe(document, { childList: true, subtree: true });
}
