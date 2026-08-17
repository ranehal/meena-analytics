import os
import sys

scrape_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'scrape.py')
with open(scrape_file, 'r', encoding='utf-8') as f:
    code = f.read()

exec(compile(code, scrape_file, 'exec'))
