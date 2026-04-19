#!/bin/bash

vp i -g agent-browser
# sudo apt-get install chromium-browser

# # tell agent-browser to use chromium
# if ! grep -q "export AGENT_BROWSER_EXECUTABLE_PATH=/snap/bin/chromium" ~/.bashrc; then
#   echo 'export AGENT_BROWSER_EXECUTABLE_PATH=/snap/bin/chromium' >> ~/.bashrc

#   echo
#   echo "Restart your shell to apply the changes or run 'source ~/.bashrc'"
# fi

# https://github.com/vercel-labs/agent-browser/issues/107#issuecomment-3767438842
sudo apt-get install libatk1.0-0t64\
  libatk-bridge2.0-0t64\
  libcups2t64\
  libatspi2.0-0t64\
  libxcomposite1\
  libxdamage1\
  libxfixes3\
  libxrandr2\
  libgbm1\
  libcairo2\
  libpango-1.0-0\
  libasound2t64
npx playwright-core@1.57.0 install chromium

# agent-browser --executable-path /snap/bin/chromium open https://www.google.com
