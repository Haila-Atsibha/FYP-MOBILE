import os
import re
import json

def extract_strings(directory):
    strings = set()
    # Regex to match Text('...'), hintText: '...', labelText: '...', title: Text('...'), etc.
    # We will just look for simple single-quoted strings inside Text() for a start
    pattern = re.compile(r"Text\(\s*'([^'\\]*(?:\\.[^'\\]*)*)'")
    pattern2 = re.compile(r'Text\(\s*"([^"\\]*(?:\\.[^"\\]*)*)"')
    
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.dart'):
                with open(os.path.join(root, file), 'r', encoding='utf-8') as f:
                    content = f.read()
                    matches = pattern.findall(content)
                    matches2 = pattern2.findall(content)
                    for m in matches + matches2:
                        # exclude strings with interpolation for now
                        if '$' not in m:
                            strings.add(m)
                            
    return list(strings)

if __name__ == '__main__':
    screens_dir = r"c:\Users\Y\OneDrive\Desktop\FYP_MOBILE\mobile_app\lib\screens"
    widgets_dir = r"c:\Users\Y\OneDrive\Desktop\FYP_MOBILE\mobile_app\lib\widgets"
    
    all_strings = set(extract_strings(screens_dir) + extract_strings(widgets_dir))
    
    print(json.dumps(list(all_strings), indent=2, ensure_ascii=False))
