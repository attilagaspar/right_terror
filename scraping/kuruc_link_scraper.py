import requests
from bs4 import BeautifulSoup
import pandas as pd
import time

# Starting and ending URL numbers
start_num = 3160
end_num = 16120
increment = 20

# Base URL with placeholder for the number
base_url = "https://kuruc.info/to/35/{}/"

# List to store extracted data
data = []

# Loop over the range of URLs
for num in range(start_num, end_num + 1, increment):
    print(num)
    # Construct the URL for the current iteration
    url = base_url.format(num)
    
    # Send a request to the webpage
    try:
        response = requests.get(url)
        response.raise_for_status()  # Check if request was successful
        print(f"Scraping {url}")
        
        # Parse the page content
        soup = BeautifulSoup(response.text, 'html.parser')
        
        # Find all <a> tags with the specified class
        links = soup.find_all('a', class_="alcikkheader alcikktovabb")
        
        # Extract URL and text from each link
        for link in links:
            link_url = link.get('href')
            link_text = link.get_text(strip=True)
            data.append({'URL': link_url, 'Text': link_text})
    
    except requests.RequestException as e:
        print(f"Failed to scrape {url}: {e}")
    
    # Pause between requests to avoid overloading the server
    time.sleep(1)

# Convert the data list into a DataFrame and save to CSV
df = pd.DataFrame(data)
df.to_csv('scraped_links.csv', index=False)

print("Scraping complete. Data saved to 'scraped_links.csv'.")
