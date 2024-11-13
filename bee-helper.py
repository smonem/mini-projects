from pprint import pprint

# Import words
with open("/etc/dictionaries-common/words", "r") as f:
    all_words = set(line.rstrip() for line in f.readlines())

# Get valid words
words = set(word.lower() for word in all_words if word.isalpha() and len(word) > 3)

valid_alpha = set()
required_alpha = None


def valid(word):
    word = list(word)
    if required_alpha not in word:
        return False
    for c in word:
        if c not in valid_alpha:
            return False

    return True


# Prompt user for words until exit requested
usr_input = input("Enter alphabet and required letter: ")
prompt = usr_input.split(" ")
if len(prompt) != 2:
    print("Invalid format")
    exit()

alphabet, required = prompt
if not alphabet.isalpha() or not required.isalpha():
    print("Invalid format")
    exit()

[valid_alpha.add(c) for c in alphabet]
valid_alpha.add(required)
required_alpha = required

words = set(w for w in words if valid(w))
pprint(words)
