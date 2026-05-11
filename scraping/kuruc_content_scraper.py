import os
import requests
from bs4 import BeautifulSoup
import pandas as pd
import time

# Load the links from the CSV file
df = pd.read_csv('scraped_links.csv')

# Create the folder to store the scraped content if it doesn't exist
output_folder = 'scraped_links'
os.makedirs(output_folder, exist_ok=True)

# Base URL for completing relative links
base_url = "https://kuruc.info"

# Loop over each row in the DataFrame
for index, row in df.iterrows():
    # Construct the full URL
    relative_link = row['URL']
    full_url = base_url + relative_link
    
    try:
        # Request the page content
        response = requests.get(full_url)
        response.raise_for_status()
        print(f"Scraping {full_url}")
        
        # Parse the page content
        soup = BeautifulSoup(response.text, 'html.parser')
        
        # Extract the date from the <span itemprop="datePublished">
        date_element = soup.find('span', itemprop="datePublished")
        date_text = date_element.get_text(strip=True) if date_element else 'Date not found'
        
        # Extract text content from all <div class="cikktext"> elements
        text_elements = soup.find_all('div', class_="cikktext")
        text_content = "\n".join([element.get_text(strip=True) for element in text_elements])
        
        # Define filename based on the link
        safe_link = relative_link.replace('/', '_')
        filename = f"{output_folder}/content_{safe_link}.txt"
        
        # Save the content to a text file
        with open(filename, 'w', encoding='utf-8') as file:
            file.write(f"Date: {date_text}\n\n{text_content}")
        
    except requests.RequestException as e:
        print(f"Failed to scrape {full_url}: {e}")
    
    # Pause to avoid overloading the server
    time.sleep(1)

print("Scraping complete. Individual files are saved in the 'scraped_links' folder.")
