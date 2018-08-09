from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.keys import Keys
import selenium.webdriver
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
from selenium.webdriver.common.action_chains import ActionChains
import time
import csv
import re


driver = webdriver.Chrome(r'C:\Users\Shani Fisher\Downloads\Selenium\chromedriver_win32\chromedriver.exe')

driver.implicitly_wait(5)
driver.get("https://play.google.com/store/apps/details?id=com.google.android.apps.maps&hl=en_US&showAllReviews=true")
#this is to click on the reviews button tab thing
#driver.find_element_by_xpath("""//span[@class="RveJvd snByac"]""").click()
csv_file = open('Google_maps_new.csv', 'wb')
writer = csv.writer(csv_file)



SCROLL_PAUSE_TIME = 1

# Get scroll height
last_height = driver.execute_script("return document.body.scrollHeight")
num_scrolls = 0

while num_scrolls < 100:
	try:

		showmore = driver.find_element_by_xpath('//div[@class="U26fgb O0WRkf oG5Srb C0oVfc n9lfJ"]') 
		#//div[@role="button"]')
		#actions = ActionChains(driver)
		#actions.move_to_element(showmore).perform()
		showmore.click()
		
		print('click one time')


	except:
		try:
			showmore = driver.find_element_by_xpath('//div[@class="U26fgb O0WRkf oG5Srb C0oVfc n9lfJ M9Bg4d"]') 
			#//div[@role="button"]')
			showmore.click()
			print('click two time')
			# Scroll down to bottom
		except:
			driver.execute_script("window.scrollTo(0, document.body.scrollHeight - 800);")

			# Wait to load page
			time.sleep(SCROLL_PAUSE_TIME)
			num_scrolls += 1


			# Calculate new scroll height and compare with last scroll height
			new_height = driver.execute_script("return document.body.scrollHeight")
			if new_height == last_height:
				break	
			last_height = new_height
			time.sleep(3)
			print('scoll once')

			
			continue






#could try doing this by find by xpath and then put the xpath and do the click after send keys before it should go back up		
#.WebDriverWait(driver, 150).until(
		#EC.visibility_of_element_located((By.XPATH, '//span[@class="X43Kjb"]'))
		#)
wait_review = WebDriverWait(driver, 15)


# reviews = wd.findElements(By.className("jsdata"));
reviews = wait_review.until(EC.presence_of_all_elements_located((By.XPATH,
	'//div[@jscontroller="H6eOGe"]')))
		
		#print('=' * 50)
		#print(len(reviews))
		#print('=' * 50)
		#reviews.send_keys(Keys.NULL)

for review in reviews:
	review_dict={}

	

	user = review.find_element_by_xpath('.//span[@class="X43Kjb"]').text.encode('ascii', 'ignore').decode('ascii')
	print(user)
 	print('=' * 50)

 	stars=review.find_element_by_xpath('.//div[@class="pf5lIe"]/div').get_attribute('aria-label').encode('ascii', 'ignore').decode('ascii')
 	print(stars)
 	print('=' * 50)

 	text=review.find_element_by_xpath('.//span[@jsname="bN97Pc"]').text.encode('ascii', 'ignore').decode('ascii')
 	print(text)
 	print('=' * 50)

 	date=review.find_element_by_xpath('.//span[@class="p2TkOb"]').text.encode('ascii', 'ignore').decode('ascii')
 	print(date)
 	print('=' * 50)

 	helpful=review.find_element_by_xpath('.//div[@class="jUL89d y92BAb"]').text.encode('ascii', 'ignore').decode('ascii')
 	# if helpful == []:
 	# 	helpful == list([0])
 	# else:
 	# 	pass
 	print(helpful)
 	print('='* 50)

 	review_dict['user']=user
 	review_dict['stars']=stars
 	review_dict['text']=text
 	review_dict['date']=date
 	review_dict['helpful']=helpful
 	writer.writerow(review_dict.values())

csv_file.close()
driver.close()

