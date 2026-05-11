import os
import pandas as pd

# Define folder path and output CSV file name
input_folder = 'scraped_links'
output_csv = 'consolidated_data.csv'

# List to store each file's data as a row
data = []

# Loop through all text files in the folder
for filename in os.listdir(input_folder):
    if filename.endswith(".txt"):
        filepath = os.path.join(input_folder, filename)
        
        with open(filepath, 'r', encoding='utf-8') as file:
            # Read lines and remove any surrounding whitespace
            lines = [line.strip() for line in file.readlines()]
            
            # Extract date from the first line and collapse remaining lines into a single text block
            date = lines[0].replace("Date: ", "")  # Remove the "Date: " prefix
            text = " ".join(lines[1:])  # Combine text lines into one string
            
            # Clean the text by removing quotation marks
            text = text.replace('"', '').replace("'", "")
            
            # Append the date and text as a row in the data list
            data.append({'Date': date, 'Text': text})

# Convert the data list to a DataFrame and save as CSV
df = pd.DataFrame(data)
df.to_csv(output_csv, index=False, encoding='utf-8')

print(f"Data from all text files saved to '{output_csv}'.")
