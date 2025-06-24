import os
import pandas as pd
import openai

# First run this in terminal: OPENAI_API_KEY=your_api_key
# Then in terminal you can use this to run this code: uv run minutes_reason.py

# Load OpenAI API key from environment variable
OPENAI_API_KEY = os.getenv('OPENAI_API_KEY')
if not OPENAI_API_KEY:
    raise ValueError('Please set the OPENAI_API_KEY environment variable.')
openai.api_key = OPENAI_API_KEY

# Load the minutes CSV
minutes_df = pd.read_csv('data/minutes_tbl.csv')

# The prompt
# Change this and see how it performs differently e.g. try adding You should be concise. Focus on whether the main cause was domestic or international and whether it was economic or financial. One or two words only. 
SYSTEM_PROMPT = "You are an expert summarizer of central bank meeting minutes. Given the following meeting minutes, extract and state the main reason for the monetary policy decision. You should be concise. One or two words only. Focus on whether the main cause was domestic or international and whether it was economic or financial."

results = []

for idx, row in minutes_df.iterrows():
    date = row['date']
    text = row['text']
    print(f"Processing {idx+1}/{len(minutes_df)}: {date}")
    main_reason = None
    error = None
    try:
        response = openai.chat.completions.create(
            model="gpt-4.1-2025-04-14", # Can change these - try gpt-4.1-2025-04-14 or o4-mini-2025-04-16 or o3-mini-2025-01-31
            messages=[
                {"role": "system", "content": SYSTEM_PROMPT},
                {"role": "user", "content": text}
            ],
            max_tokens=200,
            temperature=0.2 # Change this - 0 should be most consistent responses and 1 will provide most inconsistency
        )
        main_reason = response.choices[0].message.content.strip()
        print(f"  Main reason: {main_reason[:100]}{'...' if len(main_reason) > 100 else ''}")
    except Exception as e:
        error = str(e)
        print(f"  Error for {date}: {error}")
    results.append({
        'date': date,
        'main_reason': main_reason,
        'error': error
    })

# Write results to CSV
output_df = pd.DataFrame(results)
output_df.to_csv('data/minutes_main_reasons.csv', index=False)
print("\nAll results written to data/minutes_main_reasons.csv") 