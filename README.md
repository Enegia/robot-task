Set up environment for running robot tests:
-------------------------------------------
1. Install Python 2.7
2. Install pip
3. Run `pip install -r requirements.txt`
4. Download webdriver for your browser (for Chrome/Chromium: https://chromedriver.chromium.org/) 
5. Download Selenium from https://selenium.dev/downloads/

Run tests against test environment:
--------------------------------------
1. Start a Selenium server (java -jar selenium-server-standalone-3.10.0.jar)
2. Run `robot -A local.args`
